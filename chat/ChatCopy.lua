local addonName, SpaUI = ...
local L = SpaUI.Localization

local ALPHA_ENTER = 0.4
local ALPHA_LEAVE = 0.2

local function CreateCopyFrame()
    local CopyFrame = CreateFrame("Frame", "SpaUIEmoteTableFrame",
    UIParent, "BasicFrameTemplateWithInset")
end

-- 创建复制按钮
local function CreateCopyButton()
    local CopyButton = CreateFrame("Button","SpaUICopyButton",UIParent)
    CopyButton:SetWidth(18)
    CopyButton:SetHeight(18)
    -- 图标太亮了，降点透明度
    CopyButton:SetAlpha(ALPHA_LEAVE)
    CopyButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT")
    CopyButton:SetNormalTexture("Interface\\Addons\\SpaUI\\Media\\copy")
    CopyButton:SetHighlightTexture("Interface\\Addons\\SpaUI\\Media\\copy_highlight")
    CopyButton:SetPushedTexture("Interface\\Addons\\SpaUI\\Media\\copy_pressed")
    CopyButton:SetScript("OnEnter",function(self) self:SetAlpha(ALPHA_ENTER) end)
    CopyButton:SetScript("OnLeave",function(self) self:SetAlpha(ALPHA_LEAVE) end)
end

SpaUI:CallbackOnce('PLAYER_LOGIN',CreateCopyButton)