local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

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
        Library:Notify('Destroying Hub and Loading AFS...', 2)
        
        task.wait(0.5)
        Library:Unload() -- Completely destroys the Hub UI
        
        local scriptRepo = 'https://raw.githubusercontent.com/pavlocoo/Astral1/refs/heads/main/main.lua'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddButton({
    Text = 'Blox Fruits',
    Func = function()
        Library:Notify('Destroying Hub and Loading Blox Fruits...', 2)
        
        task.wait(0.5)
        Library:Unload() -- Completely destroys the Hub UI
        
        local scriptRepo = 'YOUR_BLOX_FRUITS_URL_HERE'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

-- [[ DETAILED USER INFO ]]
local Player = game.Players.LocalPlayer

RightGroupBox:AddLabel('Name: ' .. Player.Name)
RightGroupBox:AddLabel('Display: ' .. Player.DisplayName)
RightGroupBox:AddLabel('User ID: ' .. Player.UserId)
RightGroupBox:AddLabel('Account Age: ' .. Player.AccountAge .. ' days')
RightGroupBox:AddDivider()
RightGroupBox:AddLabel('Status: Verified ✅')

-- Game Detection
local marketplace = game:GetService("MarketplaceService")
local success, info = pcall(function() return marketplace:GetProductInfo(game.PlaceId) end)
local gameName = success and info.Name or "Unknown Game"
RightGroupBox:AddLabel('Current Game: ' .. gameName)

RightGroupBox:AddDivider()

-- Destroyer Button
RightGroupBox:AddButton('Destroy Hub', function() 
    Library:Unload() 
end)

Library:Notify('Grimix Hub: Session Started')
