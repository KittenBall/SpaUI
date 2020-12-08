local addonName,SpaUI = ...
local L = SpaUI.Localization
local GetNumSavedInstances,GetSavedInstanceInfo = GetNumSavedInstances,GetSavedInstanceInfo
-- 地下城手册显示副本进度

local IconIndexByDifficulty = {
    [1] = 11, -- 普通地下城
    [2] = 3, -- 英雄地下城
    [3] = 11, -- 10人普通难度
    [4] = 11, -- 25人普通难度
    [5] = 3, -- 10人英雄难度
    [6] = 3, -- 25人英雄难度
    [7] = 4, -- 随机难度(SoO)
    [9] = 11, -- 40人难度
    [14] = 11, -- 普通难度
    [15] = 3, -- 英雄难度
    [16] = 12, -- 史诗难度
    [17] = 4, -- 随机团
    [23] = 12, -- 史诗地下城
    [24] = 13, -- 时光漫游地下城
    [33] = 13, --时光漫游团本
}

-- 根据难度id获取icon位置
local function IconIndexForDifficultyID(difficultyID)
    return IconIndexByDifficulty[difficultyID]
end

-- 地下城手册显示的时候存下所有击杀进度
local function OnEncounterJournalShow(self)
    if not self.SpaUISavedInstances then
        self.SpaUISavedInstances = {}
    end
    local SpaUISavedInstances = self.SpaUISavedInstances
    local savedInstancesNum = GetNumSavedInstances()
    for i=1,savedInstancesNum do
        local name,_,_,difficultyID,locked,_,_,isRaid,_,_,numEncounters,encounterProgress = GetSavedInstanceInfo(i)
        if locked then
            local savedInstance = {}
            savedInstance.isRaid = isRaid
            savedInstance.numEncounters = numEncounters
            savedInstance.encounterProgress = encounterProgress
            if not SpaUISavedInstances[name] then
               SpaUISavedInstances[name] = {}
            end
            SpaUISavedInstances[name][difficultyID] = savedInstance
        else
            -- 不锁定的时候清除对应副本信息
            -- 这一步在CD重置的时候很有用.
            if SpaUISavedInstances[name] then
               SpaUISavedInstances[name][difficultyID] = nil
            end
        end
    end
end

-- 在副本按钮上显示或隐藏进度
-- 未完工
local function ShowOrHideSavedInstanceForInstanceButton(button,difficultyID,savedInstance)
    if not button.savedInstanceButtons then
        button.savedInstanceButtons = {}
    end
    if not button.savedInstanceButtons[difficultyID] then
        local iconIndex = IconIndexForDifficultyID(difficultyID)
        if iconIndex then
            local savedInstanceButton = CreateFrame("Button",button:GetName().."SavedInstanceButtonDifficulty"..difficultyID,button,"EncounterJournalSavedInstanceButton")
            EncounterJournal_SetFlagIcon(savedInstanceButton.Icon,iconIndex)
            savedInstanceButton:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,3)
            button.savedInstanceButtons[difficultyID] = savedInstanceButton
        end
    end
    local savedInstanceButton = button.savedInstanceButtons[difficultyID]
    savedInstanceButton.Text:SetText(savedInstance.encounterProgress.."/"..savedInstance.numEncounters)
end

-- 副本列表显示时回调
local function OnEncounterJournalListInstances()
    if not EncounterJournal.SpaUISavedInstances  then
        return
    end

    local SpaUISavedInstances = EncounterJournal.SpaUISavedInstances

    local scrollFrame = EncounterJournal.instanceSelect.scroll.child
    local index = 1
    while true do
        local instanceButton = scrollFrame["instance"..index];
        if not instanceButton or not instanceButton:IsShown() then
            break
        end
        local instanceTitle = instanceButton.tooltipTitle
        
        if SpaUISavedInstances[instanceTitle] then
            for difficultyID,savedInstance in pairs(SpaUISavedInstances[instanceTitle]) do
                ShowOrHideSavedInstanceForInstanceButton(instanceButton,difficultyID,savedInstance)
            end            
        end

        index = index + 1
    end
end

-- 地下城手册加载
local function OnEncounterJournalLoaded(event,name)
    if name ~= 'Blizzard_EncounterJournal' then return end
    if not EncounterJournal then 
        SpaUI:Log(L['ej_loaded_fail'])
    return end

    hooksecurefunc("EncounterJournal_ListInstances",OnEncounterJournalListInstances)
    EncounterJournal:HookScript("OnShow",OnEncounterJournalShow)
    return true
end

SpaUI:RegisterEvent('ADDON_LOADED',OnEncounterJournalLoaded)
