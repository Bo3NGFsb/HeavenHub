
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HEAVENHUB V1",
   LoadingTitle = "HEAVENHUB: KINETIC SYNC",
   LoadingSubtitle = "Jump & Velocity Overdrive Active",
   ConfigurationSaving = { Enabled = false }
})

-- TABS
local MainTab = Window:CreateTab("Combat & Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals (ESP)", 4483362458)

-- STEALTH TOGGLE (Tap top-middle of screen to show/hide menu)
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
--- KINETIC OVERRIDE (Speed & Jump Hack)
--- ==========================================
local MovementSection = MainTab:CreateSection("Kinetic Manipulation")
local WalkMultiplier = 0
local SprintMultiplier = 0
local JumpForce = 0
local NoclipActive = false

MainTab:CreateSlider({
   Name = "Walk Multiplier",
   Range = {0, 10}, 
   Increment = 0.1,
   CurrentValue = 0,
   Callback = function(Value) WalkMultiplier = Value end,
})

MainTab:CreateSlider({
   Name = "Sprint Multiplier",
   Range = {0, 15}, 
   Increment = 0.1,
   CurrentValue = 0,
   Callback = function(Value) SprintMultiplier = Value end,
})

MainTab:CreateSlider({
   Name = "Jump Force (Hack)",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value) JumpForce = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip (Phase Walls)",
   CurrentValue = false,
   Flag = "NoclipTog",
   Callback = function(Value) NoclipActive = Value end,
})

-- 1. Jump Hack Logic (Physical Velocity Impulse)
game:GetService("UserInputService").JumpRequest:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and JumpForce > 0 then
        char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, JumpForce, char.HumanoidRootPart.Velocity.Z)
    end
end)

-- 2. Movement & Collision Loop
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local root = char.HumanoidRootPart
        
        -- Physical Movement Bypass (Speed Fix)
        if hum.MoveDirection.Magnitude > 0 then
            local isSprinting = hum.WalkSpeed > 20 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift)
            local activeForce = isSprinting and SprintMultiplier or WalkMultiplier
            if activeForce > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * activeForce)
            end
        end
        
        -- Noclip Logic
        if NoclipActive then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

--- ==========================================
--- COMBAT PROTOCOLS (Attack & Defense)
--- ==========================================
local CombatSection = MainTab:CreateSection("Combat Protocols")
local AutoAttack = false
local TargetPlayer = nil

MainTab:CreateToggle({
   Name = "Neural Strike (Auto-Attack)",
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

MainTab:CreateToggle({
   Name = "Auto-Block (Guest 1337)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
          task.spawn(function()
              while Value do
                  local Guest = game.Players:FindFirstChild("Guest 1337")
                  if Guest then game.StarterGui:SetCore("PromptBlockPlayer", Guest) end
                  task.wait(5)
              end
          end)
      end
   end,
})

--- ==========================================
--- TARGETING SUITE
--- ==========================================
local TargetSection = MainTab:CreateSection("Targeting Suite")

local TargetDropdown = MainTab:CreateDropdown({
   Name = "Select Player",
   Options = {"None"},
   Callback = function(Option) TargetPlayer = game.Players:FindFirstChild(Option[1]) end,
})

MainTab:CreateButton({
   Name = "Scan Players (Refresh List)",
   Callback = function()
      local List = {}
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer then table.insert(List, p.Name) end
      end
      TargetDropdown:Refresh(List)
   end,
})

MainTab:CreateButton({
   Name = "Neural Warp (Teleport)",
   Callback = function()
      if TargetPlayer and TargetPlayer.Character then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

--- ==========================================
--- DETECTION SYSTEMS (ESP)
--- ==========================================
local VisualsSection = VisualsTab:CreateSection("Detection Sync")

VisualsTab:CreateToggle({
   Name = "Player ESP (Neon Green)",
   CurrentValue = false,
   Callback = function(Value)
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer and p.Character then
              if Value then
                  local High = Instance.new("Highlight", p.Character)
                  High.Name = "HeavenHubESP"
                  High.FillColor = Color3.fromRGB(0, 255, 0)
              else
                  if p.Character:FindFirstChild("HeavenHubESP") then p.Character.HeavenHubESP:Destroy() end
              end
          end
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Generator ESP (Deep Blue)",
   CurrentValue = false,
   Callback = function(Value)
      for _, obj in pairs(game.Workspace:GetDescendants()) do
          if obj.Name == "Generator" then
              if Value then
                  local High = Instance.new("Highlight", obj)
                  High.Name = "GenHighlight"
                  High.FillColor = Color3.fromRGB(0, 0, 150)
              else
                  if obj:FindFirstChild("GenHighlight") then obj.GenHighlight:Destroy() end
              end
          end
      end
   end,
})

Rayfield:Notify({Title = "V1 READY", Content = "HEAVENHUB modules are synchronized.", Duration = 5})
