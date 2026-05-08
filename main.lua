-- 1. Gọi thư viện Rayfield (Đây là đoạn code giúp menu hiện lên đẹp như Beecon Hub)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Tạo cửa sổ chính cho HeavenHub
local Window = Rayfield:CreateWindow({
   Name = "HeavenHub | Sol's RNG",
   LoadingTitle = "Đang kiểm tra dữ liệu...",
   LoadingSubtitle = "by ChosenBossScript",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HeavenHubData"
   }
})

-- 3. Tạo một cái Tab (Giống như danh mục bên trái của Beecon Hub)
local MainTab = Window:CreateTab("Tính năng chính", 4483362458)

-- 4. Thêm nút gạt Bật/Tắt Auto Nhặt Đồ
MainTab:CreateToggle({
   Name = "Auto Collect Items (Tự nhặt đồ)",
   CurrentValue = false,
   Flag = "ToggleAutoPick", 
   Callback = function(Value)
      _G.AutoPick = Value -- Khi bạn gạt nút, biến này sẽ thành true hoặc false
      if Value then
          print("Đã bật Auto Nhặt!")
          -- Chèn code nhặt đồ của bạn ở đây
      else
          print("Đã tắt Auto Nhặt!")
      end
   end,
})

Rayfield:Notify({
   Title = "Thành công!",
   Content = "HeavenHub đã sẵn sàng!",
   Duration = 5,
   Image = 4483362458,
})
