local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = 'Grimix Hub | Premium Selector',
    Center = true,
    AutoShow = true,
})

local MainTab = Window:AddTab('Game Scripts')
local LeftGroupBox = MainTab:AddLeftGroupbox('Select a Script')
local RightGroupBox = MainTab:AddRightGroupbox('Account Info')

-- [[ THE EXECUTION FUNCTION ]]
-- We use this to make sure the script runs in its own "thread"
local function Execute(url)
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            Library:Notify('❌ Error: ' .. tostring(err), 5)
        end
    end)
end

-- [[ BUTTONS ]]

LeftGroupBox:AddButton({
    Text = '🚀 Anime Fighting Simulator',
    Func = function()
        Library:Notify('Executing AFS...', 2)
        Execute("https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua")
    end,
    Tooltip = 'Loads Astral1 AFS'
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = '🌊 Blox Fruits',
    Func = function()
        Library:Notify('Executing Blox Fruits...', 2)
        -- Execute("YOUR_BLOX_FRUITS_URL")
    end
})

-- [[ RIGHT SIDE INFO ]]
RightGroupBox:AddLabel('<b>User:</b> ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('<b>Status:</b> <font color="#00ff00">Verified ✅</font>')
RightGroupBox:AddDivider()
RightGroupBox:AddButton('Unload Hub', function() Library:Unload() end)

Library:Notify('Grimix Hub Ready!')
