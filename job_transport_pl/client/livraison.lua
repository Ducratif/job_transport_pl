function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not handle or handle == -1 then
            return
        end
        local success
        repeat
            coroutine.yield(vehicle)
            success, vehicle = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end


local deliveryNPC = nil
local npcCoords = vector4(-378.2488, -2770.6555, 6.04537, 46.07542)
local deliveryPoint = nil
local deliveryPNJ = nil
local deliveryBlip = nil
local reward = 0

local authorizedTrucks = {
    [`hauler`] = true,
    [`phantom`] = true,
    [`phantom3`] = true,
    [`phantom4`] = true
}

local authorizedTrailers = {
    [`docktrailer`] = true,
    [`freighttrailer`] = true,
    [`tanker`] = true,
    [`tr4`] = true,
    [`trailerlogs`] = true,
    [`trailers2`] = true,
    [`trailers3`] = true,
    [`tvtrailer`] = true,
    [`tvtrailer2`] = true
}

local deliveryLocations = {
    ville = {
        {x = -694.80, y = -2454.77, z = 13.86, reward = 500},
        {x = -887.51, y = -3004.30, z = 13.08, reward = 500},
        {x = -389.66, y = -1878.83, z = 19.66, reward = 800},
        {x = -344.53, y = -1520.52, z = 26.87, reward = 800},
        {x = -727.15, y = -914.17, z = 18.14, reward = 900},
        {x = -835.79, y = -809.48, z = 18.62, reward = 900},
        {x = -1051.42, y = -250.19, z = 36.94, reward = 1000},
        {x = -1379.89, y = 52.01, z = 52.81, reward = 1200},
        {x = -1432.85, y = -249.93, z = 45.50, reward = 1300},
        {x = -1514.76, y = -421.23, z = 34.57, reward = 1300},
        {x = -1668.52, y = -542.80, z = 34.12, reward = 1300}
    },
    entreDeux = {
        {x = -2968.76, y = 64.66, z = 10.74, reward = 2000},
        {x = -2963.01, y = 369.73, z = 13.90, reward = 2000},
        {x = -3251.03, y = 992.02, z = 11.61, reward = 2200},
        {x = -2553.25, y = 2321.25, z = 32.19, reward = 3000}
    },
    nordDucratif = {
        {x = -2194.89, y = 3301.98, z = 31.94, reward = 5000},
        {x = -1575.24, y = 5157.69, z = 18.95, reward = 5200},
        {x = 40.64, y = 3682.99, z = 38.70, reward = 5500},
        {x = 388.73, y = 3591.79, z = 32.42, reward = 5700},
        {x = 1533.96, y = 3769.58, z = 33.18, reward = 5850}
    },
    testDucratif = {
        {x = -369.12, y = -2801.22, z = 6.00, reward = 5000},
        {x = -407.37, y = -2806.55, z = 6.00, reward = 7200}
    }
}

function SpawnDeliveryPNJ(location)
    RequestModel("s_m_m_trucker_01")
    while not HasModelLoaded("s_m_m_trucker_01") do
        Wait(100)
    end
    deliveryPNJ = CreatePed(4, "s_m_m_trucker_01", location.x, location.y, location.z - 1.0, 0.0, false, true)
    SetEntityInvincible(deliveryPNJ, true)
    FreezeEntityPosition(deliveryPNJ, true)
    SetBlockingOfNonTemporaryEvents(deliveryPNJ, true)
end

function ValidateFinalDelivery()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local truck, trailer = GetNearbyTruckAndTrailer()

    if not trailer or #(GetEntityCoords(trailer) - vector3(deliveryPoint.x, deliveryPoint.y, deliveryPoint.z)) > 20.0 then
        ESX.ShowNotification("Votre remorque n'est pas à moins de 20m du PNJ de livraison.")
        return
    end

    if #(playerCoords - vector3(deliveryPoint.x, deliveryPoint.y, deliveryPoint.z)) > 2.0 then
        ESX.ShowNotification("Vous devez être proche du PNJ de livraison.")
        return
    end

    DeleteEntity(trailer)
    RemoveBlip(deliveryBlip)
    deliveryPoint = nil

    -- Envoi au serveur pour ajouter l'argent
    TriggerServerEvent("job_transport_pl:giveMoney", reward)

    ESX.ShowNotification("Livraison effectuée, vous avez gagné " .. reward .. "€ en liquide.")
end




-- PNJ DE DEPART DE LIVRAISON

