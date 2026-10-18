--[[
    Pigeon Vehicle Access: server.

    Every second, the server looks at who is driving each vehicle (with OneSync, the server knows this itself;
    players can't hide it). If a driver isn't allowed, their game is told to keep the engine off, and if they
    drive it anyway, the server takes them out of it.
]]

local Rules = VehicleAccessRules
local Bridge = VehicleAccessBridge
local Q = VehicleAccessQueries

local RESOURCE = GetCurrentResourceName()
local EVENT_ENFORCE = RESOURCE .. ':client:enforce'
local EVENT_RELEASE = RESOURCE .. ':client:release'
local MOVING_SPEED = 2.0             -- metres per second; above this the vehicle counts as being driven
local LEAVE_FLAGS = 16               -- TaskLeaveVehicle: put them straight outside

local strings = Locales[Config.Locale] or Locales.en
local rules, problems = Rules.compile(Config.Vehicles)
local ready = false
local framework

local stopped = {}                   -- [source] = { vehicle, netId, model, moving }
local whitelistCache = {}            -- [source] = { [model] = true | false }

---------------------------------------------------------------------------
-- Text

local function t(key, values)
    local text = strings[key] or Locales.en[key] or key
    return (text:gsub('{(%w+)}', function(name)
        local value = values and values[name]
        if value == nil then return '{' .. name .. '}' end
        return tostring(value)
    end))
end

local function log(message, colour)
    print(('%s[%s]^7 %s'):format(colour or '^5', RESOURCE, message))
end

local function notify(source, message)
    local useOx = Config.Notifications == 'ox_lib'
        or (Config.Notifications ~= 'chat' and GetResourceState('ox_lib') == 'started')
    if useOx then
        TriggerClientEvent('ox_lib:notify', source, { title = t('title'), description = message, type = 'error', duration = 6000 })
    else
        TriggerClientEvent('chat:addMessage', source, { color = { 240, 110, 110 }, multiline = true, args = { t('title'), message } })
    end
end

---------------------------------------------------------------------------
-- Whitelist

local function isWhitelisted(source, model, player)
    local cache = whitelistCache[source]
    if not cache then
        cache = {}
        whitelistCache[source] = cache
    end
    if cache[model] ~= nil then return cache[model] end

    local identifiers = Bridge.identifiers(source, player)
    if #identifiers == 0 or not ready then return false end

    local params = { model }
    for _, id in ipairs(identifiers) do params[#params + 1] = id end
    local ok, result = pcall(MySQL.scalar.await, Q.isWhitelisted(#identifiers), params)
    local allowed = ok and result ~= nil
    if ok then cache[model] = allowed end
    return allowed
end

--- Forgets cached whitelist answers for a model (after it's changed), or for everyone.
local function clearWhitelistCache(model)
    for _, cache in pairs(whitelistCache) do
        if model then cache[model] = nil else for key in pairs(cache) do cache[key] = nil end end
    end
end

---------------------------------------------------------------------------
-- Deciding

--- Can this player drive a vehicle with this rule? Returns allowed, reason.
local function canDrive(source, rule)
    local player = Bridge.player(source)
    return Rules.evaluate(rule, player, {
        bypass = function() return Config.BypassAce and IsPlayerAceAllowed(source, Config.BypassAce) end,
        ace = function(name) return IsPlayerAceAllowed(source, name) end,
        whitelisted = function() return isWhitelisted(source, rule.model, player) end,
    })
end

local function deniedMessage(rule)
    if Config.ShowWhoCanDrive then
        return t('denied_who', { vehicle = rule.label, who = Rules.describe(rule, t) })
    end
    return t('denied', { vehicle = rule.label })
end

local function release(source)
    local state = stopped[source]
    if not state then return end
    stopped[source] = nil
    TriggerClientEvent(EVENT_RELEASE, source, state.netId)
end

--- Checks one player. Called every Config.CheckInterval.
local function checkPlayer(source)
    local ped = GetPlayerPed(source)
    local vehicle = ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
    local driving = vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped
    local rule = driving and rules[GetEntityModel(vehicle)]

    if not rule then
        if stopped[source] then release(source) end
        return
    end

    local allowed = canDrive(source, rule)
    local state = stopped[source]

    if allowed then
        if state then release(source) end
        return
    end

    if not state or state.vehicle ~= vehicle then
        if state then release(source) end
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        stopped[source] = { vehicle = vehicle, netId = netId, model = rule.model, moving = 0 }
        TriggerClientEvent(EVENT_ENFORCE, source, netId, t('denied_help'))
        notify(source, deniedMessage(rule))
        return
    end

    -- Repeat the instruction every check. Their game ignores repeats, but this restarts it if they got out
    -- and back in between checks.
    TriggerClientEvent(EVENT_ENFORCE, source, state.netId, t('denied_help'))

    -- Already told to stop. If the vehicle keeps moving anyway, their game is ignoring it.
    if Config.RemoveIfDriven and GetEntitySpeed(vehicle) > MOVING_SPEED then
        state.moving = state.moving + 1
        if state.moving >= Config.RemoveIfDriven then
            TaskLeaveVehicle(ped, vehicle, LEAVE_FLAGS)
            state.moving = 0
            if Config.LogBypassAttempts then
                log(t('bypass_attempt', { id = source, name = GetPlayerName(source) or '?', model = rule.model }), '^3')
            end
        end
    else
        state.moving = 0
    end
end

---------------------------------------------------------------------------
-- Start

for _, problem in ipairs(problems) do
    log(t('config_problem', { problem = problem }), '^3')
end

MySQL.ready(function()
    local ok, problem = pcall(MySQL.query.await, Q.create)
    if not ok then
        log(('Couldn\'t create the %s table: %s'):format(Q.TABLE, tostring(problem)), '^1')
        return
    end
    ready = true
end)

CreateThread(function()
    Wait(1000) -- let frameworks start
    framework = Bridge.detect()
    local count = 0
    for _ in pairs(rules) do count = count + 1 end
    if framework then
        log(t('started', { count = count, framework = framework }))
    else
        log(t('no_framework'), '^3')
    end

    while true do
        Wait(math.max(250, Config.CheckInterval or 1000))
        if next(rules) then
            for _, id in ipairs(GetPlayers()) do
                local source = tonumber(id)
                local ok, err = pcall(checkPlayer, source)
                if not ok then log(('Check failed for player %d: %s'):format(source, tostring(err)), '^1') end
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    stopped[source] = nil
    whitelistCache[source] = nil
end)

-- A different character can have a different whitelist, so forget cached answers when characters change.
for _, event in ipairs({ 'QBCore:Server:OnPlayerUnload', 'QBCore:Server:PlayerLoaded' }) do
    AddEventHandler(event, function(arg)
        local id = type(arg) == 'table' and arg.PlayerData and arg.PlayerData.source or tonumber(arg) or source
        if id then whitelistCache[id] = nil end
    end)
end

---------------------------------------------------------------------------
-- Admin command

local function resolveWho(text)
    local who = Rules.parseWho(text)
    if not who then return nil, t('bad_who', { who = tostring(text) }) end
    if who.kind == 'server' then
        if not GetPlayerName(who.value) then return nil, t('player_offline', { id = who.value }) end
        local player = Bridge.player(who.value)
        if not player or not player.citizenid then
            local discord = GetPlayerIdentifierByType(who.value, 'discord')
            if discord then return discord end
            return nil, t('player_offline', { id = who.value })
        end
        return player.citizenid
    end
    return who.value
end

local function adminName(source)
    if source == 0 then return 'console' end
    local player = Bridge.player(source)
    return (player and player.citizenid) or GetPlayerIdentifierByType(source, 'license') or ('player ' .. source)
end

local function ruleFor(model)
    model = tostring(model or ''):lower()
    return rules[Rules.hash(model)], model
end

local actions = {}

function actions.add(source, args)
    local rule, model = ruleFor(args[2])
    if not rule then return { t('unknown_model', { model = model }) } end
    local who, problem = resolveWho(args[3])
    if not who then return { problem } end
    local note = table.concat(args, ' ', 4)
    note = note ~= '' and note:sub(1, 255) or nil
    local changed = MySQL.insert.await(Q.add, { model, who, note, adminName(source) })
    clearWhitelistCache(model)
    local lines = { t(changed and changed > 0 and 'added' or 'already', { who = who, model = model }) }
    if not rule.whitelist then lines[#lines + 1] = t('not_whitelist_model', { model = model }) end
    return lines
end

function actions.remove(source, args)
    local rule, model = ruleFor(args[2])
    if not rule then return { t('unknown_model', { model = model }) } end
    local who, problem = resolveWho(args[3])
    if not who then return { problem } end
    local changed = MySQL.update.await(Q.remove, { model, who })
    clearWhitelistCache(model)
    return { t(changed and changed > 0 and 'removed' or 'not_found', { who = who, model = model }) }
end

function actions.list(source, args)
    local rule, model = ruleFor(args[2])
    if not rule then return { t('unknown_model', { model = model }) } end
    local rows = MySQL.query.await(Q.list, { model }) or {}
    if #rows == 0 then return { t('list_empty', { model = model }) } end
    local lines = { t('list_header', { model = model, count = #rows }) }
    for _, row in ipairs(rows) do
        lines[#lines + 1] = t('list_entry', {
            who = row.identifier, note = row.note and (' (' .. row.note .. ')') or '', date = row.added_on, by = row.added_by or '?',
        })
    end
    return lines
end

function actions.check(source, args)
    local id = tonumber(args[2])
    if not id or not GetPlayerName(id) then return { t('player_offline', { id = tostring(args[2]) }) } end
    local rule, model = ruleFor(args[3])
    if not rule then return { t('unknown_model', { model = model }) } end
    local allowed, reason = canDrive(id, rule)
    return { t('check_result', { id = id, result = t(allowed and 'check_can' or 'check_cannot'), model = model, reason = reason }) }
end

function actions.rules()
    local list = {}
    for _, rule in pairs(rules) do list[#list + 1] = rule end
    table.sort(list, function(a, b) return a.model < b.model end)
    local lines = { t('rules_header', { count = #list }) }
    for _, rule in ipairs(list) do
        lines[#lines + 1] = t('rules_entry', { model = rule.model, label = rule.label, who = Rules.describe(rule, t) })
    end
    return lines
end

RegisterCommand(Config.Command, function(source, args)
    local function reply(lines)
        for _, line in ipairs(lines) do
            if source == 0 then
                log(line)
            else
                TriggerClientEvent('chat:addMessage', source, { color = { 167, 139, 250 }, multiline = true, args = { t('title'), line } })
            end
        end
    end

    if source ~= 0 and not IsPlayerAceAllowed(source, Config.AdminAce) then
        return reply({ t('no_permission') })
    end

    local action = actions[(args[1] or ''):lower()]
    if not action then
        return reply({ t('usage', { command = Config.Command }), t('who_help') })
    end

    CreateThread(function()
        local ok, lines = pcall(action, source, args)
        reply(ok and lines or { ('Something went wrong: %s'):format(tostring(lines)) })
    end)
end, false)

---------------------------------------------------------------------------
-- Exports

--- Can this player drive this model? Unrestricted models always return true.
--- exports['pigeon-vehicle-access']:CanDrive(source, 'police3') -> allowed, reason
exports('CanDrive', function(source, model)
    local rule = rules[type(model) == 'number' and model or Rules.hash(tostring(model or ''))]
    if not rule then return true, 'unrestricted' end
    return canDrive(tonumber(source), rule)
end)

--- Adds an identifier (citizen ID or discord:ID) to a model's whitelist. Returns true if added.
--- exports['pigeon-vehicle-access']:AddToWhitelist('c3coqheat', 'ABC12345', 'Bought in-game')
exports('AddToWhitelist', function(model, identifier, note)
    model = tostring(model or ''):lower()
    if not ready or not rules[Rules.hash(model)] or type(identifier) ~= 'string' or identifier == '' then return false end
    local changed = MySQL.insert.await(Q.add, { model, identifier, note and tostring(note):sub(1, 255) or nil, GetInvokingResource() or RESOURCE })
    clearWhitelistCache(model)
    return changed ~= nil and changed > 0
end)

--- Removes an identifier from a model's whitelist. Returns true if it was there.
exports('RemoveFromWhitelist', function(model, identifier)
    model = tostring(model or ''):lower()
    if not ready then return false end
    local changed = MySQL.update.await(Q.remove, { model, tostring(identifier or '') })
    clearWhitelistCache(model)
    return changed ~= nil and changed > 0
end)
