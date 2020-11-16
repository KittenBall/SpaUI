local addonName, SpaUI = ...

print(addonName.."已载入")

SpaUI.EventListener = CreateFrame("Frame", "SpaUIEventListener")
SpaUI.EventListener:SetScript("OnEvent", function(self,event,...)
    if not SpaUI.Events or not SpaUI.Events[event] then return end
    local len = #SpaUI.Events[event]
    for i = 1, len do
        if SpaUI.Events[event][i] then SpaUI.Events[event][i](event, ...) end
    end
end)

-- 注册事件
function SpaUI:RegisterEvent(event, handler)
    if not event or not handler or type(handler) ~= "function" then return end
    if not self.EventListener then return end
    if not self.EventListener:IsEventRegistered(event) then
        self.EventListener:RegisterEvent(event)
    end
    if not self.Events then self.Events = {} end
    if not self.Events[event] then self.Events[event] = {} end
    local len = #self.Events[event]
    for i = 1, len do if self.Events[event][i] == handler then return end end
    tinsert(self.Events[event], handler)
end

-- 注销事件
function SpaUI:UnregisterEvent(event)
    if not event then return end
    if not self.EventListener then return end
    self.EventListener:UnregisterEvent(event)
    if self.Events then self.Events[event] = nil end
end

-- 注销某事件的某个回调
function SpaUI:UnregisterEvent(event, handler)
    if not event or not handler or type(handler) ~= "function" then return end
    if not self.EventListener then return end
    if self.Events and self.Events[event] then
        local len = #self.Events[event]
        for i = 1, len do
            if self.Events[event][i] == handler then
                tremove(self.Events[event], i)
                break
            end
        end
        len = #self.Events[event]
        if len == 0 then
            self.Events[event] = nil
            self.EventListener:UnregisterEvent(event)
        end
    end
end

-- 注销全部事件
function SpaUI:UnregisterAllEvents()
    if not self.EventListener then return end
    self.EventListener:UnregisterAllEvents()
    self.Events = nil
end
