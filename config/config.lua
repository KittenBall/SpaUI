local addonName, SpaUI = ...

local L = SpaUI.Localization

-- SpaUI 配置面板命令
SlashCmdList["SPAUI"] = function() 
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(SpaUI.OptionsPanel) 
end
SLASH_SPAUI1 = "/spa"
SLASH_SPAUI2 = "/spaui"

-- 界面面板内插入SpaUI配置面板
local function CreateOptionsPanel(event, name)
    if name ~= addonName then return end
    local SpaUIOptionsPanel =
        CreateFrame("Frame", "SpaUIOptionsPanel"  , UIParent)
    SpaUIOptionsPanel.name = addonName
    InterfaceOptions_AddCategory(SpaUIOptionsPanel)
    SpaUI.OptionsPanel = SpaUIOptionsPanel
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED', CreateOptionsPanel)
