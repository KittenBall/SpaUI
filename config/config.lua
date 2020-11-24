local addonName, SpaUI = ...

local L = SpaUI.Localization

-- 界面面板内插入SpaUI配置面板
local function CreateOptionsPanel(event, name)
    if name ~= addonName then return end
    local SpaUIOptionsPanel =
        CreateFrame("Frame", "SpaUIOptionsPanel", UIParent)
    SpaUIOptionsPanel.name = addonName
    InterfaceOptions_AddCategory(SpaUIOptionsPanel)
    SpaUI.OptionsPanel = SpaUIOptionsPanel
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED', CreateOptionsPanel)
