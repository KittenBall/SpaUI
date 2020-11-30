local addonName, SpaUI = ...

local L = SpaUI.Localization

local Debug = true

print(L["addon_loaded_tip"]:format(GetAddOnMetadata(addonName, "Version")))

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SpaUI.EventListener = CreateFrame("Frame", "SpaUIEventListener")

function SpaUI:Log(msg)
    if not Debug then return end
    print(L["debug_format"]:format(msg))
end

function SpaUI:Log(msg, ...)
    if not Debug then return end
    print(L["debug_format"]:format(msg), ...)
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