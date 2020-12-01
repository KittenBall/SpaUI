local addonName, SpaUI = ...

local L = SpaUI.Localization

SpaUI.Config = {}

local Config = SpaUI.Config

-- SpaUI 配置面板命令
SlashCmdList["SPAUI"] = function()
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(Config.ConfigPanel)
end
SLASH_SPAUI1 = "/spa"
SLASH_SPAUI2 = "/spaui"

-- 创建一个CheckButton
-- return not nil
function Config:CreateOptionCheckButton(parent,text,checked,tooltipText)
    local checkButton = CreateFrame("CheckButton",nil,parent,"InterfaceOptionsCheckButtonTemplate")
    checkButton.Text:SetText(text)
    checkButton:SetChecked(checked)
    checkButton:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:AddLine(tooltipText)
        GameTooltip:Show()
    end)
    checkButton:SetScript("OnLeave",function(self)
        GameTooltip:Hide()
    end)
    return checkButton
end

