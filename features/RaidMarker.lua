local addonName,SpaUI = ...
local LocalEvents = SpaUI.LocalEvents
local L = SpaUI.Localization
local MAX_MARKERS_SIZE_RAW = 3
local Widget = SpaUI.Widget

local ALPHA_MARKER_NOT_SET = 0.5
local ALPHA_MARKER_ON_ENTER = 1
local ALPHA_MARKER_ACTIVE = 0.8
local IsRaidMarkerActive = IsRaidMarkerActive

local MARKERS = {
    {id = 1, tooltipText = WORLD_MARKER1..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6", type = "macro", leftmacrotext = "/wm 1\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(1)"},
    {id = 2, tooltipText = WORLD_MARKER2..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4", type = "macro", leftmacrotext = "/wm 2\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(2)"},
    {id = 3, tooltipText = WORLD_MARKER3..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3", type = "macro", leftmacrotext = "/wm 3\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(3)"},
    {id = 4, tooltipText = WORLD_MARKER4..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7", type = "macro", leftmacrotext = "/wm 4\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(4)"},
    {id = 5, tooltipText = WORLD_MARKER5..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1", type = "macro", leftmacrotext = "/wm 5\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(5)"},
    {id = 6, tooltipText = WORLD_MARKER6..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2", type = "macro", leftmacrotext = "/wm 6\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(6)"},
    {id = 7, tooltipText = WORLD_MARKER7..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5", type = "macro", leftmacrotext = "/wm 7\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(7)"},
    {id = 8, tooltipText = WORLD_MARKER8..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8", type = "macro", leftmacrotext = "/wm 8\n/run SpaUIRaidMarkerContainer:Hide()", rightmacrotext = "/run ClearRaidMarker(8)"},
    {tooltipText = L["raid_markers_clear_all"], texture= "Interface\\Addons\\SpaUI\\media\\raid_markers_clear", type = "function",OnClick = function(self,button)
        for i = 1, 8 do
            ClearRaidMarker(i)
        end
        if button == "RightButton" then
            SpaUIRaidMarkerContainer:Hide()
        end
    end}
}

-- 设置标记属性
local function SetUpMarker(parent,icon,index,degree)
    icon.info = MARKERS[index]
    icon:SetSize(64,64)
    icon:SetNormalTexture(icon.info.texture)
    icon:RegisterForClicks("AnyUp")
    if icon.info.type == "macro" then
        icon.alphaOnLeave = ALPHA_MARKER_NOT_SET
        icon:SetAttribute("type1","macro")
        icon:SetAttribute("macrotext1",icon.info.leftmacrotext)
        icon:SetAttribute("type2","macro")
        icon:SetAttribute("macrotext2",icon.info.rightmacrotext)
        local x = 125 * cos(degree*(index-1))
        local y = 125 * sin(degree*(index-1))
        icon:SetPoint("CENTER",parent,"CENTER",x,y)
    elseif icon.info.type == "function" then
        icon.alphaOnLeave = ALPHA_MARKER_ON_ENTER
        icon:SetScript("OnClick",function(self,button) icon.info.OnClick(self,button) end)
        icon:SetPoint("CENTER",parent,"CENTER")
    end
    icon:SetAlpha(icon.alphaOnLeave)

    -- 标记鼠标是否悬停，用于处理刷新状态时的透明度变更问题
    icon.IsEnter = false
    icon:SetScript("OnEnter",function(self)
        self.IsEnter = true
        self:SetAlpha(ALPHA_MARKER_ON_ENTER)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:AddLine(self.info.tooltipText)
        GameTooltip:Show()
    end)
    icon:SetScript("OnLeave",function(self)
        self.IsEnter = false
        self:SetAlpha(self.alphaOnLeave)
        GameTooltip:Hide()
    end)

    if icon.info.id then
        icon.ActiveMark = icon:CreateTexture(nil,"OVERLAY")
        icon.ActiveMark:SetTexture("Interface\\Addons\\SpaUI\\media\\raid_marker_active")
        icon.ActiveMark:SetSize(18,18)
        icon.ActiveMark:SetPoint("TOPRIGHT",icon,"TOPRIGHT",5,5)
        icon.ActiveMark:Hide() 
    end
end

-- 检查标记放置状态
local function CheckRaidMarkerStatus(frame)
    if not frame or not frame.Icons then return end
    for i = 1,#frame.Icons do
        local icon = frame.Icons[i]
        if icon and icon.info and icon.info.id then
            icon.IsActive =  IsRaidMarkerActive(icon.info.id)
            icon.alphaOnLeave = icon.IsActive and ALPHA_MARKER_ACTIVE or ALPHA_MARKER_NOT_SET
            if not icon.IsEnter then
                icon:SetAlpha(icon.alphaOnLeave)
            end
            if icon.IsActive then
                icon.ActiveMark:Show()
            else
                icon.ActiveMark:Hide()
            end
        end
    end
end

-- todo 单人模式不允许呼出，快捷键呼出面板
local function CreateRaidMarkerFrame()
    local RaidMarkerFrame = CreateFrame("Button","SpaUIRaidMarkerContainer",UIParent)
    RaidMarkerFrame:SetSize(500,500)
    RaidMarkerFrame:SetPoint("CENTER",UIParent,"CENTER")
    RaidMarkerFrame:SetFrameStrata("DIALOG")
    RaidMarkerFrame:Hide()
    RaidMarkerFrame.timer = 0

    RaidMarkerFrame.Icons = {}

    local markerCount = 0;

    for _,markerInfo in ipairs(MARKERS) do
        if markerInfo.id then
           markerCount = markerCount + 1
        end
    end

    local degree = 360/markerCount

    for i=1,#MARKERS do
        local icon = CreateFrame("Button","SpaUIRaidMarker"..i,RaidMarkerFrame,"SecureActionButtonTemplate")
        SetUpMarker(RaidMarkerFrame,icon,i,degree)
        RaidMarkerFrame.Icons[i] = icon
    end

    -- 检测标记状态
    RaidMarkerFrame:SetScript("OnUpdate",function(self,elapsed)
        if self.timer >=0.3 then
            self.timer = 0
            CheckRaidMarkerStatus(self)
        else
            self.timer = self.timer + elapsed
        end
    end)

    Widget.RaidMarkers = RaidMarkerFrame
end

function Widget:ToggleRaidMarkersFrame()
    local RaidMarkers = self.RaidMarkers
    if RaidMarkers:IsShown() then
        RaidMarkers:Hide()
    else
        if (IsInGroup() and not IsInRaid())
        or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then      
            RaidMarkers:Show()
        else
            SpaUI:ShowMessage(L["raid_markers_nopermission"])    
        end
    end
end

SpaUI:CallbackLocalEventOnce(LocalEvents.ADDON_INITIALIZATION,CreateRaidMarkerFrame)