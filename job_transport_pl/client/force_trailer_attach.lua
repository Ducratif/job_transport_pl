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

local authorizedTrucks = {
    [`hauler`] = true,
    [`phantom`] = true,
    [`phantom3`] = true,
    [`phantom4`] = true
}

-- Fonction pour attacher une remorque
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle and authorizedTrucks[GetEntityModel(vehicle)] then
            local vehicleCoords = GetEntityCoords(vehicle)
            local trailerFound = nil

            -- Recherche une remorque proche
            for trailerModel, _ in pairs(authorizedTrailers) do
                local trailerHash = GetHashKey(trailerModel)
                local trailer = GetClosestVehicle(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 10.0, trailerHash, 70)

                if DoesEntityExist(trailer) then
                    trailerFound = trailer
                    break
                end
            end

            -- Si une remorque est trouvée, proposer l'attache
            if trailerFound then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour attacher la remorque")

                if IsControlJustReleased(0, 38) then
                    AttachVehicleToTrailer(vehicle, trailerFound, 1.0)
                    ESX.ShowNotification("🚛 Remorque attachée avec succès !")
                end
            end
        end
    end
end)

-- Fonction pour détacher une remorque
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle and authorizedTrucks[GetEntityModel(vehicle)] then
            if IsVehicleAttachedToTrailer(vehicle) then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour détacher la remorque")

                if IsControlJustReleased(0, 38) then
                    DetachVehicleFromTrailer(vehicle)
                    ESX.ShowNotification("🔗 Remorque détachée avec succès !")
                end
            end
        end
    end
end)
