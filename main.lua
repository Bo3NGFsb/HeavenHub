-- [[ HEAVENHUB - BLADE BALL AUTO PARRY ]] --
repeat task.wait(0) until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Blade Ball",
   LoadingTitle = "Đang khởi chạy Blade Ball Hack...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = { Enabled = true, FolderName = "HeavenHub_BladeBall" }
})

-- [[ BIẾN ĐIỀU KHIỂN ]] --
_G.AutoParry = false
_G.Distance = 20
_G.AutoSpam = false

-- [[ TAB 1: CHIẾN ĐẤU (COMBAT) ]] --
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)

CombatTab:CreateSection("Main Features")

CombatTab:CreateToggle({
   Name = "Auto Parry (Tự động đỡ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoParry = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Parry Distance (Khoảng cách)",
   Range = {10, 100},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(Value)
      _G.Distance = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Auto Spam Parry",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoSpam = Value
   end,
})

-- [[ THUẬT TOÁN XỬ LÝ (BACKEND) ]] --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Bạn cần thay đổi cái này sau khi dùng RemoteSpy
local ParryRemote = ReplicatedStorage:FindFirstChild("ParryAttempt", true) 

-- Vòng lặp chính xử lý đỡ bóng
RunService.PreRender:Connect(function()
    if not _G.AutoParry then return end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Tìm quả bóng (Blade Ball thường để bóng trong Workspace)
    local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChildWhichIsA("BasePart", true)
    
    if root and ball and ball.Name == "Ball" then
        local dist = (root.Position - ball.Position).Magnitude
        local velocity = ball.AssemblyLinearVelocity
        local ballDir = (root.Position - ball.Position).Unit
        local dot = velocity.Unit:Dot(ballDir)

        -- Điều kiện đỡ: Khoảng cách < tùy chỉnh VÀ bóng đang bay về phía mình
        if dist <= _G.Distance and dot > 0 then
            if ParryRemote then
                ParryRemote:FireServer()
            end
        end
        
        -- Chế độ Spam khi bóng cực gần (dưới 10m)
        if _G.AutoSpam and dist <= 10 then
            ParryRemote:FireServer()
        end
    end
end)

Rayfield:Notify({
   Title = "HeavenHub Ready",
   Content = "Bản hack Blade Ball đã sẵn sàng!",
   Duration = 5
})
