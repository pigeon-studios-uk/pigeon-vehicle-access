--[[
    Pigeon Vehicle Access: client.

    Does what the server says: keeps the engine off while this player is in the driver's seat of a vehicle
    they aren't allowed to drive, and shows a reminder. The server decides who is allowed; nothing is decided here.
]]

local RESOURCE = GetCurrentResourceName()

local active                    -- { netId, vehicle, message }

local function releaseVehicle(vehicle)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetVehicleUndriveable(vehicle, false)
    end
end

local function stop()
    if active then releaseVehicle(active.vehicle) end
    active = nil
end

RegisterNetEvent(RESOURCE .. ':client:enforce', function(netId, message)
    if type(netId) ~= 'number' then return end
    if active and active.netId ~= netId then stop() end
    message = type(message) == 'string' and message or ''

    -- Repeats from the server just refresh the message; the loop below is already running.
    if active then
        active.message = message
        return
    end
    active = { netId = netId, message = message }

    CreateThread(function()
        while active and active.netId == netId do
            local vehicle = NetworkDoesNetworkIdExist(netId) and NetworkGetEntityFromNetworkId(netId) or 0
            local ped = PlayerPedId()
            if vehicle == 0 or not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= ped then
                -- Not in the driver's seat any more; the server will confirm, but stop straight away.
                releaseVehicle(vehicle)
                if active and active.netId == netId then active = nil end
                break
            end

            active.vehicle = vehicle
            SetVehicleEngineOn(vehicle, false, true, true)
            SetVehicleUndriveable(vehicle, true)

            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(active.message)
            EndTextCommandDisplayHelp(0, false, false, -1)

            Wait(0)
        end
    end)
end)

RegisterNetEvent(RESOURCE .. ':client:release', function(netId)
    if active and (netId == nil or active.netId == netId) then stop() end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == RESOURCE then stop() end
end)
