-- 大米不同层数装备奖励明细
local addonName,SpaUI = ...
local L = SpaUI.Localization

local RewardItemMargin = 5

-- 系统api有问题，懒得查原因，直接写死
local REWARD_LEVELS = {
    {level = 2, firstWeek = 187, endofRunLevel = 187, weeklyLevel = 200},
    {level = 3, firstWeek = 190, endofRunLevel = 190, weeklyLevel = 203},
    {level = 4, firstWeek = 194, endofRunLevel = 194, weeklyLevel = 207},
    {level = 5, firstWeek = 194, endofRunLevel = 194, weeklyLevel = 210},
    {level = 6, firstWeek = 197, endofRunLevel = 197, weeklyLevel = 210},
    {level = 7, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 213},
    {level = 8, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 216},
    {level = 9, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 216},
    {level = 10, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 220},
    {level = 11, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 220},
    {level = 12, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 223},
    {level = 13, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 223},
    {level = 14, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 226},
    {level = 15, firstWeek = 203, endofRunLevel = 210, weeklyLevel = 226},
}

local function IsFirstWeek()
    local dateTable = {year=2020,month=12,day=17,hour=7,min=0,sec=0}
    return GetServerTime()<time(dateTable)
end

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

local function RewardContainer_OnShow()
    SpaUI:Log("RewardContainer_OnShow")
    if not ChallengesFrame or not SpaUIChallengesRewardContainer then
        if not ChallengesFrame then
            SpaUI:Log("RewardContainer_OnShow ChallengesFrame nil")
        else
            SpaUI:Log("RewardContainer_OnShow SpaUIChallengesRewardContainer nil")
        end
        return 
    end
    UpdateRewardButtonVisibility(true)

    local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    if keyStoneLevel then
        local rewardInfo
        for _,info in ipairs(REWARD_LEVELS) do
            if info.level == keyStoneLevel then  
                rewardInfo = info
                break
            end
        end
        if not rewardInfo then
            local last = REWARD_LEVELS[#REWARD_LEVELS]
            if keyStoneLevel > last.level then
                rewardInfo = last
            end
        end
        if rewardInfo then
            local isFirstWeek = IsFirstWeek()
            SpaUIChallengesRewardContainer.CurrentReward:SetText(("%d(%d)"):format(isFirstWeek and rewardInfo.firstWeek or rewardInfo.endofRunLevel,rewardInfo.weeklyLevel))
            SpaUIChallengesRewardContainer.CurrentDifficultyLevel:SetText(tostring(rewardInfo.level))
        end
    else
        SpaUIChallengesRewardContainer.CurrentReward:SetText("")
        SpaUIChallengesRewardContainer.CurrentDifficultyLevel:SetText("")
    end
end

local function CreateRewardFrames()
    if not ChallengesFrame then 
        SpaUI:Log("ChallengesFrame is nil")
        return
    end
    SpaUI:Log("CreateRewardFrames")

    ChallengesFrame.RewardButton = CreateFrame("Button","ChallengesFrameRewardButton",ChallengesFrame)
    ChallengesFrame.RewardButton:SetWidth(18)
    ChallengesFrame.RewardButton:SetHeight(18)
    ChallengesFrame.RewardButton:SetPoint("TOPRIGHT",PVEFrame.CloseButton,"BOTTOMRIGHT",-10,0)
    ChallengesFrame.RewardButton:SetNormalTexture(525134)
    ChallengesFrame.RewardButton:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
    ChallengesFrame.RewardButton:SetScript("OnClick",function() SpaUIChallengesRewardContainer:Show() end)
    ChallengesFrame.RewardButton:SetScript("OnEnter", function(self)
        ShowTooltip("OnEnter")
    end)
    ChallengesFrame.RewardButton:SetScript("OnLeave", function(self)
        ShowTooltip("OnLeave")
    end)
    ChallengesFrame.RewardButton:Hide()

    local RewardContainer = CreateFrame("Frame","SpaUIChallengesRewardContainer",ChallengesFrame,"SpaUIBasicFrameTemplate")
    RewardContainer:EnableMouse(false)
    RewardContainer:SetMovable(false)
    RewardContainer:SetWidth(200)
    RewardContainer:SetPoint("LEFT",ChallengesFrame,"RIGHT",0,0)
    RewardContainer:SetPoint("TOP",ChallengesFrame,"TOP",0,0)
    RewardContainer:SetPoint("BOTTOM",ChallengesFrame,"BOTTOM",0,2)

    RewardContainer.TitleText:SetText(L["key_stone_reward_title"])

    RewardContainer.DifficultyTextTitle = RewardContainer:CreateFontString(nil,nil,"GameFontNormal")
    RewardContainer.DifficultyTextTitle:SetText(L["key_stone_reward_title_difficulty"])
    RewardContainer.DifficultyTextTitle:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.DifficultyTextTitle:SetPoint("TOP",RewardContainer.LeftBorder,"TOP",0,-RewardItemMargin)
    RewardContainer.DifficultyTextTitle:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    RewardContainer.RewardTextTitle = RewardContainer:CreateFontString(nil,nil,"GameFontNormal")
    RewardContainer.RewardTextTitle:SetText(L["key_stone_reward_title_level"])
    RewardContainer.RewardTextTitle:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    RewardContainer.RewardTextTitle:SetPoint("TOP",RewardContainer.RightBorder,"TOP",0,-RewardItemMargin)
    RewardContainer.RewardTextTitle:SetPoint("LEFT",RewardContainer,"CENTER",0,0)

    local isFirstWeek = IsFirstWeek()
    for i = #REWARD_LEVELS, 1, -1 do
        local rewardInfo = REWARD_LEVELS[i]
        RewardContainer["DifficultyText"..i] = RewardContainer:CreateFontString(nil,nil,"GameFontHighlight")
        if i == #REWARD_LEVELS then
            RewardContainer["DifficultyText"..i]:SetPoint("TOP",RewardContainer.DifficultyTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            RewardContainer["DifficultyText"..i]:SetPoint("TOP",RewardContainer["DifficultyText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        RewardContainer["DifficultyText"..i]:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
        RewardContainer["DifficultyText"..i]:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)
        RewardContainer["DifficultyText"..i]:SetText(rewardInfo.level)
        
        RewardContainer["RewardText"..i] = RewardContainer:CreateFontString(nil,nil,"GameFontHighlight")
        if i == #REWARD_LEVELS then
            RewardContainer["RewardText"..i]:SetPoint("TOP",RewardContainer.RewardTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            RewardContainer["RewardText"..i]:SetPoint("TOP",RewardContainer["RewardText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        RewardContainer["RewardText"..i]:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
        RewardContainer["RewardText"..i]:SetPoint("LEFT",RewardContainer,"CENTER",0,0)
        RewardContainer["RewardText"..i]:SetText(("%d(%d)"):format(isFirstWeek and rewardInfo.firstWeek or rewardInfo.endofRunLevel,rewardInfo.weeklyLevel))
    end

    RewardContainer.CurrentDifficultyText = RewardContainer:CreateFontString(nil,nil,"GameFontGreen")
    RewardContainer.CurrentDifficultyText:SetText(L["key_stone_current_owned"])
    RewardContainer.CurrentDifficultyText:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.CurrentDifficultyText:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)

    RewardContainer.CurrentDifficultyLevel = RewardContainer:CreateFontString(nil,nil,"GameFontGreen")
    RewardContainer.CurrentDifficultyLevel:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    RewardContainer.CurrentDifficultyLevel:SetPoint("TOP",RewardContainer["DifficultyText1"],"BOTTOM",0,-RewardItemMargin)
    RewardContainer.CurrentDifficultyLevel:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    RewardContainer.CurrentReward = RewardContainer:CreateFontString(nil,nil,"GameFontGreen")
    RewardContainer.CurrentReward:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    RewardContainer.CurrentReward:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)
    RewardContainer.CurrentReward:SetPoint("LEFT",RewardContainer,"CENTER",0,0)

    RewardContainer:SetScript("OnShow",function() RewardContainer_OnShow() end)
    RewardContainer:SetScript("OnHide",function() UpdateRewardButtonVisibility(false) end)
end

local function OnChallengesFrameShow()
    if not SpaUIChallengesRewardContainer then
        CreateRewardFrames()
    end
end

local function OnBlizzardChallengesUIInitialize(event,name)
    if name == 'Blizzard_ChallengesUI' then
        SpaUI:Log("OnBlizzardChallengesUIInitialize")
        if ChallengesFrame then
            ChallengesFrame:HookScript("OnShow",OnChallengesFrameShow)
        end
        return true
    end
end

if IsAddOnLoaded('Blizzard_ChallengesUI') then
    SpaUI:Log("Blizzard_ChallengesUI Has Loaded,Create Rewardframes now!")
    CreateRewardFrames()
else
    SpaUI:RegisterEvent('ADDON_LOADED',OnBlizzardChallengesUIInitialize)
end


