-- 参考自SUI
local addonName, SpaUI = ...
local L = SpaUI.Localization
local Widget = SpaUI.Widget

local ALPHA_ENTER = 0.4
local ALPHA_LEAVE = 0.2

local function MessageIsProtected(message)
    return strmatch(message, '[^|]-|K[vq]%d-[^|]-|k')
end

local function OnCopyFrameShow()
    local ChatFrame = SELECTED_CHAT_FRAME
    if ChatFrame then
        local fontPath,height,flag = ChatFrame:GetFont()
        Widget.CopyFrame.EditBox:SetFont(fontPath,height,flag)
        local text = ""
        for i = 1, ChatFrame:GetNumMessages() do
            local line = ChatFrame:GetMessageInfo(i)
            if not MessageIsProtected(line) and line:len()>0 then 
                if text:len()>0 then text = text.."\n" end
                text = text..line
                text = text:gsub("|T[^\\]+\\[^\\]+\\[Uu][Ii]%-[Rr][Aa][Ii][Dd][Tt][Aa][Rr][Gg][Ee][Tt][Ii][Nn][Gg][Ii][Cc][Oo][Nn]_(%d)[^|]+|t", "{rt%1}")
                text = text:gsub("|T13700([1-8])[^|]+|t", "{rt%1}")
                text = text:gsub("|T[^|]+|t", "")
            end
        end
        Widget.CopyFrame.EditBox:SetText(text)
    end
end

-- 创建复制窗口
function Widget:CreateCopyFrame()
    if self.CopyFrame then return end
    local CopyFrame = CreateFrame("Frame", "SpaUICopyFrame",UIParent, "SpaUIBasicScrollFrameTemplate")
    CopyFrame:SetSize(500,600)
    CopyFrame.TitleText:SetText(L["chat_copy_dialog_title"])
    self.CopyFrame = CopyFrame

    -- 创建EditBox
    local CopyEditBox = CreateFrame("EditBox", "SpaUICopyEditBox", CopyFrame)
    CopyEditBox:SetMultiLine(true)
    CopyEditBox:SetMaxLetters(99999)
    CopyEditBox:EnableMouse(true)
    CopyEditBox:SetAutoFocus(false)
    CopyEditBox:SetFontObject(ChatFontNormal)
    CopyEditBox:SetWidth(CopyFrame.Container:GetWidth()-CopyFrame.Container.ScrollBar:GetWidth()-5)
    CopyEditBox:SetScript("OnEscapePressed",function() CopyFrame:Hide()end)
    CopyFrame.EditBox = CopyEditBox
    CopyFrame.Container:SetScrollChild(CopyEditBox)

    CopyFrame:SetScript("OnShow",OnCopyFrameShow)
    OnCopyFrameShow()
end

function Widget:ToggleCopyFrame()
    local CopyFrame = self.CopyFrame
    if not CopyFrame then
        self:CreateCopyFrame()
    else
        if CopyFrame:IsShown() then
            CopyFrame:Hide()
        else
            CopyFrame:Show()
        end
    end
end

-- 创建复制按钮
local function CreateCopyButton()
    local CopyButton = CreateFrame("Button","SpaUICopyButton",UIParent)
    CopyButton:SetWidth(18)
    CopyButton:SetHeight(18)
    CopyButton:SetAlpha(ALPHA_LEAVE)
    CopyButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT")
    CopyButton:SetNormalTexture("Interface\\Addons\\SpaUI\\Media\\copy")
    CopyButton:SetHighlightTexture("Interface\\Addons\\SpaUI\\Media\\copy_highlight")
    CopyButton:SetPushedTexture("Interface\\Addons\\SpaUI\\Media\\copy_pressed")
    CopyButton:SetScript("OnEnter",function(self) self:SetAlpha(ALPHA_ENTER) end)
    CopyButton:SetScript("OnLeave",function(self) self:SetAlpha(ALPHA_LEAVE) end)
    CopyButton:SetScript("OnClick",function() Widget:ToggleCopyFrame() end)
    Widget.CopyButton = CopyButton
end

SpaUI:CallbackOnce('PLAYER_LOGIN',CreateCopyButton)