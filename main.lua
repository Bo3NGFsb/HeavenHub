-- HEAVEN HUB V2.3 (FIX ESP COLORS & AUTO REPAIR)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
ESPBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = Frame

local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
RepairBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
RepairBtn.Text = "AUTO REPAIR: OFF"
RepairBtn.Parent = Frame

-- Hàm kiểm tra xem người chơi có phải là Killer không
local function isKiller(player)
    -- Kiểm tra qua Team, Tên hoặc các thuộc tính đặc biệt trong Forsaken
    if player.Team and (player.Team.Name:lower():find("kill") or player.Team.Name:lower():find("monster")) then
        return true
    elseif player.Character and (player.Character:FindFirstChild("Killer") or player.Character:FindFirstChild("Weapon")) then
        return true
    end
    return false
end

local espActive = false
ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
end)

local repairActive = false
RepairBtn.MouseButton1Click:Connect(function()
    repairActive = not repairActive
    RepairBtn.Text = repairActive and "REPAIR: ON" or "REPAIR: OFF"
end)

RunService.RenderStepped:Connect(function()
    -- 1. CẬP NHẬT ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("HeavenHighlight")
            if espActive then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "HeavenHighlight"
                    highlight.Parent = p.Character
                end
                -- Phân màu: Killer Đỏ, Survival Xanh lá
                if isKiller(p) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Đỏ
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Xanh lá
                end
                highlight.FillOpacity = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Enabled = true
            elseif highlight then
                highlight.Enabled = false
            end
        end
    end

    -- 2. CẬP NHẬT AUTO REPAIR (Khi đứng gần máy)
    if repairActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                -- Kiểm tra khoảng cách đến máy phát điện
                local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                if dist < 12 then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)
