-- [[ HEAVENHUB - FORSAKEN KINETIC SYNC ]] --
-- Optimized by ChosenBossScript

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HEAVENHUB | FORSAKEN V1",
   LoadingTitle = "HEAVENHUB: KINETIC OVERDRIVE",
   LoadingSubtitle = "Synchronizing Velocity Modules...",
   ConfigurationSaving = { Enabled = true, FolderName = "HeavenHub_Forsaken" }
})

-- TABS
local MainTab = Window:CreateTab("🚀 Movement", 4483362458)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483362458)

-- STEALTH TOGGLE (Nút tàng hình ở giữa trên màn hình để đóng/mở Menu)
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
--- KINETIC OVERRIDE (Speed & Jump)
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
   Name = "Jump Impulse (Height)",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value) JumpForce = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip (Phase Walls)",
   CurrentValue = false,
   Callback = function(Value) NoclipActive = Value end,
})

-- Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and JumpForce > 0 then
        char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, JumpForce, char.HumanoidRootPart.Velocity.Z)
    end
end)

-- Movement Loop
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local root = char.HumanoidRootPart
        
        if hum.MoveDirection.Magnitude > 0 then
            local isSprinting = hum.WalkSpeed > 20 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift)
            local activeForce = isSprinting and SprintMultiplier or WalkMultiplier
            if activeForce > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * activeForce)
            end
        end
        
        if NoclipActive then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

--- ==========================================
--- COMBAT PROTOCOLS
--- ==========================================
local CombatSection = CombatTab:CreateSection("Assault Modules")
local AutoAttack = false
local TargetPlayer = nil

CombatTab:CreateToggle({
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

local TargetSection = CombatTab:CreateSection("Targeting Suite")
local TargetDropdown = CombatTab:CreateDropdown({
   Name = "Select Target",
   Options = {"None"},
   Callback = function(Option) TargetPlayer = game.Players:FindFirstChild(Option[1]) end,
})

CombatTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
      local List = {}
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer then table.insert(List, p.Name) end
      end
      TargetDropdown:Refresh(List)
   end,
})

CombatTab:CreateButton({
   Name = "Heaven Warp (Teleport to Target)",
   Callback = function()
      if TargetPlayer and TargetPlayer.Character then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

--- ==========================================
--- VISUAL SYNC (ESP)
--- ==========================================
local VisualsSection = VisualsTab:CreateSection("Scanning Modules")

VisualsTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      for _, p in pairs(game.Players:GetPlayers()) do
          if p ~= game.Players.LocalPlayer and p.Character then
              if Value then
                  local High = Instance.new("Highlight", p.Character)
                  High.Name = "HeavenESP"
                  High.FillColor = Color3.fromRGB(0, 255, 100)
              else
                  if p.Character:FindFirstChild("HeavenESP") then p.Character.HeavenESP:Destroy() end
              end
          end
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Generator ESP",
   CurrentValue = false,
   Callback = function(Value)
      for _, obj in pairs(game.Workspace:GetDescendants()) do
          if obj.Name == "Generator" then
              if Value then
                  local High = Instance.new("Highlight", obj)
                  High.Name = "HeavenGenESP"
                  High.FillColor = Color3.fromRGB(0, 200, 255)
              else
                  if obj:FindFirstChild("HeavenGenESP") then obj.HeavenGenESP:Destroy() end
              end
          end
      end
   end,
})

Rayfield:Notify({
    Title = "HEAVENHUB LOADED", 
    Content = "Forsaken modules are now operational.", 
    Duration = 5
})
