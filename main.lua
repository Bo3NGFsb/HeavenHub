-- [[ HEAVENHUB - SOL'S RNG ULTIMATE ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Sol's RNG",
   LoadingTitle = "Đang khởi chạy hệ thống...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HeavenHub_Configs"
   }
})

-- [[ BIẾN ĐIỀU KHIỂN ]] --
_G.AutoRoll = false
_G.AutoPick = false
_G.AntiAFK = true

-- [[ TABS ]] --
local MainTab = Window:CreateTab("Tự Động (Auto)", 4483362458)
local PlayerTab = Window:CreateTab("Người Chơi", 4483362458)
local MiscTab = Window:CreateTab("Tiện Ích", 4483362458)

-- [[ TÍNH NĂNG AUTO ROLL ]] --
MainTab:CreateSection("Quay Aura")

MainTab:CreateToggle({
   Name = "Auto Roll (Tự động quay)",
   CurrentValue = false,
   Flag = "AutoRoll",
   Callback = function(Value)
      _G.AutoRoll = Value
      task.spawn(function()
         while _G.AutoRoll do
            -- Remote cho Sol's RNG
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") 
            if remote and remote:FindFirstChild("Roll") then
                remote.Roll:FireServer()
            end
            task.wait(0.1)
         end
      end)
   end,
})

-- [[ TÍNH NĂNG AUTO PICK (ĐÃ FIX) ]] --
MainTab:CreateSection("Nhặt Vật Phẩm")

MainTab:CreateToggle({
   Name = "Auto Pick Potions/Items (Tất cả)",
   CurrentValue = false,
   Flag = "AutoPick",
   Callback = function(Value)
      _G.AutoPick = Value
      task.spawn(function()
         while _G.AutoPick do
            -- Quét toàn bộ Workspace để tìm đồ rơi
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.AutoPick then break end
               
               -- Kiểm tra xem vật phẩm có thể nhặt được không (TouchTransmitter)
               if v:IsA("TouchTransmitter") and v.Parent then
                  local item = v.Parent
                  local char = game.Players.LocalPlayer.Character
                  local root = char and char:FindFirstChild("HumanoidRootPart")
                  
                  -- Kiểm tra xem item có phải là vật phẩm trong game (né các vùng dịch chuyển)
                  if item:IsA("BasePart") or item:FindFirstChild("Handle") then
                     local target = item:IsA("BasePart") and item or item.Handle
                     
                     -- Di chuyển đến và nhặt
                     if root and target then
                        local oldCFrame = root.CFrame
                        root.CFrame = target.CFrame
                        task.wait(0.1) -- Đợi 0.1s để server nhận lệnh nhặt
                        firetouchinterest(root, target, 0)
                        firetouchinterest(root, target, 1)
                        task.wait(0.05)
                        -- (Tùy chọn) Quay lại vị trí cũ sau khi nhặt
                        -- root.CFrame = oldCFrame 
                     end
                  end
               end
            end
            task.wait(1) -- Quét lại sau mỗi giây
         end
      end)
   end,
})

-- [[ TAB NGƯỜI CHƠI ]] --
PlayerTab:CreateSlider({
   Name = "Tốc độ chạy (WalkSpeed)",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Sức nhảy (JumpPower)",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- [[ TAB TIỆN ÍCH ]] --
MiscTab:CreateButton({
   Name = "Xóa hiệu ứng (Giảm Lag cực mạnh)",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
            v.Enabled = false
         end
      end
      Rayfield:Notify({Title = "HeavenHub", Content = "Đã tối ưu hóa FPS!"})
   end,
})

-- [[ HỆ THỐNG ANTI-AFK ]] --
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   if _G.AntiAFK then
      vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      task.wait(1)
      vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   end
end)

Rayfield:Notify({
   Title = "HeavenHub đã sẵn sàng!",
   Content = "Chúc bạn may mắn với các Aura!",
   Duration = 5,
})
