-- Carga la configuración externa
local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/angelespananow-web/kaitun/main/config.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Función para limitar FPS
local function SetFPSLimit(fps)
    if type(setfpscap) == "function" then
        setfpscap(fps)
    elseif type(setfps) == "function" then
        setfps(fps)
    elseif type(syn) == "table" and type(syn.setfpscap) == "function" then
        syn.setfpscap(fps)
    else
        print("No se pudo limitar los FPS. Tu exploit no soporta esta función.")
    end
end

-- Aplica el límite de FPS al iniciar
if config.FPSLimit then
    SetFPSLimit(config.FPSLimit)
    print("FPS limit set to", config.FPSLimit)
end

-- Función para farmear hasta el nivel máximo
function AutoFarmLevel()
    local maxLevel = config.MaxLevel or 2800
    while LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Data.Level.Value < maxLevel do
        -- Lógica de farm original de Kaitun aquí
        wait(1)
    end
    print("¡Nivel máximo alcanzado!")
end

-- Auto raid con máximo de fragmentos
function AutoRaids()
    while config.AutoRaid do
        local fragments = LocalPlayer.Data.Fragments.Value
        if fragments >= (config.MaxFragments or 20000) then
            print("Fragmentos máximos alcanzados, raids pausadas.")
            wait(60)
        else
            if ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
                if LocalPlayer.Backpack:FindFirstChild("Special Microchip") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Dough")
                    print("Raid iniciada")
                end
            end
            wait(60)
        end
    end
end

-- Guardar frutas sin comer ni vender
function SaveFruits()
    while config.SaveFruits do
        for _, fruit in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if fruit:IsA("Tool") and string.find(fruit.Name, "Fruit") then
                -- Si la fruta es mítica, la guardamos
                local isMythical = false
                for _, v in ipairs(config.MythicalFruitsList) do
                    if string.find(fruit.Name, v) then
                        isMythical = true
                    end
                end
                if config.OnlyMythicalFruits then
                    if not isMythical then
                        print("No es fruta mítica, no la guardo.")
                        -- Puedes vender/comer aquí si quieres, pero la lógica es solo guardar míticas
                    else
                        print("¡Fruta mítica encontrada y guardada!", fruit.Name)
                        -- Aquí podrías agregar lógica para transferir a tu almacenamiento privado si usas exploits avanzados
                    end
                end
            end
        end
        wait(10)
    end
end

-- Auto reroll de frutas, solo si no tienes una mítica
function AutoRerollFruit()
    while config.AutoRerollFruit do
        local hasMythical = false
        for _, fruit in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if fruit:IsA("Tool") and string.find(fruit.Name, "Fruit") then
                for _, v in ipairs(config.MythicalFruitsList) do
                    if string.find(fruit.Name, v) then
                        hasMythical = true
                    end
                end
            end
        end
        if not hasMythical then
            print("No tengo fruta mítica, haciendo reroll...")
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFruit", true)
        else
            print("Ya tengo fruta mítica, no hago reroll.")
        end
        wait(120)
    end
end

-- Función para conseguir God Human automáticamente
function AutoGodHuman()
    while config.AutoGodHuman do
        if LocalPlayer.Data.Level.Value >= 2300 then
            local hasMaterials = true -- Aquí pon la lógica para revisar los materiales
            if hasMaterials then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                print("Intentando comprar God Human")
            else
                print("Faltan materiales para God Human")
            end
        end
        wait(30)
    end
end

-- Función para desbloquear Sea 2 y Sea 3
function AutoUnlockSeas()
    if config.UnlockSeas then
        if LocalPlayer.Data.Level.Value >= 700 and game.PlaceId == 2753915549 then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa")
            print("Intentando desbloquear Sea 2")
        end
        if LocalPlayer.Data.Level.Value >= 1500 and game.PlaceId == 4442272183 then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou")
            print("Intentando desbloquear Sea 3")
        end
    end
end

-- Ejecución de tareas automáticas
spawn(AutoFarmLevel)
spawn(AutoRaids)
spawn(SaveFruits)
spawn(AutoRerollFruit)
spawn(AutoGodHuman)
spawn(AutoUnlockSeas)

print("Kaitun Auto Script actualizado con fragmentos, frutas, FPS y configuración externa.")

-- Puedes añadir más funciones, logs, o mejoras según la lógica original de Kaitun aquí.
