-- ================= SCRIPT HUB OPTIMIZED =================
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

-- Load libraries
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Create window
local Window = Library:CreateWindow({
    Title = 'GrimiX Optimized',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- ================= TABS =================
local Tabs = {
    Home = Window:AddTab('Home'),
    Shops = Window:AddTab('Shops'),
    PvP = Window:AddTab('PvP'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Toggles = {}

-- ================= LEFT GROUPBOX: AUTO FUNCTIONS =================
local LeftGroupBox = Tabs.Home:AddLeftGroupbox('Auto Functions')
local RightGroupBox = Tabs.Home:AddRightGroupbox('Auto Stats')

-- ================= NPC FARM =================
LeftGroupBox:AddLabel('NPC Farm')
LeftGroupBox:AddDivider()

local NPCToggle = LeftGroupBox:AddToggle('NPCFarm', { Text = 'Auto Farm NPCs', Default = false })
Toggles.NPCFarm = NPCToggle

local NPCDropdown = LeftGroupBox:AddDropdown('NPCType', {
    Text = 'Select NPC',
    Values = { 'Sakra','Gen','Igicho','Booh','Saitama' },
    Default = 1
})

local NPCSpeed = LeftGroupBox:AddSlider('NPCSpeed', {
    Text = 'NPC Tween Speed',
    Default = 0.15,
    Min = 0.05,
    Max = 2,
    Rounding = 2
})

local MobMap = { Sakra="1", Gen="2", Igicho="3", Booh="5", Saitama="6" }
local SelectedMobName = "Sakra"
NPCDropdown:OnChanged(function(value) SelectedMobName = tostring(value) end)

local NPCRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteEvent")
local NPCFolder = Workspace:WaitForChild("Scriptable"):WaitForChild("Mobs")

-- NPC Farm Loop - OPTIMIZED FOR SPEED
task.spawn(function()
    while true do
        if not NPCToggle.Value then
            task.wait(0.1)
            continue
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            task.wait(0.1)
            continue
        end

        local mobId = MobMap[SelectedMobName]
        if not mobId then
            task.wait(0.1)
            continue
        end

        local mob = NPCFolder:FindFirstChild(mobId)
        if not mob then
            task.wait(0.01) -- Fast check for new mobs
            continue
        end

        -- Instant teleport to position in front
        local mobPivot = mob:GetPivot()
        local targetCFrame = mobPivot * CFrame.new(0, 0, -1)
        hrp.CFrame = targetCFrame

        local backpackFist = player.Backpack:FindFirstChild("Fist")
        local charFist = char:FindFirstChild("Fist")
        if backpackFist and not charFist then
            char.Humanoid:EquipTool(backpackFist)
        end

        while NPCToggle.Value and mob.Parent == NPCFolder do
            -- Keep facing the NPC
            local mobCurrentPivot = mob:GetPivot()
            local facingCFrame = CFrame.new(hrp.Position, mobCurrentPivot.Position)
            hrp.CFrame = facingCFrame
            
            NPCRemote:FireServer("Train", 1)
            task.wait(0.01) -- Super fast attack speed
        end
    end
end)

-- ================= AUTO CLASS & STATS =================
RightGroupBox:AddLabel('Auto Class & Stats')
RightGroupBox:AddDivider()

local StatsList = { "Strength", "Endurance", "Chakra", "Sword", "Agility", "Speed" }
local StatsIDMap = {
    Strength = 1,
    Endurance = 2,
    Chakra = 3,
    Sword = 4,
    Agility = 5,
    Speed = 6
}

local SelectedStatToUpgrade = "Strength"

RightGroupBox:AddDropdown('StatSelect', {
    Text = 'Select Stat to Upgrade',
    Values = StatsList,
    Default = 1
})

Options.StatSelect:OnChanged(function(value)
    SelectedStatToUpgrade = tostring(value)
end)

local AutoUpgradeToggle = RightGroupBox:AddToggle('AutoUpgradeStats', {
    Text = 'Enable Auto Upgrade',
    Default = false
})
Toggles.AutoUpgradeStats = AutoUpgradeToggle

-- Auto Upgrade Stats Loop
task.spawn(function()
    local RemoteFunction = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction")
    while true do
        task.wait(5) -- Fire every 5 seconds
        if Toggles.AutoUpgradeStats.Value then
            local statID = StatsIDMap[SelectedStatToUpgrade]
            if statID then
                local success, result = pcall(function()
                    return RemoteFunction:InvokeServer("Upgrade", statID)
                end)
                if not success then
                    warn("Auto Upgrade failed:", result)
                end
            end
        end
    end
end)

LeftGroupBox:AddLabel('Auto Pickup')
LeftGroupBox:AddDivider()

local AutoPickupChakraToggle = LeftGroupBox:AddToggle('AutoPickupChakra', {
    Text = 'Auto Pickup Chakra',
    Default = false
})

local AutoPickupFruitsToggle = LeftGroupBox:AddToggle('AutoPickupFruits', {
    Text = 'Auto Pickup Fruits',
    Default = false
})

local ChakraBoxesFolder = workspace:WaitForChild("Scriptable"):WaitForChild("ChikaraBoxes")
local FruitsFolder = workspace:WaitForChild("Scriptable"):WaitForChild("Fruits")

-- Auto Pickup Chakra with fireclickdetector
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoPickupChakraToggle.Value then
            -- Delete notifications
            pcall(function()
                local notifs = player.PlayerGui:FindFirstChild("Main")
                if notifs then
                    local mainHUD = notifs:FindFirstChild("MainHUD")
                    if mainHUD then
                        local notifsFrame = mainHUD:FindFirstChild("Notifs")
                        if notifsFrame then
                            notifsFrame:Destroy()
                        end
                    end
                end
            end)

            -- Click all chakra boxes
            for _, box in pairs(ChakraBoxesFolder:GetChildren()) do
                local clickBox = box:FindFirstChild("ClickBox")
                if clickBox then
                    local clickDetector = clickBox:FindFirstChild("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                end
            end
        end
    end
end)

-- Auto Pickup Fruits
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoPickupFruitsToggle.Value then continue end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local nearestFruit = nil
        local nearestDistance = math.huge

        for _, fruit in pairs(FruitsFolder:GetChildren()) do
            if not fruit.Parent then continue end

            local fruitPart = fruit:IsA("BasePart") and fruit or fruit:FindFirstChildWhichIsA("BasePart", true)
            if fruitPart then
                local distance = (hrp.Position - fruitPart.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestFruit = fruit
                end
            end
        end

        if nearestFruit then
            local fruitPart = nearestFruit:IsA("BasePart") and nearestFruit or nearestFruit:FindFirstChildWhichIsA("BasePart", true)
            hrp.CFrame = fruitPart.CFrame + Vector3.new(0,3,0)

            local clickBox = nearestFruit:FindFirstChild("ClickBox")
            if clickBox then
                local clickDetector = clickBox:FindFirstChildWhichIsA("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
            task.wait(0.2)
        end
    end
end)

-- ================= AUTO QUEST =================
LeftGroupBox:AddLabel('Auto Quest')
LeftGroupBox:AddDivider()

local QuestNPCs = {"Boom", "Ghoul", "Giovanni", "Reindeer", "Sword Master"}
local QuestNameMapping = {
    ["Boom"] = "Boom",
    ["Ghoul"] = "Ghoul",
    ["Giovanni"] = "Giovanni",
    ["Reindeer"] = "Reindeer",
    ["Sword Master"] = "SwordMaster"
}

local SelectedQuestNPC = "Boom"

LeftGroupBox:AddDropdown('QuestNPCSelect', {
    Text = 'Select Quest NPC',
    Values = QuestNPCs,
    Default = 1
})

Options.QuestNPCSelect:OnChanged(function(value)
    SelectedQuestNPC = tostring(value)
end)

local AutoQuestToggle = LeftGroupBox:AddToggle('AutoQuest', {
    Text = 'Enable Auto Quest',
    Default = false
})
Toggles.AutoQuest = AutoQuestToggle

-- ================= AUTO STATS =================
RightGroupBox:AddLabel('Auto Stats')
RightGroupBox:AddDivider()

local TrainRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteEvent")

local StatsMap = {
    Strength=1, Endurance=2, Chakra=3, Sword=4, Agility=5, Speed=6
}

local StatImages = {
    Strength="rbxassetid://3637259080",
    Endurance="rbxassetid://3637258608",
    Speed="rbxassetid://3878141833",
    Chakra="rbxassetid://3637259807",
    Agility="rbxassetid://3711417216"
}

local IDToStatName = {
    [1] = "Strength",
    [2] = "Endurance",
    [3] = "Chakra",
    [4] = "Sword",
    [5] = "Agility",
    [6] = "Speed"
}

local StatToRemoteID = {
    Strength = 1,
    Endurance = 2,
    Chakra = 3,
    Sword = 4,
    Agility = 5,
    Speed = 6
}

local StatToTool = {
    Strength = "Fist",
    Endurance = "Fist",
    Chakra = "Fist",
    Sword = "Sword",
    Agility = "Fist",
    Speed = "Fist"
}

local TrainingAreasFolder = Workspace:WaitForChild("Scriptable"):WaitForChild("TrainingAreas")
local QuestNPCFolder = Workspace:WaitForChild("Scriptable"):WaitForChild("NPC"):WaitForChild("Quest")

local function EquipTool(toolName)
    local char = player.Character
    if not char then return false end

    local equippedTool = char:FindFirstChild(toolName)
    if equippedTool then return true end

    local backpackTool = player.Backpack:FindFirstChild(toolName)
    if backpackTool then
        char.Humanoid:EquipTool(backpackTool)
        task.wait(0.1)
        return true
    end

    return false
end

local function parseNumber(text)
    local lowerText = text:lower()
    local num, suffix = lowerText:match("([%d%.]+)([kmbt])")
    
    if not num then
        num = lowerText:match("([%d%.]+)")
        if not num then return 0 end
        return tonumber(num) or 0
    end

    local value = tonumber(num) or 0
    if suffix == "k" then
        value = value * 1000
    elseif suffix == "m" then
        value = value * 1000000
    elseif suffix == "b" then
        value = value * 1000000000
    elseif suffix == "t" then
        value = value * 1000000000000
    end
    
    return value
end

local function GetBestArea(statName)
    local statID = StatToRemoteID[statName]
    local playerStatObj = player.Stats:FindFirstChild(tostring(statID))
    
    if not playerStatObj then return nil end
    
    local playerStat = playerStatObj.Value
    local allQualifyingAreas = {}

    for _, area in pairs(TrainingAreasFolder:GetChildren()) do
        local displayPart = area:FindFirstChild("DisplayPart")
        if not displayPart then continue end

        local display = displayPart:FindFirstChild("Display")
        if not display then continue end

        local icon = display:FindFirstChild("Icon")
        if not icon or not icon:IsA("ImageLabel") then continue end

        local requiresLabel = display:FindFirstChild("Requires")
        if not requiresLabel or not requiresLabel:IsA("TextLabel") then continue end

        if StatImages[statName] and icon.Image == StatImages[statName] then
            local reqValue = parseNumber(requiresLabel.Text)
            if playerStat >= reqValue then
                table.insert(allQualifyingAreas, {
                    requirement = reqValue,
                    pivot = area:GetPivot()
                })
            end
        end
    end

    if #allQualifyingAreas > 0 then
        table.sort(allQualifyingAreas, function(a,b)
            return a.requirement > b.requirement
        end)
        return allQualifyingAreas[1].pivot
    end

    return nil
end

-- Create toggles
for statName,argValue in pairs(StatsMap) do
    local toggle = RightGroupBox:AddToggle(statName.."Farm", {
        Text = "Auto "..statName,
        Default=false
    })
    Toggles[statName.."Farm"] = toggle
end

-- Auto Stats Loop (ONE AT A TIME, like Auto Quest)
local currentStat = nil
local lastTeleportTime = 0

task.spawn(function()
    while true do
        task.wait(0.5)

        local statToTrain = nil
        for statName, toggle in pairs(Toggles) do
            if toggle.Value and statName:find("Farm") then
                statToTrain = statName:gsub("Farm", "")
                break
            end
        end

        if not statToTrain then
            currentStat = nil
            continue
        end

        local requiredTool = StatToTool[statToTrain]
        if requiredTool then
            EquipTool(requiredTool)
        end

        if statToTrain ~= currentStat or (tick() - lastTeleportTime > 30) then
            local targetPivot = GetBestArea(statToTrain)
            if targetPivot then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local tween = ts:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetPivot})
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.3)

                    currentStat = statToTrain
                    lastTeleportTime = tick()

                    if requiredTool then
                        EquipTool(requiredTool)
                    end
                end
            end
        end

        if currentStat and StatToRemoteID[currentStat] then
            TrainRemote:FireServer("Train", StatToRemoteID[currentStat])
        end
    end
end)

-- ================= AUTO QUEST LOGIC =================
local function TurnInQuest()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local QuestNPC = QuestNPCFolder:FindFirstChild(SelectedQuestNPC)
    if not QuestNPC then return false end

    local npcPivot = QuestNPC:GetPivot()
    if npcPivot then
        local tween = ts:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = npcPivot})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.5)
    end

    local clickBox = QuestNPC:FindFirstChild("ClickBox")
    local clickDetector = clickBox and clickBox:FindFirstChild("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
        task.wait(1)
        return true
    end

    return false
end

local function IsQuestComplete(activeQuest)
    if not activeQuest then return false end

    local requirements = activeQuest:FindFirstChild("Requirements")
    local progress = activeQuest:FindFirstChild("Progress")
    
    if not requirements or not progress then return false end

    for statID = 1, 6 do
        local reqObj = requirements:FindFirstChild(tostring(statID))
        local progObj = progress:FindFirstChild(tostring(statID))
        
        if reqObj and progObj then
            if reqObj.Value > 0 and progObj.Value < reqObj.Value then
                return false
            end
        end
    end

    return true
end

local currentTrainingStat = nil
local lastQuestTeleport = 0

task.spawn(function()
    while true do
        task.wait(0.5)

        if not AutoQuestToggle.Value then
            currentTrainingStat = nil
            continue
        end

        local questFolderName = QuestNameMapping[SelectedQuestNPC]
        if not questFolderName then
            currentTrainingStat = nil
            continue
        end

        -- Collect ONLY quests for the SELECTED NPC
        local activeQuests = {}
        for _, q in pairs(player.Quests:GetChildren()) do
            -- Extract NPC name (letters only) from quest name
            local questNPCName = q.Name:match("^(%a+)")
            -- EXACT match with selected NPC
            if questNPCName == questFolderName and q:FindFirstChild("Progress") and q:FindFirstChild("Requirements") then
                table.insert(activeQuests, q)
            end
        end

        -- Check if any quest is complete and turn in
        for _, quest in ipairs(activeQuests) do
            if IsQuestComplete(quest) then
                TurnInQuest()
                task.wait(2)
                break
            end
        end

        if #activeQuests == 0 then
            currentTrainingStat = nil
            continue
        end

        -- Find the FIRST incomplete stat across ALL quests for selected NPC
        local statToTrain = nil
        for statID = 1, 6 do
            local needsTraining = false
            for _, quest in ipairs(activeQuests) do
                local requirements = quest:FindFirstChild("Requirements")
                local progress = quest:FindFirstChild("Progress")
                
                if requirements and progress then
                    local reqObj = requirements:FindFirstChild(tostring(statID))
                    local progObj = progress:FindFirstChild(tostring(statID))
                    
                    if reqObj and progObj and reqObj.Value > 0 and progObj.Value < reqObj.Value then
                        needsTraining = true
                        break
                    end
                end
            end

            if needsTraining then
                statToTrain = IDToStatName[statID]
                break
            end
        end

        if not statToTrain then
            currentTrainingStat = nil
            continue
        end

        local requiredTool = StatToTool[statToTrain]
        if requiredTool then
            EquipTool(requiredTool)
        end

        if statToTrain ~= currentTrainingStat or (tick() - lastQuestTeleport > 30) then
            local targetPivot = GetBestArea(statToTrain)
            if targetPivot then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local tween = ts:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetPivot})
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.3)

                    currentTrainingStat = statToTrain
                    lastQuestTeleport = tick()

                    if requiredTool then
                        EquipTool(requiredTool)
                    end
                end
            end
        end

        if currentTrainingStat and StatToRemoteID[currentTrainingStat] then
            TrainRemote:FireServer("Train", StatToRemoteID[currentTrainingStat])
        end
    end
