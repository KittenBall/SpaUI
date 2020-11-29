local addonName, SpaUI = ...

local L = SpaUI.Localization

-- 自动修理
local function AutoRepair()
    if CanMerchantRepair() then
        local cost , canRepair = GetRepairAllCost()
        if canRepair then
            if IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= cost then
                RepairAllItems(true)
                print(format(L["auto_repair_guild_cost"],
                             GetCoinTextureString(cost)))
            else
                if cost <= GetMoney() then
                    RepairAllItems()
                    print(format(L["auto_repair_cost"], GetCoinTextureString(cost)))
                else
                    SpaUI:ShowUIError(L["auto_repair_no_money"])
                end
            end
        end
    end
end

SpaUI:RegisterEvent('MERCHANT_SHOW', AutoRepair)
