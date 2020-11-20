-- 小地图ping，修改自SexyMap
local addonName, SpaUI = ...

local function MinimapPingTipInitalize()
    SpaUI.MinimapPingFrame = CreateFrame("Frame", "SpaUIMinimapPingFrame",
                                         Minimap, "BackdropTemplate")
    SpaUI.MinimapPingFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        insets = {left = 4, top = 4, right = 4, bottom = 4},
        edgeSize = 16,
        tile = true
    })
    SpaUI.MinimapPingFrame:SetBackdropColor(0, 0, 0, 0.8)
    SpaUI.MinimapPingFrame:SetBackdropBorderColor(0, 0, 0, 0.6)
    SpaUI.MinimapPingFrame:SetHeight(20)
    SpaUI.MinimapPingFrame:SetWidth(100)
    SpaUI.MinimapPingFrame:SetPoint("TOP", Minimap, "TOP", 0, -10)
    SpaUI.MinimapPingFrame:SetFrameStrata("HIGH")
    SpaUI.MinimapPingFrame.name = SpaUI.MinimapPingFrame:CreateFontString(nil,
                                                                          nil,
                                                                          "GameFontNormalSmall")
    SpaUI.MinimapPingFrame.name:SetAllPoints()
    SpaUI.MinimapPingFrame:Hide()

    SpaUI.MinimapPingFrame.animGroup =
        SpaUI.MinimapPingFrame:CreateAnimationGroup()
    SpaUI.MinimapPingFrame.animGroup.anim =
        SpaUI.MinimapPingFrame.animGroup:CreateAnimation("Alpha")
    SpaUI.MinimapPingFrame.animGroup:SetScript("OnFinished", function()
        SpaUI.MinimapPingFrame:Hide()
    end)
    SpaUI.MinimapPingFrame.animGroup.anim:SetFromAlpha(1)
    SpaUI.MinimapPingFrame.animGroup.anim:SetToAlpha(0)
    SpaUI.MinimapPingFrame.animGroup.anim:SetOrder(1)
    SpaUI.MinimapPingFrame.animGroup.anim:SetDuration(2)
end

local function OnMinimapPing(event, unit)
    if not unit then return end
    if not SpaUI.MinimapPingFrame then MinimapPingTipInitalize() end
    local class = select(2, UnitClass(unit))
    local color
    if class then
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or
                    RAID_CLASS_COLORS[class]
    else
        color = GRAY_FONT_COLOR
    end

    local name = UnitName(unit)
    if not name then return end
    -- 添加小队信息
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local member, _, subgroup = GetRaidRosterInfo(i)
            if member == name and subgroup then
                name = ("(%d队)%s"):format(subgroup, name)
                break
            end
        end
    end

    name = ("|cFF%02x%02x%02x%s|r"):format(color.r * 255, color.g * 255,
                                           color.b * 255, name)

    SpaUI.MinimapPingFrame.name:SetFormattedText(name)
    SpaUI.MinimapPingFrame:SetWidth(
        SpaUI.MinimapPingFrame.name:GetStringWidth() + 14)
    SpaUI.MinimapPingFrame:SetHeight(
        SpaUI.MinimapPingFrame.name:GetStringHeight() + 10)
    SpaUI.MinimapPingFrame.animGroup:Stop()
    SpaUI.MinimapPingFrame:Show()
    SpaUI.MinimapPingFrame.animGroup:Play()
end

SpaUI:RegisterEvent('MINIMAP_PING', OnMinimapPing)