end)

-- ================= QUEST TRACKER =================
local QuestTrackerGroup = Tabs.Home:AddRightGroupbox('Quest Tracker')

local questLabels = {}
local labelIndex = 1

-- Function to format numbers with suffixes
local function formatNumber(num)
    if num >= 1000000000000 then
        return string.format("%.1fT", num / 1000000000000)
    elseif num >= 1000000000 then
        return string.format("%.1fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

-- Function to get or create a label
local function GetLabel(text)
    if not questLabels[labelIndex] then
        questLabels[labelIndex] = QuestTrackerGroup:AddLabel(text)
    else
        questLabels[labelIndex]:SetText(text)
    end
    labelIndex = labelIndex + 1
    return questLabels[labelIndex - 1]
end

-- Function to update quest tracker display
local function UpdateQuestTracker()
    labelIndex = 1
    
    -- Get all active quests
    local questsByNPC = {}
    for _, quest in pairs(player.Quests:GetChildren()) do
        local requirements = quest:FindFirstChild("Requirements")
        local progress = quest:FindFirstChild("Progress")
        
        if requirements and progress then
            -- Extract NPC name from quest name (e.g., "Boom21" -> "Boom")
            local npcName = quest.Name:match("^(%a+)")
            if npcName then
                if not questsByNPC[npcName] then
                    questsByNPC[npcName] = {}
                end
                table.insert(questsByNPC[npcName], {
                    name = quest.Name,
                    requirements = requirements,
                    progress = progress
                })
            end
        end
    end
    
    -- Display quests grouped by NPC
    if next(questsByNPC) == nil then
        GetLabel('No active quests')
    else
        for npcName, quests in pairs(questsByNPC) do
            -- NPC Name Header
            GetLabel('=== ' .. npcName .. ' ===')
            
            for _, questData in ipairs(quests) do
                for statID = 1, 6 do
                    local reqObj = questData.requirements:FindFirstChild(tostring(statID))
                    local progObj = questData.progress:FindFirstChild(tostring(statID))
                    
                    if reqObj and progObj and reqObj.Value > 0 then
                        local reqValue = reqObj.Value
                        local progValue = progObj.Value
                        local statName = IDToStatName[statID]
                        
                        local displayText
                        if progValue >= reqValue then
                            displayText = statName .. ": COMPLETED"
                        else
                            displayText = statName .. ": " .. formatNumber(progValue) .. "/" .. formatNumber(reqValue)
                        end
                        
                        GetLabel(displayText)
                    end
                end
            end
            
            -- Add spacing between NPCs
            GetLabel('')
        end
    end
    
    -- Hide unused labels
    for i = labelIndex, #questLabels do
        if questLabels[i] then
            questLabels[i]:SetText('')
        end
    end
end

-- Update quest tracker every 2 seconds
task.spawn(function()
    while true do
        task.wait(2)
        pcall(UpdateQuestTracker)
    end
end)

-- Initial update
task.wait(1)
UpdateQuestTracker()

-- ================= PASTE THIS INTO YOUR SHOPS TAB SECTION =================
-- Replace everything from "-- ================= SHOPS TAB =================" to "-- ================= PvP TAB ================="

-- ================= SHOPS TAB =================
local ShopsGroup = Tabs.Shops:AddLeftGroupbox('Special Shops')
local SpecialShopsFolder = Workspace:WaitForChild("Scriptable"):WaitForChild("NPC"):WaitForChild("Shops"):WaitForChild("Special")

local ShopCategories = {
    "Stands",
    "Quirks",
    "Kagunes",
    "Grimoires",
    "Bloodlines"
}

local SelectedShopCategory = ShopCategories[1]
local SelectedTargetItem = nil
local AvailableItemsData = {}

-- ================= SHOP CATEGORY DROPDOWN =================
ShopsGroup:AddDropdown('ShopDropdown', {
    Text = 'Select Shop Category',
    Values = ShopCategories,
    Default = 1,
    Callback = function(value)
        SelectedShopCategory = tostring(value)
        print("[Shop] Category changed to: " .. SelectedShopCategory)
        UpdateItemList()
    end
})

-- ================= ITEM DROPDOWN (with percentages) =================
local ItemDropdown = ShopsGroup:AddDropdown('ItemDropdown', {
    Text = 'Select Target Item',
    Values = {'Loading...'},
    Default = 1,
    Callback = function(value)
        SelectedTargetItem = tostring(value)
        -- Extract just the item name (remove the percentage part)
        if SelectedTargetItem:find(" ") then
            SelectedTargetItem = SelectedTargetItem:match("^(.-)%s")
        end
        print("[Shop] Target item: " .. SelectedTargetItem)
    end
})

-- ================= FUNCTION: UPDATE ITEM LIST =================
function UpdateItemList()
    task.spawn(function()
        task.wait(0.5) -- Small delay to ensure everything is loaded
        
        local success, err = pcall(function()
            print("[Shop] Updating item list for: " .. SelectedShopCategory)
            
            local shopCategoryFolder = SpecialShopsFolder:FindFirstChild(SelectedShopCategory)
            if not shopCategoryFolder then 
                warn("[Shop] Category folder not found: " .. SelectedShopCategory)
                ItemDropdown:SetValues({'Category not found'})
                return 
            end
            
            local firstShop = shopCategoryFolder:FindFirstChild("1")
            if not firstShop then 
                warn("[Shop] Shop '1' not found")
                ItemDropdown:SetValues({'Shop not found'})
                return 
            end
            
            local clickBox = firstShop:FindFirstChild("ClickBox")
            if not clickBox then 
                warn("[Shop] ClickBox not found")
                ItemDropdown:SetValues({'ClickBox not found'})
                return 
            end
            
            local rarities = clickBox:FindFirstChild("Rarities")
            if not rarities then 
                warn("[Shop] Rarities folder not found")
                ItemDropdown:SetValues({'Rarities not found'})
                return 
            end
            
            local itemList = {}
            AvailableItemsData = {}
            
            -- Get all items with their rarity/percentage
            for _, child in pairs(rarities:GetChildren()) do
                local objectName = child:FindFirstChild("ObjectName")
                local rarityLabel = child:FindFirstChild("Rarity")
                
                if objectName then
                    local itemText = nil
                    local rarityText = "Unknown"
                    
                    -- Get item name
                    if objectName:IsA("TextLabel") or objectName:IsA("TextBox") then
                        itemText = objectName.Text
                    elseif objectName:IsA("StringValue") then
                        itemText = objectName.Value
                    end
                    
                    -- Get rarity/percentage
                    if rarityLabel then
                        if rarityLabel:IsA("TextLabel") or rarityLabel:IsA("TextBox") then
                            rarityText = rarityLabel.Text
                        elseif rarityLabel:IsA("StringValue") then
                            rarityText = rarityLabel.Value
                        end
                    end
                    
                    if itemText and itemText ~= "" then
                        -- Store the clean item name
                        AvailableItemsData[itemText] = rarityText
                        
                        -- Create display text: "ItemName Rarity"
                        local displayText = itemText .. " " .. rarityText
                        
                        if not table.find(itemList, displayText) then
                            table.insert(itemList, displayText)
                            print("[Shop] Found: " .. displayText)
                        end
                    end
                end
            end
            
            -- Update dropdown
            if #itemList > 0 then
                table.sort(itemList)
                
                print("[Shop] About to update dropdown with " .. #itemList .. " items")
                
                -- Use the ItemDropdown variable directly
                ItemDropdown:SetValues(itemList)
                ItemDropdown:SetValue(itemList[1])
                
                -- Set the clean item name
                local firstItem = itemList[1]
                if firstItem:find(" ") then
                    SelectedTargetItem = firstItem:match("^(.-)%s")
                else
                    SelectedTargetItem = firstItem
                end
                
                print("[Shop] ✓ Dropdown updated with " .. #itemList .. " items")
                print("[Shop] Selected target: " .. SelectedTargetItem)
            else
                ItemDropdown:SetValues({'No items found'})
                SelectedTargetItem = nil
                warn("[Shop] No items found in " .. SelectedShopCategory)
            end
        end)
        
        if not success then
            warn("[Shop] Error updating list: " .. tostring(err))
            ItemDropdown:SetValues({'Error: ' .. tostring(err)})
        end
    end)
end

-- ================= TELEPORT TO SHOP =================
ShopsGroup:AddButton({
    Text = 'Teleport to Shop',
    Func = function()
        task.spawn(function()
            local success = pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local shopCategoryFolder = SpecialShopsFolder:FindFirstChild(SelectedShopCategory)
                if not shopCategoryFolder then return end
                
                local firstShop = shopCategoryFolder:FindFirstChild("1")
                if not firstShop then return end
                
                hrp.CFrame = firstShop:GetPivot()
                print("[Shop] Teleported to " .. SelectedShopCategory)
            end)
            
            if not success then
                warn("[Shop] Teleport failed")
            end
        end)
    end
})

-- ================= BUY ONCE BUTTON =================
ShopsGroup:AddButton({
    Text = "Buy Once",
    Func = function()
        task.spawn(function()
            local success = pcall(function()
                local RemoteFunction = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteFunction")
                local args = {"BuyContainer", SelectedShopCategory, 1}
                RemoteFunction:InvokeServer(unpack(args))
                print("[Shop] Purchased from " .. SelectedShopCategory)
            end)
            
            if not success then
                warn("[Shop] Purchase failed")
            end
        end)
    end
})

-- ================= REFRESH ITEMS BUTTON =================
ShopsGroup:AddButton({
    Text = "Refresh Item List",
    Func = function()
        print("[Shop] ========== REFRESH STARTED ==========")
        print("[Shop] Selected Category: " .. SelectedShopCategory)
        UpdateItemList()
    end
})

-- ================= AUTO SPECIAL SHOP TOGGLE =================
local AutoBuyEnabled = false

local AutoSpecialToggle = ShopsGroup:AddToggle('AutoSpecialToggle', {
    Text = 'Auto Buy Until Target',
    Default = false,
    Callback = function(value)
        AutoBuyEnabled = value
        print("[Auto Shop] Toggle changed to: " .. tostring(value))
        if value then
            print("[Auto Shop] AUTO ENABLED - Starting purchases")
        else
            print("[Auto Shop] AUTO DISABLED - Stopping purchases")
        end
    end
})

print("[Auto Shop] Toggle created")

-- ================= STATUS LABELS =================
local StatusLabel = ShopsGroup:AddLabel('Status: Idle')
local PurchaseCountLabel = ShopsGroup:AddLabel('Purchases: 0')

-- ================= DYNAMIC ITEM NAME TO NUMBER MAPPING =================
local ItemNameToNumber = {}

-- Function to build mapping automatically
local function BuildItemMapping()
    ItemNameToNumber = {} -- Reset table

    local shopCategoryFolder = SpecialShopsFolder:FindFirstChild(SelectedShopCategory)
    if not shopCategoryFolder then return end

    local firstShop = shopCategoryFolder:FindFirstChild("1")
    if not firstShop then return end

    local clickBox = firstShop:FindFirstChild("ClickBox")
    if not clickBox then return end

    local rarities = clickBox:FindFirstChild("Rarities")
    if not rarities then return end

    for _, child in pairs(rarities:GetChildren()) do
        local objectName = child:FindFirstChild("ObjectName")
        if objectName then
            local itemText = nil

            -- Get the item name (TextLabel/StringValue)
            if objectName:IsA("TextLabel") or objectName:IsA("TextBox") then
                itemText = objectName.Text
            elseif objectName:IsA("StringValue") then
                itemText = objectName.Value
            end

            -- Also get the numeric ID if it exists in the child (we'll assume Rarity.Value = number if needed)
            local numberValue = child:FindFirstChild("NumberValue")
            local itemNumber = nil
            if numberValue and numberValue:IsA("IntValue") then
                itemNumber = numberValue.Value
            elseif numberValue and numberValue:IsA("StringValue") then
                itemNumber = tonumber(numberValue.Value)
            end

            -- If no explicit number exists, use the index in GetChildren()
            if not itemNumber then
                itemNumber = table.find(rarities:GetChildren(), child)
            end

            if itemText and itemNumber then
                -- Remove spaces and lowercase for consistent mapping
                local cleanName = itemText:lower():gsub("%s+", ""):gsub("'", "")
                ItemNameToNumber[cleanName] = itemNumber
                print("[Mapping] " .. cleanName .. " -> " .. itemNumber)
            end
        end
    end
end

-- Build mapping initially
BuildItemMapping()


-- ================= FUNCTION: CHECK IF GOT TARGET ITEM =================
function CheckIfGotTargetItem()
    if not SelectedTargetItem then 
        return false 
    end
    
    local success, hasItem = pcall(function()
        -- Check player.Specials.[CategoryName]
        local specialsFolder = player:FindFirstChild("Specials")
        if not specialsFolder then 
            return false 
        end
        
        local categoryFolder = specialsFolder:FindFirstChild(SelectedShopCategory)
        if not categoryFolder then 
            return false 
        end
        
        -- Remove spaces and lowercase for lookup
        local targetItemClean = SelectedTargetItem:lower():gsub("%s+", "")
        local targetNumber = ItemNameToNumber[targetItemClean]
        
        if not targetNumber then
            warn("[Inventory] No number mapping found for: '" .. SelectedTargetItem .. "' (cleaned: '" .. targetItemClean .. "')")
            return false
        end
        
        print("[Inventory] Looking for: '" .. SelectedTargetItem .. "' (Number: " .. targetNumber .. ") in " .. SelectedShopCategory)
        
        -- Check all values in the category folder
        for _, item in pairs(categoryFolder:GetChildren()) do
            local itemValue = nil
            
            -- Get the numeric value only
            if item:IsA("IntValue") or item:IsA("NumberValue") then
                itemValue = item.Value
                print("[Inventory] Found NumberValue: " .. tostring(itemValue))
            elseif item:IsA("StringValue") then
                -- Try to convert string to number
                itemValue = tonumber(item.Value)
                if itemValue then
                    print("[Inventory] Found StringValue (converted to number): " .. tostring(itemValue))
                end
            end
            
            -- Compare the numbers
            if itemValue and itemValue == targetNumber then
                print("[Inventory] ✓✓✓ MATCH FOUND! Number " .. itemValue .. " = '" .. SelectedTargetItem .. "' ✓✓✓")
                return true
            end
        end
        
        print("[Inventory] Target number " .. targetNumber .. " not found in inventory")
        return false
    end)
    
    if not success then
        warn("[Inventory] Check error: " .. tostring(hasItem))
        return false
    end
    
    return hasItem or false
end

-- ================= AUTO SPECIAL SHOP LOGIC =================
task.spawn(function()
    local successfulPurchases = 0
    local attemptCount = 0
    
    print("[Auto Shop] ========================================")
    print("[Auto Shop] Auto system INITIALIZED")
    print("[Auto Shop] Purchase delay: 10 seconds")
    print("[Auto Shop] Inventory check: After every purchase")
    print("[Auto Shop] ========================================")
    
    while true do
        -- Use the AutoBuyEnabled variable directly
        if AutoBuyEnabled then
            -- Validate target
            if not SelectedTargetItem or SelectedTargetItem == "Loading..." or SelectedTargetItem == "No items found" then
                StatusLabel:SetText('Status: No target selected')
                task.wait(1)
                continue
            end
            
            -- Wait 10 seconds before making purchase
            task.wait(10)
            
            attemptCount = attemptCount + 1
            
            -- Make the purchase
            local purchaseSuccess, result = pcall(function()
                local RemoteFunction = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteFunction")
                local args = {"BuyContainer", SelectedShopCategory, 1}
                return RemoteFunction:InvokeServer(unpack(args))
            end)
            
            if purchaseSuccess then
                successfulPurchases = successfulPurchases + 1
                
                -- Update UI with successful purchase count
                StatusLabel:SetText('Purchasing... #' .. successfulPurchases)
                PurchaseCountLabel:SetText('Purchases: ' .. successfulPurchases)
                
                print("[Auto Shop] Purchase #" .. successfulPurchases .. " completed. Checking inventory...")
                
                -- Check inventory after EVERY purchase
                local gotTarget = CheckIfGotTargetItem()
                
                if gotTarget then
                    StatusLabel:SetText('✓ SUCCESS! Got: ' .. SelectedTargetItem)
                    AutoBuyEnabled = false
                    AutoSpecialToggle:SetValue(false)
                    
                    print("==========================================")
                    print("[Auto Shop] ✓✓✓ SUCCESS! ✓✓✓")
                    print("[Auto Shop] Got item: " .. SelectedTargetItem)
                    print("[Auto Shop] Total purchases: " .. successfulPurchases)
                    print("[Auto Shop] Total attempts: " .. attemptCount)
                    print("==========================================")
                    
                    -- Show notification
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Auto Shop Success!",
                            Text = "Got " .. SelectedTargetItem .. " after " .. successfulPurchases .. " purchases!",
                            Duration = 5
                        })
                    end)
                    
                    successfulPurchases = 0
                    attemptCount = 0
                end
            else
                -- Purchase failed, don't count it
                if attemptCount % 10 == 0 then
                    warn("[Auto Shop] Some purchases failing (Attempt: " .. attemptCount .. ", Success: " .. successfulPurchases .. ")")
                end
            end
        else
            -- Not enabled
            if successfulPurchases > 0 then
                StatusLabel:SetText('Idle (Completed: ' .. successfulPurchases .. ' purchases)')
            else
                StatusLabel:SetText('Status: Idle')
            end
            task.wait(1)
        end
    end
end)

