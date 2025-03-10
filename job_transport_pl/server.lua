ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('job_transport_pl:setJob')
AddEventHandler('job_transport_pl:setJob', function(targetId, job)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xTarget then
        local jobGrade = 0

        -- Définir le grade automatiquement (ajuster selon ton système)
        if job == "stagiaire" then jobGrade = 0
        elseif job == "apprenti" then jobGrade = 1
        elseif job == "chauffeur_pl" then jobGrade = 2
        elseif job == "chauffeur_pl_exp" then jobGrade = 3
        elseif job == "chef_equipe" then jobGrade = 4
        elseif job == "patron" then jobGrade = 5
        elseif job == "unemployed" then job = "unemployed"; jobGrade = 0
        end


        -- Mettre à jour le job et le grade dans la base de données
        MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier', {
            ['@job'] = job,
            ['@grade'] = jobGrade,
            ['@identifier'] = xTarget.identifier
        }, function(rowsChanged)
            if rowsChanged > 0 then
                -- Appliquer le changement en live
                xTarget.setJob(job, jobGrade)
            
                -- Mise à jour immédiate et forçage de la sauvegarde en base
                MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @jobGrade WHERE identifier = @identifier', {
                    ['@job'] = job,
                    ['@jobGrade'] = jobGrade,
                    ['@identifier'] = xTarget.identifier
                })
            
                -- Notifier le joueur du changement de job
                TriggerClientEvent('esx:showNotification', targetId, "Votre métier a été changé en : " .. job .. " !")
            
                -- Forcer la mise à jour côté client
                TriggerClientEvent('job_transport_pl:updateJob', targetId, job, jobGrade)
            else
                TriggerClientEvent('esx:showNotification', targetId, "Erreur lors du changement de métier.")
            end
            
            
        end)
    end
end)




local playerVehicles = {}

RegisterServerEvent('registerPlayerVehicle')
AddEventHandler('registerPlayerVehicle', function(playerId, vehicle)
    playerVehicles[playerId] = vehicle
    print("Véhicule enregistré pour le joueur " .. playerId .. ": " .. vehicle)
end)

RegisterServerEvent('unregisterPlayerVehicle')
AddEventHandler('unregisterPlayerVehicle', function(playerId)
    playerVehicles[playerId] = nil
    print("Véhicule supprimé pour le joueur " .. playerId)
end)

RegisterServerEvent('getPlayerVehicle')
AddEventHandler('getPlayerVehicle', function(playerId)
    local vehicle = playerVehicles[playerId]
    TriggerClientEvent('setPlayerVehicle', source, vehicle)
end)


RegisterServerEvent("job_transport_pl:giveMoney")
AddEventHandler("job_transport_pl:giveMoney", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addMoney(amount) -- Ajoute l'argent directement en liquide
        TriggerClientEvent('esx:showNotification', source, "Vous avez reçu ~g~" .. amount .. "€ en liquide.")
    else
        print("[ERROR] Impossible de récupérer le joueur avec l'ID: " .. source)
    end
end)

