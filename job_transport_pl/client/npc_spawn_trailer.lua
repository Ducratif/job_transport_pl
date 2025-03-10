local npcCoords = vector3(-498.322, -2855.463, 7.295)
local npcModel = "s_m_m_trucker_01" 
local trailerModels = {
    {model = "docktrailer", label = "Conteneur"},
    {model = "freighttrailer", label = "Rien"},
    {model = "tanker", label = "Fuel"},
    {model = "tr4", label = "Voiture"},
    {model = "trailerlogs", label = "Bois"},
    {model = "trailers2", label = "Remorque Boutique"},
    {model = "trailers3", label = "Livraison"},
    {model = "tvtrailer", label = "Télévision"},
    {model = "tvtrailer2", label = "Sport"}
}
local trailerSpots = {
    vector4(-514.902, -2856.003, 5.136, 45.69),
    vector4(-508.849, -2852.764, 5.136, 42.99),
    vector4(-505.184, -2847.696, 5.137, 43.83),
    vector4(-501.139, -2842.647, 5.137, 46.99)
}
local currentTrailer = nil

-- Spawn du PNJ
Citizen.CreateThread(function()
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Wait(1)
    end
    local npc = CreatePed(4, GetHashKey(npcModel), npcCoords.x, npcCoords.y, npcCoords.z - 1.0, 39.74, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    print("[JOB TRANSPORT] PNJ de prise de service chargé.")
end)

-- Vérification de la proximité et affichage du menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - npcCoords)

        if distance < 2.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre votre service")
            if IsControlJustReleased(0, 38) then -- Touche E
                OpenTrailerMenu()
            end
        end
    end
end)

-- Ouverture du menu de sélection de remorque
function OpenTrailerMenu()
    local elements = {}
    for _, trailer in ipairs(trailerModels) do
        table.insert(elements, {label = trailer.label, value = trailer.model})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'trailer_menu', {
        title = "Sélectionnez une remorque",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        menu.close()
        SpawnTrailer(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

-- Spawn de la remorque
function SpawnTrailer(model)
    if currentTrailer then
        ESX.Game.DeleteVehicle(currentTrailer)
    end
    
    for _, spot in ipairs(trailerSpots) do
        if ESX.Game.IsSpawnPointClear(vector3(spot.x, spot.y, spot.z), 2.5) then
            ESX.Game.SpawnVehicle(model, vector3(spot.x, spot.y, spot.z), spot.w, function(vehicle)
                currentTrailer = vehicle
                ESX.ShowNotification("Merci d'aller à la barrière pour valider votre bon de livraison !")
            end)
            return
        end
    end
    
    ESX.ShowNotification("Aucun quai de chargement disponible.")
end
