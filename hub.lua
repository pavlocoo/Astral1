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
        Library:Notify('Executing Anime Fighting Simulator...', 2)
        -- Direct URL execution style
        local scriptRepo = 'https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Blox Fruits',
    Func = function()
        Library:Notify('Executing Blox Fruits...', 2)
        local scriptRepo = 'YOUR_BLOX_FRUITS_URL_HERE'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Pet Simulator 99',
    Func = function()
        Library:Notify('Executing Pet Simulator 99...', 2)
        local scriptRepo = 'YOUR_PET_SIM_URL_HERE'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

-- [[ FIXED USER INFO SECTION ]]
-- Clean labels without <b> tags to fix the display issue
RightGroupBox:AddLabel('User: ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('Status: Verified ✅')

-- Fixed Game Detection
local marketplace = game:GetService("MarketplaceService")
local success, info = pcall(function() return marketplace:GetProductInfo(game.PlaceId) end)
local gameName = success and info.Name or "Unknown Game"

RightGroupBox:AddLabel('Game: ' .. gameName)

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

-- [[ THEME MANAGEMENT ]]
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('GrimixHub')
ThemeManager:ApplyToTab(MainTab)
ThemeManager:BuildConfigSection(MainTab)

Library:Notify('Grimix Hub Loaded!')
