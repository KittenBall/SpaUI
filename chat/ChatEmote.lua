local addonName, SpaUI = ...

local L = SpaUI.Localization

-- 生成表情按钮
local function CreateChatEmoteButton()
    if not ChatFrame1EditBox or not ChatFrame1EditBoxLanguage then return end
    local ChatEmoteButton = CreateFrame("Button", "SpaUIChatEmoteButton",
                                        UIParent)
    ChatEmoteButton:SetWidth(20)
    ChatEmoteButton:SetHeight(20)
    ChatEmoteButton:SetPoint("BOTTOM", ChatFrame1EditBoxLanguage, "TOP", 0, 0)
    ChatEmoteButton:SetNormalTexture(
        "Interface\\Addons\\SpaUI\\chat\\emojis\\greet")
    ChatEmoteButton:SetScript("OnEnter", function(self) self:SetScale(1.35) end)
    ChatEmoteButton:SetScript("OnLeave", function(self) self:SetScale(1) end)
    ChatEmoteButton:SetScript("OnMouseUp", function(self) self:SetAlpha(1) end)
    ChatEmoteButton:SetScript("OnMouseDown",
                              function(self) self:SetAlpha(0.5) end)
    return true
end

SpaUI:RegisterEvent('PLAYER_ENTERING_WORLD', CreateChatEmoteButton)