Citizen.CreateThread(function()
    RequestModel("s_m_m_trucker_01")
    while not HasModelLoaded("s_m_m_trucker_01") do
        Wait(100)
    end
    deliveryNPC = CreatePed(4, "s_m_m_trucker_01", npcCoords.x, npcCoords.y, npcCoords.z - 1.0, npcCoords.w, false, true)
    SetEntityInvincible(deliveryNPC, true)
    FreezeEntityPosition(deliveryNPC, true)
    SetBlockingOfNonTemporaryEvents(deliveryNPC, true)
end)

function GetNearbyTruckAndTrailer()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local truck, trailer = nil, nil

    for vehicle in EnumerateVehicles() do
        local model = GetEntityModel(vehicle)

        -- Vérifie si c'est un camion
        if authorizedTrucks[model] and #(playerCoords - GetEntityCoords(vehicle)) < 10.0 then
            truck = vehicle
        end

        -- Vérifie si c'est une remorque
        if authorizedTrailers[model] and #(playerCoords - GetEntityCoords(vehicle)) < 10.0 then
            trailer = vehicle
        end

        -- Si on a trouvé les deux, on arrête la recherche
        if truck and trailer then
            break
        end
    end

    return truck, trailer
end


function ValidateDelivery()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local truck, trailer = GetNearbyTruckAndTrailer()
    
    if not truck then
        --ShowMessage("Vous n'avez pas de camion proche.")
        ESX.ShowNotification("Vous n'avez pas de camion proche.")
        return false
    end
    
    if not trailer then
        ESX.ShowNotification("Vous n'avez pas de remorque proche.")
        return false
    end
    
    if #(playerCoords - vector3(npcCoords.x, npcCoords.y, npcCoords.z)) > 2.0 then
        ESX.ShowNotification("Vous devez être proche du PNJ de livraison.")
        return false
    end
    
    return true
end

function ShowMessage(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function OpenDeliveryMenu()
    local elements = {
        {label = "Livraison en Ville", value = "ville"},
        {label = "Entre Deux", value = "entreDeux"},
        {label = "Nord de Ducratif", value = "nordDucratif"},
        {label = "Test développemebt Ducratif", value = "testDucratif"}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delivery_menu', {
        title = "Choisissez votre destination",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local category = data.current.value
        if deliveryLocations[category] then
            deliveryPoint = deliveryLocations[category][math.random(#deliveryLocations[category])]
            reward = deliveryPoint.reward
            deliveryBlip = AddBlipForCoord(deliveryPoint.x, deliveryPoint.y, deliveryPoint.z)
            SetBlipRoute(deliveryBlip, true)
            SpawnDeliveryPNJ(deliveryPoint)
            ESX.ShowNotification("Livraison définie, direction: " .. category)
        else
            ESX.ShowNotification("Erreur : Destination invalide.")
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end


-- Vérifier si le joueur est sur l'un ou l'autre PNJ
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        -- Vérification si le joueur est au point de livraison
        if deliveryPoint then
            if #(playerCoords - vector3(deliveryPoint.x, deliveryPoint.y, deliveryPoint.z)) < 2.0 then
                ShowMessage("Appuyez sur ~INPUT_CONTEXT~ pour finaliser votre livraison.")
                if IsControlJustPressed(0, 38) then
                    ValidateFinalDelivery()
                end
            end
        end

        -- Vérification si le joueur est proche du PNJ pour valider le bon de livraison
        if npcCoords then
            if #(playerCoords - vector3(npcCoords.x, npcCoords.y, npcCoords.z)) < 2.0 then
                ShowMessage("Appuyez sur ~INPUT_CONTEXT~ pour valider votre bon de livraison.")
                if IsControlJustPressed(0, 38) then
                    if ValidateDelivery() then
                        OpenDeliveryMenu()
                    end
                end
            end
        end
    end
end)

-- ANNULER LA LIVRAISON, touche: A
function CancelDelivery()
    if not deliveryPoint then
        ESX.ShowNotification("Vous n'avez pas de livraison en cours.")
        return
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if not vehicle or not authorizedTrucks[GetEntityModel(vehicle)] then
        ESX.ShowNotification("Vous devez être dans un camion pour annuler la livraison.")
        return
    end

    local elements = {
        {label = "Oui", value = "yes"},
        {label = "Non", value = "no"}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cancel_delivery_menu', {
        title = "Voulez-vous annuler la livraison ?",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "yes" then
            RemoveBlip(deliveryBlip)
            deliveryPoint = nil
            deliveryPNJ = nil
            ESX.ShowNotification("Livraison annulée ! Le client est averti.")
        else
            ESX.ShowNotification("La livraison continue !")
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 74) then -- Touche A (QAZERTY) ou Gauche (AZERTY)
            CancelDelivery()
        end
    end
end)

