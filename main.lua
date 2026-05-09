-- HEAVEN HUB V2.1 (FORSAKEN - ESP BY ROLES & SMART REPAIR)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- UI Giao diện
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
ESPBtn.Position = UDim2.new(0.05, 0, 0.08, 0)
ESPBtn.Text = "HIỆN NGƯỜI (K/S): OFF"
ESPBtn.Parent = Frame

local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
RepairBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
RepairBtn.Text = "SỬA MÁY TỰ ĐỘNG: OFF"
RepairBtn.Parent = Frame

-- 1. LOGIC ESP PHÂN BIỆT ROLE (Sát nhân màu Đỏ, Survivor màu Xanh)
local espEnabled = false
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = p.Character:FindFirstChild("HeavenESP") or Instance.new("Highlight")
            highlight.Name = "HeavenESP"
            highlight.Parent = p.Character
            highlight.Enabled = espEnabled
            
            -- Kiểm tra Role (Dựa trên Team hoặc thuộc tính đặc biệt trong Forsaken)
            if p.TeamColor == BrickColor.new("Really red") or p:FindFirstChild("Killer") then
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Đỏ cho Killer
            else
                highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Xanh cho Survivor
            end
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP: ĐANG BẬT" or "ESP: ĐANG TẮT"
    updateESP()
end)

-- 2. LOGIC AUTO REPAIR (Không dịch chuyển, tự nhấn khi đứng gần)
local repairEnabled = false
RepairBtn.MouseButton1Click:Connect(function()
    repairEnabled = not repairEnabled
    RepairBtn.Text = repairEnabled and "AUTO REPAIR: ON" or "AUTO REPAIR: OFF"
end)

-- Vòng lặp kiểm tra liên tục
game:GetService("RunService").Heartbeat:Connect(function()
    if espEnabled then updateESP() end
    
    if repairEnabled then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            -- Tìm máy phát điện có ProximityPrompt
            if v:IsA("ProximityPrompt") and (v.ObjectText:lower():find("gen") or v.Parent.Name:lower():find("gen")) then
                local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
                -- Chỉ tự động sửa nếu bạn đứng trong phạm vi 10 studs (không dịch chuyển)
                if dist < 10 then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)
