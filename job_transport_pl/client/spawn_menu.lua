ESX = exports['es_extended']:getSharedObject()

local npcPosition = vector3(-350.9190, -2767.1335, 6.0402)
local npcHeading = 50.2006
local npcModel = "s_m_m_trucker_01" -- Modèle du NPC
local menuOpen = false

local vehicleConfig = {
    ['stagiaire'] = { {model = 'hauler', label = 'Hauler'} },
    ['apprenti'] = { {model = 'hauler', label = 'Hauler'} },
    ['chauffeur_pl'] = { {model = 'hauler', label = 'Hauler'} },
    ['chauffeur_pl_exp'] = {
        {model = 'hauler', label = 'Hauler'},
        {model = 'phantom', label = 'Phantom'}
    },
    ['chef_equipe'] = {
        {model = 'hauler', label = 'Hauler'},
        {model = 'phantom', label = 'Phantom'},
        {model = 'phantom3', label = 'Phantom Custom'}
    },
    ['patron'] = {
        {model = 'hauler', label = 'Hauler'},
        {model = 'phantom', label = 'Phantom'},
        {model = 'phantom3', label = 'Phantom Custom'},
        {model = 'phantom4', label = 'Phantom 4'}
    }
}

-- Création du NPC
Citizen.CreateThread(function()
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Wait(500)
    end
    
    local npc = CreatePed(4, GetHashKey(npcModel), npcPosition, npcHeading, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
end)

-- Vérifie la distance et affiche le message
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - npcPosition)

        if distance < 3.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour choisir un véhicule")
            if IsControlJustReleased(0, 38) and not menuOpen then
                OpenVehicleMenu()
            end
        end
    end
end)

-- Ouvre le menu des véhicules
function OpenVehicleMenu()
    ESX.TriggerServerCallback('esx:getPlayerData', function(data)
        local job = data.job.name
        local vehicles = vehicleConfig[job]
        
        if not vehicles then
            ESX.ShowNotification("Vous n'avez pas accès aux véhicules.")
            return
        end
        
        local elements = {}
        for _, veh in pairs(vehicles) do
            table.insert(elements, { label = veh.label, value = veh.model })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
            title = 'Choisissez un véhicule',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()
            SpawnVehicle(data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

-- Spawn le véhicule
local vehicleSpawnPoints = {
    {x = -367.734, y = -2767.876, z = 6.000, h = 313.711},
    {x = -363.065, y = -2773.156, z = 6.010, h = 326.126},
    {x = -362.247, y = -2783.009, z = 6.003, h = 0.309}
}

function SpawnVehicle(model)
    local playerPed = PlayerPedId()
    
    for _, pos in ipairs(vehicleSpawnPoints) do
        if not IsAnyVehicleNearPoint(pos.x, pos.y, pos.z, 3.0) then
            ESX.Game.SpawnVehicle(model, vector3(pos.x, pos.y, pos.z), pos.h, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                local plate = "PL-" .. math.random(1000, 9999)
                SetVehicleNumberPlateText(vehicle, plate)
            end)
            return
        end
    end

    ESX.ShowNotification("Toutes les places sont prises !")
end
    
    ESX.Game.SpawnVehicle(vehicleModel, vector3(spawnLocation.x, spawnLocation.y, spawnLocation.z), spawnLocation.h, function(vehicle)
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "PL-" .. math.random(1000, 9999))
    end)
end
