-- Kaitun Blox Fruits FULL AUTO - Solo Level Max, God Human y 3 Frutas Míticas
-- Todo lo demás deshabilitado/modular por config externa.
-- Listo para usar con Delta, Synapse, ScriptWare, KRNL.

-- CONFIG EXTERNA (ponla afuera del script o en tu executor)
--[[
getgenv().KaitunConfig = {
    ["AutoLevelMax"] = true,
    ["GetGodhuman"] = true,
    ["GetMythicFruits"] = true,
    ["MythicFruitList"] = {"Leopard-Leopard", "Dragon-Dragon", "Kitsune-Kitsune"}
}
]]

local cfg = getgenv().KaitunConfig or {
    ["AutoLevelMax"] = true,
    ["GetGodhuman"] = true,
    ["GetMythicFruits"] = true,
    ["MythicFruitList"] = {"Leopard-Leopard", "Dragon-Dragon", "Kitsune-Kitsune"}
}

repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer

-- Selección robusta de Marines
local function getRemote()
    local rep = game:GetService("ReplicatedStorage")
    local remote
    repeat
        local remotes = rep:FindFirstChild("Remotes")
        if remotes then remote = remotes:FindFirstChild("CommF_") end
        wait(0.5)
    until remote
    return remote
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

-- ========== LEVEL MAX ==========

local function getLevel() return game.Players.LocalPlayer.Data.Level.Value end
local LevelTable = {
    [1] = {mob="Bandit",quest="BanditQuest"},
    [700] = {mob="Sea Soldier",quest="SeaSoldierQuest"},
    [1500] = {mob="Zombie",quest="ZombieQuest"},
    [2000] = {mob="Pirate",quest="PirateQuest"},
}
local function getNextMobQuest(lvl)
    local pick
    for k,v in pairs(LevelTable) do
        if lvl >= k then pick = v end
    end
    return pick.mob, pick.quest
end
local function autoFarmLevel()
    local maxLevel = 2800
    while getLevel() < maxLevel do
        local mob, quest = getNextMobQuest(getLevel())
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

-- ========== GOD HUMAN ==========

local materiales_gh = {
    ["Fish Tail"] = {qty=20, mobs={"Fishman Warrior","Fishman Commando"}},
    ["Magma Ore"] = {qty=20, mobs={"Military Spy","Military Soldier"}},
    ["Mystic Droplet"] = {qty=10, mobs={"Sea Soldier","Water Fighter"}},
    ["Dragon Scale"] = {qty=10, mobs={"Dragon Crew Archer","Dragon Crew Warrior"}},
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

-- ========== FRUTAS MITICAS (x3) ==========

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
    local list = cfg["MythicFruitList"] or {"Leopard-Leopard","Dragon-Dragon","Kitsune-Kitsune"}
    for _,fruit in ipairs(list) do
        while not tieneFruta(fruit) do
            snipearFruta(fruit)
            wait(1)
        end
    end
end

-- ========== MAIN ==========
if cfg["AutoLevelMax"] then autoFarmLevel() end
if cfg["GetGodhuman"] then autoGodhuman() end
if cfg["GetMythicFruits"] then autoMythicFruits() end
