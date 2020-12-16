local addonName,SpaUI = ...
local L = SpaUI.Localization
local LocalEvents = SpaUI.LocalEvents
local IsShiftKeyDown,UnitName = IsShiftKeyDown,UnitName
local GetNumActiveQuests,GetNumAvailableQuests = GetNumActiveQuests,GetNumAvailableQuests
local GossipGetNumActiveQuests,GossipGetNumAvailableQuests = C_GossipInfo.GetNumActiveQuests,C_GossipInfo.GetNumAvailableQuests
local GetActiveQuests,GetAvailableQuests = C_GossipInfo.GetActiveQuests,C_GossipInfo.GetAvailableQuests
local GossipSelectActiveQuest,GossipSelectAvailableQuest = C_GossipInfo.SelectActiveQuest,C_GossipInfo.SelectAvailableQuest
local GetActiveTitle,SelectActiveQuest,SelectAvailableQuest = GetActiveTitle,SelectActiveQuest,SelectAvailableQuest
local GetNumQuestChoices,GetQuestReward,CompleteQuest = GetNumQuestChoices,GetQuestReward,CompleteQuest
local QuestFrame = QuestFrame
local IsQuestCompletable = IsQuestCompletable
local Widget = SpaUI.Widget

-- 是否为自动交接模式
local function IsAutoTurnIn()
    return SpaUIConfigDBPC.AutoTurnIn and not IsShiftKeyDown()
end

-- 任务详情自动接受任务
-- todo 过滤某些npc的某些任务
local function OnQuestDetail(questStartItemID)
    if not IsAutoTurnIn() then return end
    local npc = UnitName("npc")
    if QuestFrame and QuestFrame:IsVisible() and npc then
        AcceptQuest()
    end
end

-- 任务列表
-- 先自动完成可完成的任务，再接受未接受的任务
local function OnQuestGreeting()
    if not IsAutoTurnIn() then return end
    local activeNum = GetNumActiveQuests()
    local availableNum = GetNumAvailableQuests()
    
    for i = 1, activeNum do
       local title,isComplete =  GetActiveTitle(i)
       if isComplete and QuestFrame:IsVisible() then
            SpaUI:Log("自动选择可完成任务："..title)
            SelectActiveQuest(i)
            break
       end
    end

    for i = 1, availableNum do
        --todo 过滤某些任务
        SelectAvailableQuest(i)
    end
end

-- 任务完成页
local function OnQuestComplete()
    if not IsAutoTurnIn() then return end
    if not (GetNumQuestChoices() > 1) and QuestFrame:IsVisible() then
        GetQuestReward(1)
    end
end

local function OnQuestProgress()
    if not IsAutoTurnIn() then return end
    if QuestFrame:IsVisible() and IsQuestCompletable() then
        CompleteQuest()
    end
end

local function OnGossipShow()
    if not IsAutoTurnIn() then return end
    local activeNum = GossipGetNumActiveQuests()
    local availableNum = GossipGetNumAvailableQuests()
    if activeNum > 0  then
        local activeQuests = GetActiveQuests()
        for i = 1, activeNum do
            local quest = activeQuests[i]
            if quest and quest.isComplete and GossipFrame:IsVisible() then
                SpaUI:Log("自动选择可完成任务："..quest.title)
                GossipSelectActiveQuest(i)
                break
            end
         end
    end

    if availableNum > 0 then
        for i = 1,availableNum do
            GossipSelectAvailableQuest(i)
        end
    end
end

local AutoQuestSwitchTable = {
    ['QUEST_DETAIL'] = OnQuestDetail,
    ['QUEST_GREETING'] = OnQuestGreeting,
    ['QUEST_COMPLETE'] = OnQuestComplete,
    ['QUEST_PROGRESS'] = OnQuestProgress,
    ['GOSSIP_SHOW'] = OnGossipShow
}

local function AutoQuest(event,...)
    SpaUI:Log(event,...)
    if not IsAutoTurnIn() then return end
    local func = AutoQuestSwitchTable[event]
    if func then
        func(...)
    end
end

-- 开启或关闭自动交接任务
local function ToggleAutoTurnIn(open)
    SpaUIConfigDBPC.AutoTurnIn = open
    if open then
        SpaUI:RegisterEvent('QUEST_DETAIL',AutoQuest)
        SpaUI:RegisterEvent('QUEST_GREETING',AutoQuest)
        SpaUI:RegisterEvent('QUEST_COMPLETE',AutoQuest)
        SpaUI:RegisterEvent('QUEST_PROGRESS',AutoQuest)
        SpaUI:RegisterEvent('GOSSIP_SHOW',AutoQuest)
    else
        SpaUI:UnregisterEvent('QUEST_DETAIL',AutoQuest)
        SpaUI:UnregisterEvent('QUEST_GREETING',AutoQuest)
        SpaUI:UnregisterEvent('QUEST_COMPLETE',AutoQuest)
        SpaUI:UnregisterEvent('QUEST_PROGRESS',AutoQuest)
        SpaUI:UnregisterEvent('GOSSIP_SHOW',AutoQuest)
    end
end

-- 自动交接开关点击事件
local function OnAutoTurnInButtonClick(self)
    PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    ToggleAutoTurnIn(self:GetChecked())
end

-- 创建自动交接按钮
local function CreateAutoTurnInButton()
    local AutoTurnInButton = CreateFrame('CheckButton','SpaUIAutoTurnInButton',ObjectiveTrackerFrame.HeaderMenu)
    AutoTurnInButton:SetSize(18,18)
    AutoTurnInButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
    AutoTurnInButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
    AutoTurnInButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight","ADD")
    AutoTurnInButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    AutoTurnInButton:SetPoint("LEFT",ObjectiveTrackerFrame.HeaderMenu.MinimizeButton,"RIGHT",3,0)
    AutoTurnInButton:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_TOP")
        GameTooltip:AddLine(L['auto_quest_turnin_button_tooltip'])
        GameTooltip:Show()
    end)
    AutoTurnInButton:SetScript("OnLeave",function(self)
        GameTooltip:Hide()
    end)
    AutoTurnInButton:SetScript("OnClick",OnAutoTurnInButtonClick)

    Widget.AutoTurnInButton = AutoTurnInButton

    AutoTurnInButton:SetChecked(SpaUIConfigDBPC.AutoTurnIn or false)
end

local function OnInitialzation()
    CreateAutoTurnInButton()
    ToggleAutoTurnIn(SpaUIConfigDBPC.AutoTurnIn)
end

SpaUI:CallbackLocalEventOnce(LocalEvents.ADDON_INITIALIZATION,OnInitialzation)
