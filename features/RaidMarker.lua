local addonName,SpaUI = ...
local LocalEvents = SpaUI.LocalEvents
local L = SpaUI.Localization
local Widget = SpaUI.Widget

local ALPHA_MARKER_NOT_SET = 0.5
local ALPHA_MARKER_ON_ENTER = 1
local ALPHA_MARKER_ACTIVE = 0.8
local IsRaidMarkerActive = IsRaidMarkerActive

function SpaUI:ShowCanNotPlaceRaidMarkerMessage()
    if not ((IsInGroup() and not IsInRaid())
        or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
        SpaUI:ShowMessage(L["raid_markers_nopermission"])
    end
end

local MARKERS = {
    {id = 1, tooltipText = WORLD_MARKER1..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 1", rightmacrotext = "/cwm 1"},
    {id = 2, tooltipText = WORLD_MARKER2..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 2", rightmacrotext = "/cwm 2"},
    {id = 3, tooltipText = WORLD_MARKER3..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 3", rightmacrotext = "/cwm 3"},
    {id = 4, tooltipText = WORLD_MARKER4..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 4", rightmacrotext = "/cwm 4"},
    {id = 5, tooltipText = WORLD_MARKER5..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 5", rightmacrotext = "/cwm 5"},
    {id = 6, tooltipText = WORLD_MARKER6..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 6", rightmacrotext = "/cwm 6"},
    {id = 7, tooltipText = WORLD_MARKER7..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 7", rightmacrotext = "/cwm 7"},
    {id = 8, tooltipText = WORLD_MARKER8..L["raid_markers_tooltip"], texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8", type = "macro", leftmacrotext = "/run SpaUI:ShowCanNotPlaceRaidMarkerMessage()\n/wm 8", rightmacrotext = "/cwm 8"},
    {tooltipText = L["raid_markers_clear_all"], texture= "Interface\\Addons\\SpaUI\\media\\raid_markers_clear", type = "macro",leftmacrotext="/cwm "..ALL}
}

-- 设置标记属性
local function SetUpMarker(parent,icon,index,degree)
    icon.info = MARKERS[index]
    icon:SetSize(64,64)
    icon:SetNormalTexture(icon.info.texture)
    icon:RegisterForClicks("AnyUp")
    icon:SetAttribute("type1","macro")
    icon:SetAttribute("macrotext1",icon.info.leftmacrotext)
    if icon.info.rightmacrotext then
        icon:SetAttribute("type2","macro")
        icon:SetAttribute("macrotext2",icon.info.rightmacrotext)
    end

    if icon.info.id then
        icon.alphaOnLeave = ALPHA_MARKER_NOT_SET
        local x = 125 * cos(degree*(index-1))
        local y = 125 * sin(degree*(index-1))     
        icon:SetPoint("CENTER",parent,"CENTER",x,y)
    else
        icon.alphaOnLeave = ALPHA_MARKER_ON_ENTER
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

local function SetRaidMarkerToggleButtonBinding()
    if Widget and Widget.RaidMarkerToggleButton then
        ClearOverrideBindings(Widget.RaidMarkerToggleButton)
        local key = GetBindingKey("SPAUI_TOGGLE_RAID_MARKER_FRAME")
        if key then
            SetOverrideBindingClick(Widget.RaidMarkerToggleButton, false, key, "SpaUIRaidMarkerToggleButton", "LeftButton")
        end
    end
end

-- 快捷键呼出面板
local function CreateRaidMarkerFrame()
    local RaidMarkerFrame = CreateFrame("Frame","SpaUIRaidMarkerContainer",UIParent)
    tinsert(UISpecialFrames,RaidMarkerFrame:GetName())
    RaidMarkerFrame:EnableMouse(false)
    RaidMarkerFrame:SetSize(350,350)
    RaidMarkerFrame:SetPoint("CENTER",UIParent,"CENTER")
    RaidMarkerFrame:SetFrameStrata("DIALOG")
    RaidMarkerFrame:Hide()

    -- 显示/隐藏开关
    local RaidMarkerToggleButton = CreateFrame("Button","SpaUIRaidMarkerToggleButton",UIParent,"SecureHandlerClickTemplate")
    RaidMarkerToggleButton:Execute[[
        ToggleButton = self
        Toggle = [==[
            local RaidMarkerContainer = self:GetFrameRef("RaidMarkerContainer")
            if RaidMarkerContainer then
                if RaidMarkerContainer:IsShown() then
                    RaidMarkerContainer:Hide()
                else
                    RaidMarkerContainer:Show()
                end
            end
        ]==]
    ]]
    RaidMarkerToggleButton:SetAttribute("_onclick",[=[
        ToggleButton:Run(Toggle)
    ]=])
    RaidMarkerToggleButton:SetFrameRef("RaidMarkerContainer",RaidMarkerFrame)
    Widget.RaidMarkerToggleButton = RaidMarkerToggleButton
    SetRaidMarkerToggleButtonBinding()

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
        RaidMarkerToggleButton:WrapScript(icon,"OnClick",[[ToggleButton:Run(Toggle)]])
        SetUpMarker(RaidMarkerFrame,icon,i,degree)
        RaidMarkerFrame.Icons[i] = icon
    end
    CheckRaidMarkerStatus(RaidMarkerFrame)

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

SpaUI:CallbackLocalEventOnce(LocalEvents.ADDON_INITIALIZATION,CreateRaidMarkerFrame)

SpaUI:RegisterEvent("UPDATE_BINDINGS",SetRaidMarkerToggleButtonBinding)