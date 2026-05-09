-- HEAVEN HUB V2.4 (FIX UI & ESP COLORS)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Xóa UI cũ nếu có để tránh kẹt
if CoreGui:FindFirstChild("HeavenHubV2") then
    CoreGui.HeavenHubV2:Destroy()
end

-- TẠO GIAO DIỆN (Đưa ra ngoài vòng lặp để chắc chắn hiện lên)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HeavenHubV2"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 110)
Frame.Position = UDim2.new(0.5, -100, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
ESPBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ESPBtn.Text = "ESP: OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Parent = Frame

local RepairBtn = Instance.new("TextButton")
RepairBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
RepairBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
RepairBtn.Text = "AUTO REPAIR: OFF"
RepairBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RepairBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RepairBtn.Parent = Frame

-- BIẾN ĐIỀU KHIỂN
local espActive = false
local repairActive = false

ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
end)

RepairBtn.MouseButton1Click:Connect(function()
    repairActive = not repairActive
    RepairBtn.Text = repairActive and "REPAIR: ON" or "REPAIR: OFF"
    RepairBtn.BackgroundColor3 = repairActive and Color3.fromRGB(0, 100, 150) or Color3.fromRGB(50, 50, 50)
end)

-- HÀM KIỂM TRA KILLER
local function getRoleColor(player)
    if player.Character then
        -- Kiểm tra tên Team hoặc các Folder đặc biệt của Killer trong Forsaken
        if player.Team and (player.Team.Name:lower():find("kill") or player.Team.Name:lower():find("monster")) then
            return Color3.fromRGB(255, 0, 0) -- Đỏ
        elseif player.Character:FindFirstChild("Knife") or player.Character:FindFirstChild("Weapon") then
            return Color3.fromRGB(255, 0, 0) -- Đỏ
        end
    end
    return Color3.fromRGB(0, 255, 0) -- Mặc định Xanh lá (Survival)
end

-- VÒNG LẶP XỬ LÝ (Tách ra để không làm lag UI)
task.spawn(function()
    while true do
        if espActive then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local hl = p.Character:FindFirstChild("HeavenHighlight") or Instance.new("Highlight")
                    hl.Name = "HeavenHighlight"
                    hl.Parent = p.Character
                    hl.Enabled = true
                    hl.FillColor = getRoleColor(p)
                    hl.FillOpacity = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        else
            -- Tắt ESP
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HeavenHighlight") then
                    p.Character.HeavenHighlight:Destroy()
                end
            end
        end

        if repairActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                    if dist < 12 then
                        fireproximityprompt(v)
                    end
                end
            end
        end
        task.wait(0.5) -- Quét vừa phải để tránh bị game chặn
    end
end)