print("[Auto Shop] Loop task spawned successfully")

-- ================= INITIALIZE =================
task.wait(1.5)
print("[Shop] Initializing shop system...")
UpdateItemList()

-- ================= AUTO GACHA SECTION =================
local GachaGroup = Tabs.Shops:AddRightGroupbox('Auto Gacha')

local GachaTypes = {"Jutsu", "Nen", "Soul", "Ninchiyin", "Seiyen", "Mystery"}
local GachaMapping = {
    Jutsu = "G1",
    Nen = "G2",
    Soul = "G3",
    Ninchiyin = "G4",
    Seiyen = "G5",
    Mystery = "G6"
}

GachaGroup:AddDropdown('GachaSelect', {
    Text = 'Select Gacha Type',
    Values = GachaTypes,
    Default = 1
})

GachaGroup:AddDropdown('AutoDelete', {
    Text = 'Auto Delete (Coming Soon)',
    Values = {"Blank"},
    Default = 1,
    Multi = true
})

GachaGroup:AddToggle('AutoGachaToggle', {
    Text = 'Enable Auto Gacha',
    Default = false
})

local GachaStatusLabel = GachaGroup:AddLabel('Status: Idle')
local GachaSpinCountLabel = GachaGroup:AddLabel('Spins: 0')

task.spawn(function()
    local spinCount = 0
    local lastSpinTime = 0
    
    while true do
        task.wait(0.1)
        
        if Toggles.AutoGachaToggle and Toggles.AutoGachaToggle.Value then
            local selectedName = Options.GachaSelect.Value
            local gachaID = GachaMapping[selectedName]
            
            if not gachaID then
                task.wait(1)
                continue
            end
            
            if tick() - lastSpinTime < 1.2 then
                task.wait(0.1)
                continue
            end
            
            lastSpinTime = tick()
            spinCount = spinCount + 1
            
            GachaStatusLabel:SetText('Spinning... #' .. spinCount)
            GachaSpinCountLabel:SetText('Spins: ' .. spinCount)
            
            pcall(function()
                local args = {"BuyGacha", gachaID}
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
            end)
        else
            if spinCount > 0 then
                GachaStatusLabel:SetText('Idle (Total: ' .. spinCount .. ')')
            else
                GachaStatusLabel:SetText('Status: Idle')
            end
            task.wait(1)
        end
    end
end)

