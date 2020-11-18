-- 单位框体
-- 隐藏玩家和宠物头像浮动状态文字
PlayerHitIndicator:SetText(nil)
PlayerHitIndicator.SetText = function() end
PetHitIndicator:SetText(nil)
PetHitIndicator.SetText = function() end

-- 血条和名字职业染色
local UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS =
    UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS
local _, class, c

local function colour(statusbar, unit)
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and
        UnitClass(unit) then
        _, class = UnitClass(unit)
        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or
                RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(c.r, c.g, c.b)
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged",
               function(self) colour(self, self.unit) end)

-- 目标和焦点名字背景透明
FocusFrameNameBackground:SetTexture()
TargetFrameNameBackground:SetTexture()

-- 目标身上来源为自己的Debuff放大
local function TargetFrame_UpdateDebuffAnchor_OnHook(_, frame, index)
    local _, _, _, _, _, _, source = UnitAura("target", index, "HARMFUL")
    if (source and source == "player") then
        _G[frame .. index]:SetSize(28, 28)
    end
end

hooksecurefunc("TargetFrame_UpdateDebuffAnchor",
               TargetFrame_UpdateDebuffAnchor_OnHook)

-- 目标身上来源为自己的Buff放大
local function TargetFrame_UpdateBuffAnchor_OnHook(_, frame, index)
    local _, _, _, _, _, _, source = UnitAura("target", index)
    if (source and source == "player") then
        _G[frame .. index]:SetSize(28, 28)
    end
end

hooksecurefunc("TargetFrame_UpdateBuffAnchor",
               TargetFrame_UpdateBuffAnchor_OnHook)

-- 显示Buff来源
local function UNIT_AURA_OnHooK(self, unit, buffIndex, filter)
    if unit and buffIndex then
        local _, _, _, _, _, _, source, _, _, _, _, _, castByPlayer =
            UnitAura(unit, buffIndex, filter)
        if source then
            local name = GetUnitName(source)
            if name then
                GameTooltip:AddLine("")
                local r, g, b
                if castByPlayer then
                    local class = UnitClassBase(source)
                    if class then
                        r, g, b = GetClassColor(class)
                    end
                end
                GameTooltip:AddDoubleLine("法术来源：", name, 1, 0.82, 0,
                                          r or 1, g or 1, b or 1)
                GameTooltip:Show()
            end
        end
    end
end

local function UNIT_BUFF_OnHooK(self, unit, buffIndex)
    if unit and buffIndex then
        local _, _, _, _, _, _, source, _, _, _, _, _, castByPlayer =
            UnitAura(unit, buffIndex)
        if source then
            local name = GetUnitName(source)
            if name then
                GameTooltip:AddLine("")
                local r, g, b
                if castByPlayer then
                    local class = UnitClassBase(source)
                    if class then
                        r, g, b = GetClassColor(class)
                    end
                end
                GameTooltip:AddDoubleLine("增益来源：", name, 1, 0.82, 0,
                                          r or 1, g or 1, b or 1)
                GameTooltip:Show()
            end
        end
    end
end

local function UNIT_DEBUFF_OnHooK(self, unit, buffIndex)
    if unit and buffIndex then
        local _, _, _, _, _, _, source, _, _, _, _, _, castByPlayer =
            UnitAura(unit, buffIndex, "HARMFUL")
        if source then
            local name = GetUnitName(source)
            if name then
                GameTooltip:AddLine("")
                local r, g, b
                if castByPlayer then
                    local class = UnitClassBase(source)
                    if class then
                        r, g, b = GetClassColor(class)
                    end
                end
                GameTooltip:AddDoubleLine("减益来源：", name, 1, 0.82, 0,
                                          r or 1, g or 1, b or 1)
                GameTooltip:Show()
            end
        end
    end
end

hooksecurefunc(GameTooltip, "SetUnitBuff", UNIT_BUFF_OnHooK)
hooksecurefunc(GameTooltip, "SetUnitDebuff", UNIT_DEBUFF_OnHooK)
hooksecurefunc(GameTooltip, "SetUnitAura", UNIT_AURA_OnHooK)

-- 宠物生命值和资源可见性优化
local function TextStatusBar_UpdateTextStringWithValues_OnHook(statusFrame,
                                                               textString,
                                                               value, valueMin,
                                                               valueMax)
    if (statusFrame and PetFrameHealthBar and PetFrameManaBar and
        (statusFrame == PetFrameHealthBar or statusFrame == PetFrameManaBar) and
        statusFrame.TextString) then
        if statusFrame.LeftText then statusFrame.LeftText:Hide() end
        if statusFrame.RightText then statusFrame.RightText:Hide() end
        local valueDisplay
        if value < 1e4 then
            valueDisplay = ('%d'):format(value)
        else
            valueDisplay = ('%.2f万'):format(value / 1e4)
        end
        statusFrame.TextString:SetText(valueDisplay)
        statusFrame.TextString:Show()
    end
end

hooksecurefunc("TextStatusBar_UpdateTextStringWithValues",
               TextStatusBar_UpdateTextStringWithValues_OnHook)
