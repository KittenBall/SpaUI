-- 输入坐标标记位置
local addonName, SpaUI = ...

local L = SpaUI.Localization

local WayPointPositionButton = CreateFrame("Button",
                                           "SpaUIWayPointPositionButton",
                                           WorldMapFrame.BorderFrame,
                                           "UIPanelButtonTemplate")
WayPointPositionButton:SetWidth(65)
WayPointPositionButton:SetHeight(18)
WayPointPositionButton:SetText(L["mp_button_text"])
WayPointPositionButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

function WayPointPositionButton:OnShow()
    self:ClearAllPoints()
    if MapsterOptionsButton and MapsterOptionsButton:IsShown() then
        self:SetPoint('RIGHT', MapsterOptionsButton, 'LEFT', 0, 0)
    else
        self:SetPoint('RIGHT', WorldMapFrame.BorderFrame.TitleBg, 'RIGHT', -20,
                      1)
    end
    SpaUIWayPointContainer:Close()
end
WayPointPositionButton:SetScript("OnShow", WayPointPositionButton.OnShow)

-- 设置目标位置
function WayPointPositionButton:SetWayPoint(desX, desY)
    local currentViewMapID = WorldMapFrame:GetMapID()
    if C_Map.CanSetUserWaypointOnMap(currentViewMapID) then
        local point = UiMapPoint.CreateFromCoordinates(currentViewMapID,
                                                       desX / 100, desY / 100)
        C_Map.SetUserWaypoint(point)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true);
    else
        SpaUI:ShowUIError(L["mp_cannot_mark"])
    end
end

-- 点击定位按钮
function WayPointPositionButton.OnClick(widget, button, down)
    if button == "RightButton" then
        C_Map.ClearUserWaypoint()
        C_SuperTrack.SetSuperTrackedUserWaypoint(false);
        return
    end
    local currentViewMapID = WorldMapFrame:GetMapID()
    if not C_Map.CanSetUserWaypointOnMap(currentViewMapID) then
        SpaUI:ShowUIError(L["mp_cannot_mark"])
        return
    end
    if SpaUIWayPointContainer then
        if SpaUIWayPointContainer:IsShown() then
            local xl = SpaUIWayPointContainer.CoordX:GetText():len()
            local yl = SpaUIWayPointContainer.CoordY:GetText():len()
            if xl ~= 0 and yl ~= 0 then
                local x = SpaUIWayPointContainer.CoordX:GetNumber()
                local y = SpaUIWayPointContainer.CoordY:GetNumber()
                SpaUIWayPointPositionButton:SetWayPoint(x, y)
            end
            SpaUIWayPointContainer:Close()
        else
            SpaUIWayPointContainer:Show()
            SpaUIWayPointContainer.CoordX:SetFocus()
        end
    end
end

WayPointPositionButton:SetScript("OnClick", WayPointPositionButton.OnClick)

-- 地图切换
function WayPointPositionButton:OnMapChanged()
    local currentViewMapID = WorldMapFrame:GetMapID()
    if C_Map.CanSetUserWaypointOnMap(currentViewMapID) then
        SpaUIWayPointPositionButton:Enable()
    else
        SpaUIWayPointPositionButton:Disable()
    end
end

hooksecurefunc(WorldMapFrame, "OnMapChanged",
               WayPointPositionButton.OnMapChanged)

-- 显示鼠标提示
function WayPointPositionButton:ShowTooltip(event)
    if event == "OnEnter" then
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText(L["mp_button_tooltip"])
        GameTooltip:Show()
    else
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        GameTooltip:Hide()
    end
end

WayPointPositionButton:SetScript("OnEnter", function(self)
    SpaUIWayPointPositionButton:ShowTooltip("OnEnter")
end)
WayPointPositionButton:SetScript("OnLeave", function(self)
    SpaUIWayPointPositionButton:ShowTooltip("OnLeave")
end)

local WayPointContainer = CreateFrame("Frame", "SpaUIWayPointContainer",
                                      WorldMapFrame)
WayPointContainer:SetFrameStrata("DIALOG")
WayPointContainer:SetWidth(100)
WayPointContainer:SetHeight(25)

