ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)




--- Thread 



Citizen.CreateThread(function()
    while true do 
        Wait(3)

        local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())

        local sleep = true
        for k,v in pairs(MN.markers) do 
            local x,y,z = table.unpack(v.coords)
            local dist = #(vector3(x,y,z) - coords)


            if (dist < 10) then 
                sleep = false
                DrawMarker(20,x,y,z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.3, 0.2, 147,112,219, 100, false, true, 2, true, nil, nil, false) 

                if (dist < 1.5) then 
                    DrawScriptText(vector3(x,y,z), v.draw)

                    if (IsControlJustReleased(0, v.key)) then 
                        TriggerEvent(v.trigger)
                    end
                end
            end
        end
        if sleep then 
            Wait(500)
        end
    end
end)



RegisterNetEvent("mn-cbr:client:openCBR")
AddEventHandler('mn-cbr:client:openCBR', function()
    ESX.TriggerServerCallback("mn-cbr:server:checkLicenses", function(dmv, truck, car, motor)
        elements = {}
        if not (dmv) then 
            table.insert(elements,{
                label = "Theorie aanvragen | <span style='color: green;'>€" .. MN.PraktijkData['dmv'].price .. "</span>", trigger = "mn-cbr:client:openTheorie", params = nil
            })
        else
            if not (car) then 
                table.insert(elements,{
                    label = "Auto afrijden | <span style='color: green;'>€" .. MN.PraktijkData['drive'].price .. "</span>", trigger = "mn-cbr:client:startpraktijk", params = MN.PraktijkData['drive'].vehicle, type = 'drive'
                })
            end
            if not (truck) then 
                table.insert(elements,{
                    label = "Vrachtwagen afrijden | <span style='color: green;'>€" .. MN.PraktijkData['drive_truck'].price .. "</span>", trigger = "mn-cbr:client:startpraktijk", params = MN.PraktijkData['drive_truck'].vehicle, type = 'drive_truck'
                })
            end
            if not (motor) then 
                table.insert(elements,{
                    label = "Motor afrijden | <span style='color: green;'>€" .. MN.PraktijkData['drive_bike'].price .. "</span>", trigger = "mn-cbr:client:startpraktijk", params = MN.PraktijkData['drive_bike'].vehicle, type = 'drive_bike'
                })
            end
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mn-scripts', {
            title = "CBR",
            align = "top-right",
            elements = elements
        }, function(data, menu)
            if data.current.trigger == 'mn-cbr:client:startpraktijk' then curType = data.current.type end
            TriggerEvent(data.current.trigger, data.current.params)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end)
end)




-- Afrijden 


RegisterNetEvent("mn-cbr:client:startpraktijk")
AddEventHandler("mn-cbr:client:startpraktijk", function(waggie)
    ESX.TriggerServerCallback("mn-cbr:client:moneyCheck", function(Enough)
        if (Enough) then 
            praktijk(waggie)
        else
            ESX.ShowNotification("~r~U heeft niet genoeg geld")
        end
    end, MN.PraktijkData[curType].price)
end)


praktijk = function(waggie)
    local route = MN.Routes[curType]
    local index = 1 
    mistakes = 0
    local x,y,z,h = table.unpack(route[index].coords)
    onroute =  true
    speedtoMuch = false
    ESX.Game.SpawnVehicle(waggie, vector3(x,y,z), h, function(veh) 
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleNumberPlateText(veh, "PRAKTIJK")

        local Health = 1000 

        Citizen.CreateThread(function()
            index = index +1
            createBlip(route[index].coords.x, route[index].coords.y, route[index].coords.z)
            while onroute do 
                Wait(3)

                local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())

                if not (IsPedInVehicle(PlayerPedId(), veh)) then ESX.ShowNotification("~r~U bent uitgestapt") ESX.Game.DeleteVehicle(veh) return end

                local x,y,z = table.unpack(route[index].coords)
                local dist = #(vector3(x,y,z) - coords)
                DrawMarker(1, x,y,z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)

                local speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6

                if (GetEntityHealth(veh) < Health) then 
                    Health = GetEntityHealth(veh)
                    mistakes = mistakes + 1
                    ESX.ShowNotification("~r~U heeft schade aan de auto aangebracht. aantal fouten: " .. mistakes)
                end

                if (speed > route[index].maxspeed) then 
                    if not speedtoMuch then
                        speedtoMuch = true
                        mistakes = mistakes + 1 
                        ESX.ShowNotification("~r~U reed tehard! aantal fouten: " .. mistakes)
                        ESX.SetTimeout(2500,function()
                            speedtoMuch = false
                        end)
                    end
                end
                if (dist < 2) then 
                    if (route[index +1] == nil) then RemoveBlip(blip) checkScore() return end
                    index = index + 1
                    createBlip(route[index].coords.x, route[index].coords.y, route[index].coords.z)
                end
            end
        end)
    end)
end

createBlip = function(x,y,z)
    if DoesBlipExist(blip) then RemoveBlip(blip) end
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite (blip, 0)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 5)
    SetBlipRoute(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Volgende checkpoint')
    EndTextCommandSetBlipName(blip)
end


checkScore = function()
    if mistakes < MN.maxFouten then 
        ESX.ShowNotification("~g~Je bent geslaagd!")
        TriggerServerEvent("mn-cbr:server:giveLicense", curType)
    else
        ESX.ShowNotification("~r~Je bent gezakt")
    end
end



-- Theorie UI


RegisterNetEvent('mn-cbr:client:openTheorie')
AddEventHandler('mn-cbr:client:openTheorie', function()
    ESX.TriggerServerCallback("mn-cbr:client:moneyCheck", function(Enough)
        if Enough then
            SendNUIMessage({
                action = "openCBR"
            })
            SetNuiFocus(true, true)
        else
            ESX.ShowNotification("~r~U heeft niet genoeg geld")
        end
    end, MN.PraktijkData['dmv'].price)
end)

RegisterNUICallback("testDone", function(DATA)
    TriggerServerEvent("mn-cbr:server:TheorieDone", DATA)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("mn-cbr:client:notification")
AddEventHandler("mn-cbr:client:notification", function(msg)
    ESX.ShowNotification(msg)
end)


-- Utils 

function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end