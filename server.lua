ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback("mn-cbr:server:checkLicenses", function(source, callback)
    local src = source 
    local user = ESX.GetPlayerFromId(src)
    local dmv, truck, car, motor = false,false,false,false
    TriggerEvent('esx_license:getLicenses', src, function(licenses)
        for k,v in pairs(licenses) do 
            if v.type == 'dmv' then dmv = true end
            if v.type == 'drive' then car = true end
            if v.type == 'drive_bike' then motor = true end
            if v.type == 'drive_truck' then truck = true end
        end
        callback(dmv, truck, car, motor)
    end)
end)


ESX.RegisterServerCallback("mn-cbr:client:moneyCheck", function(source, callback, money)
    if ESX.GetPlayerFromId(source).getMoney() >= money then callback(true) ESX.GetPlayerFromId(source).removeMoney(money) return end
    callback(false)
end)


RegisterServerEvent("mn-cbr:server:giveLicense")
AddEventHandler("mn-cbr:server:giveLicense", function(data)
    local src = source 
    TriggerEvent('esx_license:addLicense', src, data, function() end)
end)


RegisterServerEvent("mn-cbr:server:TheorieDone", function(DATA)
    local fouten = 0
    for i=1, #DATA, 1 do 
        for k,v in pairs(DATA[i].antwoorden) do 
            if v.selected then 
                if not v.good then fouten = fouten + 1 end 
            end
        end
    end

    if fouten <= MN.maxTheoriefouten then 
        TriggerEvent('esx_license:addLicense', source, 'dmv', function() end)
        TriggerClientEvent('mn-cbr:client:notification', source, "~g~Gefeliciteerd u bent geslaagd!")
    else
        TriggerClientEvent('mn-cbr:client:notification', source, "~r~Helaas u bent gezakt")
    end
end)