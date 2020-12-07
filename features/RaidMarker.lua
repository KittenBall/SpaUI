local addonName,SpaUI = ...
local LocalEvents = SpaUI.LocalEvents

local function SetIconPosition(parent,icon,index,num)
    local angle = (index-1)*(360/num)
    local x = 100 * cos(angle)
    local y = 100 * sin(angle)
    icon:SetPoint("CENTER",parent,"CENTER",x,y)
end

local function CreateRaidMarkerFrame()
    local Frame = CreateFrame("Frame","SpaUIRaidMarkerFrame",UIParent)
    Frame:SetSize(600,600)
    for i=1,8 do
        local icon = Frame:CreateTexture()
        icon:SetSize(48,48)
        icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)  
        SetIconPosition(parent,icon,i,8)
        Frame["Icon"..i] = icon
    end
    Frame.timer = 0
    Frame:SetScript("OnUpdate",function(self,elapsed)
        if self.timer>=1 then
            self.timer = 0
        local x,y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        print(UIParent:GetWidth(),UIParent:GetHeight(),x/scale,y/scale)
        else
            self.timer = self.timer + elapsed
        end
    end)
end

SpaUI:CallbackLocalEventOnce(LocalEvents.ADDON_INITIALIZATION,CreateRaidMarkerFrame)