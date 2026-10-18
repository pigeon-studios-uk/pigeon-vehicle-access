--[[
    Pigeon Vehicle Access: rules.

    Turns Config.Vehicles into rules keyed by model hash, and decides whether a player may drive a vehicle.
    Pure Lua with no FiveM calls: the server loads it as the VehicleAccessRules table; the tests in tests/
    run it in plain Lua 5.4.
]]

local Rules = {}

--- GTA's model hash (Jenkins one-at-a-time, lower-cased), the same as FiveM's joaat().
--- Returns a signed 32-bit integer, as GetEntityModel does.
function Rules.hash(name)
    local h = 0
    name = tostring(name):lower()
    for i = 1, #name do
        h = (h + name:byte(i)) & 0xFFFFFFFF
        h = (h + (h << 10)) & 0xFFFFFFFF
        h = (h ~ (h >> 6)) & 0xFFFFFFFF
    end
    h = (h + (h << 3)) & 0xFFFFFFFF
    h = (h ~ (h >> 11)) & 0xFFFFFFFF
    h = (h + (h << 15)) & 0xFFFFFFFF
    if h >= 0x80000000 then h = h - 0x100000000 end
    return h
end

local function isGradeMap(value)
    if type(value) ~= 'table' then return false end
    for name, grade in pairs(value) do
        if type(name) ~= 'string' or type(grade) ~= 'number' or grade < 0 or grade ~= math.floor(grade) then return false end
    end
    return true
end

--- Checks Config.Vehicles and builds rules keyed by model hash.
--- Returns rules, problems (a list of human-readable messages for settings that were skipped).
---@param vehicles table Config.Vehicles
function Rules.compile(vehicles)
    local rules, problems = {}, {}
    for model, rule in pairs(vehicles or {}) do
        local where = ('Config.Vehicles[\'%s\']'):format(tostring(model))
        if type(model) ~= 'string' or not model:match('^[%w_%-]+$') then
            problems[#problems + 1] = ('%s: the model must be a spawn name such as \'police3\'.'):format(where)
        elseif type(rule) ~= 'table' then
            problems[#problems + 1] = ('%s: must be a table of who may drive it.'):format(where)
        else
            local ok = true
            if rule.jobs ~= nil and not isGradeMap(rule.jobs) then
                problems[#problems + 1] = ('%s.jobs must look like { police = 0, sheriff = 2 } (job name = lowest grade).'):format(where)
                ok = false
            end
            if rule.gangs ~= nil and not isGradeMap(rule.gangs) then
                problems[#problems + 1] = ('%s.gangs must look like { ballas = 0 } (gang name = lowest grade).'):format(where)
                ok = false
            end
            if rule.ace ~= nil and (type(rule.ace) ~= 'string' or rule.ace == '') then
                problems[#problems + 1] = ('%s.ace must be an ACE permission name.'):format(where)
                ok = false
            end
            local any = (rule.jobs and next(rule.jobs)) or (rule.gangs and next(rule.gangs)) or rule.ace or rule.whitelist
            if ok and not any then
                problems[#problems + 1] = ('%s has no jobs, gangs, ace or whitelist, so nobody could drive it. Skipped.'):format(where)
                ok = false
            end
            if ok then
                local key = model:lower()
                rules[Rules.hash(key)] = {
                    model = key,
                    label = type(rule.label) == 'string' and rule.label or key,
                    jobs = rule.jobs,
                    gangs = rule.gangs,
                    onDuty = rule.onDuty == true,
                    ace = rule.ace,
                    whitelist = rule.whitelist == true,
                }
            end
        end
    end
    return rules, problems
end

--- Decides whether a player may drive a vehicle with this rule.
---@param rule table a compiled rule
---@param player table|nil { jobs = { [name] = grade }, primaryJob = name, onDuty = bool, gang = name, gangGrade = number }
---@param checks table { ace = function(name) -> bool, whitelisted = function() -> bool, bypass = function() -> bool }
---@return boolean allowed, string reason  ('bypass', 'job', 'gang', 'ace', 'whitelist' or 'denied')
function Rules.evaluate(rule, player, checks)
    if checks.bypass and checks.bypass() then return true, 'bypass' end

    if rule.jobs and player and player.jobs then
        for name, minimum in pairs(rule.jobs) do
            local grade = player.jobs[name]
            if grade and grade >= minimum then
                local onDuty = not rule.onDuty or (name == player.primaryJob and player.onDuty)
                if onDuty then return true, 'job' end
            end
        end
    end

    if rule.gangs and player and player.gang then
        local minimum = rule.gangs[player.gang]
        if minimum and (player.gangGrade or 0) >= minimum then return true, 'gang' end
    end

    if rule.ace and checks.ace and checks.ace(rule.ace) then return true, 'ace' end

    -- Last, because it may need the database.
    if rule.whitelist and checks.whitelisted and checks.whitelisted() then return true, 'whitelist' end

    return false, 'denied'
end

--- Describes who may drive a vehicle, for the in-game message and the admin command.
---@param t function locale lookup t(key, values)
function Rules.describe(rule, t)
    local parts = {}
    local function list(map)
        local names = {}
        for name, grade in pairs(map) do
            names[#names + 1] = grade > 0 and t('who_grade', { name = name, grade = grade }) or name
        end
        table.sort(names)
        return table.concat(names, ', ')
    end
    if rule.jobs and next(rule.jobs) then
        parts[#parts + 1] = t(rule.onDuty and 'who_jobs_on_duty' or 'who_jobs', { jobs = list(rule.jobs) })
    end
    if rule.gangs and next(rule.gangs) then parts[#parts + 1] = t('who_gangs', { gangs = list(rule.gangs) }) end
    if rule.ace then parts[#parts + 1] = t('who_ace') end
    if rule.whitelist then parts[#parts + 1] = t('who_whitelist') end
    return table.concat(parts, t('who_or'))
end

--- Reads an admin's "who" argument: an online server ID, a citizen ID, or discord:ID.
--- Returns { kind = 'server' | 'citizenid' | 'discord', value } or nil.
function Rules.parseWho(text)
    text = tostring(text or ''):match('^%s*(.-)%s*$')
    if text == '' then return nil end
    local discord = text:match('^discord:(%d+)$')
    if discord then return { kind = 'discord', value = 'discord:' .. discord } end
    if text:match('^%d+$') and #text <= 6 then return { kind = 'server', value = tonumber(text) } end
    if text:match('^[%w]+$') and #text <= 64 then return { kind = 'citizenid', value = text } end
    return nil
end

VehicleAccessRules = Rules
return Rules
