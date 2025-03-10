local npcModel = "s_m_m_trucker_01" -- Modèle du PNJ (change si besoin)
local npcCoords = vector4(-350.919, -2767.133, 6.040, 50.2) -- Position + rotation du PNJ

Citizen.CreateThread(function()
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Citizen.Wait(100)
    end

    local npc = CreatePed(4, GetHashKey(npcModel), npcCoords.x, npcCoords.y, npcCoords.z - 1.0, npcCoords.w, false, true)
    
    -- Empêche le PNJ de disparaître
    SetEntityAsMissionEntity(npc, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(npcModel))

    -- Propriétés du PNJ
    SetEntityInvincible(npc, true) 
    SetBlockingOfNonTemporaryEvents(npc, true) 
    FreezeEntityPosition(npc, true) 

    print("PNJ chargé à l'endroit indiqué !")
end)
