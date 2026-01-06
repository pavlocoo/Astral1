local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

-- Create the Hub Window
local Window = Library:CreateWindow({
    Title = 'Grimix Hub | BETA',
    Center = true,
    AutoShow = true,
})

-- Single Tab for all your games
local MainTab = Window:AddTab('Scripts')
local Group = MainTab:AddLeftGroupbox('Select a Game')

-- Button for Game 1
Group:AddButton({
    Text = 'Anime Fighting Simulator Script',
    Func = function()
        Library:Notify('Executing Anime Fighting Simulator...', 2)
        -- loadstring(game:HttpGet("https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua"))()
    end
})

Group:AddDivider()

-- Button for Game 2
Group:AddButton({
    Text = 'Blox Fruits Script',
    Func = function()
        Library:Notify('Executing Blox Fruits...', 2)
        -- loadstring(game:HttpGet("YOUR_RAW_GITHUB_LINK_FOR_BLOX_FRUITS"))()
    end
})

-- Right Side Info
local RightGroup = MainTab:AddRightGroupbox('Info')
RightGroup:AddLabel('Welcome: ' .. game.Players.LocalPlayer.DisplayName)
RightGroup:AddButton('Unload Hub', function() Library:Unload() end)

Library:Notify('Grimix Hub Loaded! Select a script.')
