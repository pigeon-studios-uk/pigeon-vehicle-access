--[[
    Pigeon Vehicle Access: framework bridge.

    Reads a player's jobs, gang and character identifiers from Qbox (qbx_core), QBCore (qb-core) or ESX
    (es_extended), in the shape server/rules.lua expects. Add another framework by adding a table with the
    same functions.
]]

local Bridge = {}

local function fromPlayerData(data, extraJobs)
    if type(data) ~= 'table' then return nil end
    local job = type(data.job) == 'table' and data.job or {}
    local gang = type(data.gang) == 'table' and data.gang or {}
    local jobs = {}
    if type(extraJobs) == 'table' then
        for name, grade in pairs(extraJobs) do jobs[name] = tonumber(grade) or 0 end
    end
    if job.name then
        local grade = type(job.grade) == 'table' and (job.grade.level or job.grade.grade) or job.grade
        jobs[job.name] = tonumber(grade) or 0
    end
    return {
        citizenid = data.citizenid,
        jobs = jobs,
        primaryJob = job.name,
        onDuty = job.onduty == true,
        gang = gang.name ~= 'none' and gang.name or nil,
        gangGrade = type(gang.grade) == 'table' and tonumber(gang.grade.level) or tonumber(gang.grade) or 0,
    }
end

local frameworks = {
    qbx = {
        resource = 'qbx_core',
        label = 'Qbox',
        player = function(source)
            local player = exports.qbx_core:GetPlayer(source)
            if not player then return nil end
            -- Qbox players can hold several jobs; GetGroups includes all of them (and gangs, which are filtered out below).
            local ok, groups = pcall(function() return exports.qbx_core:GetGroups(source) end)
            local jobs = {}
            if ok and type(groups) == 'table' then
                local gangName = player.PlayerData.gang and player.PlayerData.gang.name
                for name, grade in pairs(groups) do
                    if name ~= gangName then jobs[name] = grade end
                end
            end
            return fromPlayerData(player.PlayerData, jobs)
        end,
    },
    qb = {
        resource = 'qb-core',
        label = 'QBCore',
        player = function(source)
            local core = exports['qb-core']:GetCoreObject()
            local player = core and core.Functions.GetPlayer(source)
            return player and fromPlayerData(player.PlayerData) or nil
        end,
    },
    esx = {
        resource = 'es_extended',
        label = 'ESX',
        player = function(source)
            local esx = exports.es_extended:getSharedObject()
            local xPlayer = esx and esx.GetPlayerFromId(source)
            return xPlayer and Bridge.fromESX(xPlayer) or nil
        end,
    },
}

--- An ESX player in the same shape. ESX has one job and no gangs, and its character ID is xPlayer.identifier
--- (char1:... with esx_multicharacter). ESX before job duty has no job.onDuty, so everyone counts as on duty.
function Bridge.fromESX(xPlayer)
    if type(xPlayer) ~= 'table' then return nil end
    local job = type(xPlayer.job) == 'table' and xPlayer.job or {}
    local jobs = {}
    if job.name then jobs[job.name] = tonumber(job.grade) or 0 end
    return {
        citizenid = xPlayer.identifier,
        jobs = jobs,
        primaryJob = job.name,
        onDuty = job.onDuty ~= false,
        gang = nil,
        gangGrade = 0,
    }
end

local active

--- Picks the running framework. Qbox first, because it also provides qb-core for compatibility.
function Bridge.detect()
    for _, key in ipairs({ 'qbx', 'qb', 'esx' }) do
        if GetResourceState(frameworks[key].resource) == 'started' then
            active = frameworks[key]
            return active.label
        end
    end
    active = nil
    return nil
end

--- The player's jobs, gang and citizen ID, or nil if they haven't loaded a character.
function Bridge.player(source)
    if not active then return nil end
    local ok, result = pcall(active.player, source)
    if not ok then return nil end
    return result
end

--- Every identifier that could be on a whitelist for this player: their citizen ID and Discord ID.
function Bridge.identifiers(source, player)
    local list = {}
    if player and player.citizenid then list[#list + 1] = player.citizenid end
    local discord = GetPlayerIdentifierByType(source, 'discord')
    if discord then list[#list + 1] = discord end
    return list
end

Bridge.fromPlayerData = fromPlayerData
VehicleAccessBridge = Bridge
