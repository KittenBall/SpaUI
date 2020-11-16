-- 显示分格线
SLASH_EA1 = "/align"

local AlignFrame

SlashCmdList["EA"] = function()
	if AlignFrame then
		AlignFrame:Hide()
		AlignFrame = nil		
	else
		AlignFrame = CreateFrame('Frame', nil, UIParent) 
		AlignFrame:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', AlignFrame, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', AlignFrame, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local t = AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', AlignFrame, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', AlignFrame, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end