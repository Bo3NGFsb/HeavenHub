-- [[ HEAVENHUB BOOTLOADER ]] --
repeat task.wait(0) until game:IsLoaded()

-- Thông báo khi chạy script (Giống Beecon)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Multi-Game",
   LoadingTitle = "Đang kiểm tra dữ liệu game...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = { Enabled = false }
})

local i_am_skidder = game.PlaceId

-- [[ HỆ THỐNG NHẬN DIỆN GAME ]] --
if i_am_skidder == 15579077077 then 
    -- ĐÂY LÀ ID CỦA SOL'S RNG (Hoặc thay bằng ID chính xác của game bạn muốn)
    Rayfield:Notify({Title = "HeavenHub", Content = "Đã nhận diện: Sol's RNG!"})
    
    -- TẠO TAB TÍNH NĂNG CHO SOL'S RNG
    local MainTab = Window:CreateTab("Main Features", 4483362458)
    
    _G.AutoPick = false
    MainTab:CreateToggle({
       Name = "Auto Collect Potions (Beecon Method)",
       CurrentValue = false,
       Callback = function(Value)
          _G.AutoPick = Value
          if Value then
              task.spawn(function()
                  while _G.AutoPick do
                      -- Cách nhặt đồ tối ưu nhất cho Sol's RNG
                      for _, v in pairs(workspace:GetChildren()) do
                          if v:IsA("Model") or (v:IsA("BasePart") and v:FindFirstChild("TouchInterest")) then
                              if v.Name:lower():find("potion") or v.Name:lower():find("lucky") then
                                  local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                  local target = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                                  if root and target then
                                      root.CFrame = target.CFrame
                                      firetouchinterest(root, target, 0)
                                      task.wait(0.1)
                                      firetouchinterest(root, target, 1)
                                  end
                              end
                          end
                      end
                      task.wait(0.5)
                  end
              end)
          end
       end,
    })
    
    MainTab:CreateToggle({
       Name = "Auto Roll",
       CurrentValue = false,
       Callback = function(Value)
          _G.AutoRoll = Value
          task.spawn(function()
             while _G.AutoRoll do
                game:GetService("ReplicatedStorage"):FindFirstChild("Roll", true):FireServer()
                task.wait(0.1)
             end
          end)
       end,
    })

else
    -- NẾU VÀO GAME KHÁC, SẼ HIỆN KEY SYSTEM HOẶC THÔNG BÁO
    Rayfield:Notify({
        Title = "Cảnh báo",
        Content = "Game này chưa được HeavenHub hỗ trợ!",
        Duration = 10
    })
    
    -- Bạn có thể thêm các game khác ở đây dùng elseif giống như Beecon Hub
end

-- [[ ANTI-AFK CHUNG ]] --
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
