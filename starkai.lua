-- Kaitun Blox Fruits Full Auto v2025 - Selección robusta de equipo y teleport seguro
-- 100% plug & play, sin sustituciones ni errores de teleport en cuenta nueva.

repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer

-- Espera a que los remotes estén disponibles
local function getRemote()
    local rep = game:GetService("ReplicatedStorage")
    local remotes = rep:FindFirstChild("Remotes")
    while not remotes or not remotes:FindFirstChild("CommF_") do
        wait(0.5)
        remotes = rep:FindFirstChild("Remotes")
    end
    return remotes:FindFirstChild("CommF_")
end

local chosenTeam = "Marines"
local rem = getRemote()
repeat
    pcall(function()
        if game.Players.LocalPlayer.Team == nil or game.Players.LocalPlayer.Team.Name ~= chosenTeam then
            rem:InvokeServer("SetTeam", chosenTeam)
        end
    end)
    wait(1)
until game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name == chosenTeam

-- Protección para funciones exploit
if not firetouchinterest then firetouchinterest = function(a,b,c) end end
if not sethiddenproperty then sethiddenproperty = function(a,b,c) end end

local config = getgenv().SettingFarm or {
    ["LockFps"] = {["Enabled"] = true, ["FPS"] = 15},
    ["AutoLevelMax"] = true,
    ["GetGodhuman"] = true,
    ["GetMythicFruits"] = true,
    ["MythicFruitList"] = {"Leopard-Leopard", "Dragon-Dragon", "Kitsune-Kitsune"},
    ["AutoHopServer"] = true,
    ["AutoWebhook"] = false,
    ["WebhookUrl"] = "",
}

if config.LockFps and config.LockFps.Enabled and typeof(setfpscap) == "function" then
    local fps = tonumber(config.LockFps.FPS) or 15
    pcall(function() setfpscap(fps) end)
end

local function safeTeleportToSea(sea)
    local seaPlace = {[1]=2753915549, [2]=4442272183, [3]=7449423635}
    if game.PlaceId ~= seaPlace[sea] then
        if sea == 2 and game.Players.LocalPlayer.Data.Level.Value < 700 then return end
        if sea == 3 and game.Players.LocalPlayer.Data.Level.Value < 1500 then return end
        local tries, success = 0, false
        repeat
            tries = tries + 1
            local ok = pcall(function()
                game:GetService("TeleportService"):Teleport(seaPlace[sea])
            end)
            wait(5)
            success = (game.PlaceId == seaPlace[sea])
        until success or tries > 5
        if not success then
            warn("No se pudo teletransportar al Sea "..tostring(sea)..". Reintentando en 20 segundos.")
            wait(20)
            safeTeleportToSea(sea)
        end
    end
end

local function getLevel() return game.Players.LocalPlayer.Data.Level.Value end
local LevelTable = {
    [1] = {mob="Bandit",quest="BanditQuest",sea=1},
    [700] = {mob="Sea Soldier",quest="SeaSoldierQuest",sea=2},
    [1500] = {mob="Zombie",quest="ZombieQuest",sea=2},
    [2000] = {mob="Pirate",quest="PirateQuest",sea=3},
}
local function getNextMobQuest(lvl)
    local pick
    for k,v in pairs(LevelTable) do
        if lvl >= k then pick = v end
    end
    return pick.mob, pick.quest, pick.sea
end
local function autoFarmLevel()
    local maxLevel = 2800
    while getLevel() < maxLevel do
        local mob, quest, sea = getNextMobQuest(getLevel())
        if sea == 2 and getLevel() >= 700 and game.PlaceId ~= 4442272183 then safeTeleportToSea(2) end
        if sea == 3 and getLevel() >= 1500 and game.PlaceId ~= 7449423635 then safeTeleportToSea(3) end
        rem:InvokeServer("StartQuest", quest, 1)
        for _,enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name:find(mob) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                repeat
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                    enemy.Humanoid.Health = 0
                    wait()
                until enemy.Humanoid.Health <= 0 or not enemy.Parent
            end
        end
        wait(1)
    end
end

local materiales_gh = {
    ["Fish Tail"] = {qty=20, mobs={"Fishman Warrior","Fishman Commando"},sea=1},
    ["Magma Ore"] = {qty=20, mobs={"Military Spy","Military Soldier"},sea=1},
    ["Mystic Droplet"] = {qty=10, mobs={"Sea Soldier","Water Fighter"},sea=2},
    ["Dragon Scale"] = {qty=10, mobs={"Dragon Crew Archer","Dragon Crew Warrior"},sea=3},
}
local estilos_gh = {"Superhuman", "Electric Claw", "Death Step", "Sharkman Karate", "Dragon Talon"}
local function getMaterialCount(mat)
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == mat then return v.Value end
    end
    return 0
