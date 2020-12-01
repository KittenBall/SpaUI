-- 来源于插件开发教程及翻译 https://bbs.nga.cn/read.php?tid=24295645
local addonName, SpaUI = ...

local L = SpaUI.Localization

local function ShowTooltip(frame, link)
    if link then
        local type = strsplit(":", link)
        if type == "item" or type == "spell" or type == "enchant" or type ==
            "quest" or type == "talent" or type == "glyph" or type == "unit" or
            type == "achievement" then
            GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end
    end
end

local function hideTooltip(frame,link) 
    GameTooltip:Hide()
end

local function SetOrHookHandler(frame, script, func)
    if frame:GetScript(script) then
        frame:HookScript(script, func)
    else
        frame:SetScript(script, func)
    end
end

for i = 1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame" .. i]
    if frame ~= COMBATLOG then
        SetOrHookHandler(frame, "OnHyperLinkEnter", ShowTooltip)
        SetOrHookHandler(frame, "OnHyperLinkLeave", hideTooltip)
    end
end
