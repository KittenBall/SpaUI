local addonName,SpaUI = ...
local Config = SpaUI.Config
local L = SpaUI.Localization
local Widget = SpaUI.Widget

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
        cmd = string.upper(cmd)
        -- debug模式
        if cmd == "DEBUGMODE" then
            Config:ToggleDebugMode(value=="1")
        elseif cmd == "ALIGN" then
            Widget:ToggleAlign()
        else
            SpaUI:ShowMessage(L["config_macro"])
        end
    end
end