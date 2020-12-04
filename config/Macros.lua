local addonName,SpaUI = ...
local Config = SpaUI.Config
local L = SpaUI.Localization

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SLASH_SPAUI1 = "/spa"
SLASH_SPAUI2 = "/spaui"

SlashCmdList["SPAUI"] = function(msg)
    -- 显示配置面板
    if msg == "" then  
        InterfaceOptionsFrame_Show()
        InterfaceOptionsFrame_OpenToCategory(Config.ConfigPanel)
    else
        local cmd,value = strsplit(" ",msg)
        -- debug模式
        if cmd == "debugMode" then
            Config:ToggleDebugMode(value=="1")
        elseif cmd == "align" then
            SpaUI:ToggleAlign()
        else
            SpaUI:ShowMessage(L["config_macro"])
        end
    end
end