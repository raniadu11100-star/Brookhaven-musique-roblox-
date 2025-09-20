-- playlist_fr.lua
-- Script à placer dans ServerScriptService (serveur) ou dans un Script côté serveur.
-- Remplace les "RBX_ASSET_ID" par tes propres IDs audio uploadés (ex: 123456789)

local Playlist = {
    "rbxassetid://RBX_ASSET_ID_1", -- ex: "rbxassetid://123456789"
    "rbxassetid://RBX_ASSET_ID_2",
    "rbxassetid://RBX_ASSET_ID_3",
    -- ajoute autant d'IDs que tu veux
}

local volume = 0.6       -- volume par défaut (0.0 -> 1.0)
local shuffle = false    -- true = lecture aléatoire, false = lecture dans l'ordre
local loopPlaylist = true -- true = répéter la playlist indéfiniment

local SoundService = game:GetService("SoundService")

-- Création du lecteur dans SoundService
local playerSound = Instance.new("Sound")
playerSound.Name = "PlaylistPlayer"
playerSound.Looped = false
playerSound.Volume = volume
playerSound.Parent = SoundService

-- Fonction utilitaire : retourne une table copiée
local function shuffleTable(t)
    local out = {}
    for i = 1, #t do out[i] = t[i] end
    for i = #out, 2, -1 do
        local j = math.random(1, i)
        out[i], out[j] = out[j], out[i]
    end
    return out
end

-- Prépare l'ordre de lecture
local playOrder = {}
local function prepareOrder()
    if shuffle then
        playOrder = shuffleTable(Playlist)
    else
        playOrder = {}
        for i = 1, #Playlist do playOrder[i] = Playlist[i] end
    end
end

-- Lecture principale (boucle)
spawn(function()
    if #Playlist == 0 then
        warn("Playlist vide — ajoute des RBX asset IDs dans la table Playlist.")
        return
    end

    prepareOrder()
    local index = 1

    while true do
        if index > #playOrder then
            if loopPlaylist then
                prepareOrder
