-- 巅峰声望可见性优化，修改自ParagonReputation
local addonName, SpaUI = ...

local L = SpaUI.Localization

local function ReputationOnUpdate()
    local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
    local breakUpLargeNumbers = C_CVar.GetCVarBool("breakUpLargeNumbers")
    for i = 1, NUM_FACTIONS_DISPLAYED do
        local factionIndex = factionOffset + i
        local factionRow = _G["ReputationBar" .. i]
        local factionBar = _G["ReputationBar" .. i .. "ReputationBar"]
        local factionStanding = _G["ReputationBar" .. i ..
                                    "ReputationBarFactionStanding"]

        if factionIndex <= GetNumFactions() then
            local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID =
                GetFactionInfo(factionIndex)
            if factionID and C_Reputation.IsFactionParagon(factionID) then
                local currentValue, threshold, rewardQuestID, hasRewardPending =
                    C_Reputation.GetFactionParagonInfo(factionID)
                if currentValue then
                    local value = mod(currentValue, threshold)
                    factionRow.rolloverText =
                        HIGHLIGHT_FONT_COLOR_CODE ..
                            format(REPUTATION_PROGRESS_FORMAT,
                                   not breakUpLargeNumbers and value or
                                       BreakUpLargeNumbers(value),
                                   not breakUpLargeNumbers and threshold or
                                       BreakUpLargeNumbers(threshold)) ..
                            FONT_COLOR_CODE_CLOSE
                    factionBar:SetMinMaxValues(0, threshold)
                    factionBar:SetValue(value)
                    local count = floor(currentValue / threshold)
                    local paragon = count==0 and L["reputation_paragon_no_history"]:format(count) or L["reputation_paragon"]:format(count)
                    factionStanding:SetText(paragon)
                    factionRow.standingText = paragon
                end
            end
        end
    end
end

hooksecurefunc("ReputationFrame_Update", ReputationOnUpdate)
