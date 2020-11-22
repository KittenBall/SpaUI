-- 修改自SUI
local addonName, SpaUI = ...

local function UpdateFriends(...)
    local buttons = FriendsListFrameScrollFrame.buttons
    for i = 1, #buttons do
        local nameText
        local button = buttons[i]
        if button and button:IsShown() then
            if button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
                local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
                if accountInfo.gameAccountInfo.isOnline and
                    accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW then
                    local accountName = accountInfo.accountName
                    local characterName =
                        accountInfo.gameAccountInfo.characterName
                    local class = accountInfo.gameAccountInfo.className
                    if accountName and characterName and class then
                        nameText = accountName .. " |c" ..
                                       RAID_CLASS_COLORS[SpaUI:GetClassFileByLocalizedClassName(
                                           class)].colorStr .. "(" ..
                                       characterName .. ")" ..
                                       FONT_COLOR_CODE_CLOSE
                    end
                end
            elseif button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
                local friendInfo = C_FriendList.GetFriendInfoByIndex(button.id)
                if friendInfo and friendInfo.connected and friendInfo.name and
                    friendInfo.className and friendInfo.level then
                    nameText = "|c" ..
                                   RAID_CLASS_COLORS[SpaUI:GetClassFileByLocalizedClassName(
                                       friendInfo.className)].colorStr ..
                                   friendInfo.name .. "|r, " ..
                                   format(FRIENDS_LEVEL_TEMPLATE,
                                          friendInfo.level, friendInfo.className)
                end
            end
        end
        if nameText then button.name:SetText(nameText) end
    end
end

local function HookFriendsFrameUpdate(event)
    hooksecurefunc("FriendsFrame_UpdateFriends", UpdateFriends)
    hooksecurefunc(FriendsListFrameScrollFrame, "update", UpdateFriends)
end

SpaUI:CallbackOnce('PLAYER_LOGIN', HookFriendsFrameUpdate)
