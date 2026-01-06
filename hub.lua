local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Grimix Hub | Premium Selector',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local MainTab = Window:AddTab('Game Scripts')
local LeftGroupBox = MainTab:AddLeftGroupbox('Select a Script')
local RightGroupBox = MainTab:AddRightGroupbox('User Information')

-- [[ GAME BUTTONS ]]

LeftGroupBox:AddButton({
    Text = 'Anime Fighting Simulator',
    Func = function()
        Library:Notify('Unloading Hub and Loading AFS...', 2)
        
        task.wait(0.5)
        Library:Unload() -- This makes the Hub disappear
        
        local scriptRepo = 'https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Blox Fruits',
    Func = function()
        Library:Notify('Unloading Hub and Loading Blox Fruits...', 2)
        
        task.wait(0.5)
        Library:Unload() -- This makes the Hub disappear
        
        local scriptRepo = 'YOUR_BLOX_FRUITS_URL_HERE'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

-- [[ CLEAN USER INFO ]]
RightGroupBox:AddLabel('User: ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('Status: Verified ✅')

local marketplace = game:GetService("MarketplaceService")
local success, info = pcall(function() return marketplace:GetProductInfo(game.PlaceId) end)
local gameName = success and info.Name or "Unknown Game"
RightGroupBox:AddLabel('Game: ' .. gameName)

RightGroupBox:AddDivider()

RightGroupBox:AddButton('Unload Hub', function() 
    Library:Unload() 
end)

-- [[ THEME MANAGEMENT ]]
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('GrimixHub')
ThemeManager:ApplyToTab(MainTab)
ThemeManager:BuildConfigSection(MainTab)

Library:Notify('Grimix Hub Loaded!')
