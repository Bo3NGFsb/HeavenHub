-- HEAVEN HUB V1.4 (FIX LỖI DI CHUYỂN & NHẶT)
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Giao diện
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0, 220, 0, 50)
Btn.Position = UDim2.new(0.5, -110, 0.15, 0)
Btn.Text = "HEAVEN AUTO COLLECT: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Parent = ScreenGui

local active = false

-- Hàm tìm trứng gần nhất
local function getClosestEgg()
    local closestEgg = nil
    local shortestDistance = math.huge

    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("BasePart") then
            local egg = v.Parent
            local distance = (rootPart.Position - egg.Position).Magnitude
            if distance < shortestDistance then
                closestEgg = egg
                shortestDistance = distance
            end
        end
    end
    return closestEgg
end

-- Hàm di chuyển và nhặt
local function walkToAndCollect(targetEgg)
    local path = PathfindingService:CreatePath({AgentCanJump = true})
    path:ComputeAsync(rootPart.Position, targetEgg.Position)

    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for i, waypoint in pairs(waypoints) do
            if not active or not targetEgg.Parent then break end -- Dừng nếu tắt hoặc trứng mất
            
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            
            humanoid:MoveTo(waypoint.Position)
            
            -- Chờ đi đến điểm (nhưng không quá 2 giây để tránh bị kẹt)
            local arrived = humanoid.MoveToFinished:Wait(2)
            
            -- Nếu đã đến điểm cuối cùng, nhích thêm một chút để nhặt
            if i == #waypoints then
                humanoid:MoveTo(targetEgg.Position)
                task.wait(0.3)
            end
        end
    end
end

Btn.MouseButton1Click:Connect(function()
    active = not active
    Btn.Text = active and "HEAVEN AUTO COLLECT: ON" or "HEAVEN AUTO COLLECT: OFF"
    Btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)

    if active then
        task.spawn(function()
            while active do
                local target = getClosestEgg()
                if target then
                    walkToAndCollect(target)
                end
                task.wait(0.5) -- Nghỉ một chút trước khi tìm trứng tiếp theo
            end
        end)
    end
end)
