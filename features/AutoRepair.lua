local addonName, SpaUI = ...

local L = SpaUI.Localization

-- 自动修理
local function AutoRepair()
    if CanMerchantRepair() then
        local cost = GetRepairAllCost()
        if cost > 0 then
            local money = GetMoney()
            if IsInGuild() then
                local guildMoney = GetGuildBankWithdrawMoney()
                if guildMoney > GetGuildBankMoney() then
                    guildMoney = GetGuildBankMoney()
                end
                if guildMoney > cost and CanGuildBankRepair() then
                    RepairAllItems(1)
                    print(format(L["auto_repair_guild_cost"],
                                 GetCoinTextureString(cost)))
                    return
                end
            end
            if money > cost then
                RepairAllItems()
                print(format(L["auto_repair_cost"], GetCoinTextureString(cost)))
            else
                SpaUI:ShowUIError(L["auto_repair_no_money"])
            end
        end
    end
end

SpaUI:RegisterEvent('MERCHANT_SHOW', AutoRepair)
