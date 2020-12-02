-- 聊天表情 修改自SimpleChat
local addonName, SpaUI = ...

local L = SpaUI.Localization
local Widget = SpaUI.Widget

local EMOTE_SIZE = 25
local EMOTE_SIZE_MARGIN = 6
local EMOTE_RAW_SIZE = 8
local ALPHA_PRESS = 0.6
local ALPHA_NORMAL = 1

local emotes = {
    -- 原版暴雪提供的8个图标
    {L["chat_emote_rt1"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
    {L["chat_emote_rt2"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
    {L["chat_emote_rt3"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
    {L["chat_emote_rt4"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
    {L["chat_emote_rt5"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
    {L["chat_emote_rt6"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
    {L["chat_emote_rt7"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
    {L["chat_emote_rt8"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
    -- 自定义表情
    {L["chat_emote_angle"], [=[Interface\Addons\SpaUI\chat\emojis\Angel]=]},
    {L["chat_emote_angry"], [=[Interface\Addons\SpaUI\chat\emojis\Angry]=]},
    {L["chat_emote_laugh"], [=[Interface\Addons\SpaUI\chat\emojis\Biglaugh]=]},
    {L["chat_emote_applause"], [=[Interface\Addons\SpaUI\chat\emojis\Clap]=]},
    {L["chat_emote_cool"], [=[Interface\Addons\SpaUI\chat\emojis\Cool]=]},
    {L["chat_emote_cry"], [=[Interface\Addons\SpaUI\chat\emojis\Cry]=]},
    {L["chat_emote_lovely"], [=[Interface\Addons\SpaUI\chat\emojis\Cutie]=]},
    {L["chat_emote_despise"], [=[Interface\Addons\SpaUI\chat\emojis\Despise]=]},
    {L["chat_emote_dream"], [=[Interface\Addons\SpaUI\chat\emojis\Dreamsmile]=]},
    {L["chat_emote_embarrassed"],[=[Interface\Addons\SpaUI\chat\emojis\Embarrass]=]},
    {L["chat_emote_evil"], [=[Interface\Addons\SpaUI\chat\emojis\Evil]=]},
    {L["chat_emote_excited"], [=[Interface\Addons\SpaUI\chat\emojis\Excited]=]},
    {L["chat_emote_dizzy"], [=[Interface\Addons\SpaUI\chat\emojis\Faint]=]},
    {L["chat_emote_fight"], [=[Interface\Addons\SpaUI\chat\emojis\Fight]=]},
    {L["chat_emote_influenza"], [=[Interface\Addons\SpaUI\chat\emojis\Flu]=]},
    {L["chat_emote_stay"], [=[Interface\Addons\SpaUI\chat\emojis\Freeze]=]},
    {L["chat_emote_frown"], [=[Interface\Addons\SpaUI\chat\emojis\Frown]=]},
    {L["chat_emote_salute"], [=[Interface\Addons\SpaUI\chat\emojis\Greet]=]},
    {L["chat_emote_grimace"], [=[Interface\Addons\SpaUI\chat\emojis\Grimace]=]},
    {L["chat_emote_barking_teeth"],[=[Interface\Addons\SpaUI\chat\emojis\Growl]=]}, 
    {L["chat_emote_happy"], [=[Interface\Addons\SpaUI\chat\emojis\Happy]=]},
    {L["chat_emote_heart"], [=[Interface\Addons\SpaUI\chat\emojis\Heart]=]},
    {L["chat_emote_fear"], [=[Interface\Addons\SpaUI\chat\emojis\Horror]=]},
    {L["chat_emote_sick"], [=[Interface\Addons\SpaUI\chat\emojis\Ill]=]},
    {L["chat_emote_innocent"],[=[Interface\Addons\SpaUI\chat\emojis\Innocent]=]},
    {L["chat_emote_kung_fu"], [=[Interface\Addons\SpaUI\chat\emojis\Kongfu]=]},
    {L["chat_emote_anthomaniac"], [=[Interface\Addons\SpaUI\chat\emojis\Love]=]},
    {L["chat_emote_mail"], [=[Interface\Addons\SpaUI\chat\emojis\Mail]=]},
    {L["chat_emote_makeup"], [=[Interface\Addons\SpaUI\chat\emojis\Makeup]=]},
    {L["chat_emote_mario"], [=[Interface\Addons\SpaUI\chat\emojis\Mario]=]},
    {L["chat_emote_meditation"],[=[Interface\Addons\SpaUI\chat\emojis\Meditate]=]},
    {L["chat_emote_poor"], [=[Interface\Addons\SpaUI\chat\emojis\Miserable]=]},
    {L["chat_emote_good"], [=[Interface\Addons\SpaUI\chat\emojis\Okay]=]},
    {L["chat_emote_beautiful"], [=[Interface\Addons\SpaUI\chat\emojis\Pretty]=]},
    {L["chat_emote_spit"], [=[Interface\Addons\SpaUI\chat\emojis\Puke]=]},
    {L["chat_emote_shake_hands"],[=[Interface\Addons\SpaUI\chat\emojis\Shake]=]}, 
    {L["chat_emote_yell"], [=[Interface\Addons\SpaUI\chat\emojis\Shout]=]},
    {L["chat_emote_shut_up"], [=[Interface\Addons\SpaUI\chat\emojis\Shuuuu]=]},
    {L["chat_emote_shy"], [=[Interface\Addons\SpaUI\chat\emojis\Shy]=]},
    {L["chat_emote_sleep"], [=[Interface\Addons\SpaUI\chat\emojis\Sleep]=]},
    {L["chat_emote_smile"], [=[Interface\Addons\SpaUI\chat\emojis\Smile]=]},
    {L["chat_emote_surprised"],[=[Interface\Addons\SpaUI\chat\emojis\Suprise]=]},
    {L["chat_emote_failure"],[=[Interface\Addons\SpaUI\chat\emojis\Surrender]=]}, 
    {L["chat_emote_sweat"], [=[Interface\Addons\SpaUI\chat\emojis\Sweat]=]},
    {L["chat_emote_tears"], [=[Interface\Addons\SpaUI\chat\emojis\Tear]=]},
    {L["chat_emote_tragedy"], [=[Interface\Addons\SpaUI\chat\emojis\Tears]=]},
    {L["chat_emote_thinking"], [=[Interface\Addons\SpaUI\chat\emojis\Think]=]},
    {L["chat_emote_snicker"], [=[Interface\Addons\SpaUI\chat\emojis\Titter]=]},
    {L["chat_emote_wretched"], [=[Interface\Addons\SpaUI\chat\emojis\Ugly]=]},
    {L["chat_emote_victory"], [=[Interface\Addons\SpaUI\chat\emojis\Victory]=]},
    {L["chat_emote_lei_feng"],[=[Interface\Addons\SpaUI\chat\emojis\Volunteer]=]},
    {L["chat_emote_injustice"],[=[Interface\Addons\SpaUI\chat\emojis\Wronged]=]}
}

-- 表情解析规则
local EMOTE_RULE = format("\124T%%s:%d\124t", max(floor(select(2, SELECTED_CHAT_FRAME:GetFont())),EMOTE_SIZE))

local function ReplaceEmote(msg)
    for i = 1, #emotes do
        if msg == emotes[i][1] then
            return format(EMOTE_RULE,emotes[i][2])
        end
    end
    return msg
end

local function ChatEmoteFilter(self, event, msg, ...)
    msg = msg:gsub("%{.-%}", ReplaceEmote)
    return false, msg, ...
end

local function OnEmoteClick(button, clickType)
    if (clickType == "LeftButton") then
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
        if (not ChatFrameEditBox:IsShown()) then
            ChatEdit_ActivateChat(ChatFrameEditBox)
        end
        ChatFrameEditBox:Insert(button.text)
    end
    Widget:ToggleEmoteTable()
end

function CreateEmoteTableFrame()
    local EmoteTableFrame = CreateFrame("Frame", "SpaUIEmoteTableFrame",
                                        UIParent, "BasicFrameTemplateWithInset")
    -- 响应Esc                                    
    tinsert(UISpecialFrames, EmoteTableFrame:GetName())
    EmoteTableFrame.Container = CreateFrame("Frame",
                                            "SpaUIEmoteTableFrameContainer",
                                            EmoteTableFrame)
    EmoteTableFrame.Container:SetPoint("TOPLEFT", EmoteTableFrame.LeftBorder,
                                       "TOPRIGHT")
    EmoteTableFrame.Container:SetPoint("BOTTOMRIGHT",
                                       EmoteTableFrame.RightBorder, "BOTTOMLEFT")
    EmoteTableFrame:SetWidth((EMOTE_SIZE + EMOTE_SIZE_MARGIN) * EMOTE_RAW_SIZE +
                                 20)
    EmoteTableFrame.TitleText:SetText(L["chat_bar_emote_table"])
    EmoteTableFrame:Hide()
    EmoteTableFrame:SetFrameStrata("DIALOG")

    local icon, row, col, text, texture
    for i = 1, #emotes do
        row = floor((i - 1) / EMOTE_RAW_SIZE)
        col = floor((i - 1) % EMOTE_RAW_SIZE)
        text = emotes[i][1]
        texture = emotes[i][2]

        icon = CreateFrame("Button", format("SpaUIEmoteIcon%d", i),
                           EmoteTableFrame.Container)
        icon:SetWidth(EMOTE_SIZE)
        icon:SetHeight(EMOTE_SIZE)
        icon.text = text
        icon:SetNormalTexture(texture)
        icon:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight",
                                 "ADD")
        icon:Show()
        icon:SetPoint("LEFT", EmoteTableFrame.Container, "LEFT",
                      col * (EMOTE_SIZE + EMOTE_SIZE_MARGIN), 0)
        icon:SetPoint("TOP", EmoteTableFrame.Container, "TOP", 0,
                      -row * (EMOTE_SIZE + EMOTE_SIZE_MARGIN))
        icon:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(emotes[i][1])
            GameTooltip:Show()
        end)
        icon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
        icon:SetScript("OnMouseDown",
                       function(self) self:SetAlpha(ALPHA_PRESS) end)
        icon:SetScript("OnMouseUp", function(self, button)
            self:SetAlpha(ALPHA_NORMAL)
            OnEmoteClick(self, button)
        end)
    end
    EmoteTableFrame:SetHeight((row + 1) * (EMOTE_SIZE + EMOTE_SIZE_MARGIN) + 35)
end

-- 注册需要解析表情的频道
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatEmoteFilter) -- 公共频道
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatEmoteFilter) -- 说
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatEmoteFilter) -- 大喊
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatEmoteFilter) -- 团队
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatEmoteFilter) -- 团队领袖
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatEmoteFilter) -- 队伍
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatEmoteFilter) -- 队伍领袖
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatEmoteFilter) -- 公会

ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", ChatEmoteFilter) -- AFK玩家自动回复
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatEmoteFilter) -- 切勿打扰自动回复

-- 副本和副本领袖
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatEmoteFilter)
-- 解析战网私聊
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatEmoteFilter)
-- 解析社区聊天内容
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatEmoteFilter)

local EMOTE_CHAT_DEFAULT_RULE = format("\124T%%s:%d\124t", EMOTE_SIZE)     

local function DefaultReplaceEmote(msg)
    for i = 1, #emotes do
        if msg == emotes[i][1] then
            return format(EMOTE_CHAT_DEFAULT_RULE,emotes[i][2])
        end
    end
    return msg
end

-- 替换聊天气泡表情
local function ReplaceChatBubbleEmote()
    local chatBubbles = C_ChatBubbles.GetAllChatBubbles()
        local frame, text, after
        for _, v in pairs(chatBubbles) do
            frame = v:GetChildren()
            if (frame and frame.String) then
                text = frame.String:GetText()
                after = text:gsub("%{.-%}", DefaultReplaceEmote)
                if (after ~= text) then
                    return frame.String:SetText(after)
                end
            end
        end
end

local CHAT_BUBBLE_TASK_NAME = "ChatBubbles"

-- 聊天气泡消息接收监听
local function OnChatBubblesMsgReceived()
    local task = SpaUI:GetTimerTask(CHAT_BUBBLE_TASK_NAME) 
    if not task then
        SpaUI:Schedule(CHAT_BUBBLE_TASK_NAME,0.15,0.15,5,ReplaceChatBubbleEmote)
    else
        task:ReStart()
    end
end

-- 聊天气泡设置变更回调
local function OnChatBubblesSettingChanged()
    local chatBubbles = C_CVar.GetCVarBool("chatBubbles")
    local chatBubblesParty = C_CVar.GetCVarBool("chatBubblesParty")
    if chatBubbles then
        SpaUI:RegisterEvent('CHAT_MSG_SAY',OnChatBubblesMsgReceived)
    else
        SpaUI:UnregisterEvent('CHAT_MSG_SAY',OnChatBubblesMsgReceived)
    end
    if chatBubblesParty then
        SpaUI:RegisterEvent('CHAT_MSG_PARTY',OnChatBubblesMsgReceived)
    else
        SpaUI:UnregisterEvent('CHAT_MSG_PARTY',OnChatBubblesMsgReceived)
    end
    return true
end

-- 监听聊天气泡设置变更
hooksecurefunc("InterfaceOptionsDisplayPanelChatBubblesDropDown_SetValue",OnChatBubblesSettingChanged)
SpaUI:CallbackOnce('PLAYER_LOGIN',OnChatBubblesSettingChanged)

-- 获取表情面板
function Widget:GetEmoteTable()
    if not SpaUIEmoteTableFrame then CreateEmoteTableFrame() end
    return SpaUIEmoteTableFrame
end

-- 关闭表情面板
function Widget:CloseEmoteTable()
    local ChatEmoteTable = self:GetEmoteTable()
    ChatEmoteTable:Hide()
end

-- 打开/关闭表情面板
function Widget:ToggleEmoteTable()
    local ChatEmoteTable = self:GetEmoteTable()
    if ChatEmoteTable:IsShown() then
        ChatEmoteTable:Hide()
    else
        ChatEmoteTable:Show()
    end
end

