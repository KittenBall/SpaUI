-- Castbar timer from thek 施法条计时器
CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
CastingBarFrame.timer:SetFont("Fonts\\ARIALN.ttf", 8, "THINOUTLINE")
CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "RIGHT", 0, 2)
CastingBarFrame.update = .1

local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
    if not self.timer then return end
    if self.update and self.update < elapsed then
        if self.casting then
            self.timer:SetText(format("%.1f/%.1f",
                                      max(self.maxValue - self.value, 0),
                                      self.maxValue))
        elseif self.channeling then
            self.timer:SetText(format("%.1f/%.1f", max(self.value, 0),
                                      self.maxValue))
        else
            self.timer:SetText("")
        end
        self.update = .1
    else
        self.update = self.update - elapsed
    end
end

CastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)