-- 大米不同层数装备奖励明细
local addonName,SpaUI = ...
local L = SpaUI.Localization

local MAX_DIFFICULTY_LEVEL = 16
local MAX_REWARD_DIFFICULTY_LEVEL = 15
local RewardItemMargin = 5

local function ShowTooltip(event)
    if event == "OnEnter" then
        GameTooltip:SetOwner(ChallengesFrame.RewardButton, "ANCHOR_BOTTOM")
        GameTooltip:SetText(L["key_stone_reward_tooltip"])
        GameTooltip:Show()
    else
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        GameTooltip:Hide()
    end
end

local function UpdateRewardButtonVisibility(show)
    if not ChallengesFrame or not ChallengesFrame.RewardButton then return end
    if show then
        ChallengesFrame.RewardButton:Hide()
    else
        ChallengesFrame.RewardButton:Show()
    end
end

local function ShowCurrentLevelAndReward()
    if not ChallengesFrame or not RewardContainer or not RewardContainer:IsShown() then return end
    local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    if keyStoneLevel then
        local weeklyLevel,endOfRunLevel = C_MythicPlus.GetRewardLevelForDifficultyLevel(keyStoneLevel) 
        SpaUIChallengesRewardContainer.CurrentReward:SetText(("%d(%d)"):format(endOfRunLevel,weeklyLevel))
        SpaUIChallengesRewardContainer.CurrentDifficultyLevel:SetText(tostring(keyStoneLevel))
    else
        SpaUIChallengesRewardContainer.CurrentReward:SetText("")
        SpaUIChallengesRewardContainer.CurrentDifficultyLevel:SetText("")
    end
end

local function CreateRewardFrames()
    if not ChallengesFrame then return end

    ChallengesFrame.RewardButton = CreateFrame("Button","ChallengesFrameRewardButton",ChallengesFrame)
    ChallengesFrame.RewardButton:SetWidth(18)
    ChallengesFrame.RewardButton:SetHeight(18)
    ChallengesFrame.RewardButton:SetPoint("TOPRIGHT",PVEFrame.CloseButton,"BOTTOMRIGHT",-10,0)
    ChallengesFrame.RewardButton:SetNormalTexture(525134)
    ChallengesFrame.RewardButton:Hide()
    ChallengesFrame.RewardButton:SetScript("OnClick",function() SpaUIChallengesRewardContainer:Show() end)
    ChallengesFrame.RewardButton:SetScript("OnEnter", function(self)
        ShowTooltip("OnEnter")
    end)
    ChallengesFrame.RewardButton:SetScript("OnLeave", function(self)
        ShowTooltip("OnLeave")
    end)

    local RewardContainer = CreateFrame("Frame","SpaUIChallengesRewardContainer",ChallengesFrame,"BasicFrameTemplateWithInset")
    RewardContainer:SetWidth(200)
    RewardContainer:SetPoint("LEFT",ChallengesFrame,"RIGHT",0,0)
    RewardContainer:SetPoint("TOP",ChallengesFrame,"TOP",0,0)
    RewardContainer:SetPoint("BOTTOM",ChallengesFrame,"BOTTOM",0,0)

    RewardContainer.TitleText:SetText(L["key_stone_reward_title"])

    RewardContainer.DifficultyTextTitle = RewardContainer:CreateFontString(RewardContainer,nil,"GameFontNormal")
    RewardContainer.DifficultyTextTitle:SetText(L["key_stone_reward_title_difficulty"])
    RewardContainer.DifficultyTextTitle:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.DifficultyTextTitle:SetPoint("TOP",RewardContainer.LeftBorder,"TOP",0,-RewardItemMargin)
    RewardContainer.DifficultyTextTitle:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    RewardContainer.RewardTextTitle = RewardContainer:CreateFontString(RewardContainer,nil,"GameFontNormal")
    RewardContainer.RewardTextTitle:SetText(L["key_stone_reward_title_level"])
    RewardContainer.RewardTextTitle:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    RewardContainer.RewardTextTitle:SetPoint("TOP",RewardContainer.RightBorder,"TOP",0,-RewardItemMargin)
    RewardContainer.RewardTextTitle:SetPoint("LEFT",RewardContainer,"CENTER",0,0)


    for i = MAX_DIFFICULTY_LEVEL, 1, -1 do
        RewardContainer["DifficultyText"..i] = RewardContainer:CreateFontString(RewardContainer,nil,i == MAX_REWARD_DIFFICULTY_LEVEL and "GameFontNormal" or"GameFontHighlight")
        RewardContainer["DifficultyText"..i]:SetText(tostring(i))
        if i == MAX_DIFFICULTY_LEVEL then
            RewardContainer["DifficultyText"..i]:SetPoint("TOP",RewardContainer.DifficultyTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            RewardContainer["DifficultyText"..i]:SetPoint("TOP",RewardContainer["DifficultyText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        RewardContainer["DifficultyText"..i]:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
        RewardContainer["DifficultyText"..i]:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

        local weeklyLevel,endOfRunLevel = C_MythicPlus.GetRewardLevelForDifficultyLevel(i)  
        
        RewardContainer["RewardText"..i] = RewardContainer:CreateFontString(RewardContainer,nil,i == MAX_REWARD_DIFFICULTY_LEVEL and "GameFontNormal" or"GameFontHighlight")
        RewardContainer["RewardText"..i]:SetText(("%d(%d)"):format(endOfRunLevel,weeklyLevel))
        if i == MAX_DIFFICULTY_LEVEL then
            RewardContainer["RewardText"..i]:SetPoint("TOP",RewardContainer.RewardTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            RewardContainer["RewardText"..i]:SetPoint("TOP",RewardContainer["RewardText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        RewardContainer["RewardText"..i]:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
        RewardContainer["RewardText"..i]:SetPoint("LEFT",RewardContainer,"CENTER",0,0)
    end

    RewardContainer.CurrentDifficultyText = RewardContainer:CreateFontString(RewardContainer,nil,"GameFontGreen")
    RewardContainer.CurrentDifficultyText:SetText(L["key_stone_current_owned"])
    RewardContainer.CurrentDifficultyText:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.CurrentDifficultyText:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)

    RewardContainer.CurrentDifficultyLevel = RewardContainer:CreateFontString(RewardContainer,nil,"GameFontGreen")
    RewardContainer.CurrentDifficultyLevel:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.CurrentDifficultyLevel:SetPoint("TOP",RewardContainer["DifficultyText1"],"BOTTOM",0,-RewardItemMargin)
    RewardContainer.CurrentDifficultyLevel:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    RewardContainer.CurrentReward = RewardContainer:CreateFontString(RewardContainer,nil,"GameFontGreen")
    RewardContainer.CurrentReward:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    RewardContainer.CurrentReward:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)
    RewardContainer.CurrentReward:SetPoint("LEFT",RewardContainer,"CENTER",0,0)

    RewardContainer:SetScript("OnShow",function() UpdateRewardButtonVisibility(true) end)
    RewardContainer:SetScript("OnHide",function() UpdateRewardButtonVisibility(false) end)

    ChallengesFrame:HookScript("OnShow",ShowCurrentLevelAndReward)
end

local function OnBlizzardChallengesUIInitialize(event,name)  
    if name == 'Blizzard_ChallengesUI' then
        CreateRewardFrames()
        return true
    end
end

SpaUI:RegisterEvent('ADDON_LOADED',OnBlizzardChallengesUIInitialize)