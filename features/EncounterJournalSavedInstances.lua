-- 地下城手册显示副本进度
local addonName,SpaUI = ...
local L = SpaUI.Localization
local GetNumSavedInstances,GetSavedInstanceInfo,GetSavedInstanceEncounterInfo = GetNumSavedInstances,GetSavedInstanceInfo,GetSavedInstanceEncounterInfo
local COMPLETED_COLOR = "FFFF0000"
local UNCOMPLETED_COLOR = "FF00FF00"

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
        local name,_,_,difficultyID,locked,_,_,isRaid,_,difficultyName,numEncounters,encounterProgress = GetSavedInstanceInfo(i)
        if locked then
            local savedInstance = {}
            savedInstance.isRaid = isRaid
            savedInstance.numEncounters = numEncounters
            savedInstance.encounterProgress = encounterProgress
            savedInstance.difficultyName = difficultyName
            -- 存入副本的BOSS击杀信息
            for j=1,numEncounters do
                local bossName,_,isKilled = GetSavedInstanceEncounterInfo(i,j)
                savedInstance[j] = {}
                savedInstance[j].bossName = bossName
                savedInstance[j].isKilled = isKilled
            end
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

-- 副本进度窗体鼠标指向显示Boss击杀信息
local function OnSaveInstanceFrameEnter(self)
    if not self.info then return end
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine(self.info.difficultyName)
    for _,bossInfo in ipairs(self.info) do
        GameTooltip:AddDoubleLine(bossInfo.bossName,bossInfo.isKilled and L["ej_savedinstance_boss_killed"] or L["ej_savedinstance_boss_not_killed"])
    end
    GameTooltip:Show()
end

-- 在副本按钮上显示或隐藏进度
local function ShowOrHideSavedInstanceForInstanceButton(button,savedInstances)
    if not button.savedInstanceFrames then
        button.savedInstanceFrames = {}
    end
    local offsetY = 0
    if savedInstances then
        -- 显示需要显示的难度
        for difficultyID,savedInstance in pairs(savedInstances) do
            if not button.savedInstanceFrames[difficultyID] then
                local iconIndex = IconIndexForDifficultyID(difficultyID)
                if iconIndex then
                    -- 创建frame并设置难度图标
                    local savedInstanceFrame = CreateFrame("Frame",button:GetName().."SavedInstanceFrameDifficulty"..difficultyID,button,"EncounterJournalSavedInstanceFrame")
                    EncounterJournal_SetFlagIcon(savedInstanceFrame.Icon,iconIndex)
                    savedInstanceFrame:SetScript("OnLeave",function()
                        GameTooltip:Hide()
                    end)
                    button.savedInstanceFrames[difficultyID] = savedInstanceFrame
                end
            end
            
            local savedInstanceFrame = button.savedInstanceFrames[difficultyID]
            local encounterProgress,numEncounters = savedInstance.encounterProgress,savedInstance.numEncounters
            local color = (encounterProgress<numEncounters) and UNCOMPLETED_COLOR or COMPLETED_COLOR
            savedInstanceFrame.info = savedInstance
            savedInstanceFrame.Text:SetText(L["ej_savedinstance_progress"]:format(color,encounterProgress,numEncounters))
            savedInstanceFrame:ClearAllPoints()
            savedInstanceFrame:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,offsetY)
            savedInstanceFrame:SetScript("OnEnter",OnSaveInstanceFrameEnter)
            savedInstanceFrame:Show()
            offsetY = offsetY + savedInstanceFrame:GetHeight()
        end
        -- 将不需要显示的难度隐藏
        for difficultyID,frame in pairs(button.savedInstanceFrames) do
            if not savedInstances[difficultyID] then
                frame:Hide()
            end
        end
    else
        for _,frame in pairs(button.savedInstanceFrames) do
            frame:Hide() 
        end
    end
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
            ShowOrHideSavedInstanceForInstanceButton(instanceButton,SpaUISavedInstances[instanceTitle])
        else
            ShowOrHideSavedInstanceForInstanceButton(instanceButton)
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
