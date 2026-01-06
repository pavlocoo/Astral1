local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = 'Grimix Hub | Premium Selector',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- [[ MAIN TAB ]]
local MainTab = Window:AddTab('Game Scripts')

local LeftGroupBox = MainTab:AddLeftGroupbox('Select a Script')
local RightGroupBox = MainTab:AddRightGroupbox('User Information')

-- [[ GAME BUTTONS ]]

LeftGroupBox:AddButton({
    Text = 'Anime Fighting Simulator',
    Func = function()
        Library:Notify('Destroying Hub and Loading AFS...', 2)
        
        task.wait(0.5)
        Library:Unload() -- This completely destroys the Hub UI
        
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
        Library:Unload() -- This completely destroys the Hub UI
        
        local scriptRepo = 'YOUR_BLOX_FRUITS_URL_HERE'
        loadstring(game:HttpGet(scriptRepo))()
    end
})

-- [[ DETAILED USER INFO ]]
RightGroupBox:AddLabel('User: ' .. game.Players.LocalPlayer.Name)
RightGroupBox:AddLabel('Display: ' .. game.Players.LocalPlayer.DisplayName)
RightGroupBox:AddLabel('User ID: ' .. game.Players.LocalPlayer.UserId)
RightGroupBox:AddLabel('Account Age: ' .. game.Players.LocalPlayer.AccountAge .. ' days')
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
