local addonName, SpaUI = ...
local L = SpaUI.Localization

local function CreateCopyFrame()
    local CopyFrame = CreateFrame("Frame", "SpaUIEmoteTableFrame",
    UIParent, "BasicFrameTemplateWithInset")
end

-- 创建复制按钮
local function CreateCopyButton()
    local CopyButton = CreateFrame("Button","SpaUICopyButton",UIParent)
    CopyButton:SetWidth(16)
    CopyButton:SetHeight(16)
    CopyButton:SetAlpha(0.3)
    CopyButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT")
    CopyButton:SetNormalTexture("Interface\\Addons\\SpaUI\\media\\copy")
    CopyButton:SetHighlightTexture("Interface\\Addons\\SpaUI\\media\\copy_highlight")
    return true
end

SpaUI:RegisterEvent('PLAYER_ENTERING_WORLD',CreateCopyButton)