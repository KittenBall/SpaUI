local addonName,SpaUI = ...

-- 自动卖店
local function AutoSell()
    local total = 0
    for container = 0, 4 do
        local slotNum = GetContainerNumSlots(container)
        for slot = 1, slotNum do
            local link = GetContainerItemLink(container, slot)
            -- item quality == 0 (poor) 
            if link and select(3, GetItemInfo(link)) == 0 then
                -- vendor price per each * stack number 
                local price = select(11, GetItemInfo(link)) *
                                  select(2,
                                         GetContainerItemInfo(container, slot))
                if price > 0 then
                    UseContainerItem(container, slot)
                    PickupMerchantItem()
                    total = total + price
                    print(string.format("%s卖出了%s", link,
                                        GetCoinTextureString(price)))
                end
            end
        end
    end

    if total > 0 then
        print(string.format("共获得收入%s", GetCoinTextureString(total)))
    end
end

SpaUI:RegisterEvent('MERCHANT_SHOW',AutoSell)