-- HEAVEN HUB V1.1 (SOL'S RNG)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoCollectBtn = Instance.new("TextButton")

-- Tự động chọn nơi hiển thị Menu (Ưu tiên CoreGui, nếu lỗi thì dùng PlayerGui)
local parentUI = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parentUI

-- Giao diện Menu
MainFrame.Name = "HeavenHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true -- Nắm chuột kéo menu đi được

Title.Parent = MainFrame
Title.Text = "HEAVEN HUB V1.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 0) -- Màu vàng cho sang
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

AutoCollectBtn.Parent = MainFrame
AutoCollectBtn.Text = "BẬT AUTO NHẶT"
AutoCollectBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoCollectBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- LOGIC NHẶT ĐỒ
local active = false
AutoCollectBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        AutoCollectBtn.Text = "AUTO: ĐANG CHẠY"
        AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Chạy vòng lặp nhặt đồ ngầm
        task.spawn(function()
            while active do
                -- Quét toàn bộ map để tìm vật phẩm có thể nhặt (TouchInterest)
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("BasePart") then
                        local item = v.Parent
                        -- Dịch chuyển bạn đến vật phẩm
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                        task.wait(0.2) -- Đợi một chút để game nhận diện
                    end
                end
                task.wait(1) -- Quét lại sau mỗi 1 giây
            end
        end)
    else
        AutoCollectBtn.Text = "BẬT AUTO NHẶT"
        AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)
