-- car: Name of the model to be added to the script
-- door1, door2: index of the doors to fold:
-- 0: Drivers Front (dside_f)
-- 1: Passengers Front (pside_f)
-- 2: Drivers Rear (dside_r)
-- 3: Passengers Rear (pside_r)
local config = {
    {car = 'f14d2', door1 = 2, door2 = 3},
    {car = 'bone', door1 = 0, door2 = 1},
}

-- rlgNotify has been disabled, you can use your own notification script here if youd like.

local sweep = true
RegisterCommand('sweep', function()
    sweep = not sweep
    -- rlgNotify('~b~Auto wing-sweep ~w~'..tostring(sweep))
end)

RegisterCommand('wings', function()
    sweep = false
    for k,v in pairs(config) do
        if GetVehicleDoorAngleRatio(GetVehiclePedIsIn(PlayerPedId()), v.door1) < 0.9 then
            -- rlgNotify('~b~Wings Swept Back.')
            SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), v.door1, 0, 0)
            SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), v.door2, 0, 0)
        else
            -- rlgNotify('~b~Wings Swept Forwards.')
            SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), v.door1, 0)
            SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), v.door2, 0)
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/sweep', 'Toggle Automatic Wing Sweeping')
TriggerEvent('chat:addSuggestion', '/wings', 'Toggle Wings Sweep Position')

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(config) do
            if sweep then
                local ped = PlayerPedId()
                if GetEntityModel(GetVehiclePedIsIn(ped)) == GetHashKey(v.car) then
                    local veh = GetVehiclePedIsIn(ped)

                    if GetEntitySpeed(veh) >= 100 then
                        if not IsVehicleDoorFullyOpen(veh, v.door1) and not IsVehicleDoorFullyOpen(veh, v.door2) then
                            SetVehicleDoorOpen(veh, v.door1, 0, 0)
                            SetVehicleDoorOpen(veh, v.door2, 0, 0)
                        end
                    elseif GetEntitySpeed(veh) >= 10 and not IsControlPressed(0, 71) then
                        local angle = GetVehicleDoorAngleRatio(veh, v.door1)
                        local angle2 = GetVehicleDoorAngleRatio(veh, v.door2)
                        if angle >= 0.9 and angle2 >= 0.9 then
                            SetVehicleDoorShut(veh, v.door1, 0)
                            SetVehicleDoorShut(veh, v.door2, 0)
                        end
                    end
                end
            end
        end
    end
end)