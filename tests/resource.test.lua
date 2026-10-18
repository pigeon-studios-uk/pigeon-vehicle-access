--[[
    Tests for server/main.lua, server/bridge.lua and client/main.lua.

    Loads the real resource files in plain Lua 5.4 with a simulated FiveM world: players with peds in
    vehicles, Qbox or QBCore player data, ACE permissions, an in-memory whitelist table answering the
    resource's queries, and a client running the real client/main.lua.

    Run from the repository root:
        lua tests/resource.test.lua
]]

local passed, failed = 0, 0
local function check(name, ok, detail)
    if ok then
        passed = passed + 1
    else
        failed = failed + 1
        io.write(('  \27[31mFAIL\27[0m  %s%s\n'):format(name, detail ~= nil and ('\n          ' .. tostring(detail)) or ''))
    end
end

local Rules = dofile('server/rules.lua')

---------------------------------------------------------------------------
-- Simulated server

local function newServer(options)
    options = options or {}
    local s = {
        clock = 0,
        threads = {},
        commands = {},
        handlers = {},
        exports = {},
        printed = {},
        events = {},          -- client events sent: { target, name, a, b }
        leaves = {},          -- TaskLeaveVehicle calls
        players = {},         -- [id] = { name, ped, vehicle, seat, speed, data (PlayerData), aces, groups, discord }
        vehicles = {},        -- [handle] = { model, netId }
        whitelist = {},       -- list of { model, identifier, note, added_by }
        resources = options.resources or { qbx_core = 'started', oxmysql = 'started' },
        queries = 0,
    }

    local env = setmetatable({}, { __index = _G })
    env.GetCurrentResourceName = function() return 'pigeon-vehicle-access' end
    env.GetInvokingResource = function() return 'some-shop' end
    env.GetResourceState = function(name) return s.resources[name] or 'missing' end
    env.GetConvar = function(_, default) return default end
    env.GetPlayers = function()
        local list = {}
        for id in pairs(s.players) do list[#list + 1] = tostring(id) end
        table.sort(list)
        return list
    end
    env.GetPlayerName = function(id) local p = s.players[tonumber(id)] return p and p.name end
    env.GetPlayerPed = function(id) local p = s.players[tonumber(id)] return p and p.ped or 0 end
    env.GetVehiclePedIsIn = function(ped)
        for _, p in pairs(s.players) do if p.ped == ped then return p.vehicle or 0 end end
        return 0
    end
    env.GetPedInVehicleSeat = function(vehicle, seat)
        for _, p in pairs(s.players) do if p.vehicle == vehicle and p.seat == seat then return p.ped end end
        return 0
    end
    env.GetEntityModel = function(vehicle) return Rules.hash(s.vehicles[vehicle].model) end
    env.GetEntitySpeed = function(vehicle)
        for _, p in pairs(s.players) do if p.vehicle == vehicle and p.seat == -1 then return p.speed or 0 end end
        return 0
    end
    env.NetworkGetNetworkIdFromEntity = function(vehicle) return s.vehicles[vehicle].netId end
    env.TaskLeaveVehicle = function(ped, vehicle, flags) s.leaves[#s.leaves + 1] = { ped = ped, vehicle = vehicle, flags = flags } end
    env.IsPlayerAceAllowed = function(id, ace) local p = s.players[tonumber(id)] return p and p.aces and p.aces[ace] or false end
    env.GetPlayerIdentifierByType = function(id, kind)
        local p = s.players[tonumber(id)]
        if not p then return nil end
        if kind == 'discord' then return p.discord end
        if kind == 'license' then return 'license:' .. id end
    end
    env.RegisterCommand = function(name, fn) s.commands[name] = fn end
    env.AddEventHandler = function(name, fn) s.handlers[name] = fn end
    env.TriggerClientEvent = function(name, target, a, b) s.events[#s.events + 1] = { target = target, name = name, a = a, b = b } end
    env.exports = setmetatable({}, {
        __call = function(_, name, fn) s.exports[name] = fn end,
        __index = function(_, resource)
            if resource == 'qbx_core' then
                return {
                    GetPlayer = function(_, id) local p = s.players[id] return p and p.data and { PlayerData = p.data } end,
                    GetGroups = function(_, id) local p = s.players[id] return p and p.groups or {} end,
                }
            elseif resource == 'qb-core' then
                return { GetCoreObject = function()
                    return { Functions = { GetPlayer = function(id) local p = s.players[id] return p and p.data and { PlayerData = p.data } end } }
                end }
            end
        end,
    })
    env.print = function(text) s.printed[#s.printed + 1] = (tostring(text):gsub('%^%d', '')) end
    env.CreateThread = function(fn) s.threads[#s.threads + 1] = { co = coroutine.create(fn), wake = s.clock } end
    env.Wait = function(ms) coroutine.yield(ms) end

    local function matchesAny(identifiers, row)
        for _, id in ipairs(identifiers) do if row.identifier == id then return true end end
    end
    env.MySQL = {
        ready = function(cb) env.CreateThread(cb) end,
        query = { await = function(sql, params)
            s.queries = s.queries + 1
            if sql:find('CREATE TABLE') then return {} end
            if sql:find('SELECT `identifier`') then
                local rows = {}
                for _, row in ipairs(s.whitelist) do
                    if row.model == params[1] then rows[#rows + 1] = { identifier = row.identifier, note = row.note, added_by = row.added_by, added_on = '2026-10-18' } end
                end
                return rows
            end
            error('unexpected query ' .. sql)
        end },
        scalar = { await = function(sql, params)
            s.queries = s.queries + 1
            assert(sql:find('SELECT 1 FROM `pigeon_vehicle_access`'))
            local ids = { table.unpack(params, 2) }
            for _, row in ipairs(s.whitelist) do
                if row.model == params[1] and matchesAny(ids, row) then return 1 end
            end
            return nil
        end },
        insert = { await = function(sql, params)
            s.queries = s.queries + 1
            for _, row in ipairs(s.whitelist) do
                if row.model == params[1] and row.identifier == params[2] then return 0 end
            end
            s.whitelist[#s.whitelist + 1] = { model = params[1], identifier = params[2], note = params[3], added_by = params[4] }
            return 1
        end },
        update = { await = function(sql, params)
            s.queries = s.queries + 1
            for i, row in ipairs(s.whitelist) do
                if row.model == params[1] and row.identifier == params[2] then table.remove(s.whitelist, i) return 1 end
            end
            return 0
        end },
    }
    env.Locales = nil
    s.env = env

    for _, file in ipairs({ 'configuration/config.lua', 'locales/en.lua' }) do assert(loadfile(file, 't', env))() end
    env.Config.Vehicles = options.vehicles or {
        police3 = { label = 'Interceptor', jobs = { police = 2 }, onDuty = true },
        adder = { label = 'Adder', whitelist = true },
        buffalo4 = { gangs = { ballas = 1 } },
        t20 = { ace = 'vehicle.t20' },
        empty = {},
    }
    if options.configure then options.configure(env.Config) end
    for _, file in ipairs({ 'server/rules.lua', 'server/queries.lua', 'server/bridge.lua', 'server/main.lua' }) do
        assert(loadfile(file, 't', env))()
    end

    function s.run(ms)
        local target = s.clock + (ms or 0)
        for _ = 1, 100000 do
            local soonest
            for _, th in ipairs(s.threads) do
                if th.wake <= target and (not soonest or th.wake < soonest.wake) then soonest = th end
            end
            if not soonest then break end
            s.clock = math.max(s.clock, soonest.wake)
            local ok, wait = coroutine.resume(soonest.co)
            if not ok then error(wait, 0) end
            if coroutine.status(soonest.co) == 'dead' then
                for i, th in ipairs(s.threads) do if th == soonest then table.remove(s.threads, i) break end end
            else
                soonest.wake = s.clock + (wait or 0)
            end
        end
        s.clock = target
    end

    function s.addPlayer(id, info)
        info.ped = 100 + id
        info.name = info.name or ('Player' .. id)
        s.players[id] = info
    end

    function s.addVehicle(handle, model) s.vehicles[handle] = { model = model, netId = 5000 + handle } end

    function s.sent(target, name)
        local list = {}
        for _, e in ipairs(s.events) do
            if (target == nil or e.target == target) and (name == nil or e.name:find(name, 1, true)) then list[#list + 1] = e end
        end
        return list
    end

    function s.command(source, ...)
        s.printed, s.events = {}, {}
        s.commands.vehicleaccess(source, { ... })
        s.run(10)
        local lines = {}
        for _, p in ipairs(s.printed) do lines[#lines + 1] = p end
        for _, e in ipairs(s.events) do if e.name == 'chat:addMessage' then lines[#lines + 1] = e.a.args[2] end end
        return table.concat(lines, '\n')
    end

    s.run(2000) -- start: tables, framework detection, first loop
    return s
end

local function qbx(job, grade, onduty, gang, gangGrade, citizenid)
    return {
        citizenid = citizenid or 'CID',
        job = { name = job, grade = { level = grade }, onduty = onduty },
        gang = { name = gang or 'none', grade = { level = gangGrade or 0 } },
    }
end

io.write('Pigeon Vehicle Access resource tests\n')

---------------------------------------------------------------------------
-- Start-up

do
    local s = newServer()
    local out = table.concat(s.printed, '\n')
    check('reports how many vehicles and which framework', out:find('Watching 4 restricted vehicles with Qbox') ~= nil, out)
    check('bad config entries are explained, not fatal', out:find("Config problem: Config.Vehicles%['empty'%] has no jobs") ~= nil)
end

do
    local s = newServer({ resources = { ['qb-core'] = 'started' } })
    check('detects QBCore', table.concat(s.printed, '\n'):find('with QBCore') ~= nil)
end

do
    local s = newServer({ resources = {} })
    check('no framework: explains that only ACE and whitelist rules work', table.concat(s.printed, '\n'):find('Neither qbx_core nor qb%-core') ~= nil)
end

---------------------------------------------------------------------------
-- Enforcing

do
    local s = newServer()
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('police', 1, true), vehicle = 1, seat = -1 })
    s.events = {}
    s.run(1000)
    local enforce = s.sent(1, ':client:enforce')
    check('driver without the grade is stopped', #enforce == 1 and enforce[1].a == 5001, #enforce)
    local msg = s.sent(1, 'chat:addMessage')[1]
    check('and told who can drive it', msg and msg.a.args[2] == "You aren't cleared to drive this Interceptor. It's for on-duty police (grade 2+).", msg and msg.a.args[2])

    s.events = {}
    s.run(1000)
    check('the instruction is repeated, but the message isn\'t', #s.sent(1, ':client:enforce') == 1 and #s.sent(1, 'chat:addMessage') == 0)

    -- Promoted while sitting in it.
    s.players[1].data = qbx('police', 2, true)
    s.events = {}
    s.run(1000)
    check('promotion is picked up on the next check and the vehicle released', #s.sent(1, ':client:release') == 1 and s.sent(1, ':client:release')[1].a == 5001)

    -- Goes off duty.
    s.players[1].data = qbx('police', 2, false)
    s.events = {}
    s.run(1000)
    check('going off duty stops them again', #s.sent(1, ':client:enforce') == 1)

    -- Gets out.
    s.players[1].vehicle = nil
    s.events = {}
    s.run(1000)
    check('getting out releases the vehicle', #s.sent(1, ':client:release') == 1)
end

do
    local s = newServer()
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('unemployed', 0, false), vehicle = 1, seat = 0 })
    s.addVehicle(2, 'sultan')
    s.addPlayer(2, { data = qbx('unemployed', 0, false), vehicle = 2, seat = -1 })
    s.events = {}
    s.run(3000)
    check('passengers are never stopped', #s.sent(1) == 0)
    check('unrestricted vehicles are ignored', #s.sent(2) == 0)
end

do
    local s = newServer({ resources = { ['qb-core'] = 'started' } })
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('police', 3, true), vehicle = 1, seat = -1 })
    s.events = {}
    s.run(3000)
    check('QBCore: allowed officer is left alone', #s.sent(1, ':client:enforce') == 0)
end

do
    local s = newServer()
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('mechanic', 0, true), groups = { mechanic = 0, police = 5 }, vehicle = 1, seat = -1 })
    s.events = {}
    s.run(1000)
    check('Qbox second job doesn\'t count when onDuty is required (they\'re on duty as mechanic)', #s.sent(1, ':client:enforce') == 1)
end

do
    -- A gang that happens to share a job's name. Qbox's GetGroups returns jobs and gangs together.
    local s = newServer({ vehicles = { police3 = { jobs = { police = 0 } } } })
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('unemployed', 0, false, 'police', 3), groups = { unemployed = 0, police = 3 }, vehicle = 1, seat = -1 })
    s.events = {}
    s.run(1000)
    check('Qbox: a gang with a job\'s name doesn\'t count as that job', #s.sent(1, ':client:enforce') == 1)
end

do
    local s = newServer({ vehicles = { police3 = { jobs = { police = 2 } } } })
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('mechanic', 0, true), groups = { mechanic = 0, police = 5 }, vehicle = 1, seat = -1 })
    s.events = {}
    s.run(2000)
    check('Qbox second job counts when onDuty isn\'t required', #s.sent(1, ':client:enforce') == 0)
end

do
    local s = newServer()
    s.addVehicle(1, 'buffalo4')
    s.addPlayer(1, { data = qbx('unemployed', 0, false, 'ballas', 1), vehicle = 1, seat = -1 })
    s.addVehicle(2, 't20')
    s.addPlayer(2, { data = qbx('unemployed', 0, false), aces = { ['vehicle.t20'] = true }, vehicle = 2, seat = -1 })
    s.addVehicle(3, 'adder')
    s.addPlayer(3, { data = qbx('unemployed', 0, false), aces = { ['pigeon-vehicle-access.bypass'] = true }, vehicle = 3, seat = -1 })
    s.events = {}
    s.run(2000)
    check('gang rule allows', #s.sent(1, ':client:enforce') == 0)
    check('ACE rule allows', #s.sent(2, ':client:enforce') == 0)
    check('bypass ACE allows anything', #s.sent(3, ':client:enforce') == 0)
end

---------------------------------------------------------------------------
-- Driving anyway

do
    local s = newServer()
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('unemployed', 0, false), vehicle = 1, seat = -1, speed = 0 })
    s.run(1000)
    s.players[1].speed = 15
    s.printed = {}
    s.run(2000)
    check('not removed before the limit', #s.leaves == 0)
    s.run(1000)
    check('removed after 3 checks moving', #s.leaves == 1 and s.leaves[1].ped == 101 and s.leaves[1].vehicle == 1 and s.leaves[1].flags == 16)
    check('the attempt is logged', table.concat(s.printed, '\n'):find('Player 1 %(Player1%) kept driving police3') ~= nil)
    s.players[1].speed = 0
    s.leaves = {}
    s.run(5000)
    check('stopped vehicle isn\'t a reason to remove them', #s.leaves == 0)
end

do
    local s = newServer({ configure = function(c) c.RemoveIfDriven = false end })
    s.addVehicle(1, 'police3')
    s.addPlayer(1, { data = qbx('unemployed', 0, false), vehicle = 1, seat = -1, speed = 30 })
    s.run(10000)
    check('RemoveIfDriven = false never removes', #s.leaves == 0)
end

---------------------------------------------------------------------------
-- Whitelist

do
    local s = newServer()
    s.addVehicle(1, 'adder')
    s.addPlayer(1, { data = qbx('unemployed', 0, false, nil, nil, 'ABC123'), discord = 'discord:42', vehicle = 1, seat = -1 })
    s.events = {}
    s.run(1000)
    check('not whitelisted: stopped', #s.sent(1, ':client:enforce') == 1)

    local before = s.queries
    s.run(5000)
    check('the whitelist answer is cached (no query every second)', s.queries == before, s.queries - before)

    local out = s.command(0, 'add', 'adder', '1', 'Won', 'the', 'raffle')
    check('add by server ID uses their citizen ID', out:find('Added ABC123 to the adder whitelist') ~= nil and s.whitelist[1].note == 'Won the raffle' and s.whitelist[1].added_by == 'console', out)
    s.events = {}
    s.run(1000)
    check('adding clears the cache and releases them straight away', #s.sent(1, ':client:release') == 1)

    out = s.command(0, 'add', 'adder', 'ABC123')
    check('adding twice says they\'re already on it', out:find('already on the adder whitelist') ~= nil, out)

    out = s.command(0, 'list', 'adder')
    check('list shows entries with note, date and who added them', out:find('adder whitelist %(1%):') and out:find('ABC123 %(Won the raffle%) %- added 2026%-10%-18 by console'), out)

    out = s.command(0, 'remove', 'adder', 'ABC123')
    check('remove', out:find('Removed ABC123') ~= nil and #s.whitelist == 0, out)
    s.events = {}
    s.run(1000)
    check('removing stops them again', #s.sent(1, ':client:enforce') == 1)

    out = s.command(0, 'add', 'adder', 'discord:42')
    s.events = {}
    s.run(1000)
    check('a Discord ID on the whitelist works too', #s.sent(1, ':client:release') == 1, out)
end

do
    local s = newServer()
    s.addPlayer(1, { data = qbx('unemployed', 0, false, nil, nil, 'ABC123') })
    check('unknown model is refused', s.command(0, 'add', 'nope', 'ABC123'):find('"nope" isn\'t in Config.Vehicles') ~= nil)
    check('bad who is refused', s.command(0, 'add', 'adder', 'drop;table'):find("isn't a server ID") ~= nil)
    check('offline server ID is refused', s.command(0, 'add', 'adder', '55'):find('No player is online with server ID 55') ~= nil)
    check('adding to a non-whitelist vehicle warns', s.command(0, 'add', 'police3', 'ABC123'):find("doesn't have whitelist = true") ~= nil)
    check('check reports the reason', s.command(0, 'check', '1', 'police3'):find('Player 1 can\'t drive police3 %(denied%)') ~= nil)
    local rules = s.command(0, 'rules')
    check('rules lists every restricted vehicle', rules:find('Restricted vehicles %(4%)') and rules:find('police3 %(Interceptor%): on%-duty police %(grade 2%+%)'), rules)
    check('no action shows usage', s.command(0):find('Usage: /vehicleaccess add') ~= nil)
end

do
    local s = newServer()
    s.addPlayer(7, { data = qbx('police', 9, true), aces = {} })
    check('in game without the admin ACE: refused', s.command(7, 'rules'):find("don't have permission") ~= nil)
    s.players[7].aces = { ['pigeon-vehicle-access.admin'] = true }
    check('in game with the admin ACE: answered in chat', s.command(7, 'rules'):find('Restricted vehicles') ~= nil)
end

---------------------------------------------------------------------------
-- Exports

do
    local s = newServer()
    s.addPlayer(1, { data = qbx('police', 5, true, nil, nil, 'ZZZ') })
    check('CanDrive: allowed with reason', select(2, s.exports.CanDrive(1, 'police3')) == 'job')
    check('CanDrive: unrestricted models', select(2, s.exports.CanDrive(1, 'sultan')) == 'unrestricted')
    check('AddToWhitelist records the calling resource', s.exports.AddToWhitelist('adder', 'ZZZ', 'Bought') == true and s.whitelist[1].added_by == 'some-shop')
    check('AddToWhitelist refuses unknown models', s.exports.AddToWhitelist('nope', 'ZZZ') == false)
    check('CanDrive sees the new entry', select(2, s.exports.CanDrive(1, 'adder')) == 'whitelist')
    check('RemoveFromWhitelist', s.exports.RemoveFromWhitelist('adder', 'ZZZ') == true and s.exports.RemoveFromWhitelist('adder', 'ZZZ') == false)
end

do
    local s = newServer()
    s.addVehicle(1, 'adder')
    s.addPlayer(1, { data = qbx('unemployed', 0, false, nil, nil, 'A1'), vehicle = 1, seat = -1 })
    s.run(1000)
    s.env.source = 1
    s.handlers.playerDropped()
    s.players[1] = nil
    s.events = {}
    s.run(2000)
    check('leaving the server clears their state, and nothing more is sent to them', #s.sent(1) == 0)
end

---------------------------------------------------------------------------
-- Client

local function newClient()
    local c = { threads = {}, events = {}, undriveable = {}, engine = {}, help = {}, seat = 'driver', exists = true }
    local env = setmetatable({}, { __index = _G })
    env.GetCurrentResourceName = function() return 'pigeon-vehicle-access' end
    env.RegisterNetEvent = function(name, fn) c.events[name] = fn end
    env.AddEventHandler = function(name, fn) c.events[name] = fn end
    env.CreateThread = function(fn) c.threads[#c.threads + 1] = coroutine.create(fn) end
    env.Wait = function() coroutine.yield() end
    env.NetworkDoesNetworkIdExist = function() return c.exists end
    env.NetworkGetEntityFromNetworkId = function(netId) return netId - 5000 end
    env.DoesEntityExist = function() return c.exists end
    env.PlayerPedId = function() return 101 end
    env.GetPedInVehicleSeat = function() return c.seat == 'driver' and 101 or 0 end
    env.SetVehicleEngineOn = function(v, on) c.engine[v] = on end
    env.SetVehicleUndriveable = function(v, on) c.undriveable[v] = on end
    env.BeginTextCommandDisplayHelp = function() end
    env.AddTextComponentSubstringPlayerName = function(text) c.help[#c.help + 1] = text end
    env.EndTextCommandDisplayHelp = function() end
    assert(loadfile('client/main.lua', 't', env))()
    function c.tick()
        c.help = {}
        for i = #c.threads, 1, -1 do
            local co = c.threads[i]
            local ok, err = coroutine.resume(co)
            if not ok then error(err) end
            if coroutine.status(co) == 'dead' then table.remove(c.threads, i) end
        end
    end
    return c
end

do
    local c = newClient()
    c.events['pigeon-vehicle-access:client:enforce'](5001, 'You aren\'t cleared to drive this vehicle.')
    c.tick()
    check('client: engine kept off and vehicle undriveable', c.engine[1] == false and c.undriveable[1] == true)
    check('client: reminder shown', c.help[1] == "You aren't cleared to drive this vehicle.")
    c.events['pigeon-vehicle-access:client:enforce'](5001, 'x')
    check('client: repeats don\'t start a second loop', #c.threads == 1)
    c.events['pigeon-vehicle-access:client:release'](5001)
    c.tick()
    check('client: release makes the vehicle driveable again', c.undriveable[1] == false and #c.threads == 0)
end

do
    local c = newClient()
    c.events['pigeon-vehicle-access:client:enforce'](5001, 'x')
    c.tick()
    c.seat = 'passenger'
    c.tick()
    check('client: moving out of the driver\'s seat releases straight away', c.undriveable[1] == false and #c.threads == 0)
    c.seat = 'driver'
    c.events['pigeon-vehicle-access:client:enforce'](5001, 'x')
    c.tick()
    check('client: the next repeat from the server restarts it', c.undriveable[1] == true and #c.threads == 1)
    c.events['pigeon-vehicle-access:client:enforce']('garbage', 'x')
    check('client: malformed events are ignored', #c.threads == 1)
end

io.write(('%d passed, %d failed\n'):format(passed, failed))
os.exit(failed == 0 and 0 or 1)
