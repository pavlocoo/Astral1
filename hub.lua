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

-- [[ SCRIPT EXECUTION LOGIC ]]
local function ExecuteScript(url)
    task.spawn(function()
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        
        if success then
            Library:Notify('✅ Script Executed Successfully!', 3)
        else
            Library:Notify('❌ Execution Error: ' .. tostring(result), 5)
            warn("Grimix Hub Error: " .. result)
        end
    end)
end

-- [[ GAME BUTTONS ]]
LeftGroupBox:AddButton({
    Text = 'Anime Fighting Simulator',
    Func = function()
        ExecuteScript("https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua")
    end,
    Tooltip = 'Run Anime Fighting Simulator Script'
})

LeftGroupBox:AddButton({
    Text = 'Blox Fruits',
    Func = function()
        -- ExecuteScript("YOUR_BLOX_FRUITS_URL_HERE")
        Library:Notify('Coming Soon!', 2)
    end
})

LeftGroupBox:AddButton({
    Text = 'Pet Simulator 99',
    Func = function()
        -- ExecuteScript("YOUR_PS99_URL_HERE")
        Library:Notify('Coming Soon!', 2)
    end
})

-- [[ FIXED USER INFO SECTION ]]
-- We remove the <b> tags if they aren't rendering and use standard formatting
RightGroupBox:AddLabel('User: ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('Status: Verified ✅')

-- Improved Game Detection
local marketplace = game:GetService("MarketplaceService")
local success, info = pcall(function() return marketplace:GetProductInfo(game.PlaceId) end)
local currentGame = success and info.Name or "Unknown Game"

RightGroupBox:AddLabel('Game: ' .. currentGame)

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

-- [[ THEME SECTION ]]
local ThemeGroupBox = MainTab:AddLeftGroupbox('Themes')
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('GrimixHub')
ThemeManager:ApplyToTab(MainTab)
ThemeManager:BuildConfigSection(MainTab)

Library:Notify('Grimix Hub Loaded!')
