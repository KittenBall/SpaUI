
local GetChannelName_origin = GetChannelName
local gusb = string.gsub

-- 大脚世界频道短频道名
GetChannelName = function(source)
    local id,name,instanceID,isCommunitiesChannel = GetChannelName_origin(source)
    if not name then return id,name,instanceID,isCommunitiesChannel end
    return id,name:gsub('大脚世界频道','世界'),instanceID,isCommunitiesChannel
end

local function ChangeChannelToWorld(editbox)
    local num = C_ChatInfo.GetNumActiveChannels()
    local channelTarget
    for i = 1, num do 
        local id,name = GetChannelName(i)
        if name == "世界" then
            channelTarget = i
            break
        end
    end
    editbox:SetAttribute("chatType", "CHANNEL")
    editbox:SetAttribute("channelTarget", channelTarget);
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
            ChangeChannelToWorld(self)
        end
    elseif type == "GUILD" then
        -- 公会切换到世界频道
        ChangeChannelToWorld(self)
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
            return am(frame, text:gsub('|h%[(%d+)%. 大脚世界频道%]|h','|h%[%1%. 世界%]|h'), ...)
        end
    end
end