-- 各种ID，修改自idTip

-- Tooltip添加id
local function addLine(tooltip, id, prefix)
    if not id or id == "" then return end
    id = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
    tooltip:AddLine("")
    tooltip:AddDoubleLine(prefix, id)
    tooltip:Show()
end

-- 法术ID
local SpellIDPrefix = "法术ID："

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
    local id = select(10, UnitBuff(...))
    addLine(self, id, SpellIDPrefix)
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...)
    local id = select(10, UnitDebuff(...))
    addLine(self, id, SpellIDPrefix)
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
    local id = select(10, UnitAura(...))
    addLine(self, id, SpellIDPrefix)
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    -- 天赋面板会出现两次，这里过滤掉，来自idTip
    local frame, text
    for i = 1, 15 do
        frame = _G[self:GetName() .. "TextLeft" .. i]
        if frame then text = frame:GetText() end
        if text and string.find(text, SpellIDPrefix) then return end
    end
    local id = select(2, self:GetSpell())
    addLine(self, id, SpellIDPrefix)
end)

-- NPC ID
local NpcIDPrefix = "NpcID："

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if C_PetBattles.IsInBattle() then return end
    local unit = select(2, self:GetUnit())
    if unit then
        local guid = UnitGUID(unit) or ""
        local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
        if id and guid:match("%a+") ~= "Player" then
            addLine(GameTooltip, id, NpcIDPrefix)
        end
    end
end)

-- 货币ID
local CurrencyIDPrefix = "货币ID："

hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
    local id = tonumber(string.match(C_CurrencyInfo.GetCurrencyListLink(index),
                                     "currency:(%d+)"))
    addLine(self, id, CurrencyIDPrefix)
end)

hooksecurefunc(GameTooltip, "SetCurrencyByID",
               function(self, id) addLine(self, id, CurrencyIDPrefix) end)

hooksecurefunc(GameTooltip, "SetCurrencyTokenByID",
               function(self, id) addLine(self, id, CurrencyIDPrefix) end)

-- 任务ID
local TaskIDPrefix = "任务ID"

hooksecurefunc("QuestMapLogTitleButton_OnEnter", function(self)
    local id = C_QuestLog.GetQuestIDForLogIndex(self.questLogIndex)
    addLine(GameTooltip, id, TaskIDPrefix)
end)

hooksecurefunc("TaskPOI_OnEnter", function(self)
    if self and self.questID then
        addLine(GameTooltip, self.questID, TaskIDPrefix)
    end
end)