print("=== SHOPS & GACHA AUTOMATION LOADED ===")

-- ================= PvP TAB =================
local PvPGroupBox = Tabs.PvP:AddLeftGroupbox('PvP')

-- Config
local AIM_LOCK_ENABLED = false
local AIM_SMOOTHNESS = 0.15
local AIM_MAX_DISTANCE = 1500
local AIM_KEY = Enum.KeyCode.Q

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- UI Elements
PvPGroupBox:AddLabel("Aim Lock")

local AimLockToggle = PvPGroupBox:AddToggle('AimLock', {
    Text = 'Enable Aim Lock',
    Default = false
})

local SmoothSlider = PvPGroupBox:AddSlider('AimSmooth', {
    Text = 'Smoothness',
    Default = AIM_SMOOTHNESS,
    Min = 0.01,
    Max = 1,
    Rounding = 2
})

local DistanceSlider = PvPGroupBox:AddSlider('AimDistance', {
    Text = 'Max Distance',
    Default = AIM_MAX_DISTANCE,
    Min = 100,
    Max = 5000,
    Rounding = 0
})

-- Update config when sliders/UI change
AimLockToggle:OnChanged(function(value)
    AIM_LOCK_ENABLED = value
end)

SmoothSlider:OnChanged(function(value)
    AIM_SMOOTHNESS = value
end)

