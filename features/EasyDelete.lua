local addonName, SpaUI = ...

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

        SpaUI.EasyDeleteLink:SetText(link)
        SpaUI.EasyDeleteLink:Show()
    end
end

local function EasyDeleteInitialization(event, loaded_addon)
    if loaded_addon ~= addonName then return end
    -- create item link container
    SpaUI.EasyDeleteLink = StaticPopup1:CreateFontString(nil, 'ARTWORK',
                                                         'GameFontHighlight')
    SpaUI.EasyDeleteLink:SetPoint('CENTER', StaticPopup1EditBox)
    SpaUI.EasyDeleteLink:Hide()

    StaticPopup1:HookScript('OnHide',
                            function(self) SpaUI.EasyDeleteLink:Hide() end)
end

SpaUI:RegisterEvent('ADDON_LOADED', EasyDeleteInitialization)
SpaUI:RegisterEvent('DELETE_ITEM_CONFIRM', DeleteItemConfirm)
