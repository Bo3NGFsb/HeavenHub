-- [[ HEAVENHUB UNIVERSAL - BEECON STYLE ]] --
repeat task.wait(0) until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Universal Edition",
   LoadingTitle = "Đang khởi chạy HeavenHub...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = { Enabled = true, FolderName = "HeavenHub_Global" }
})

-- [[ BIẾN ĐIỀU KHIỂN ]] --
_G.AutoPick = false
_G.WalkSpeed = 16
_G.JumpPower = 50

-- [[ TAB 1: TỰ ĐỘNG (MAIN) ]] --
local MainTab = Window:CreateTab("🏠 Main", 4483362458)

MainTab:CreateSection("Auto Features")

-- Tính năng nhặt đồ dùng chung cho mọi game (Potions, Xu, Rương...)
MainTab:CreateToggle({
   Name = "Auto Collect Items (Universal)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPick = Value
      task.spawn(function()
         while _G.AutoPick do
            -- Quét mọi thứ có thể nhặt được trong Workspace
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.AutoPick then break end
               if v:IsA("TouchTransmitter") and v.Parent then
                  local target = v.Parent
                  if target:IsA("BasePart") or target:IsA("Model") then
                     local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                     local handle = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")) or target
                     
                     if root and handle then
                        -- Bay đến nhặt rồi quay lại (Tối ưu cho mọi game)
                        local oldPos = root.CFrame
                        root.CFrame = handle.CFrame
                        firetouchinterest(root, handle, 0)
                        task.wait(0.1)
                        firetouchinterest(root, handle, 1)
                        root.CFrame = oldPos
                     end
                  end
               end
            end
            task.wait(1)
         end
      end)
   end,
})

-- Nút Roll dùng chung (Cố gắng tìm mọi Remote có tên "Roll" hoặc "Spin")
MainTab:CreateButton({
   Name = "Force Auto Roll (Dò tìm Remote)",
   Callback = function()
      task.spawn(function()
         Rayfield:Notify({Title = "HeavenHub", Content = "Đang dò tìm lệnh quay của game..."})
         local found = false
         for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("roll") or v.Name:lower():find("spin")) then
               v:FireServer()
               found = true
            end
         end
         if not found then
            Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy lệnh quay trong game này!"})
         end
      end)
   end,
})

-- [[ TAB 2: NGƯỜI CHƠI (PLAYER) ]] --
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)

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

-- [[ TAB 3: TIỆN ÍCH (MISC) ]] --
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

MiscTab:CreateButton({
   Name = "FPS Boost (Giảm Lag)",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
      end
   end,
})

MiscTab:CreateToggle({
   Name = "Full Bright (Làm sáng Map)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game:GetService("Lighting").Brightness = 2
         game:GetService("Lighting").ClockTime = 14
         game:GetService("Lighting").GlobalShadows = false
      else
         game:GetService("Lighting").Brightness = 1
         game:GetService("Lighting").ClockTime = 12
         game:GetService("Lighting").GlobalShadows = true
      end
   end,
})

-- [[ ANTI-AFK (LUÔN CHẠY) ]] --
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({
   Title = "HeavenHub Universal",
   Content = "Đã tải xong! Mọi tính năng đã sẵn sàng.",
   Duration = 5
})