DistanceSlider:OnChanged(function(value)
    AIM_MAX_DISTANCE = value
end)

-- Optional toggle key
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == AIM_KEY then
        AIM_LOCK_ENABLED = not AIM_LOCK_ENABLED
        AimLockToggle:SetValue(AIM_LOCK_ENABLED)
    end
end)

-- Get closest target head
local function GetClosestTargetHead()
    local closestHead = nil
    local closestDistance = AIM_MAX_DISTANCE
    
    local charactersFolder = Workspace:FindFirstChild("Scriptable") and Workspace.Scriptable:FindFirstChild("Characters")
    if not charactersFolder then return nil end
    
    for _, character in pairs(charactersFolder:GetChildren()) do
        if character.Name ~= LocalPlayer.Name then
            local head = character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local dist = (Camera.CFrame.Position - head.Position).Magnitude
                if dist < closestDistance then
                    closestDistance = dist
                    closestHead = head
                end
            end
        end
    end
    
    return closestHead
end

-- Aim function
local function AimAt(part, deltaTime)
    if not part then return end
    
    local camPos = Camera.CFrame.Position
    local desiredCFrame = CFrame.new(camPos, part.Position)
    Camera.CFrame = Camera.CFrame:Lerp(desiredCFrame, AIM_SMOOTHNESS)
end

-- Main loop
RunService.RenderStepped:Connect(function(deltaTime)
    if not AIM_LOCK_ENABLED then return end
    
    local targetHead = GetClosestTargetHead()
    if targetHead then
        AimAt(targetHead, deltaTime)
    end
end)

-- ================= UI SETTINGS =================
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default='End',
    NoUI=true,
    Text='Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

-- Theme & Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

-- END & watermark
Library:SetWatermarkVisibility(true)

-- FPS Counter
local FPSLabel = Library:AddLabel('FPS: 0', true)
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        local fps = math.floor(frameCount / (now - lastUpdate))
        FPSLabel:SetText('FPS: ' .. fps)
        frameCount = 0
        lastUpdate = now
    end
end)

Library:OnUnload(function()
    Library.Unloaded = true
end)
