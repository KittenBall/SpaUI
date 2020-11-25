local addonName, SpaUI = ...
-- 通用字符串
local LU = {}

LU["addon_loaded_tip"] = "%s|cFF00BFFF%s|r已载入"
LU["debug_format"] = "%sDebug:%s"
LU["message_format"] = "%s:%s"
-- config

-- AutoRepair
LU["auto_repair_guild_cost"] = "|cfff07100公会修理花费: %s|r"
LU["auto_repair_cost"] = "|cffead000修理花费: %s|r"
LU["auto_repair_no_money"] = "你没钱，穷逼！"
-- AutoSell
LU["auto_sell_detail"] = "%s卖出了%s"
LU["auto_sell_total"] = "共获得收入%s"
-- Tooltip
LU["tooltip_spell_id"] = "法术ID："
LU["tooltip_npc_id"] = "NPCID："
LU["tooltip_currency_id"] = "货币ID："
LU["tooltip_task_id"] = "任务ID："
-- MarkPosition
LU["mp_button_text"] = "定位"
LU["mp_cannot_mark"] = "当前地图无法标记！"
LU["mp_button_tooltip"] = "左键显示输入框，右键取消位置标记"
-- Reputation
LU["reputation_paragon"] = "巅峰x%d"
LU["reputation_paragon_no_history"] = "巅峰"
-- MinimapPing
LU["minimap_ping_who_group"] = "(%d队)%s"
-- UnitFrames
LU["uf_spell_source_prefix"] = "法术来源："
LU["uf_buff_source_prefix"] = "增益来源："
LU["uf_debuff_source_prefix"] = "减益来源："
-- KeystoneRewardLevel
LU["key_stone_reward_title"] = "史诗钥石奖励"
LU["key_stone_reward_title_difficulty"] = "层数"
LU["key_stone_reward_title_level"] = "奖励(低保)"
LU["key_stone_current_owned"] = "当前"
LU["key_stone_reward_tooltip"] = "显示史诗钥石奖励对照表"
-- ChatBar
LU["chat_bar_channel_say"] = "说"
LU["chat_bar_channel_yell"] = "喊"
LU["chat_bar_channel_party"] = "队"
LU["chat_bar_channel_raid"] = "团"
LU["chat_bar_channel_instance_chat"] = "副"
LU["chat_bar_channel_guild"] = "公"
LU["chat_bar_channel_world"] = "世"
LU["chat_bar_outside"] = "频道切换栏似乎在屏幕外面？"

-- 这里加入本地化
SpaUI.Localization = {}
local L = SpaUI.Localization
-- 占位

setmetatable(L, {
    __index = function(self, key)
        local value = LU[key]
        self[key] = value
        return value
    end
})
