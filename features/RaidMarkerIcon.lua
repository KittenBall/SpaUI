-- ----------------------------------------------------------------------------
-- RaidFrameIcons by Szandos
-- Continued by Soyier
-- ----------------------------------------------------------------------------
-- 团队框架标记 修改自Raid Frame Icons
local addonName, SpaUI = ...

local Widget = SpaUI.Widget

Widget.RaidTargetIcons = {}

local function UpdateRaidTargetIcon(frame)
    local unit = frame.unit
    local name = frame:GetName()

    if not name or not unit or not UnitExists(unit) then return end
    local marker = GetRaidTargetIndex(unit)

    if not Widget.RaidTargetIcons[name] then
        Widget.RaidTargetIcons[name] = {}
        Widget.RaidTargetIcons[name].icon = frame:CreateTexture(nil, "OVERLAY")
        Widget.RaidTargetIcons[name].icon:SetPoint("CENTER", 0, 0)
        Widget.RaidTargetIcons[name].icon:SetWidth(28)
        Widget.RaidTargetIcons[name].icon:SetHeight(28)
    end

    if marker ~= Widget.RaidTargetIcons[name].marker then
        Widget.RaidTargetIcons[name].marker = marker
        if marker then
            Widget.RaidTargetIcons[name].icon:SetTexture(
                "Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. marker)
                Widget.RaidTargetIcons[name].icon:Show()
        else
            Widget.RaidTargetIcons[name].icon:Hide()
        end
    end
end

local function UpdateRaidTarget()
    CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal",
                                            function(frame)
        UpdateRaidTargetIcon(frame)
    end)
end

SpaUI:RegisterEvent('RAID_TARGET_UPDATE', UpdateRaidTarget)
SpaUI:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateRaidTarget)
SpaUI:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateRaidTarget)

