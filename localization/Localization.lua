local addonName, SpaUI = ...

local L = {}

L["addon_name"] = "|cFF00FFFFS|r|cFFFFC0CBp|r|cFFFF6347a|rUI"
L["addon_loaded_tip"] = L["addon_name"]..":|cFF00BFFF%s|r 已载入"
L["debug_format"] = L["addon_name"].." Debug:%s"
L["message_format"] = L["addon_name"]..":%s"
-- Config
L["config_addon_version"] = "|cFF00BFFF%s|r"
L["config_addon_author"] = "作者：|cFFADD8E6%s|r"
L["config_addon_introduct"] = [[
|cFF00FFFFS|r|cFFFFC0CBp|r|cFFFF6347a|rUI只对暴雪原生界面进行了功能增强，几乎没有任何"美化"，未来也不会考虑
    ]]
L["config_macro"] = [[
以下为常用的宏命令：

    |cFF00BFFF/rl|r 重载界面
    |cFF00BFFF/spa|r 打开此面板
    |cFF00BFFF/spa align|r 显示或隐藏网格线
]]
L["config_id_tip"] = "鼠标提示显示ID"
L["config_id_tip_tooltip"] = "在鼠标提示内显示任务ID，法术ID，货币ID，NPCID等"
L["config_debug"] = "调试模式"
L["config_debug_tooltip"] = "作者用，勾选后会看见很多对用户没意义的信息，正常情况下你不应该看到该选项"
-- AutoRepair
L["auto_repair_guild_cost"] = "|cfff07100你本次修理消耗公会资金: %s|r"
L["auto_repair_cost"] = "|cffead000修理花费: %s|r"
L["auto_repair_no_money"] = "你没钱，穷逼！"
-- AutoSell
L["auto_sell_detail"] = "%s卖出了%s"
L["auto_sell_total"] = "共获得收入%s"
-- Tooltip
L["tooltip_spell_id"] = "法术ID："
L["tooltip_npc_id"] = "NPCID："
L["tooltip_currency_id"] = "货币ID："
L["tooltip_task_id"] = "任务ID："
L["tooltip_item_id"] = "物品ID："
-- MarkPosition
L["mp_button_text"] = "定位"
L["mp_cannot_mark"] = "当前地图无法标记！"
L["mp_button_tooltip"] = "左键显示输入框，右键取消位置标记"
-- Reputation
L["reputation_paragon"] = "巅峰x%d"
L["reputation_paragon_no_history"] = "巅峰"
-- MinimapPing
L["minimap_ping_who_group"] = "(%d队)%s"
-- FriendsList
L["friends_list_area"] = "|cFF7FFF00%s|r"
-- UnitFrames
L["uf_spell_source_prefix"] = "法术来源："
L["uf_buff_source_prefix"] = "增益来源："
L["uf_debuff_source_prefix"] = "减益来源："
-- KeystoneRewardLevel
L["key_stone_reward_title"] = "史诗钥石奖励"
L["key_stone_reward_title_difficulty"] = "层数"
L["key_stone_reward_title_level"] = "奖励(低保)"
L["key_stone_current_owned"] = "当前"
L["key_stone_reward_tooltip"] = "显示史诗钥石奖励对照表"
-- ChatBar
L["chat_bar_channel_say"] = "说"
L["chat_bar_channel_yell"] = "喊"
L["chat_bar_channel_party"] = "队"
L["chat_bar_channel_raid"] = "团"
L["chat_bar_channel_instance_chat"] = "副"
L["chat_bar_channel_guild"] = "公"
L["chat_bar_channel_world"] = "世"
L["chat_bar_outside"] = "频道切换栏似乎在屏幕外面？"
L["chat_bar_emote_table"] = "聊天表情"
L["chat_bar_world_channel_tooltip_join"] = "点击加入大脚世界频道"
L["chat_bar_world_channel_tooltip_leave"] = "右键点击离开大脚世界频道"
L["chat_bar_world_channel_join_confirm"] = "确定加入\"大脚世界频道\"吗？"
-- ChatEmote
L["chat_emote_rt1"] = "{rt1}"
L["chat_emote_rt2"] = "{rt2}"
L["chat_emote_rt3"] = "{rt3}"
L["chat_emote_rt4"] = "{rt4}"
L["chat_emote_rt5"] = "{rt5}"
L["chat_emote_rt6"] = "{rt6}"
L["chat_emote_rt7"] = "{rt7}"
L["chat_emote_rt8"] = "{rt8}"
L["chat_emote_angle"] = "{天使}"
L["chat_emote_angry"] = "{生气}"
L["chat_emote_laugh"] = "{大笑}"
L["chat_emote_applause"] = "{鼓掌}"
L["chat_emote_cool"] = "{酷}"
L["chat_emote_cry"] = "{哭}"
L["chat_emote_lovely"] = "{可爱}"
L["chat_emote_despise"] = "{鄙视}"
L["chat_emote_dream"] = "{美梦}"
L["chat_emote_embarrassed"] = "{尴尬}"
L["chat_emote_evil"] = "{邪恶}"
L["chat_emote_excited"] = "{兴奋}"
L["chat_emote_dizzy"] = "{晕}"
L["chat_emote_fight"] = "{打架}"
L["chat_emote_influenza"] = "{流感}"
L["chat_emote_stay"] = "{呆}"
L["chat_emote_frown"] = "{皱眉}"
L["chat_emote_salute"] = "{致敬}"
L["chat_emote_grimace"] = "{鬼脸}"
L["chat_emote_barking_teeth"] = "{龇牙}"
L["chat_emote_happy"] = "{开心}"
L["chat_emote_heart"] = "{心}"
L["chat_emote_fear"] = "{恐惧}"
L["chat_emote_sick"] = "{生病}"
L["chat_emote_innocent"] = "{无辜}"
L["chat_emote_kung_fu"] = "{功夫}"
L["chat_emote_anthomaniac"] = "{花痴}"
L["chat_emote_mail"] = "{邮件}"
L["chat_emote_makeup"] = "{化妆}"
L["chat_emote_mario"] = "{马里奥}"
L["chat_emote_meditation"] = "{沉思}"
L["chat_emote_poor"] = "{可怜}"
L["chat_emote_good"] = "{好}"
L["chat_emote_beautiful"] = "{漂亮}"
L["chat_emote_spit"] = "{吐}"
L["chat_emote_shake_hands"] = "{握手}"
L["chat_emote_yell"] = "{喊}"
L["chat_emote_shut_up"] = "{闭嘴}"
L["chat_emote_shy"] = "{害羞}"
L["chat_emote_sleep"] = "{睡觉}"
L["chat_emote_smile"] = "{微笑}"
L["chat_emote_surprised"] = "{吃惊}"
L["chat_emote_failure"] = "{失败}"
L["chat_emote_sweat"] = "{流汗}"
L["chat_emote_tears"] = "{流泪}"
L["chat_emote_tragedy"] = "{悲剧}"
L["chat_emote_thinking"] = "{想}"
L["chat_emote_snicker"] = "{偷笑}"
L["chat_emote_wretched"] = "{猥琐}"
L["chat_emote_victory"] = "{胜利}"
L["chat_emote_lei_feng"] = "{雷锋}"
L["chat_emote_injustice"] = "{委屈}"
-- ChatCopy
L["chat_copy_dialog_title"] = "聊天复制"

SpaUI.Localization = L
