local addonName,SpaUI = ...
local L = SpaUI.Localization
local Config = SpaUI.Config
local LocalEvents = SpaUI.LocalEvents

-- 创建配置首页
local function CreateConfigHomePage(configPanel)
    -- 插件名
    local title = configPanel:CreateFontString(nil, nil, "Game30Font")
    title:SetText(L["addon_name"])
    title:SetPoint("TOPLEFT", configPanel, "TOPLEFT", 15, -15)
    configPanel.Title = title

    -- 版本号
    local version = configPanel:CreateFontString(nil, nil, "GameFontNormal")
    version:SetText(L["config_addon_version"]:format(GetAddOnMetadata(addonName, "Version")))
    version:SetPoint("BOTTOMLEFT",title,"BOTTOMRIGHT",10,0)
    configPanel.Version = version

    local author = configPanel:CreateFontString(nil, nil, "GameFontWhite")
    author:SetText(L["config_addon_author"]:format(GetAddOnMetadata(addonName,"Author")))
    author:SetPoint("BOTTOM", title, "BOTTOM")
    author:SetPoint("RIGHT",configPanel,"RIGHT",-15,0)
    configPanel.Author = author

    -- 添加分割线
    local line = SpaUI:CreateHorizontalLine(configPanel)
    line:SetPoint("LEFT",configPanel,"LEFT",20,0)
    line:SetPoint("RIGHT",configPanel,"RIGHT",-20,0)
    line:SetPoint("TOP",title,"BOTTOM",0,-15)
    configPanel.Line = line

    -- 介绍
    local introduct = configPanel:CreateFontString(nil,nil,"GameFontNormal")
    introduct:SetText(L["config_addon_introduct"])
    introduct:SetJustifyH("LEFT")
    introduct:SetPoint("LEFT",configPanel,"LEFT",15,0)
    introduct:SetPoint("RIGHT",configPanel,"RIGHT",-15,0)
    introduct:SetPoint("TOP",line,"BOTTOM",0,-15)
    configPanel.Introduct = introduct

    -- 宏命令
    local macro = configPanel:CreateFontString(nil,nil,"GameFontHighlightLeft")
    macro:SetText(L["config_macro"])
    macro:SetPoint("LEFT",configPanel,"LEFT",15,0)
    macro:SetPoint("RIGHT",configPanel,"RIGHT",-15,0)
    macro:SetPoint("TOP",introduct,"BOTTOM",0,-15)
    configPanel.Macro = macro
    
    Config:ToggleDebugMode(SpaUIConfigDB.DebugMode)
end

-- 界面面板内插入SpaUI配置面板
local function CreateConfigPanel()
    if Config.ConfigPanel then return end
    local SpaUIConfigPanel =
        CreateFrame("Frame", "SpaUIConfigPanel", UIParent)
    Config.ConfigPanel = SpaUIConfigPanel
    CreateConfigHomePage(SpaUIConfigPanel)
    SpaUIConfigPanel.name = L["addon_name"]
    InterfaceOptions_AddCategory(SpaUIConfigPanel)
end

SpaUI:CallbackLocalEventOnce(LocalEvents.ADDON_INITIALIZATION, CreateConfigPanel)