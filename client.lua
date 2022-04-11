ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)



RegisterNetEvent('mn-cbr:client:openTheorie')
AddEventHandler('mn-cbr:client:openTheorie', function()
    SendNUIMessage({
        action = "openCBR"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("testDone", function(DATA)
    TriggerServerEvent("nlrp-rijschool:geefLicentie", 'dmv', DATA)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("mn-cbr:client:notification")
AddEventHandler("mn-cbr:client:notification", function(msg)
    ESX.ShowNotification(msg)
end)