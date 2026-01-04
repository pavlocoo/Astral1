-- Load Library
loadstring(game:HttpGet("https://raw.githubusercontent.com/pavlocoo/Astral1/main/main.lua"))()

-- =========================
-- [ LEGIT TAB ]
-- =========================
local LegitTab = library:AddTab("Legit")
local LegitColumn1 = LegitTab:AddColumn()
local LegitColumn2 = LegitTab:AddColumn()

-- Aim Assist
local LegitMain = LegitColumn1:AddSection("Aim Assist")
LegitMain:AddDivider("Main")
LegitMain:AddToggle({text = "Enabled", flag = "AimbotEnabled"})
LegitMain:AddSlider({text = "Aimbot FOV", flag = "AimbotFov", min = 0, max = 750, value = 105, suffix = "°"})
LegitMain:AddSlider({text = "Smoothing Factor", flag = "Smoothing", min = 0, max = 30, value = 3, suffix = "%"})
LegitMain:AddList({text = "Hit Box", flag = "AimbotHitbox", value = "Head", values = {"Head", "Torso"}})
LegitMain:AddList({text = "Aimbot Key", flag = "AimbotKey", value = "On Aim", values = {"On Aim", "On Shoot"}})

LegitMain:AddDivider("Draw FOV")
local circleToggle = LegitMain:AddToggle({text = "Enabled", flag = "CircleEnabled"})
circleToggle:AddColor({flag = "CircleColor", color = Color3.new(1,1,1)})
LegitMain:AddSlider({text = "Num Sides", flag = "CircleNumSides", min = 3, max = 48, value = 48})

-- Extend Hitbox
local LegitSecond = LegitColumn1:AddSection("Extend Hitbox")
LegitSecond:AddDivider("Main")
LegitSecond:AddToggle({text = "Enabled", flag = "HitboxEnabled"})
LegitSecond:AddList({text = "Hit Box", flag = "ExtendHitbox", value = "Head", values = {"Head", "Torso"}})
LegitSecond:AddSlider({text = "Extend Rate", flag = "ExtendRate", min = 0, max = 10, value = 10})

-- Trigger Bot
local LegitThird = LegitColumn1:AddSection("Trigger Bot")
LegitThird:AddDivider("Main")
local triggerToggle = LegitThird:AddToggle({text = "Enabled", flag = "TriggerEnabled"})
triggerToggle:AddBind({flag = "TriggerBind", key = "One"})
LegitThird:AddSlider({text = "Trigger Speed", flag = "TriggerSpeed", min = 0, max = 1000, value = 10})

-- Silent Aim
local LegitFourth = LegitColumn2:AddSection("Bullet Redirection")
LegitFourth:AddDivider("Main")
LegitFourth:AddToggle({text = "Enabled", flag = "SilentAimEnabled"})
LegitFourth:AddSlider({text = "Silent Aim FOV", flag = "SilentAimFOV", min = 0, max = 750, value = 105})
LegitFourth:AddSlider({text = "Hit Chance", flag = "HitChances", min = 0, max = 100, value = 100})
LegitFourth:AddList({text = "Mode", flag = "RedirectionMode", value = "P Mode", values = {"P Mode", "Normal Mode"}})
LegitFourth:AddList({text = "Hit Box", flag = "SilentAimHitbox", value = "Head", values = {"Head", "Torso"}})

LegitFourth:AddDivider("Draw FOV")
local circle2Toggle = LegitFourth:AddToggle({text = "Enabled", flag = "Circle2Enabled"})
circle2Toggle:AddColor({flag = "Circle2Color", color = Color3.new(1,1,1)})
LegitFourth:AddSlider({text = "Num Sides", flag = "Circle2NumSides", min = 3, max = 48, value = 48})

LegitFourth:AddDivider("Checks")
LegitFourth:AddToggle({text = "Visible Check", flag = "VisibleCheck"})

-- Recoil Control
local LegitFifth = LegitColumn2:AddSection("Recoil Control")
LegitFifth:AddDivider("Main")
LegitFifth:AddToggle({text = "Enabled", flag = "RecoilControlEnabled"})
LegitFifth:AddSlider({text = "Model Kick", flag = "ModelKick", min = 5, max = 100, value = 100})
LegitFifth:AddSlider({text = "Camera Kick", flag = "CameraKick", min = 5, max = 100, value = 100})

-- =========================
-- [ RAGE TAB ]
-- =========================
local RageTab = library:AddTab("Rage")
local RageColumn = RageTab:AddColumn()
local RageMain = RageColumn:AddSection("Main")

RageMain:AddDivider("Main")
RageMain:AddToggle({text = "Enabled", flag = "AutoWallEnabled"})

-- =========================
-- [ VISUALS TAB ]
-- =========================
local VisualsTab = library:AddTab("Visuals")
local VisualsColumn1 = VisualsTab:AddColumn()
local VisualsColumn2 = VisualsTab:AddColumn()

local VisualsMain = VisualsColumn1:AddSection("Local Visuals")
VisualsMain:AddDivider("Main")
VisualsMain:AddToggle({text = "Enabled", flag = "LocalVisualsEnabled"})

local armToggle = VisualsMain:AddToggle({text = "Custom Arm", flag = "CustomArm"})
armToggle:AddColor({flag = "ArmColor", color = Color3.fromRGB(153,114,248)})
VisualsMain:AddSlider({text = "Arm Transparency", flag = "ArmTransparency", min = 0.1, max = 0.95, value = 0.85})

local weaponToggle = VisualsMain:AddToggle({text = "Custom Weapon", flag = "CustomWeapon"})
weaponToggle:AddColor({flag = "WeaponColor", color = Color3.new(1,1,1)})
VisualsMain:AddSlider({text = "Weapon Transparency", flag = "WeaponTransparency", min = 0.1, max = 0.95, value = 0.85})

-- Camera Visuals
local VisualsSecond = VisualsColumn2:AddSection("Camera Visuals")
VisualsSecond:AddDivider("Main")
VisualsSecond:AddToggle({text = "Enabled", flag = "CameraVisualsEnabled"})
VisualsSecond:AddToggle({text = "Change Camera FOV", flag = "ChangeCameraFOV"})
VisualsSecond:AddSlider({text = "Camera FOV", flag = "CameraFOV", min = 10, max = 120, value = 120})

-- =========================
-- [ SETTINGS TAB ]
-- =========================
local SettingsTab = library:AddTab("Settings")
local SettingsColumn = SettingsTab:AddColumn()
local SettingsColumn2 = SettingsTab:AddColumn()

local MenuSection = SettingsColumn:AddSection("Menu")
local ConfigSection = SettingsColumn2:AddSection("Configs")

MenuSection:AddBind({
    text = "Open / Close",
    flag = "UI Toggle",
    key = "End",
    callback = function()
        library:Close()
    end
})

-- I