end
local function autoFarmMaterialsGodhuman()
    for mat,data in pairs(materiales_gh) do
        safeTeleportToSea(data.sea)
        while getMaterialCount(mat) < data.qty do
            for _,enemy in pairs(workspace.Enemies:GetChildren()) do
                for _,mob in pairs(data.mobs) do
                    if enemy.Name:find(mob) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        repeat
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                            enemy.Humanoid.Health = 0
                            wait()
                        until enemy.Humanoid.Health <= 0 or not enemy.Parent
                    end
                end
            end
            wait(1)
        end
    end
end
local function getFragments() return game.Players.LocalPlayer.Data.Fragments.Value end
local function autoFarmFragmentsGodhuman()
    safeTeleportToSea(3)
    while getFragments() < 5000 do
        rem:InvokeServer("RaidsNpc","Select","Flame")
        wait(15)
        for _,enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") then
                enemy.Humanoid.Health = 0
            end
        end
        wait(1)
    end
end
local function getMastery(style)
    local inv = game.Players.LocalPlayer.Backpack:FindFirstChild(style) or game.Players.LocalPlayer.Character:FindFirstChild(style)
    return inv and inv:FindFirstChild("Mastery") and inv.Mastery.Value or 0
end
local function autoFarmMasteryGodhuman()
    for _,style in ipairs(estilos_gh) do
        while getMastery(style) < 400 do
            for _,enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    repeat
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                        enemy.Humanoid.Health = 0
                        wait()
                    until enemy.Humanoid.Health <= 0 or not enemy.Parent
                end
            end
            wait(1)
        end
    end
end
local function getBeli() return game.Players.LocalPlayer.Data.Beli.Value end
local function tieneGodhuman()
    return game.Players.LocalPlayer.Backpack:FindFirstChild("Godhuman") or game.Players.LocalPlayer.Character:FindFirstChild("Godhuman")
end
local function comprarGodhuman()
    if getBeli() >= 5000000 and getFragments() >= 5000 then
        safeTeleportToSea(3)
        local npc = workspace.NPCs:FindFirstChild("Ancient Monk")
        if npc then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
            rem:InvokeServer("BuyGodhuman",true)
        end
    end
end
local function autoGodhuman()
    if tieneGodhuman() then return end
    autoFarmMaterialsGodhuman()
    autoFarmFragmentsGodhuman()
    autoFarmMasteryGodhuman()
    comprarGodhuman()
end

local function tieneFruta(fruit)
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name:find(fruit) then return true end
    end
    for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v.Name:find(fruit) then return true end
    end
    return false
end
local function snipearFruta(fruit)
    local shop = rem:InvokeServer("GetFruitsShop")
    for _,v in pairs(shop) do
        if v.Name:find(fruit) and v.Price <= getBeli() then
            rem:InvokeServer("BuyFruits",v.Name)
        end
    end
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find(fruit) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
            firetouchinterest(v.Handle,game.Players.LocalPlayer.Character.HumanoidRootPart,0)
            wait(.5)
        end
    end
end
local function autoMythicFruits()
    for _,fruit in ipairs(config["MythicFruitList"]) do
        while not tieneFruta(fruit) do
            snipearFruta(fruit)
            wait(1)
        end
    end
end

local function autoHopIfNeeded()
    if config.AutoHopServer then
        local players = #game.Players:GetPlayers()
        if players > 5 then
            local servers = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/7449423635/servers/Public?sortOrder=Asc&limit=100")).data
            for _,srv in pairs(servers) do
                if srv.playing < 5 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,srv.id,game.Players.LocalPlayer)
                    break
                end
            end
        end
    end
end

local function enviarWebhook(msg)
    if config.AutoWebhook and config.WebhookUrl ~= "" then
        local http = game:GetService("HttpService")
        http:PostAsync(config.WebhookUrl,http:JSONEncode({content=msg}))
    end
end

local function main()
    autoHopIfNeeded()
    if config.AutoLevelMax then autoFarmLevel() end
    if config.GetGodhuman then autoGodhuman() end
    if config.GetMythicFruits then autoMythicFruits() end
end

main()
