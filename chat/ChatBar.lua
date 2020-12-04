local addonName, SpaUI = ...

local L = SpaUI.Localization
local BIG_FOOT_CHANNEL_NAME = "大脚世界频道"
local Widget = SpaUI.Widget

-- 找到大脚世界频道的频道id
function SpaUI:GetWorldChannelID()
    local num = C_ChatInfo.GetNumActiveChannels()
    for i = 1, num do
        local id, name = GetChannelName(i)
        if name == BIG_FOOT_CHANNEL_NAME then return i end
    end
end

--------------
-- 添加ChatBar
--------------

local CHAT_BAR_MESSAGE_TYPES = {
    "Say", "Yell", "Party", "Raid", "Instance_Chat", "Guild", "World", "Roll"
}
local CHAT_BAR_BUTTON_SIZE = 20
local CHAT_BAR_BUTTON_MARGIN = 2
local ALPHA_ENTER = 1.0
local ALPHA_LEAVE = 0.3
local SCALE_PRESS = 1.25
local SCALE_UP = 1
local CHANNEL_WORLD_DEFAULT_COLOR_R = 1
local CHANNEL_WORLD_DEFAULT_COLOR_G = 0.75294125080109
local CHANNEL_WORLD_DEFAULT_COLOR_B = 0.75294125080109

-- 点击世界频道按钮
local function OnWorldChannelButtonClick(button)
    local channelTarget = SpaUI:GetWorldChannelID()
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
    bar[type]:SetPoint("LEFT", bar, "LEFT", (index - 1) *
                           (CHAT_BAR_BUTTON_MARGIN + CHAT_BAR_BUTTON_SIZE), 0)
    local chatTypeInfo = ChatTypeInfo[strupper(type)]
    if chatTypeInfo then
        -- 更改按钮颜色 设置点击事件
        local text = SpaUI:formatColorTextByRGBPerc(
                         L["chat_bar_channel_" .. (strlower(type))],
                         chatTypeInfo.r, chatTypeInfo.g, chatTypeInfo.b)
        bar[type].Text = bar[type]:CreateFontString(bar[type], nil,
                                                    "GameFontNormal")
        bar[type].Text:SetPoint("CENTER", bar[type], "CENTER")
        bar[type].Text:SetJustifyH("CENTER")
        bar[type].Text:SetText(text)
        bar[type]:SetScript("OnClick", function(self)
            ChatMenu_SetChatType(ChatFram1, strupper(type))
        end)
    elseif type == "World" then
        local channelTarget = SpaUI:GetWorldChannelID()
        local chatTypeInfo = channelTarget and
                                 ChatTypeInfo["CHANNEL" .. channelTarget] or nil
        local r = chatTypeInfo and chatTypeInfo.r or
                      CHANNEL_WORLD_DEFAULT_COLOR_R
        local g = chatTypeInfo and chatTypeInfo.g or
                      CHANNEL_WORLD_DEFAULT_COLOR_G
        local b = chatTypeInfo and chatTypeInfo.b or
                      CHANNEL_WORLD_DEFAULT_COLOR_B
        -- 世界频道按钮
        local text = SpaUI:formatColorTextByRGBPerc(
                         L["chat_bar_channel_" .. (strlower(type))], r, g, b)
        bar[type].Text = bar[type]:CreateFontString(bar[type], nil,
                                                    "GameFontNormal")
        bar[type].Text:SetPoint("CENTER", bar[type], "CENTER")
        bar[type].Text:SetJustifyH("CENTER")
        bar[type].Text:SetText(text)
        bar[type]:SetScript("OnClick", OnWorldChannelButtonClick)
    elseif type == "Roll" then
        -- roll点
        bar[type]:SetNormalTexture("Interface\\Addons\\SpaUI\\Media\\roll")
        bar[type]:SetHighlightTexture("Interface\\Addons\\SpaUI\\Media\\roll_highlight")
        bar[type]:SetPushedTexture("Interface\\Addons\\SpaUI\\Media\\roll_pressed")
        bar[type]:SetScript("OnClick", function(self) RandomRoll(1, 100) end)
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
        SpaUIChatBar:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, 0)
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
        Widget:CloseEmoteTable()
    end
end

local function SetOrHookScript(scriptType)
    if ChatFrame1EditBox:GetScript(scriptType) then
        ChatFrame1EditBox:HookScript(scriptType, OnEditBoxStatusChange)
    else
        ChatFrame1EditBox:SetScript(scriptType, OnEditBoxStatusChange)
    end
end

-- 生成表情按钮
local function CreateChatEmoteButton()
    if not SpaUIChatBar then return end
    local ChatEmoteButton = CreateFrame("Button", "SpaUIChatEmoteButton",
                                        UIParent)
    ChatEmoteButton:SetWidth(CHAT_BAR_BUTTON_SIZE)
    ChatEmoteButton:SetHeight(CHAT_BAR_BUTTON_SIZE)
    ChatEmoteButton:SetPoint("RIGHT", SpaUIChatBar, "LEFT",
                             -CHAT_BAR_BUTTON_MARGIN, 0)
    ChatEmoteButton:SetAlpha(ALPHA_LEAVE)
    ChatEmoteButton:SetNormalTexture(
        "Interface\\Addons\\SpaUI\\chat\\emojis\\greet")
    ChatEmoteButton:SetScript("OnEnter",
                              function(self) self:SetAlpha(ALPHA_ENTER) end)
    ChatEmoteButton:SetScript("OnLeave",
                              function(self) self:SetAlpha(ALPHA_LEAVE) end)
    ChatEmoteButton:SetScript("OnMouseUp",
                              function(self) self:SetScale(SCALE_UP) end)
    ChatEmoteButton:SetScript("OnMouseDown",
                              function(self) self:SetScale(SCALE_PRESS) end)

    local ChatEmoteTable = Widget:GetEmoteTable()
    ChatEmoteTable:SetPoint("BOTTOMLEFT", ChatEmoteButton, "TOPRIGHT", 3, 3)
    ChatEmoteButton:SetScript("OnClick",
                              function(self) Widget:ToggleEmoteTable() end)
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

    CreateChatEmoteButton()
end

-- 切换聊天风格的时候更改锚点
hooksecurefunc("ChatEdit_ActivateChat", ChangeChatBarPoint)

SpaUI:CallbackOnce('PLAYER_LOGIN', CreateChatBar)
