local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Grimix Hub | Premium Game Selector',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- [[ MAIN TAB ]]
local MainTab = Window:AddTab('Game Scripts')

local LeftGroupBox = MainTab:AddLeftGroupbox('Available Games')
local RightGroupBox = MainTab:AddRightGroupbox('User Information')

-- [[ GAME BUTTONS ]]

LeftGroupBox:AddButton({
    Text = 'Anime Fighting Simulator',
    Func = function()
        Library:Notify('🚀 Executing Anime Fighting Simulator...', 3)
        -- This executes your actual script
        local repo = 'https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua'
    end,
    DoubleClick = false,
    Tooltip = 'Loads the latest Anime Fighting Simulator script'
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Blox Fruits',
    Func = function()
        Library:Notify('🌊 Executing Blox Fruits...', 3)
        -- loadstring(game:HttpGet("PASTE_BLOX_FRUITS_LINK_HERE"))()
    end,
    DoubleClick = false,
    Tooltip = 'Loads the latest Blox Fruits script'
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Pet Simulator 99',
    Func = function()
        Library:Notify('🐾 Executing Pet Simulator 99...', 3)
        -- loadstring(game:HttpGet("PASTE_PS99_LINK_HERE"))()
    end,
    DoubleClick = false
})

-- [[ INFO SECTION ]]

RightGroupBox:AddLabel('<b>User:</b> ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('<b>Status:</b> <font color="#00ff00">Verified ✅</font>')
RightGroupBox:AddLabel('<b>Game:</b> ' .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

RightGroupBox:AddDivider()

RightGroupBox:AddButton('Join Discord', function()
    if setclipboard then
        setclipboard("https://discord.gg/6kXC2ge6ur")
        Library:Notify('Discord Link Copied!')
    end
end)

RightGroupBox:AddButton('Unload Hub', function() 
    Library:Unload() 
end)

-- UI Setup
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(MainTab)

Library:Notify('Grimix Hub: Successfully Authenticated!')
