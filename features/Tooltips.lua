-- 各种ID，修改自idTip
local addonName, SpaUI = ...

local L = SpaUI.Localization

-- Tooltip添加id
local function addLine(tooltip, id, prefix)
    if not id or id == "" then return end
    if tooltip == GameTooltip and not IsAltKeyDown() then
        return
    end
    id = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
    tooltip:AddLine("")
    tooltip:AddDoubleLine(prefix, id)
    tooltip:Show()
end

-- 法术ID
local SpellIDPrefix = L["tooltip_spell_id"]

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
local NpcIDPrefix = L["tooltip_npc_id"]

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
local CurrencyIDPrefix = L["tooltip_currency_id"]

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
local TaskIDPrefix = L["tooltip_task_id"]

hooksecurefunc("QuestMapLogTitleButton_OnEnter", function(self)
    local id = C_QuestLog.GetQuestIDForLogIndex(self.questLogIndex)
    addLine(GameTooltip, id, TaskIDPrefix)
end)

hooksecurefunc("TaskPOI_OnEnter", function(self)
    if self and self.questID then
        addLine(GameTooltip, self.questID, TaskIDPrefix)
    end
end)


-- 物品id

local ItemIDPrefix = L["tooltip_item_id"]

hooksecurefunc(GameTooltip, "SetToyByItemID", function(self, id)
    addLine(self, id, ItemIDPrefix)
  end)

local function attachItemTooltip(self)
    local link = select(2, self:GetItem())
    if not link then return end
    local itemString = string.match(link, "item:([%-?%d:]+)")
    if not itemString then return end

    local id = string.match(link, "item:(%d*)")
    if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
        local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
        for i = 1, 8 do
            if GetMouseFocus().reagentIndex == i then
                id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d*)") or nil
                break
            end
        end
    end

    if id then
        addLine(self, id, ItemIDPrefix)
    end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
