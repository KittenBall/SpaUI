local addonName, SpaUI = ...

local L = SpaUI.Localization
local gusb = string.gsub
local BIG_FOOT_CHANNEL_NAME = "大脚世界频道"

local function ChangeToWorldChannel(editbox)
    local num = C_ChatInfo.GetNumActiveChannels()
    local channelTarget
    for i = 1, num do
        local id, name = GetChannelName(i)
        if name == BIG_FOOT_CHANNEL_NAME then
            channelTarget = i
            break
        end
    end
    editbox:SetAttribute("chatType", "CHANNEL")
    editbox:SetAttribute("channelTarget", channelTarget)
end

-- tab切换频道，当既在副本又在非副本的小队或团里时，切换逻辑会较生硬
-- 符合预期，不准备改好，两个团队频道来回切换也没什么大不了的
function ChatEdit_CustomTabPressed(self)
    local type = self:GetAttribute("chatType")
    if type == "SAY" then
        -- 说切换为大喊
        self:SetAttribute("chatType", "YELL")
    elseif type == "YELL" then
        -- 大喊根据是否在副本里切换为副本或小队（团队）
        -- 如果不在队伍里则切换为公会
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            self:SetAttribute("chatType", "INSTANCE_CHAT")
        elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
            if IsInRaid(LE_PARTY_CATEGORY_HOME) then
                self:SetAttribute("chatType", "RAID")
            else
                self:SetAttribute("chatType", "PARTY")
            end
        else
            self:SetAttribute("chatType", "GUILD")
        end
    elseif type == "INSTANCE_CHAT" then
        -- 副本频道根据是否在团队副本里切换为小队或公会
        if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
            self:SetAttribute("chatType", "PARTY")
        else
            self:SetAttribute("chatType", "GUILD")
        end
    elseif type == "PARTY" then
        -- 队伍频道根据是否在团队（非副本）里切换为团队或公会
        if IsInRaid(LE_PARTY_CATEGORY_HOME) then
            self:SetAttribute("chatType", "RAID")
        else
            self:SetAttribute("chatType", "GUILD")
        end
    elseif type == "RAID" then
        -- 团队频道切换到公会，如果有的话，否则切换到世界频道
        if IsInGuild() then
            self:SetAttribute("chatType", "GUILD")
        else
            ChangeToWorldChannel(self)
        end
    elseif type == "GUILD" then
        -- 公会切换到世界频道
        ChangeToWorldChannel(self)
    elseif type == "CHANNEL" or type == "WHISPER" or type == "BN_WHISPER" then
        -- 其它频道切换到说
        self:SetAttribute("chatType", "SAY")
    end
    if self:GetAttribute("chatType") ~= type then ChatEdit_UpdateHeader(self) end
end

-- 大脚世界频道 短频道名
for i = 1, NUM_CHAT_WINDOWS do
    if (i ~= 2) then
        local f = _G["ChatFrame" .. i]
        local am = f.AddMessage
        f.AddMessage = function(frame, text, ...)
            return am(frame,
                      text:gsub(
                          '|h%[(%d+)%.' .. BIG_FOOT_CHANNEL_NAME .. '%]|h',
                          '|h%[%1%. 世界%]|h'), ...)
        end
    end
end

--------------
-- 添加ChatBar
--------------

local CHAT_BAR_MESSAGE_TYPES = {
    "Say", "Yell", "Party", "Raid", "Instance_Chat", "Guild", "World"
}
local CHAT_BAR_BUTTON_SIZE = 20
local CHAT_BAR_BUTTON_MARGIN = 2
local ALPHA_ENTER = 1.0
local ALPHA_LEAVE = 0.3
local CHANNEL_WORLD_DEFAULT_COLOR_R = 1
local CHANNEL_WORLD_DEFAULT_COLOR_G = 0.75294125080109
local CHANNEL_WORLD_DEFAULT_COLOR_B = 0.75294125080109

-- 点击世界频道按钮
local function OnWorldChannelButtonClick(button)
    -- 找到大脚世界频道的频道id
    local num = C_ChatInfo.GetNumActiveChannels()
    local channelTarget
    for i = 1, num do
        local id, name = GetChannelName(i)
        if name == BIG_FOOT_CHANNEL_NAME then
            channelTarget = i
            break
        end
    end
    if channelTarget then
        local chatTypeInfo = ChatTypeInfo["CHANNEL" .. channelTarget]
        -- 改下世界频道的按钮颜色
        if chatTypeInfo then
            local text = SpaUI:formatColorTextByRGBPerc(
                             L["chat_bar_channel_world"], chatTypeInfo.r,
                             chatTypeInfo.g, chatTypeInfo.b)
            button.Text:SetText(text)
        end
        local editbox = ChatFrame_OpenChat("", ChatFram1)
        editbox:SetAttribute("chatType", "CHANNEL")
        editbox:SetAttribute("channelTarget", channelTarget)
        ChatEdit_UpdateHeader(editbox)
    else
        if GetLocale() == "zhCN" then
            SpaUI:ShowMessage(L["chat_bar_channel_world_donot_join"])
        end
    end
