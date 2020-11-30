-- 修改自SUI
local addonName, SpaUI = ...
local L = SpaUI.Localization

local function UpdateFriends(...)
    local buttons = FriendsListFrameScrollFrame.buttons
    for i = 1, #buttons do
        local nameText, infoText
        local button = buttons[i]
        if button and button:IsShown() then
            local currentArea = GetRealZoneText()
            if button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
                local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
                if accountInfo.gameAccountInfo.isOnline and
                    accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW then
                    local accountName = accountInfo.accountName
                    local characterName = accountInfo.gameAccountInfo.characterName
                    local class = accountInfo.gameAccountInfo.className
                    local areaName = accountInfo.gameAccountInfo.areaName
                    if accountName and characterName and class then
                        local class = SpaUI:GetClassFileByLocalizedClassName(class)
                        if class then
                            nameText = accountName .. " |c" ..RAID_CLASS_COLORS[class].colorStr ..  "(" ..characterName .. ")" ..FONT_COLOR_CODE_CLOSE
                        end
                    end
                    if areaName == currentArea then
                        infoText = L["friends_list_area"]:format(areaName)
                    end
                end
            elseif button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
                local friendInfo = C_FriendList.GetFriendInfoByIndex(button.id)
                if friendInfo and friendInfo.connected and friendInfo.name and
                    friendInfo.className and friendInfo.level then
                    local class =  SpaUI:GetClassFileByLocalizedClassName(friendInfo.className)
                    if class then
                        nameText = "|c" .. RAID_CLASS_COLORS[class].colorStr ..friendInfo.name .. "|r, " ..format(FRIENDS_LEVEL_TEMPLATE,friendInfo.level, friendInfo.className)
                    end
                end
                if friendInfo and friendInfo.area and friendInfo.area == currentArea then
                    infoText = L["friends_list_area"]:format(friendInfo.area)
                end
            end
        end
        if nameText then button.name:SetText(nameText) end
        if infoText then button.info:SetText(infoText) end
    end
end

local function HookFriendsFrameUpdate(event)
    hooksecurefunc("FriendsFrame_UpdateFriends", UpdateFriends)
    hooksecurefunc(FriendsListFrameScrollFrame, "update", UpdateFriends)
end

SpaUI:CallbackOnce('PLAYER_LOGIN', HookFriendsFrameUpdate)
