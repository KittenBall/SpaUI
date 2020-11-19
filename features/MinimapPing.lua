local addonName, SpaUI = ...

local function OnMinimapPing(...) print(...) end

local function MinimapPingTipInitlize()
    //todo
end

SpaUI:RegisterEvent('MINIMAP_PING', OnMinimapPing)
