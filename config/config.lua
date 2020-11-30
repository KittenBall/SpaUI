local addonName, SpaUI = ...

local L = SpaUI.Localization

-- SpaUI 配置面板命令
SlashCmdList["SPAUI"] = function()
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(SpaUI.ConfigPanel)
end
SLASH_SPAUI1 = "/spa"
SLASH_SPAUI2 = "/spaui"
