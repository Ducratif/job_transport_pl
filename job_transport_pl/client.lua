ESX = exports['es_extended']:getSharedObject()
local vehiclesSpawned = {}

function OpenJobMenu()
    local elements = {}
    local playersInArea = ESX.Game.GetPlayersInArea(vector3(-326.3223, -2769.7073, 5.2070), 10.0)
    
    for _, player in ipairs(playersInArea) do
        local playerId = GetPlayerServerId(player)
        table.insert(elements, {label = GetPlayerName(player), value = playerId})
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu', {
        title = 'Gestion des employés',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        OpenGradeMenu(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenGradeMenu(playerId)
    local elements = {
        {label = 'Virer', value = 'unemployed'},
        {label = 'Stagiaire', value = 'stagiaire'},
        {label = 'Apprenti Chauffeur PL', value = 'apprenti'},
        {label = 'Chauffeur PL', value = 'chauffeur_pl'},
        {label = 'Chauffeur PL Expérimenté', value = 'chauffeur_pl_exp'},
        {label = 'Chef d\'équipe', value = 'chef_equipe'},
        {label = 'Patron', value = 'patron'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'grade_menu', {
        title = 'Attribuer un grade',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('job_transport_pl:setJob', playerId, data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(-326.3223, -2769.7073, 5.2070))
        
        if distance < 5 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour gérer les employés")
            if IsControlJustReleased(0, 38) then
                OpenJobMenu()
            end
        end
    end
end)



RegisterNetEvent('job_transport_pl:updateJob')
AddEventHandler('job_transport_pl:updateJob', function(job, jobGrade)
    local playerData = ESX.GetPlayerData()
    playerData.job = { name = job, grade = jobGrade }
    ESX.SetPlayerData('job', playerData.job)
    ESX.ShowNotification("Votre métier a été mis à jour : " .. job .. " (" .. jobGrade .. ") !")

    -- Debugging (Supprime après test)
    print("Mise à jour du job côté client :", job, jobGrade)
end)
