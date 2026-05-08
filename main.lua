-- [[ HEAVENHUB - PREMIUM INTERFACE ]] --
repeat task.wait(0) until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Sol's RNG",
   LoadingTitle = "Loading Beecon System...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = { Enabled = true, FolderName = "HeavenHub_Sols" }
})

-- [[ BIẾN TOÀN CỤC ]] --
_G.AutoRoll = false
_G.AutoPick = false
_G.AntiAFK = true
_G.FastRoll = false

-- [[ 1. TAB CHÍNH (MAIN) ]] --
local MainTab = Window:CreateTab("🏠 Main", 4483362458)

MainTab:CreateSection("Auto Rolling")

MainTab:CreateToggle({
   Name = "Auto Roll (Tự động quay)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoRoll = Value
      task.spawn(function()
         while _G.AutoRoll do
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Roll", true)
            if remote then remote:FireServer() end
            task.wait(0.1)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Fast Roll (Quay nhanh)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FastRoll = Value
      -- Logic giảm delay animation nếu game hỗ trợ
   end,
})

-- [[ 2. TAB NHẶT ĐỒ (ITEMS) ]] --
local ItemTab = Window:CreateTab("🎁 Items", 4483362458)

ItemTab:CreateSection("Auto Collect System")

ItemTab:CreateToggle({
   Name = "Auto Collect All (Nhặt tất cả Potions/Gifts)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPick = Value
      task.spawn(function()
         while _G.AutoPick do
            for _, v in pairs(workspace:GetChildren()) do
               if not _G.AutoPick then break end
               -- Quét tất cả vật phẩm có thể nhặt (TouchInterest)
               if v:IsA("Model") or (v:IsA("BasePart") and v:FindFirstChild("TouchInterest")) then
                  if v.Name:lower():find("potion") or v.Name:lower():find("lucky") or v.Name:lower():find("gift") then
                     local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                     local target = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                     if root and target then
                        -- Bay đến nhặt rồi quay về vị trí cũ
                        local oldPos = root.CFrame
                        root.CFrame = target.CFrame
                        firetouchinterest(root, target, 0)
                        task.wait(0.1)
                        firetouchinterest(root, target, 1)
                        root.CFrame = oldPos
                     end
                  end
               end
            end
            task.wait(0.5)
         end
      end)
   end,
})

-- [[ 3. TAB NGƯỜI CHƠI (PLAYER) ]] --
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)

PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
   Name = "WalkSpeed (Tốc độ)",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower (Sức nhảy)",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- [[ 4. TAB TIỆN ÍCH (MISC) ]] --
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

MiscTab:CreateSection("Utility")

MiscTab:CreateButton({
   Name = "Anti-AFK (Bật vĩnh viễn)",
   Callback = function()
      Rayfield:Notify({Title = "HeavenHub", Content = "Anti-AFK đã kích hoạt!"})
   end,
})

MiscTab:CreateButton({
   Name = "FPS Boost (Giảm Lag)",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
         end
      end
   end,
})

-- [[ HỆ THỐNG CHỐNG TREO MÁY ]] --
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   if _G.AntiAFK then
      vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      task.wait(1)
      vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   end
end)

Rayfield:Notify({
   Title = "HeavenHub v2.0 Loaded",
   Content = "Chúc bạn sở hữu Aura tối thượng!",
   Duration = 5
})
