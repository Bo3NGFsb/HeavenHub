-- [[ HEAVENHUB - SOL'S RNG FULL PREMIUM ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Sol's RNG 1.0",
   LoadingTitle = "Đang tải hệ thống Beecon Style...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HeavenHub_Sols",
      FileName = "Config"
   }
})

-- [[ BIẾN TOÀN CỤC ]] --
_G.AutoRoll = false
_G.AutoPick = false
_G.AutoEquipBest = false
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.SelectedAuraToKeep = "Rare"

-- [[ TABS ]] --
local MainTab = Window:CreateTab("Tự Động (Auto)", 4483362458)
local PlayerTab = Window:CreateTab("Người Chơi", 4483362458)
local CraftTab = Window:CreateTab("Chế Tạo", 4483362458)
local MiscTab = Window:CreateTab("Tiện Ích", 4483362458)

-- [[ MAIN TAB FEATURES ]] --

MainTab:CreateSection("Cày Thuê Siêu Tốc")

MainTab:CreateToggle({
   Name = "Auto Roll (Tự động quay)",
   CurrentValue = false,
   Flag = "RollToggle",
   Callback = function(Value)
      _G.AutoRoll = Value
      task.spawn(function()
         while _G.AutoRoll do
            -- Remote quay aura (Cần check SimpleSpy nếu game update)
            game:GetService("ReplicatedStorage").RemoteEvents.Roll:FireServer("Roll")
            task.wait(0.1)
         end
      end)
   end,
})
MainTab:CreateToggle({
   Name = "Auto Collect Items (Đã sửa lỗi)",
   CurrentValue = false,
   Flag = "CollectToggle",
   Callback = function(Value)
      _G.AutoPick = Value
      task.spawn(function()
         while _G.AutoPick do
            -- Tìm kiếm thông minh trong Workspace
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.AutoPick then break end
               
               -- Kiểm tra xem có phải là vật phẩm nhặt được không (thường có TouchInterest)
               if v:IsA("TouchTransmitter") then
                  local item = v.Parent
                  -- Kiểm tra tên hoặc thuộc tính để tránh nhặt nhầm cửa hay vật cản
                  if item and (item:FindFirstChild("Handle") or item:IsA("BasePart")) then
                     local target = item:FindFirstChild("Handle") or item
                     
                     -- Dùng Tween để bay đến nhặt
                     local char = game.Players.LocalPlayer.Character
                     if char and char:FindFirstChild("HumanoidRootPart") then
                        local tween = game:GetService("TweenService"):Create(
                           char.HumanoidRootPart,
                           TweenInfo.new(0.3), -- Tốc độ bay tới (0.3 giây)
                           {CFrame = target.CFrame}
                        )
                        tween:Play()
                        
                        -- Giả lập chạm
                        firetouchinterest(char.HumanoidRootPart, target, 0)
                        task.wait(0.1)
                        firetouchinterest(char.HumanoidRootPart, target, 1)
                     end
                  end
               end
            end
            task.wait(2) -- Quét lại mỗi 2 giây để tránh lag
         end
      end)
   end,
})

-- [[ PLAYER TAB FEATURES ]] --

PlayerTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateButton({
   Name = "Nhận Full Luck Buff (Map)",
   Callback = function()
      -- Tìm các điểm buff may mắn trên map để teleport đến
      Rayfield:Notify({Title = "Thông báo", Content = "Đang quét các điểm Luck Buff..."})
   end,
})

-- [[ CRAFT TAB FEATURES ]] --

CraftTab:CreateDropdown({
   Name = "Chọn vật phẩm chế tạo",
   Options = {"Luck Glove", "Solar Device", "Eclipse Device", "Jackpot Gauntlet"},
   CurrentOption = {"Luck Glove"},
   Callback = function(Option)
      _G.SelectedCraft = Option[1]
   end,
})

CraftTab:CreateToggle({
   Name = "Auto Crafting",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCraft = Value
      -- Logic gửi lệnh craft đến lò rèn
   end,
})

-- [[ MISC TAB & ANTI-AFK ]] --

MiscTab:CreateButton({
   Name = "Bật Anti-AFK (Treo máy)",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "Thành công", Content = "Đã kích hoạt chế độ chống treo máy!"})
   end,
})

MiscTab:CreateButton({
   Name = "Xóa toàn bộ hiệu ứng (Giảm Lag)",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
         end
      end
   end,
})

-- [[ THÔNG BÁO KHI LOAD XONG ]] --
Rayfield:Notify({
   Title = "HeavenHub Loaded!",
   Content = "Chào mừng bạn trở lại, chúc bạn may mắn!",
   Duration = 6.5,
   Image = 4483362458,
})
