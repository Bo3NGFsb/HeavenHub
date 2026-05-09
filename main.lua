-- HEAVEN HUB V2.0 (FORSAKEN SURVIVAL - ESP & AUTO REPAIR)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.5, -110, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
ESPBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ESPBtn.Text = "BẬT NHÌN XUYÊN TƯỜNG"
ESPBtn.Parent = Frame

local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
RepairBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
RepairBtn.Text = "AUTO SỬA MÁY: OFF"
RepairBtn.Parent = Frame

-- 1. LOGIC NHÌN XUYÊN TƯỜNG (ESP)
local espEnabled = false
local function createESP(player)
    if player ~= localPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HeavenESP"
        highlight.FillColor = player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
        highlight.FillOpacity = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = player.Character
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ĐANG HIỆN NGƯỜI CHƠI" or "BẬT NHÌN XUYÊN TƯỜNG"
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do createESP(p) end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HeavenESP") then
                p.Character.HeavenESP:Destroy()
            end
        end
    end
end)

-- 2. LOGIC AUTO SỬA MÁY PHÁT ĐIỆN (AUTO REPAIR)
local repairActive = false
RepairBtn.MouseButton1Click:Connect(function()
    repairActive = not repairActive
    RepairBtn.Text = repairActive and "AUTO SỬA MÁY: ON" or "AUTO SỬA MÁY: OFF"
    
    task.spawn(function()
        while repairActive do
            -- Tìm máy phát điện gần nhất (Thường tên là Generator hoặc chứa ProximityPrompt)
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and (v.Parent.Name:lower():find("gen") or v.ObjectText:lower():find("gen")) then
                    -- Đi tới máy phát điện
                    local char = localPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = v.Parent.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.2)
                        -- Kích hoạt sửa máy
                        fireproximityprompt(v)
                    end
                end
            end
            task.wait(1)
        end
    end)
end)
