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

-- [[ SCRIPT BUTTONS ]]

LeftGroupBox:AddButton({
    Text = '🚀 Anime Fighting Simulator',
    Func = function()
        Library:Notify('Executing AFS Script...', 3)
        
        -- This is the correct way to load and RUN the script
        local scriptUrl = "https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua"
        loadstring(game:HttpGet(scriptUrl))()
    end,
    Tooltip = 'Loads the Astral1 AFS script'
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = '🌊 Blox Fruits',
    Func = function()
        Library:Notify('Blox Fruits Link Not Set!', 3)
        -- To add Blox Fruits, put the link below:
        -- loadstring(game:HttpGet("LINK_HERE"))()
    end
})

-- [[ INFO SECTION ]]
RightGroupBox:AddLabel('<b>User:</b> ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('<b>Status:</b> <font color="#00ff00">Verified ✅</font>')
RightGroupBox:AddDivider()

RightGroupBox:AddButton('Unload Hub', function() 
    Library:Unload() 
end)

Library:Notify('Grimix Hub Ready!')