function WayPointContainer:ChangePointWithWorldMapFrameSize()
    SpaUIWayPointContainer:ClearAllPoints()
    if WorldMapFrame:IsMaximized() then
        SpaUIWayPointContainer:SetPoint("RIGHT", WayPointPositionButton, "LEFT",
                                        -1, 0)
    else
        SpaUIWayPointContainer:SetPoint("BOTTOM", WayPointPositionButton, "TOP",
                                        0, 5)
    end
end

hooksecurefunc(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame, "Minimize",
               WayPointContainer.ChangePointWithWorldMapFrameSize)
hooksecurefunc(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame, "Maximize",
               WayPointContainer.ChangePointWithWorldMapFrameSize)

function WayPointContainer:Close()
    SpaUIWayPointContainer.CoordX:SetText("")
    SpaUIWayPointContainer.CoordX:ClearFocus()
    SpaUIWayPointContainer.CoordY:SetText("")
    SpaUIWayPointContainer.CoordY:ClearFocus()
    SpaUIWayPointContainer:Hide()
end

-- 输入tab
local function OnCoordTabPressed(editBox)
    if editBox == SpaUIWayPointContainer.CoordX then
        SpaUIWayPointContainer.CoordX:ClearFocus()
        SpaUIWayPointContainer.CoordY:SetFocus()
    else
        SpaUIWayPointContainer.CoordY:ClearFocus()
        SpaUIWayPointContainer.CoordX:SetFocus()
    end
end

-- 输入回车
local function OnCoordEnterPressed(editBox)
    if editBox == SpaUIWayPointContainer.CoordX then
        if editBox:GetText():len() ~= 0 then
            SpaUIWayPointContainer.CoordX:ClearFocus()
            SpaUIWayPointContainer.CoordY:SetFocus()
        end
    else
        if SpaUIWayPointContainer.CoordX:GetText():len() ~= 0 and
            SpaUIWayPointContainer.CoordY:GetText():len() ~= 0 then
            local x = SpaUIWayPointContainer.CoordX:GetNumber()
            local y = SpaUIWayPointContainer.CoordY:GetNumber()
            SpaUIWayPointPositionButton:SetWayPoint(x, y)
            SpaUIWayPointContainer:Close()
        elseif SpaUIWayPointContainer.CoordY:GetText():len() ~= 0 and
            SpaUIWayPointContainer.CoordX:GetText():len() == 0 then
            SpaUIWayPointContainer.CoordY:ClearFocus()
            SpaUIWayPointContainer.CoordX:SetFocus()
        end
    end
end

WayPointContainer.CoordY = CreateFrame("EditBox", "SpaUIWayPointCoordY",
                                       WayPointContainer, "InputBoxTemplate")
WayPointContainer.CoordY:SetAutoFocus(false)
WayPointContainer.CoordY:SetSize(30, 20)
WayPointContainer.CoordY:SetNumeric(true)
WayPointContainer.CoordY:SetMaxLetters(2)
WayPointContainer.CoordY:SetPoint("LEFT", WayPointContainer, "CENTER", 0, 0)
WayPointContainer.CoordY:SetScript("OnTabPressed", OnCoordTabPressed)
WayPointContainer.CoordY:SetScript("OnEnterPressed", OnCoordEnterPressed)

WayPointContainer.CoordX = CreateFrame("EditBox", "SpaUIWayPointCoordX",
                                       WayPointContainer, "InputBoxTemplate")
WayPointContainer.CoordX:SetAutoFocus(false)
WayPointContainer.CoordX:SetSize(30, 20)
WayPointContainer.CoordX:SetNumeric(true)
WayPointContainer.CoordX:SetMaxLetters(2)
WayPointContainer.CoordX:SetPoint("RIGHT", WayPointContainer, "CENTER", -10, 0)
WayPointContainer.CoordX:SetScript("OnTabPressed", OnCoordTabPressed)
WayPointContainer.CoordX:SetScript("OnEnterPressed", OnCoordEnterPressed)

WayPointContainer:Hide()