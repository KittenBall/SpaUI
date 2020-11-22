local addonName, SpaUI = ...
-- 通用字符串
local Localization_Universal = {}

Localization_Universal["addon_loaded_tip"] = "%s|cFF00BFFF%s|r已载入"

--config
Localization_Universal["config_spaui_button"] = "SpaUI"
-- autoRepair
Localization_Universal["auto_repair_guild_cost"] =
    "|cfff07100公会修理花费: %s|r"
Localization_Universal["auto_repair_cost"] = "|cffead000修理花费: %s|r"
Localization_Universal["auto_repair_no_money"] = "你没钱，穷逼！"
-- autoSell
Localization_Universal["auto_sell_detail"] = "%s卖出了%s"
Localization_Universal["auto_sell_total"] = "共获得收入%s"
-- ids
Localization_Universal["tooltip_spell_id"] = "法术ID："
Localization_Universal["tooltip_npc_id"] = "NPCID："
Localization_Universal["tooltip_currency_id"] = "货币ID："
Localization_Universal["tooltip_task_id"] = "任务ID："
-- markPosition
Localization_Universal["mp_button_text"] = "定位"
Localization_Universal["mp_cannot_mark"] = "当前地图无法标记！"
Localization_Universal["mp_button_tooltip"] = "左键显示输入框，右键取消位置标记"
-- reputation
Localization_Universal["reputation_paragon"]= "巅峰x%d"
Localization_Universal["reputation_paragon_no_history"] = "巅峰"
-- minimapPing
Localization_Universal["minimap_ping_who_group"] = "(%d队)%s"
-- unitFrames
Localization_Universal["uf_spell_source_prefix"] = "法术来源："
Localization_Universal["uf_buff_source_prefix"] = "增益来源："
Localization_Universal["uf_debuff_source_prefix"] = "减益来源："

-- 这里加入本地化
SpaUI.Localization = {}
local L = SpaUI.Localization
-- 占位

setmetatable(L, {
    __index = function(self, key)
        local value = Localization_Universal[key]
        self[key] = value
        return value
    end
})
