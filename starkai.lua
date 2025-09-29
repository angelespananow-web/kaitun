-- Kaitun Blox Fruits Full Auto v2025 - Delta Executor Compatible
-- Configura getgenv().SettingFarm por fuera, ejecuta este script como loadstring.
-- Selecciona automáticamente el equipo "Marines".
-- Compatible con Delta (usa firetouchinterest, sethiddenproperty, etc. si están disponibles).

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Selección automática de equipo "Marines" (antes de cualquier lógica)
local chosenTeam = "Marines"
local rem = game:GetService("ReplicatedStorage").Remotes["CommF_"]
if game.Players.LocalPlayer.Team == nil or game.Players.LocalPlayer.Team.Name ~= chosenTeam then
    rem:InvokeServer("SetTeam", chosenTeam)
    wait(1)
    while game.Players.LocalPlayer.Team == nil or game.Players.LocalPlayer.Team.Name ~= chosenTeam do
        rem:InvokeServer("SetTeam", chosenTeam)
        wait(1)
    end
end

-- Protección para funciones (compatibilidad Delta/otros)
if not firetouchinterest then firetouchinterest = function(a,b,c) end end
if not sethiddenproperty then sethiddenproperty = function(a,b,c) end end
if not hookfunction then hookfunction = function(a,b) return a end end
if not islclosure then islclosure = function(a) return false end end
if not require then require = function(a) return {} end end

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

-- FPS CAP (Delta soporta setfpscap)
if config.LockFps and config.LockFps.Enabled and typeof(setfpscap) == "function" then
    local fps = tonumber(config.LockFps.FPS) or 15
    pcall(function() setfpscap(fps) end)
end

-- AUTO LEVEL MAX (farmear hasta 2800 con cambio de sea)
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
local function teleportToSea(sea)
    local seaPlace = {[1]=2753915549,[2]=4442272183,[3]=7449423635}
    if game.PlaceId ~= seaPlace[sea] then
        game:GetService("TeleportService"):Teleport(seaPlace[sea])
        repeat wait() until game.PlaceId == seaPlace[sea]
    end
end
local function autoFarmLevel()
    local maxLevel = 2800
    while getLevel() < maxLevel do
        local mob, quest, sea = getNextMobQuest(getLevel())
        teleportToSea(sea)
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quest, 1)
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

-- AUTO GOD HUMAN FULL
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
        teleportToSea(data.sea)
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
    teleportToSea(3)
    while getFragments() < 5000 do
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc","Select","Flame")
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
        teleportToSea(3)
        local npc = workspace.NPCs:FindFirstChild("Ancient Monk")
        if npc then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman",true)
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

-- AUTO FRUTAS MÍTICAS FULL/CONFIGURABLE
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
    local shop = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruitsShop")
    for _,v in pairs(shop) do
        if v.Name:find(fruit) and v.Price <= getBeli() then
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFruits",v.Name)
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

-- AUTO HOP SERVER (Delta soporta TeleportService)
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

-- AUTO WEBHOOK (Delta soporta HttpService)
local function enviarWebhook(msg)
    if config.AutoWebhook and config.WebhookUrl ~= "" then
        local http = game:GetService("HttpService")
        http:PostAsync(config.WebhookUrl,http:JSONEncode({content=msg}))
    end
end

-- MAIN
local function main()
    autoHopIfNeeded()
    if config.AutoLevelMax then
        autoFarmLevel()
        enviarWebhook("Nivel máximo alcanzado: "..getLevel())
    end
    if config.GetGodhuman then
        autoGodhuman()
        enviarWebhook("Godhuman conseguido.")
    end
    if config.GetMythicFruits then
        autoMythicFruits()
        enviarWebhook("Frutas míticas conseguidas.")
    end
end

main()
