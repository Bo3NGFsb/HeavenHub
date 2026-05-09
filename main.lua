-- HEAVEN HUB V2.2 (FORSAKEN - UNIVERSAL FIX)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
ESPBtn.Position = UDim2.new(0.05, 0, 0.08, 0)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = Frame

local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
RepairBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
RepairBtn.Text = "AUTO REPAIR: OFF"
RepairBtn.Parent = Frame

-- 1. FIX ESP: Tìm mọi người chơi và gắn khung sáng
local espActive = false
local function applyESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("HeavenHighlight")
            if not highlight and espActive then
                highlight = Instance.new("Highlight")
                highlight.Name = "HeavenHighlight"
                highlight.Parent = p.Character
            end
            
            if highlight then
                highlight.Enabled = espActive
                -- Nếu máu hoặc thuộc tính khác lạ thì là Killer (Màu đỏ), còn lại Xanh
                if p.Character:FindFirstChild("Killer") or (p.Team and p.Team.Name:lower():find("kill")) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
end)

-- 2. FIX AUTO REPAIR: Tự động tương tác với mọi vật thể nhấn phím E
local repairActive = false
RepairBtn.MouseButton1Click:Connect(function()
    repairActive = not repairActive
    RepairBtn.Text = repairActive and "REPAIR: ON" or "REPAIR: OFF"
end)

RunService.RenderStepped:Connect(function()
    -- Chạy ESP
    applyESP()
    
    -- Chạy Auto Repair khi đứng gần máy
    if repairActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                -- Kiểm tra nếu là máy phát điện (Generator)
                if v.ObjectText:lower():find("gen") or v.Parent.Name:lower():find("gen") or v.ActionText:lower():find("repair") then
                    local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                    if dist < 12 then -- Khoảng cách nhạy hơn
                        fireproximityprompt(v)
                    end
                end
            end
        end
    end
end)
