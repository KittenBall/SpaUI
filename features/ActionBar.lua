
-- 动作条超出距离变红
hooksecurefunc("ActionButton_UpdateRangeIndicator",
               function(self, checksRange, inRange)
    if self.action == nil then return end
    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if (checksRange and not inRange) then
        _G[self:GetName() .. "Icon"]:SetVertexColor(0.5, 0.1, 0.1)
    elseif isUsable ~= true or notEnoughMana == true then
        _G[self:GetName() .. "Icon"]:SetVertexColor(0.4, 0.4, 0.4)
    else
        _G[self:GetName() .. "Icon"]:SetVertexColor(1, 1, 1)
    end
end)
