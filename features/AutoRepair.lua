local addonName,SpaUI = ...

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
                    print(format("|cfff07100公会修理花费: %s|r",
                                 GetCoinTextureString(cost)))
                    return
                end
            end
            if money > cost then
                RepairAllItems()
                print(format("|cffead000修理花费: %s|r",
                             GetCoinTextureString(cost)))
            else
                print("你没钱，穷逼！")
            end
        end
    end
end

SpaUI:RegisterEvent('MERCHANT_SHOW',AutoRepair)