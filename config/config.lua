local addonName, SpaUI = ...

local L = SpaUI.Localization

SpaUI.Config = {}

local Config = SpaUI.Config

-- 创建一个CheckButton
-- return not nil
function Config:CreateOptionCheckButton(parent,text,checked,tooltipText)
    local checkButton = CreateFrame("CheckButton",nil,parent,"InterfaceOptionsCheckButtonTemplate")
    checkButton.Text:SetText(text)
    checkButton.tooltipText = tooltipText
    checkButton:SetChecked(checked)
    return checkButton
end

-- 切换debug模式
function Config:ToggleDebugMode(debugMode)
    SpaUIConfigDB.DebugMode = debugMode
    if not Config.ConfigPanel then return end
    local configPanel = Config.ConfigPanel
    if SpaUIConfigDB.DebugMode then
       if not configPanel.DebugButton then
            local debugButton = self:CreateOptionCheckButton(configPanel,L["config_debug"],SpaUIConfigDB.IsDebug,L["config_debug_tooltip"])
            debugButton:SetPoint("BOTTOMLEFT",configPanel,"BOTTOMLEFT",15,15)
            debugButton.SetValue = function(self,checked)
                SpaUIConfigDB.IsDebug = (checked == "1") and true or false
            end
            configPanel.DebugButton = debugButton
       end
        configPanel.DebugButton:Show()
    else
        if configPanel.DebugButton then
            configPanel.DebugButton:Hide()
        end
    end
end