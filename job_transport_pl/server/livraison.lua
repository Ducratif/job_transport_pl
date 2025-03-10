ESX.RegisterServerCallback('job_transport_pl:giveReward', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addAccountMoney('cash', amount)
        TriggerClientEvent('esx:showNotification', source, "Vous avez reçu ~g~" .. amount .. "€ ~s~en liquide.")
    end
end)
