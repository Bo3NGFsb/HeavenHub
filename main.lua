-- HEAVEN HUB V1.3 (DI CHUYỂN NHƯ NGƯỜI THẬT)
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Giao diện (Rút gọn)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0, 200, 0, 50)
Btn.Position = UDim2.new(0.5, -100, 0.1, 0)
Btn.Text = "HEAVEN AUTO MOVE: OFF"
Btn.Parent = ScreenGui

local active = false

-- Hàm để nhân vật tự đi đến một vị trí
local function walkTo(targetPosition)
    local path = PathfindingService:CreatePath({
        AgentCanJump = true, -- Cho phép nhân vật nhảy qua vật cản
        WaypointSpacing = 2
    })
    
    path:ComputeAsync(rootPart.Position, targetPosition)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in pairs(waypoints) do
            if not active then break end
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait() -- Đợi đi đến điểm hiện tại mới đi tiếp
        end
    else
        -- Nếu không tìm được đường đi phức tạp, cứ đi thẳng tới đó
        humanoid:MoveTo(targetPosition)
    end
end

Btn.MouseButton1Click:Connect(function()
    active = not active
    Btn.Text = active and "HEAVEN AUTO MOVE: ON" or "HEAVEN AUTO MOVE: OFF"
    
    if active then
        task.spawn(function()
            while active do
                local targetEgg = nil
                
                -- Tìm quả trứng gần nhất
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("BasePart") then
                        targetEgg = v.Parent
                        break -- Ưu tiên quả trứng đầu tiên tìm thấy
                    end
                end

                if targetEgg then
                    print("Đã thấy trứng! Đang đi tới...")
                    walkTo(targetEgg.Position)
                    task.wait(0.5) -- Đợi nhặt xong
                end
                
                task.wait(1) -- Quét lại sau mỗi giây
            end
        end)
    end
end)
