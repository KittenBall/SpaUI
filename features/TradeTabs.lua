-- 参考了NDUI
local addonName,SpaUI = ...
local Widget = SpaUI.Widget
local GetSpellCooldown,CastSpell,IsCurrentSpell = GetSpellCooldown,CastSpell,IsCurrentSpell

-- 需要去重的专业技能
local SkillLineNeedDistinct = {
	[171] = true, -- 炼金
	[202] = true, -- 工程
	[182] = true, -- 草药
	[393] = true, -- 剥皮
	[356] = true, -- 钓鱼
}

local function AddSpellOffsetNeededShow(table,professionIndex)
    if not professionIndex then return end 
    
    local _,_,_,_,numAbilities,spellOffset,skillLine = GetProfessionInfo(professionIndex)
    numAbilities = SkillLineNeedDistinct[skillLine] and 1 or numAbilities
    if numAbilities > 0 then   
        for i=1, numAbilities do
            tinsert(table,spellOffset+i)
        end
    end
end

local function AddSpellInfo(infos,name,icon,spellID,slotID,canCastSpellDirect)
    local info = {}
    info.name = name
    info.icon = icon
    info.spellID = spellID
    info.slotID = slotID
    info.canCastSpellDirect = canCastSpellDirect
    tinsert(infos,info)
end

local function SetTradeTab(tab)
    local spellInfo = tab.spellInfo
    local name,icon,slotID,canCastSpellDirect = spellInfo.name,spellInfo.icon,spellInfo.slotID,spellInfo.canCastSpellDirect
    tab.Icon:SetTexture(icon)
    tab:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:SetSpellBookItem(slotID,BOOKTYPE_PROFESSION)
        GameTooltip:Show()
    end)
    tab:SetScript("OnLeave",function(self)
        GameTooltip:Hide()
    end)

    if canCastSpellDirect then
        tab:SetScript("OnClick",function(self)
            CastSpell(slotID,BOOKTYPE_PROFESSION)
        end)
    else
        tab:SetAttribute("type","spell")
        tab:SetAttribute("spell",name)
    end
    
    tab.cooldown = CreateFrame("Cooldown", nil, tab, "CooldownFrameTemplate")
	tab.cooldown:SetAllPoints()

    tab.cover = CreateFrame("Frame", nil, tab)
	tab.cover:SetAllPoints()
	tab.cover:EnableMouse(true)
end

local function UpdateTradeTab()
    if not Widget.TradeTabs then
        return
    end
    for _,tab in pairs(Widget.TradeTabs) do
        local spellID = tab.spellInfo.spellID
        if IsCurrentSpell(spellID) then 
            tab:SetChecked(true)
            tab.cover:Show()
        else
            tab:SetChecked(false)
            tab.cover:Hide()
        end
        local start,duration = GetSpellCooldown(spellID)
        if start and duration and duration>1.5 then
            tab.cooldown:SetCooldown(start,duration)
        end
    end
end

-- 创建Trade Tab
local function CreateTradeTabs(spellInfos)
    if not TradeSkillFrame then
        return
    end
    local tabContainer = CreateFrame("Frame","SpaUITradeTabContainer",TradeSkillFrame)
    tabContainer:SetWidth(50)
    tabContainer:SetPoint("LEFT",TradeSkillFrame,"RIGHT")
    tabContainer:SetPoint("TOP",TradeSkillFrame,"TOP")
    tabContainer:SetPoint("BOTTOM",TradeSkillFrame,"BOTTOM")
    tabContainer:SetScript("OnLoad",UpdateTradeTab)
    tabContainer:SetScript("OnShow",function(self)
        self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
        UpdateTradeTab()
    end)
    tabContainer:SetScript("OnHide",function(self)
        self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
    end)
    tabContainer:SetScript("OnEvent",function ()
        UpdateTradeTab()
    end)

    Widget.TradeTabs = {}
    for i=1,#spellInfos do
        local spellInfo = spellInfos[i]
        local tab = CreateFrame("CheckButton",nil,tabContainer,"TradeTabsTemplate,SecureActionButtonTemplate")
        tab.spellInfo = spellInfo
        tab:SetPoint("LEFT")
        tab:SetPoint("TOP",tabContainer,0,-i*50)
        SetTradeTab(tab)
        tinsert(Widget.TradeTabs,tab)
    end
    tabContainer:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
    UpdateTradeTab()
end

local function TradeTabsInitialization()
    local prof1,prof2,_,fishing,cooking = GetProfessions()
    local spellOffsets = {}
    AddSpellOffsetNeededShow(spellOffsets,prof1)
    AddSpellOffsetNeededShow(spellOffsets,prof2)
    AddSpellOffsetNeededShow(spellOffsets,cooking)
    AddSpellOffsetNeededShow(spellOffsets,fishing)
    local spellInfos = {}
    for i=1,#spellOffsets do
        local spellOffset = spellOffsets[i]
        local name, _, icon, _, _, _, spellID = GetSpellInfo(spellOffset,"spell")
        local passive = IsPassiveSpell(spellOffset,BOOKTYPE_PROFESSION)
        if not passive then
            AddSpellInfo(spellInfos,name,icon,spellID,spellOffset,i==1)
        end
    end
    if #spellInfos>0 then   
        CreateTradeTabs(spellInfos)
    end
end

SpaUI:CallbackOnce('TRADE_SKILL_SHOW',TradeTabsInitialization)