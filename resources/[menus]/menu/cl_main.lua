Citizen.CreateThread(function()

    while true do

        Citizen.Wait(10)

        if IsControlJustPressed(1,166) then
            menu()
        end

    end

end)

local array = {
        "EntityXF",
        "Adder",
        "Blista"
    }

local arrayIndex = 1



function menu()
local ped = PlayerPedId()

Citizen.CreateThread(function()
    local menuTest = RageUI.CreateMenu("Main Menu", " ")

    RageUI.Visible(menuTest, not RageUI.Visible(menuTest))

    while menuTest do

        RageUI.IsVisible(menuTest,true,true,true,function()
        
            
            RageUI.Separator("Vehicle related")

            RageUI.List("Vehicle", array, arrayIndex, "Choose a vehicle to spawn", {}, true, function(Hovered, Active, Selected, i) arrayIndex = i 
                            if Selected then
                                RageUI.CloseAll()
                                spawnCar(array[arrayIndex])
                            end
                        end)

            RageUI.ButtonWithStyle("Repair","Repair the current vehicle", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then    
                    repairCar(ped)
                    print(ped)
                end
            end)  

            RageUI.Separator("TEST")

            RageUI.ButtonWithStyle("Titre du bouton",nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
                if Selected then    
                end
            end)
        
        end, function()
        end)
    
        Citizen.Wait(0)
    end

end)
end

function spawnCar(vehicleName)
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local vehicleId = GetVehiclePedIsIn(playerPed, false)

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        return
    end

    if (vehicleId ~= 0) then
        DeleteEntity(vehicleId)
    end
    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(500)
    end

    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetEntityAsNoLongerNeeded(vehicle)

    SetModelAsNoLongerNeeded(vehicleName)
end

function repairCar(ped)
    local vehicleId = GetVehiclePedIsIn(ped, false)
    print(vehicleId)

    SetVehicleTyreFixed(vehicleId)
    SetVehicleFixed(vehicleId)
    SetVehicleEngineHealth(vehicleId, 1000.0)
    SetVehicleDeformationFixed(vehicleId)
end
