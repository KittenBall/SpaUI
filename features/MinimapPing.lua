-- 小地图ping，修改自SexyMap
local addonName, SpaUI = ...

local L = SpaUI.Localization

local function MinimapPingTipInitalize()
    local MinimapPingFrame = CreateFrame("Frame", "SpaUIMinimapPingFrame",
                                         Minimap, "BackdropTemplate")
    MinimapPingFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        insets = {left = 4, top = 4, right = 4, bottom = 4},
        edgeSize = 16,
        tile = true
    })
    MinimapPingFrame:SetBackdropColor(0, 0, 0, 0.8)
    MinimapPingFrame:SetBackdropBorderColor(0, 0, 0, 0.6)
    MinimapPingFrame:SetHeight(20)
    MinimapPingFrame:SetWidth(100)
    MinimapPingFrame:SetPoint("TOP", Minimap, "TOP", 0, -10)
    MinimapPingFrame:SetFrameStrata("HIGH")
    MinimapPingFrame.name = MinimapPingFrame:CreateFontString(nil, nil,
                                                                    "GameFontNormalSmall")
    MinimapPingFrame.name:SetAllPoints()
    MinimapPingFrame:Hide()

    MinimapPingFrame.animGroup = MinimapPingFrame:CreateAnimationGroup()
    MinimapPingFrame.animGroup.anim =
    MinimapPingFrame.animGroup:CreateAnimation("Alpha")
    MinimapPingFrame.animGroup:SetScript("OnFinished", function()
        SpaUIMinimapPingFrame:Hide()
    end)
    MinimapPingFrame.animGroup.anim:SetFromAlpha(1)
    MinimapPingFrame.animGroup.anim:SetToAlpha(0)
    MinimapPingFrame.animGroup.anim:SetOrder(1)
    MinimapPingFrame.animGroup.anim:SetDuration(2.5)
end

local function OnMinimapPing(event, unit)
    if not unit then return end
    if not SpaUIMinimapPingFrame then MinimapPingTipInitalize() end
    local class = select(2, UnitClass(unit))
    local color
    if class then
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or
                    RAID_CLASS_COLORS[class]
    else
        color = GRAY_FONT_COLOR
    end

    local name = GetUnitName(unit, false)
    if not name then return end
    -- 添加小队信息
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local member, _, subgroup = GetRaidRosterInfo(i)
            if member == name and subgroup then
                name = L["minimap_ping_who_group"]:format(subgroup, name)
                break
            end
        end
    end

    name = ("|cFF%02x%02x%02x%s|r"):format(color.r * 255, color.g * 255,
                                           color.b * 255, name)

    SpaUIMinimapPingFrame.name:SetFormattedText(name)
    SpaUIMinimapPingFrame:SetWidth(SpaUIMinimapPingFrame.name:GetStringWidth() +14)
    SpaUIMinimapPingFrame:SetHeight(
        SpaUIMinimapPingFrame.name:GetStringHeight() + 10)
    SpaUIMinimapPingFrame.animGroup:Stop()
    SpaUIMinimapPingFrame:Show()
    SpaUIMinimapPingFrame.animGroup:Play()
end

SpaUI:RegisterEvent('MINIMAP_PING', OnMinimapPing)
