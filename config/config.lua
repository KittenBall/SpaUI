local addonName, SpaUI = ...

local L = SpaUI.Localization

local CONFIG_PANEL_NAME = "SpaUIOptionsPanel"

-- SpaUI 配置面板命令
SlashCmdList["SPAUI"] = function() 
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(_G[CONFIG_PANEL_NAME]) 
end
SLASH_SPAUI1 = "/spa"

-- 界面面板内插入SpaUI配置面板
local function CreateOptionsPanel(event, name)
    if name ~= addonName then return end
    local SpaUIOptionsPanel =
        CreateFrame("Frame", CONFIG_PANEL_NAME  , UIParent)
    SpaUIOptionsPanel.name = addonName
    InterfaceOptions_AddCategory(SpaUIOptionsPanel)
    SpaUI.OptionsPanel = SpaUIOptionsPanel
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED', CreateOptionsPanel)
