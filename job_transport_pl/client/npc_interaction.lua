local npcCoords = vector3(-350.919, -2767.133, 6.040) -- Position du PNJ
local npcModel = "s_m_m_trucker_01" -- Modèle du PNJ (un chauffeur)
local playerVehicles = {} -- Stockage des véhicules déjà sortis

-- Spawn du PNJ
Citizen.CreateThread(function()
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(npcModel), npcCoords.x, npcCoords.y, npcCoords.z - 1.0, 50.2, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
end)

-- Interaction avec le PNJ
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - npcCoords)

        if distance < 3.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au chef de transport")
            if IsControlJustReleased(0, 38) then -- Touche E
                OpenVehicleMenu()
            end
        end
    end
end)

-- Fonction pour afficher le menu des véhicules
function OpenVehicleMenu()
    local elements = {}

    ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
        local jobGrade = playerData.job.grade_name -- Grade du joueur

        if vehicleConfig[jobGrade] then
            for _, vehicle in ipairs(vehicleConfig[jobGrade]) do
                table.insert(elements, {label = vehicle.label, value = vehicle.model})
            end
        else
            table.insert(elements, {label = "Aucun véhicule disponible", value = nil})
        end

        -- Création du menu
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
            title = "Sélection de véhicule",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleModel = data.current.value
            if vehicleModel then
                SpawnJobVehicle(vehicleModel)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end)
end

-- Fonction pour spawn un véhicule
function SpawnJobVehicle(vehicleModel)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId()) -- ID du joueur
    local spawnPoints = {
        vector3(-367.73, -2767.87, 6.00),
        vector3(-363.06, -2773.15, 6.01),
        vector3(-362.24, -2783.00, 6.00)
    }

    -- Supprimer le véhicule existant du joueur
    if playerVehicles[playerId] and DoesEntityExist(playerVehicles[playerId]) then
        ESX.Game.DeleteVehicle(playerVehicles[playerId])
    end

    -- Vérifier si une place est libre et spawn le véhicule
    for _, spawnPoint in ipairs(spawnPoints) do
        if ESX.Game.IsSpawnPointClear(spawnPoint, 3.0) then
            ESX.Game.SpawnVehicle(vehicleModel, spawnPoint, 50.2, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                playerVehicles[playerId] = vehicle -- Sauvegarde du véhicule
                ESX.ShowNotification("Véhicule sorti avec succès !")
            end)
            return
        end
    end

    ESX.ShowNotification("Toutes les places de spawn sont occupées !")
end
