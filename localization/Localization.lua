local addonName, SpaUI = ...
-- 通用字符串
local LU = {}

LU["addon_name"] = "|cFF00FFFFS|r|cFFFFC0CBp|r|cFFFF6347a|rUI"
LU["addon_loaded_tip"] = LU["addon_name"]..":|cFF00BFFF%s|r 已载入"
LU["debug_format"] = LU["addon_name"].." Debug:%s"
LU["message_format"] = LU["addon_name"]..":%s"
-- config
LU["config_addon_version"] = "|cFF00BFFF%s|r"
LU["config_addon_author"] = "作者：|cFFADD8E6%s|r"
-- AutoRepair
LU["auto_repair_guild_cost"] = "|cfff07100你本次修理消耗公会资金: %s|r"
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
LU["chat_bar_channel_world_donot_join"] = "你还没有加入大脚世界频道"
LU["chat_bar_emote_table"] = "聊天表情"
-- ChatEmote
LU["chat_emote_rt1"] = "{rt1}"
LU["chat_emote_rt2"] = "{rt2}"
LU["chat_emote_rt3"] = "{rt3}"
LU["chat_emote_rt4"] = "{rt4}"
LU["chat_emote_rt5"] = "{rt5}"
LU["chat_emote_rt6"] = "{rt6}"
LU["chat_emote_rt7"] = "{rt7}"
LU["chat_emote_rt8"] = "{rt8}"
LU["chat_emote_angle"] = "{天使}"
LU["chat_emote_angry"] = "{生气}"
LU["chat_emote_laugh"] = "{大笑}"
LU["chat_emote_applause"] = "{鼓掌}"
LU["chat_emote_cool"] = "{酷}"
LU["chat_emote_cry"] = "{哭}"
LU["chat_emote_lovely"] = "{可爱}"
LU["chat_emote_despise"] = "{鄙视}"
LU["chat_emote_dream"] = "{美梦}"
LU["chat_emote_embarrassed"] = "{尴尬}"
LU["chat_emote_evil"] = "{邪恶}"
LU["chat_emote_excited"] = "{兴奋}"
LU["chat_emote_dizzy"] = "{晕}"
LU["chat_emote_fight"] = "{打架}"
LU["chat_emote_influenza"] = "{流感}"
LU["chat_emote_stay"] = "{呆}"
LU["chat_emote_frown"] = "{皱眉}"
LU["chat_emote_salute"] = "{致敬}"
LU["chat_emote_grimace"] = "{鬼脸}"
LU["chat_emote_barking_teeth"] = "{龇牙}"
LU["chat_emote_happy"] = "{开心}"
LU["chat_emote_heart"] = "{心}"
LU["chat_emote_fear"] = "{恐惧}"
LU["chat_emote_sick"] = "{生病}"
LU["chat_emote_innocent"] = "{无辜}"
LU["chat_emote_kung_fu"] = "{功夫}"
LU["chat_emote_anthomaniac"] = "{花痴}"
LU["chat_emote_mail"] = "{邮件}"
LU["chat_emote_makeup"] = "{化妆}"
LU["chat_emote_mario"] = "{马里奥}"
LU["chat_emote_meditation"] = "{沉思}"
LU["chat_emote_poor"] = "{可怜}"
LU["chat_emote_good"] = "{好}"
LU["chat_emote_beautiful"] = "{漂亮}"
LU["chat_emote_spit"] = "{吐}"
LU["chat_emote_shake_hands"] = "{握手}"
LU["chat_emote_yell"] = "{喊}"
LU["chat_emote_shut_up"] = "{闭嘴}"
LU["chat_emote_shy"] = "{害羞}"
LU["chat_emote_sleep"] = "{睡觉}"
LU["chat_emote_smile"] = "{微笑}"
LU["chat_emote_surprised"] = "{吃惊}"
LU["chat_emote_failure"] = "{失败}"
LU["chat_emote_sweat"] = "{流汗}"
LU["chat_emote_tears"] = "{流泪}"
LU["chat_emote_tragedy"] = "{悲剧}"
LU["chat_emote_thinking"] = "{想}"
LU["chat_emote_snicker"] = "{偷笑}"
LU["chat_emote_wretched"] = "{猥琐}"
LU["chat_emote_victory"] = "{胜利}"
LU["chat_emote_lei_feng"] = "{雷锋}"
LU["chat_emote_injustice"] = "{委屈}"

SpaUI.Localization = {}

setmetatable(SpaUI.Localization, {
    __index = function(self, key)
        local value = LU[key]
        self[key] = value
        return value
    end
})