end

-- 创建ChatBar按钮
local function CreateChatBarButton(bar, index)
    local type = CHAT_BAR_MESSAGE_TYPES[index]
    bar[type] = CreateFrame("Button", "SpaUIChatBar" .. type .. "Button", bar)
    bar[type]:SetWidth(CHAT_BAR_BUTTON_SIZE)
    bar[type]:SetHeight(CHAT_BAR_BUTTON_SIZE)
    bar[type]:SetAlpha(ALPHA_LEAVE)
    bar[type]:SetScript("OnEnter", function(self) self:SetAlpha(ALPHA_ENTER) end)
    bar[type]:SetScript("OnLeave", function(self) self:SetAlpha(ALPHA_LEAVE) end)
    bar[type]:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
    bar[type]:SetPoint("LEFT", bar, "LEFT", (index - 1) *
                           (CHAT_BAR_BUTTON_MARGIN + CHAT_BAR_BUTTON_SIZE), 0)
    bar[type].Text =
        bar[type]:CreateFontString(bar[type], nil, "GameFontNormal")
    bar[type].Text:SetPoint("CENTER", bar[type], "CENTER")
    local chatTypeInfo = ChatTypeInfo[strupper(type)]
    if chatTypeInfo then
        -- 更改按钮颜色 设置点击事件
        local text = SpaUI:formatColorTextByRGBPerc(
                         L["chat_bar_channel_" .. (strlower(type))],
                         chatTypeInfo.r, chatTypeInfo.g, chatTypeInfo.b)
        bar[type].Text:SetText(text)
        bar[type]:SetScript("OnClick", function(self)
            ChatMenu_SetChatType(ChatFram1, strupper(type))
        end)
    elseif type == "World" then
        local text = SpaUI:formatColorTextByRGBPerc(
                         L["chat_bar_channel_" .. (strlower(type))],
                         CHANNEL_WORLD_DEFAULT_COLOR_R,
                         CHANNEL_WORLD_DEFAULT_COLOR_G,
                         CHANNEL_WORLD_DEFAULT_COLOR_B)
        bar[type].Text:SetText(text)
        bar[type]:SetScript("OnClick", OnWorldChannelButtonClick)
    end
end

-- 更改ChatBar锚点
local function ChangeChatBarPoint(editbox)
    if not editbox or editbox ~= ChatFrame1EditBox or not SpaUIChatBar then
        return
    end
    local chatStyle = GetCVar("chatStyle")
    local relativeTo
    if chatStyle == "classic" then
        relativeTo = ChatFrame1Background
    else
        relativeTo = editbox
    end

    if SpaUIChatBar.chatStyle ~= chatStyle or SpaUIChatBar.relativeTo ~=
        relativeTo then
        SpaUIChatBar:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 6, 2)
        SpaUIChatBar.chatStyle = chatStyle
        SpaUIChatBar.relativeTo = relativeTo
    end
end

-- 状态变更
local function OnEditBoxStatusChange(editbox)
    if editbox:HasFocus() then
        SpaUIChatBar:Hide()
    else
        if editbox:GetText():len() <= 0 then SpaUIChatBar:Show() end
    end
end

local function SetOrHookScript(scriptType)
    if ChatFrame1EditBox:GetScript(scriptType) then
        ChatFrame1EditBox:HookScript(scriptType, OnEditBoxStatusChange)
    else
        ChatFrame1EditBox:SetScript(scriptType, OnEditBoxStatusChange)
    end
end

-- 创建ChatBar
local function CreateChatBar()
    if not ChatFrame1EditBox then return end
    local ChatBar = CreateFrame("Frame", "SpaUIChatBar", UIParent)
    ChatBar:SetWidth(#CHAT_BAR_MESSAGE_TYPES *
                         (CHAT_BAR_BUTTON_SIZE + CHAT_BAR_BUTTON_MARGIN))
    ChatBar:SetHeight(CHAT_BAR_BUTTON_SIZE)
    ChatBar:SetFrameStrata(ChatFrame1:GetFrameStrata())

    ChangeChatBarPoint(ChatFrame1EditBox)

    for i = 1, #CHAT_BAR_MESSAGE_TYPES do CreateChatBarButton(ChatBar, i) end

    SetOrHookScript("OnEditFocusLost")
    SetOrHookScript("OnEditFocusGained")

    if ChatBar:GetBottom() < 0 then SpaUI:ShowMessage(L["chat_bar_outside"]) end
    return true
end

-- 切换聊天风格的时候更改锚点
hooksecurefunc("ChatEdit_ActivateChat", ChangeChatBarPoint)

SpaUI:RegisterEvent('PLAYER_ENTERING_WORLD', CreateChatBar)