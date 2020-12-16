local addonName, SpaUI = ...

local L = SpaUI.Localization
local LocalEvents = SpaUI.LocalEvents

function SpaUI:Log(...)
    if SpaUIConfigDB.IsDebug then
        print(L["debug_format"],...)
    end
end

-- 通过本地化的职业名称获取职业枚举 比如：法师->MAGE
function SpaUI:GetClassFileByLocalizedClassName(localizedClassName)
    if not SpaUI.ClassFileToLocalizedClassMap then
        SpaUI.ClassFileToLocalizedClassMap = {}
        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
            SpaUI.ClassFileToLocalizedClassMap[v] = k
        end
    end
    return SpaUI.ClassFileToLocalizedClassMap[localizedClassName]
end

-- 显示红字错误
function SpaUI:ShowUIError(string)
    UIErrorsFrame:AddMessage(string, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
function SpaUI:ShowMessage(string)
    print(L["message_format"]:format(string))
end

-- SpaUI初始化完成
local function OnSpaUIInitialization(event,name)
    if name ~= addonName then return end
    SpaUIConfigDB = SpaUIConfigDB or {}
    SpaUIConfigDBPC = SpaUIConfigDBPC or {}
    print(L["addon_loaded_tip"]:format(GetAddOnMetadata(addonName, "Version")))
    SpaUI:PostLocalEvent(LocalEvents.ADDON_INITIALIZATION)
    return ture
end

SpaUI:RegisterEvent('ADDON_LOADED',OnSpaUIInitialization)