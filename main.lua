-- HEAVEN HUB V2.7 (FORSAKEN - FINAL STABLE)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 1. LÀM ĐẸP UI ĐÃ HIỆN
local sg = game:GetService("CoreGui"):FindFirstChild("HeavenSimple") or game:GetService("PlayerGui"):FindFirstChild("HeavenSimple")
local mainBtn = sg and sg:FindFirstChildOfClass("TextButton")

if mainBtn then
    mainBtn.Text = "HEAVEN HUB: READY"
    mainBtn.Font = Enum.Font.GothamBold
    mainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end

local active = false

-- 2. HÀM ESP PHÂN BIỆT RÕ RÀNG
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local char = p.Character
            local hl = char:FindFirstChild("HeavenHL") or Instance.new("Highlight", char)
            hl.Name = "HeavenHL"
            hl.Enabled = active
            
            -- Logic nhận diện vai trò trong Forsaken
            local isKiller = false
            -- Kiểm tra nếu cầm dao, súng hoặc team Killer
            if char:FindFirstChildOfClass("Tool") or (p.Team and p.Team.Name:lower():find("kill")) or char:FindFirstChild("Knife") then
                isKiller = true
            end
            
            if isKiller then
                hl.FillColor = Color3.fromRGB(255, 0, 0) -- ĐỎ CHO KILLER
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                hl.FillColor = Color3.fromRGB(0, 255, 0) -- XANH LÁ CHO SURVIVAL
                hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            hl.FillOpacity = 0.5
        end
    end
end

-- 3. AUTO REPAIR (SỬA MÁY KHI LẠI GẦN)
local function handleRepair()
    if not active then return end
    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                -- Kiểm tra khoảng cách 12 studs (khoảng 3-4 mét trong game)
                local dist = (char.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                if dist < 12 then
                    fireproximityprompt(v)
                end
            end
        end
    end
end

-- KÍCH HOẠT KHI BẤM NÚT
if mainBtn then
    mainBtn.MouseButton1Click:Connect(function()
        active = not active
        mainBtn.Text = active and "HUB: ON (ENJOY!)" or "HUB: OFF"
        mainBtn.BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 30)
    end)
end

-- VÒNG LẶP CHÍNH
RunService.Heartbeat:Connect(function()
    updateESP()
    handleRepair()
end)
