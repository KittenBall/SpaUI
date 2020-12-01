local addonName,SpaUI = ...
local L = SpaUI.Localization
local Config = SpaUI.Config

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
local function CreateConfigPanel(event, name)
    local SpaUIConfigPanel =
        CreateFrame("Frame", "SpaUIConfigPanel", UIParent)
    CreateConfigHomePage(SpaUIConfigPanel)
    SpaUIConfigPanel.name = L["addon_name"]
    InterfaceOptions_AddCategory(SpaUIConfigPanel)
    Config.ConfigPanel = SpaUIConfigPanel
end

SpaUI:CallbackOnce('PLAYER_LOGIN', CreateConfigPanel)