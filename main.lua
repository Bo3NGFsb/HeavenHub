-- [[ HEAVENHUB V3 - FIX TOÀN BỘ LỖI ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Sol's RNG",
   LoadingTitle = "Đang kiểm tra dữ liệu...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = { Enabled = false }
})

-- Biến điều khiển
_G.AutoRoll = false
_G.AutoPick = false

-- Tab chính
local MainTab = Window:CreateTab("Tính Năng", 4483362458)

-- AUTO ROLL (Đã thêm kiểm tra Remote)
MainTab:CreateToggle({
   Name = "Auto Roll",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoRoll = Value
      task.spawn(function()
         while _G.AutoRoll do
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Roll", true) or 
                           game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") and 
                           game:GetService("ReplicatedStorage").RemoteEvents:FindFirstChild("Roll")
            
            if remote then
                if remote:IsA("RemoteEvent") then remote:FireServer() end
            end
            task.wait(0.1)
         end
      end)
   end,
})

-- AUTO PICK (Cơ chế nhặt đồ chính xác hơn)
MainTab:CreateToggle({
   Name = "Auto Pick Potions",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPick = Value
      task.spawn(function()
         while _G.AutoPick do
            -- Sol's RNG thường để đồ rơi trong Workspace
            for _, v in pairs(workspace:GetChildren()) do
               if not _G.AutoPick then break end
               
               -- Kiểm tra xem có phải là vật phẩm không (Thường là Model hoặc Part có tên Potion)
               if v:IsA("Model") or (v:IsA("BasePart") and v:FindFirstChild("TouchInterest")) then
                   if v.Name:find("Potion") or v.Name:find("Lucky") or v.Name:find("Coin") then
                       local target = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                       local char = game.Players.LocalPlayer.Character
                       
                       if target and char and char:FindFirstChild("HumanoidRootPart") then
                           -- Teleport đến và nhặt
                           char.HumanoidRootPart.CFrame = target.CFrame
                           task.wait(0.1)
                           firetouchinterest(char.HumanoidRootPart, target, 0)
                           task.wait()
                           firetouchinterest(char.HumanoidRootPart, target, 1)
                       end
                   end
               end
            end
            task.wait(0.5)
         end
      end)
   end,
})

-- Nút tăng tốc (Fix lỗi lag)
MainTab:CreateButton({
   Name = "Tăng Tốc (FPS Boost)",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
         end
      end
   end,
})

-- ANTI-AFK (Luôn chạy ngầm)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
