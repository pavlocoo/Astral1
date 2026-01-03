-- Load library from GitHub
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/library.lua"))()

-- Initialize
library:init()

-- Create window
local window = library.NewWindow({
    title = 'My Script',
    size = UDim2.new(0, 550, 0, 650)
})

-- Add a tab
local tab = window:AddTab('Main', 1)
local section = tab:AddSection('Features', 1, 1)

-- Add a toggle
section:AddToggle({
    text = 'Example Toggle',
    flag = 'toggle1',
    callback = function(enabled)
        print('Toggle:', enabled)
    end
})

-- Add settings
library:CreateSettingsTab(window)

library:SendNotification('Loaded!', 5, Color3.fromRGB(0, 255, 0))
