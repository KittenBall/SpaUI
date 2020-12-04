local addonName, SpaUI = ...

local Widget = SpaUI.Widget
-- 摧毁物品不需要填写delete
--------------------------------------------------------------------------------
-- EasyDeleteConfirm
-- By Kesava at curse.com
-- All rights reserved
--------------------------------------------------------------------------------

local function DeleteItemConfirm(...)
    if StaticPopup1EditBox:IsShown() then
        StaticPopup1EditBox:Hide()
        StaticPopup1Button1:Enable()
        local link = select(3, GetCursorInfo())

        Widget.EasyDeleteLink:SetText(link)
        Widget.EasyDeleteLink:Show()
    end
end

local function EasyDeleteInitialization()
    -- create item link container
    Widget.EasyDeleteLink = StaticPopup1:CreateFontString(nil, 'ARTWORK',
                                                         'GameFontHighlight')
    Widget.EasyDeleteLink:SetPoint('CENTER', StaticPopup1EditBox)
    Widget.EasyDeleteLink:Hide()

    StaticPopup1:HookScript('OnHide',
                            function(self) Widget.EasyDeleteLink:Hide() end)
end

SpaUI:CallbackOnce('PLAYER_LOGIN', EasyDeleteInitialization)
SpaUI:RegisterEvent('DELETE_ITEM_CONFIRM', DeleteItemConfirm)
