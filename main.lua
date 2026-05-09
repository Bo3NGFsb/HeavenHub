-- [[ HEAVENHUB UNIVERSAL V1 - MODIFIED EDITION ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HEAVENHUB | UNIVERSAL V1",
   LoadingTitle = "HEAVENHUB: KINETIC SYNC",
   LoadingSubtitle = "Hệ thống nhảy và vận tốc đã sẵn sàng",
   ConfigurationSaving = { Enabled = false }
})

-- TABS
local MainTab = Window:CreateTab("🏠 Combat & Movement", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals (ESP)", 4483362458)

-- NÚT ẨN MENU (Chạm vào giữa phía trên màn hình để hiện/ẩn menu bằng phím RightControl)
local InvisibleToggle = Instance.new("ScreenGui", game.CoreGui)
local InvisibleButton = Instance.new("TextButton", InvisibleToggle)
InvisibleButton.BackgroundTransparency = 1
InvisibleButton.Position = UDim2.new(0.4, 0, 0, 0)
InvisibleButton.Size = UDim2.new(0.2, 0, 0, 50)
InvisibleButton.Text = ""
InvisibleButton.ZIndex = 100
InvisibleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

--- ==========================================
--- KINETIC OVERRIDE (Tốc độ & Nhảy cao)
--- ==========================================
local MovementSection = MainTab:CreateSection("Điều Khiển Vận Tốc")
local WalkMultiplier = 0
local SprintMultiplier = 0
local JumpForce = 0
local NoclipActive = false

MainTab:CreateSlider({
   Name = "Walk Speed Multi (Tăng tốc đi bộ)",
   Range = {0, 10}, 
   Increment = 0.1,
   CurrentValue = 0,
   Callback = function(Value) WalkMultiplier = Value end,
})

MainTab:CreateSlider({
   Name = "Sprint Speed Multi (Tăng tốc chạy)",
   Range = {0, 15}, 
   Increment = 0.1,
   CurrentValue = 0,
   Callback = function(Value) SprintMultiplier = Value end,
})

MainTab:CreateSlider({
   Name = "Jump Force Hack (Lực nhảy)",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value) JumpForce = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip (Đi xuyên tường)",
   CurrentValue = false,
   Flag = "NoclipTog",
   Callback = function(Value) NoclipActive = Value end,
})

-- Logic Nhảy Cao (Tác động vật lý trực tiếp)
game:GetService("UserInputService").JumpRequest:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and JumpForce > 0 then
        char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, JumpForce, char.HumanoidRootPart.Velocity.Z)
    end
end)

-- Vòng lặp di chuyển và Noclip
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local root = char.HumanoidRootPart
        
        -- Hack Speed (Bypass vật lý)
        if hum.MoveDirection.Magnitude > 0 then
            local isSprinting = hum.WalkSpeed > 20 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift)
            local activeForce = isSprinting and SprintMultiplier or WalkMultiplier
            if activeForce > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * activeForce)
            end
        end
        
        -- Logic Noclip
        if NoclipActive then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

--- ==========================================
--- COMBAT PROTOCOLS (Tấn công & Phòng thủ)
--- ==========================================
local CombatSection = MainTab:CreateSection("Giao Thức Chiến Đấu")
local AutoAttack = false
local TargetPlayer = nil

MainTab:CreateToggle({
   Name = "Heaven Strike (Auto-Clicker)",
   CurrentValue = false,
   Callback = function(Value)
      AutoAttack = Value
      task.spawn(function()
          while AutoAttack do
              pcall(function()
                  local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                  if weapon then weapon:Activate() end
              end)
              task.wait(0.1)
          end
      end)
   end,
})

--- ==========================================
--- TARGETING SUITE (Dò tìm đối thủ)
--- ==========================================
local TargetSection = MainTab:CreateSection("Hệ Thống Mục Tiêu")

local TargetDropdown = MainTab:CreateDropdown({
   Name = "Chọn người chơi",
   Options = {"None"},
   Callback = function(Option) TargetPlayer = game.Players:FindFirstChild(Option[1]) end,
})

MainTab:CreateButton({
   Name = "Quét danh sách người chơi",
   Callback = function()
      local List = {}
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer then table.insert(List, p.Name) end
      end
      TargetDropdown:Refresh(List)
   end,
})

MainTab:CreateButton({
   Name = "Heaven Warp (Dịch chuyển tới)",
   Callback = function()
      if TargetPlayer and TargetPlayer.Character then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

--- ==========================================
--- DETECTION SYSTEMS (ESP)
--- ==========================================
local VisualsSection = VisualsTab:CreateSection("Hệ Thống Quan Sát")

VisualsTab:CreateToggle({
   Name = "Player ESP (Hiện người chơi)",
   CurrentValue = false,
   Callback = function(Value)
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer and p.Character then
              if Value then
                  local High = Instance.new("Highlight", p.Character)
                  High.Name = "HeavenESP"
                  High.FillColor = Color3.fromRGB(255, 255, 0) -- Màu vàng thương hiệu Heaven
              else
                  if p.Character:FindFirstChild("HeavenESP") then p.Character.HeavenESP:Destroy() end
              end
          end
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Generator ESP (Hiện máy phát điện)",
   CurrentValue = false,
   Callback = function(Value)
      for _, obj in pairs(game.Workspace:GetDescendants()) do
          if obj.Name == "Generator" then
              if Value then
                  local High = Instance.new("Highlight", obj)
                  High.Name = "HeavenGenHighlight"
                  High.FillColor = Color3.fromRGB(0, 255, 255)
              else
                  if obj:FindFirstChild("HeavenGenHighlight") then obj.HeavenGenHighlight:Destroy() end
              end
          end
      end
   end,
})

Rayfield:Notify({
    Title = "HEAVENHUB V1 READY", 
    Content = "Mọi mô-đun đã được đồng bộ hóa thành công.", 
    Duration = 5
})
