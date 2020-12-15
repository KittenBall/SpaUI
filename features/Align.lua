local addonName,SpaUI = ...
local Widget = SpaUI.Widget

function Widget:ToggleAlign()
	if Widget.AlignFrame then
		Widget.AlignFrame:Hide()
		Widget.AlignFrame = nil		
	else
		Widget.AlignFrame = CreateFrame('Frame', nil, UIParent) 
		Widget.AlignFrame:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = Widget.AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', Widget.AlignFrame, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', Widget.AlignFrame, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local t = Widget.AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', Widget.AlignFrame, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', Widget.AlignFrame, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end