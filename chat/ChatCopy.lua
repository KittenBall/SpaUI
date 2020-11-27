local addonName, SpaUI = ...
local L = SpaUI.Localization

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
    CopyButton:SetAlpha(0.05)
    CopyButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT")
    CopyButton:SetNormalTexture("Interface\\Addons\\SpaUI\\media\\copy")
    CopyButton:SetHighlightTexture("Interface\\Addons\\SpaUI\\media\\copy_highlight")
    CopyButton:SetPushedTexture("Interface\\Addons\\SpaUI\\media\\copy_pressed")
    return true
end

SpaUI:RegisterEvent('PLAYER_ENTERING_WORLD',CreateCopyButton)