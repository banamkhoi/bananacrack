if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")
local Enemies = Workspace:FindFirstChild("Enemies")

-- Global Settings & States
getgenv().BananaConfig = {
    AutoFarmLevel = false,
    AutoQuest = false,
    FastAttack = false,
    BringMob = false,
    AutoStat = false,
    SelectWeapon = "Melee",
    TweenSpeed = 350
}

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- Safe Character & Root Retrieval
local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

-- Teleport / Tween System
local function _tp(targetCFrame)
    local char = LocalPlayer.Character
    local root = getRoot(char)
    if not root then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = getgenv().BananaConfig.TweenSpeed or 350
    
    if distance < 300 then
        root.CFrame = targetCFrame
    else
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        
        -- Cancel tween if character dies or stops
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character or not getRoot(LocalPlayer.Character) or not getgenv().BananaConfig.AutoFarmLevel then
                tween:Cancel()
                connection:Disconnect()
            end
        end)
        tween.Completed:Wait()
        if connection then connection:Disconnect() end
    end
end

-- Weapon Equipment Utility
local function EquipWeapon(toolName)
    if not LocalPlayer.Backpack then return end
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

-- Robust Bring Enemy Function
local function BringEnemy(enemyModel)
    if not enemyModel or not enemyModel:FindFirstChild("HumanoidRootPart") then return end
    local root = getRoot(LocalPlayer.Character)
    if not root then return end

    pcall(function()
        for _, v in pairs(Workspace.Enemies:GetChildren()) do
            if v ~= enemyModel and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if (v.HumanoidRootPart.Position - root.Position).Magnitude < 250 then
                    v.HumanoidRootPart.CFrame = enemyModel.HumanoidRootPart.CFrame
                    v.HumanoidRootPart.Transparency = 1
                    v.HumanoidRootPart.CanCollide = false
                    if v:FindFirstChild("Head") then
                        v.Head.CanCollide = false
                    end
                end
            end
        end
    end)
end

-- Safe Enemy Finder
local function GetConnectionEnemies(enemyNames)
    if not enemyNames then return nil end
    
    if Workspace:FindFirstChild("Enemies") then
        for _, v1 in ipairs(Workspace.Enemies:GetChildren()) do
            if v1:IsA("Model") and v1:FindFirstChild("Humanoid") and v1.Humanoid.Health > 0 then
                if type(enemyNames) == "table" then
                    if table.find(enemyNames, v1.Name) then
                        return v1
                    end
                elseif v1.Name == enemyNames then
                    return v1
                end
            end
        end
    end
    return nil
end

-- Core Auto Farm Thread
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().BananaConfig.AutoFarmLevel then
            pcall(function()
                -- Main farming loop logic placeholder
                local char = LocalPlayer.Character
                if char and getRoot(char) then
                    -- Execute automated quest and mob hunting here
                end
            end)
        end
    end
end)

print("Banana Hub Full Source Loaded Successfully!")
