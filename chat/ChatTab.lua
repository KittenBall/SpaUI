local addonName, SpaUI = ...

local L = SpaUI.Localization
local BIG_FOOT_CHANNEL_NAME = "大脚世界频道"

-- 切换到大脚世界频道
local function ChangeToWorldChannel(editbox)
    local channelTarget = SpaUI:GetWorldChannelID()
    if channelTarget then
        editbox:SetAttribute("chatType", "CHANNEL")
        editbox:SetAttribute("channelTarget", channelTarget)
    else
        editbox:SetAttribute("chatType", "SAY")
    end
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
    local f = _G["ChatFrame" .. i]
    if f ~= COMBATLOG then
        local am = f.AddMessage
        f.AddMessage = function(frame, text, ...)
            return am(frame,gsub(text,'|h%[(%d+)%. ' .. BIG_FOOT_CHANNEL_NAME .. '%]|h','|h%[%1%. 世界%]|h'), ...)
        end
    end
end