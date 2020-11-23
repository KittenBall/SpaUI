local addonName, SpaUI = ...

local L = SpaUI.Localization

local function CreateOptionsPanel(event, name)
    if name ~= addonName then return end
    local SpaUIOptionsPanel =
        CreateFrame("Frame", "SpaUIOptionsPanel", UIParent)
    SpaUIOptionsPanel.name = addonName
    InterfaceOptions_AddCategory(SpaUIOptionsPanel)
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED', CreateOptionsPanel)
