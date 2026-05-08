-- HEAVEN HUB VERSION 1.0
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoCollectBtn = Instance.new("TextButton")

-- Cài đặt vị trí và hình dáng
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "HeavenHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Màu xám tối sang trọng
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Bạn có thể nắm kéo cái bảng này đi khắp màn hình

Title.Parent = MainFrame
Title.Text = "HEAVEN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Nút bấm Auto Collect
AutoCollectBtn.Parent = MainFrame
AutoCollectBtn.Name = "AutoCollect"
AutoCollectBtn.Text = "Bật Auto Nhặt Trứng"
AutoCollectBtn.Size = UDim2.new(0.8, 0, 0, 40)
AutoCollectBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- LOGIC HOẠT ĐỘNG
local active = false
AutoCollectBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        AutoCollectBtn.Text = "Đang chạy Auto..."
        AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Chỗ này dán đoạn code nhặt trứng của bạn vào
        spawn(function()
            while active do
                print("Heaven Hub đang quét trứng...")
                -- (Thêm logic nhặt trứng ở đây)
                task.wait(2)
            end
        end)
    else
        AutoCollectBtn.Text = "Bật Auto Nhặt Trứng"
        AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)
