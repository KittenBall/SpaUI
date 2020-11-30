local addonName, SpaUI = ...

local L = SpaUI.Localization

-- SpaUI 配置面板命令
SlashCmdList["SPAUI"] = function()
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(SpaUI.OptionsPanel)
end
SLASH_SPAUI1 = "/spa"
SLASH_SPAUI2 = "/spaui"

-- 创建配置首页
local function CreateConfigHomePage(configPanel)
    -- 插件名
    local title = configPanel:CreateFontString(nil, nil, "Game30Font")
    title:SetText(L["addon_name"])
    title:SetPoint("TOPLEFT", configPanel, "TOPLEFT", 15, -15)

    -- 版本号
    local version = configPanel:CreateFontString(nil, nil, "GameFontNormal")
    version:SetText(L["config_addon_version"]:format(GetAddOnMetadata(addonName, "Version")))
    version:SetPoint("BOTTOMLEFT",title,"BOTTOMRIGHT",10,0)

    local author = configPanel:CreateFontString(nil, nil, "GameFontWhite")
    author:SetText(L["config_addon_author"]:format(GetAddOnMetadata(addonName,"Author")))
    author:SetPoint("BOTTOM", title, "BOTTOM")
    author:SetPoint("RIGHT",configPanel,"RIGHT",-15,0)

    -- 添加分割线
    local line = SpaUI:CreateHorizontalLine(configPanel)
    line:SetPoint("LEFT",configPanel,"LEFT",20,0)
    line:SetPoint("RIGHT",configPanel,"RIGHT",-20,0)
    line:SetPoint("TOP",title,"BOTTOM",0,-15)
end

-- 界面面板内插入SpaUI配置面板
local function CreateOptionsPanel(event, name)
    if name ~= addonName then return end
    local SpaUIOptionsPanel =
        CreateFrame("Frame", "SpaUIOptionsPanel", UIParent)
    CreateConfigHomePage(SpaUIOptionsPanel)
    SpaUIOptionsPanel.name = L["addon_name"]
    InterfaceOptions_AddCategory(SpaUIOptionsPanel)
    SpaUI.OptionsPanel = SpaUIOptionsPanel
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED', CreateOptionsPanel)
