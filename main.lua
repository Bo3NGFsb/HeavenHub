-- [[ HEAVENHUB - FORSAKEN & UNIVERSAL ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "HeavenHub | Forsaken Edition",
    LoadingTitle = "Đang quét dữ liệu game...",
    LoadingSubtitle = "Hỗ trợ: Forsaken & Universal",
    ConfigurationSaving = { Enabled = true, FolderName = "HeavenHub_Forsaken" }
})

-- [[ BIẾN HỖ TRỢ ]] --
local player = game.Players.LocalPlayer
local runAutoGen = false
local genDelay = 0.5

-- [[ TAB 1: FORSAKEN (SPECIAL) ]] --
local ForsakenTab = Window:CreateTab("🛡️ Forsaken", 4483362458)

ForsakenTab:CreateSection("Generator Mods")

ForsakenTab:CreateButton({
    Name = "Instant Solve All Gens (Dứt điểm máy)",
    Callback = function()
        -- Quét cả map thường và map Hell
        local mapPath = workspace.Map.Ingame.Map
        local targets = mapPath:FindFirstChild("Generators") and mapPath.Generators:GetChildren() or mapPath:GetChildren()
        
        for _, v in pairs(targets) do
            if v.Name == "Generator" or v:IsA("Model") then
                local remote = v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE")
                if remote then
                    for i = 1, 4 do remote:FireServer() end
                end
            end
        end
        Rayfield:Notify({Title = "Xong!", Content = "Đã ép xung toàn bộ máy phát điện."})
    end
})

ForsakenTab:CreateToggle({
    Name = "Auto Repair (Sửa máy tự động)",
    CurrentValue = false,
    Callback = function(Value)
        runAutoGen = Value
        task.spawn(function()
            while runAutoGen do
                for _, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" and v:FindFirstChild("Remotes") then
                        v.Remotes.RE:FireServer()
                    end
                end
                task.wait(genDelay)
            end
        end)
    end
})

ForsakenTab:CreateSection("Survival")

ForsakenTab:CreateToggle({
    Name = "Auto Pick Pizza (Nhặt Pizza liên tục)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoPizza = Value
        task.spawn(function()
            while _G.AutoPizza do
                for _, v in pairs(workspace.Map.Ingame:GetChildren()) do
                    if v.Name == "Pizza" and v:IsA("BasePart") then
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then v.CFrame = hrp.CFrame end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

-- [[ TAB 2: VISUAL (ESP) ]] --
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

VisualTab:CreateToggle({
    Name = "Show Generators (Hiện máy)",
    CurrentValue = false,
    Callback = function(Value)
        toggleHighlightGen(Value) -- Sử dụng logic highlight bạn đã có
    end
})

VisualTab:CreateToggle({
    Name = "Killer/Entity ESP",
    CurrentValue = false,
    Callback = function(Value)
        corruptnatureesp(Value) -- Hiện mấy con quái/Killer
    end
})

-- [[ TAB 3: UNIVERSAL (VÀO GAME NÀO CŨNG HIỆN) ]] --
local UniTab = Window:CreateTab("🌍 Universal", 4483362458)

UniTab:CreateSlider({
    Name = "Tốc độ chạy",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

UniTab:CreateButton({
    Name = "FPS Boost (Giảm Lag)",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        end
    end
})

-- [[ TAB 4: EMOTES (TROLL) ]] --
local TrollTab = Window:CreateTab("🕺 Troll", 4483362458)

TrollTab:CreateToggle({
    Name = "Hakari Dance",
    CurrentValue = false,
    Callback = function(Value) activatethehakari(Value) end
})

TrollTab:CreateToggle({
    Name = "Hawk Tuah Mode",
    CurrentValue = false,
    Callback = function(Value) hawktuahmode(Value) end
})

Rayfield:LoadConfiguration()
