-- HEAVEN HUB V3.0 (FORSAKEN - RAYFIELD UI)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HEAVEN HUB | FORSAKEN",
   LoadingTitle = "Đang tải giao diện...",
   LoadingStatus = "By Heaven Team",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HeavenHubConfig",
      FileName = "ForsakenConfig"
   }
})

-- Biến điều khiển
local _G = {
    ESP = false,
    AutoRepair = false
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Tab Chính
local MainTab = Window:CreateTab("Tính Năng", 4483362458)

-- 1. TÍNH NĂNG ESP
MainTab:CreateToggle({
   Name = "Nhìn xuyên tường (ESP)",
   CurrentValue = false,
   Flag = "ToggleESP",
   Callback = function(Value)
      _G.ESP = Value
      if not Value then
          -- Xóa Highlight khi tắt
          for _, p in pairs(Players:GetPlayers()) do
              if p.Character and p.Character:FindFirstChild("HeavenHL") then
                  p.Character.HeavenHL:Destroy()
              end
          end
      end
   end,
})

-- 2. TÍNH NĂNG AUTO REPAIR
MainTab:CreateToggle({
   Name = "Tự động sửa máy (Auto Repair)",
   CurrentValue = false,
   Flag = "ToggleRepair",
   Callback = function(Value)
      _G.AutoRepair = Value
      if Value then
          Rayfield:Notify({
             Title = "Thông báo",
             Content = "Hãy đi bộ lại gần máy phát điện để bắt đầu sửa!",
             Duration = 5,
             Image = 4483362458,
          })
      end
   end,
})

-- Logic xử lý ESP (Màu đỏ cho Killer, Xanh cho Survival)
local function updateESP()
    if not _G.ESP then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local char = p.Character
            local hl = char:FindFirstChild("HeavenHL") or Instance.new("Highlight", char)
            hl.Name = "HeavenHL"
            
            -- Kiểm tra vai trò
            local isKiller = false
            if char:FindFirstChildOfClass("Tool") or (p.Team and p.Team.Name:lower():find("kill")) then
                isKiller = true
            end
            
            hl.FillColor = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            hl.FillOpacity = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Enabled = true
        end
    end
end

-- Logic xử lý Auto Repair
local function handleRepair()
    if not _G.AutoRepair then return end
    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local dist = (char.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                if dist < 12 then
                    fireproximityprompt(v)
                end
            end
        end
    end
end

-- Vòng lặp tối ưu
game:GetService("RunService").Heartbeat:Connect(function()
    updateESP()
    handleRepair()
end)

Rayfield:Notify({
   Title = "Thành công",
   Content = "Heaven Hub đã sẵn sàng!",
   Duration = 5,
   Image = 4483362458,
})
