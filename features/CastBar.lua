-- 施法条显示进度
-- 自身
CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil, nil)
CastingBarFrame.timer:SetFont("Fonts\\ARIALN.ttf", 8, "THINOUTLINE")
if PLAYER_FRAME_CASTBARS_SHOWN then
    CastingBarFrame.timer:SetPoint("LEFT", CastingBarFrame, "RIGHT", 1, 0)
else
    CastingBarFrame.timer:SetPoint("TOPRIGHT", CastingBarFrame, "BOTTOMRIGHT", 0, -2)
end
CastingBarFrame.update = .1
CastingBarFrame.lag = CastingBarFrame:CreateTexture(nil, "BACKGROUND")
CastingBarFrame.lag:SetPoint("RIGHT", CastingBarFrame, "RIGHT", -1, 0)
CastingBarFrame.lag:SetWidth(0)
CastingBarFrame.lag:SetHeight(CastingBarFrame:GetHeight())
CastingBarFrame.lag:SetColorTexture(1, 0, 0, 1)

-- 目标
TargetFrameSpellBar.timer = CastingBarFrame:CreateFontString(nil, nil)
TargetFrameSpellBar.timer:SetFont("Fonts\\ARIALN.ttf", 8, "THINOUTLINE")
TargetFrameSpellBar.timer:SetPoint("LEFT", TargetFrameSpellBar, "RIGHT", 1, 0)
TargetFrameSpellBar.update = .1

-- 焦点
FocusFrameSpellBar.timer = CastingBarFrame:CreateFontString(nil, nil)
FocusFrameSpellBar.timer:SetFont("Fonts\\ARIALN.ttf", 8, "THINOUTLINE")
FocusFrameSpellBar.timer:SetPoint("LEFT", FocusFrameSpellBar, "RIGHT", 1, 0)
FocusFrameSpellBar.update = .1

local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
    if not self.timer then return end
    if self.update and self.update < elapsed then
        if self.casting then
            if self.lag then
                local _, _, world = GetNetStats()
                if world and world > 0 then
                    local min, max = self:GetMinMaxValues();
                    local rate = (world / 1000) / (max - min);
                    if (rate < 0) then
                        rate = 0;
                    elseif (rate > 1) then
                        rate = 1
                    end
                    self.lag:SetWidth(self:GetWidth() * rate)
                else
                    self.lag:SetWidth(0)
                end
            end
            self.timer:SetText(format("%.1f/%.1f",
                                      max(self.maxValue - self.value, 0),
                                      self.maxValue))
        elseif self.channeling then
            self.timer:SetText(format("%.1f/%.1f", max(self.value, 0),
                                      self.maxValue))
            if self.lag then self.lag:SetWidth(0) end
        else
            self.timer:SetText("")
            if self.lag then self.lag:SetWidth(0) end
        end
        self.update = .1
    else
        self.update = self.update - elapsed
    end
end

CastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
TargetFrameSpellBar:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
FocusFrameSpellBar:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)

-- 头像下方显示施法条可见性优化
local function PlayerFrame_AttachCastBar_OnHook()
    if not CastingBarFrame.timer then return end
    CastingBarFrame.timer:ClearAllPoints()
    CastingBarFrame.timer:SetPoint("LEFT", CastingBarFrame, "RIGHT", 1, 0)
end

local function PlayerFrame_DetachCastBar_OnHook()
    if not CastingBarFrame.timer then return end
    CastingBarFrame.timer:ClearAllPoints()
    CastingBarFrame.timer:SetPoint("TOPRIGHT", CastingBarFrame, "BOTTOMRIGHT", 0, -2)
end

hooksecurefunc("PlayerFrame_AttachCastBar", PlayerFrame_AttachCastBar_OnHook)
hooksecurefunc("PlayerFrame_DetachCastBar", PlayerFrame_DetachCastBar_OnHook)

-- 疲劳、呼吸、假死条等
local function CreateMirrorTimerFrameDuration(frame)
    if not frame then return end
    local statusbar = _G[frame:GetName() .. "StatusBar"]
    if statusbar then
        frame.duration = frame:CreateFontString(nil)
        frame.duration:SetFont("Fonts\\ARIALN.ttf", 10, "THINOUTLINE")
        frame.duration:SetPoint("RIGHT", statusbar, "RIGHT", -1, 2)
    end
end

local function MirrorTimerFrame_OnUpdate_Hook(frame, elapsed)
    if frame.refreshTimer and frame.refreshTimer > 0.1 then
        frame.refreshTimer = 0
        if not frame.duration then CreateMirrorTimerFrameDuration(frame) end
        frame.duration:SetText(ceil(frame.value))
    else
        frame.refreshTimer = (frame.refreshTimer or 0) + elapsed
    end
end

hooksecurefunc("MirrorTimerFrame_OnUpdate", MirrorTimerFrame_OnUpdate_Hook)
