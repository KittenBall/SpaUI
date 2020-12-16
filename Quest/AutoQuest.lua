local addonName,SpaUI = ...
local L = SpaUI.Localization
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

-- 任务详情自动接受任务
-- todo 过滤某些npc的某些任务
local function OnQuestDetail(questStartItemID)
    local npc = UnitName("npc")
    if QuestFrame and QuestFrame:IsVisible() and npc then
        AcceptQuest()
    end
end

-- 任务列表
-- 先自动完成可完成的任务，再接受未接受的任务
local function OnQuestGreeting()
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
    if not (GetNumQuestChoices() > 1) and QuestFrame:IsVisible() then
        GetQuestReward(1)
    end
end

local function OnQuestProgress()
    if QuestFrame:IsVisible() and IsQuestCompletable() then
        CompleteQuest()
    end
end

local function OnGossipShow()
    local activeNum = GossipGetNumActiveQuests()
    local availableNum = GossipGetNumAvailableQuests()
    if activeNum > 0  then
        local activeQuests = GetActiveQuests()
        for i = 1, activeNum do
            local quest = activeQuests[i]
            if quest and quest.isComplete and GossipFramemmm:IsVisible() then
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
    local func = AutoQuestSwitchTable[event]
    if func then
        func(...)
    end
end

SpaUI:RegisterEvent('QUEST_ACCEPTED',AutoQuest)
SpaUI:RegisterEvent('QUEST_AUTOCOMPLETE',AutoQuest)
SpaUI:RegisterEvent('QUEST_COMPLETE',AutoQuest)
SpaUI:RegisterEvent('QUEST_DETAIL',AutoQuest)
SpaUI:RegisterEvent('QUEST_LOG_CRITERIA_UPDATE',AutoQuest)
-- SpaUI:RegisterEvent('QUEST_LOG_UPDATE',test)
SpaUI:RegisterEvent('QUEST_POI_UPDATE',AutoQuest)
SpaUI:RegisterEvent('QUEST_REMOVED',AutoQuest)
SpaUI:RegisterEvent('QUEST_TURNED_IN',AutoQuest)
-- SpaUI:RegisterEvent('QUEST_WATCH_LIST_CHANGED',test)
SpaUI:RegisterEvent('QUEST_WATCH_UPDATE',AutoQuest)
-- SpaUI:RegisterEvent('QUESTLINE_UPDATE',test)
SpaUI:RegisterEvent('TASK_PROGRESS_UPDATE',AutoQuest)
-- SpaUI:RegisterEvent('TREASURE_PICKER_CACHE_FLUSH',test)
-- SpaUI:RegisterEvent('WAYPOINT_UPDATE',test)
SpaUI:RegisterEvent('WORLD_QUEST_COMPLETED_BY_SPELL',AutoQuest)
SpaUI:RegisterEvent('QUEST_ACCEPT_CONFIRM',AutoQuest)
SpaUI:RegisterEvent('QUEST_FINISHED',AutoQuest)
SpaUI:RegisterEvent('QUEST_GREETING',AutoQuest)
SpaUI:RegisterEvent('QUEST_ITEM_UPDATE',AutoQuest)
SpaUI:RegisterEvent('QUEST_PROGRESS',AutoQuest)
SpaUI:RegisterEvent('DYNAMIC_GOSSIP_POI_UPDATED',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_CLOSED',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_CONFIRM',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_CONFIRM_CANCEL',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_ENTER_CODE',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_OPTIONS_REFRESHED',AutoQuest)
SpaUI:RegisterEvent('GOSSIP_SHOW',AutoQuest)

-- 创建自动交接按钮
local function CreateAutoTurnInButton()
    local AutoTurnInButton = CreateFrame('CheckButton','SpaUIAutoTurnInButton',ObjectiveTrackerFrame.HeaderMenu)
    AutoTurnInButton:SetSize(18,18)
    AutoTurnInButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
    AutoTurnInButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
    AutoTurnInButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight","ADD")
    AutoTurnInButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    AutoTurnInButton:SetPoint("LEFT",ObjectiveTrackerFrame.HeaderMenu.MinimizeButton,"RIGHT",3,0)
    Widget.AutoTurnInButton = AutoTurnInButton
end

local function OnObjectiveTrackerLoaded(event,name)
    if name ~= "Blizzard_ObjectiveTracker" then
       return
    end
    if ObjectiveTrackerFrame and ObjectiveTrackerFrame.HeaderMenu then
        CreateAutoTurnInButton()
    end
    return true
end

if IsAddOnLoaded('Blizzard_ObjectiveTracker') then
    OnObjectiveTrackerLoaded('ADDON_LOADED','Blizzard_ObjectiveTracker')
else
    SpaUI:CallbackOnce('ADDON_LOADED',OnObjectiveTrackerLoaded)
end
