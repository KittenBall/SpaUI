local addonName, SpaUI = ...

local L = SpaUI.Localization

local function CreateSpaUIButton()
    local GameMenuButtonSpaUI = CreateFrame("BUTTON", "GameMenuButtonSpaUI",
                                            GameMenuFrame,
                                            "GameMenuButtonTemplate")
    GameMenuButtonSpaUI:SetText(L["config_spaui_button"])
    GameMenuButtonSpaUI:SetPoint("TOP", "GameMenuButtonWhatsNew", "BOTTOM", 0,
                                 -1)
    GameMenuButtonSpaUI:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
    end)
end

local function HookGameMenuFrameToAddSpaUIButton()
    if not GameMenuButtonSpaUI then CreateSpaUIButton() end
    GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() +
                                GameMenuButtonSpaUI:GetHeight() + 1)

    local _, _, _, offX, offY = GameMenuButtonOptions:GetPoint()
    GameMenuButtonOptions:ClearAllPoints()
    GameMenuButtonOptions:SetPoint("TOP", GameMenuButtonSpaUI, "BOTTOM", offX,
                                   offY)
end

hooksecurefunc('GameMenuFrame_UpdateVisibleButtons',
               HookGameMenuFrameToAddSpaUIButton)