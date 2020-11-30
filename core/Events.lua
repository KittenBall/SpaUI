local addonName,SpaUI = ...

local L = SpaUI.Localization

-- 事件收发
SpaUI.EventListener:SetScript("OnEvent", function(self, event, ...)
    if SpaUI.Events and SpaUI.Events[event] then
        local len = #SpaUI.Events[event]
        local consumed
        for i = 1, len do
            local handler = SpaUI.Events[event][i]
            -- 如果事件处理函数返回真，则认为消费了该事件，将该处理函数移除
            -- 这对某些满足条件后不再需要事件回调的函数很有用，提供了自动注销的功能
            if handler and SpaUI.Events[event][i](event, ...) then
                if not consumed then consumed = {} end
                tinsert(consumed, handler)
            end
        end
        -- 移除所有消费了的函数
        if consumed then
            for i = 1, #consumed do
                SpaUI:UnregisterEvent(event, consumed[i])
            end
        end
    end

    if SpaUI.OnceEvents and SpaUI.OnceEvents[event] then
        -- 回调仅通知一次的事件
        len = #SpaUI.OnceEvents[event]
        for i = 1, len do
            if SpaUI.OnceEvents[event][i] then
                SpaUI.OnceEvents[event][i](event, ...)
            end
        end
        SpaUI.OnceEvents[event] = nil

        -- 仅通知一次的事件回调完毕后，如果没有该事件没有持久注册，则注销该事件监听
        if not SpaUI.Events or not SpaUI.Events[event] or #SpaUI.Events[event] ==
            0 then self:UnregisterEvent(event) end
    end

end)

-- 注册事件，handler返回的第一个值如果为真，则该监听会自动注销
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

-- 注册事件，针对该事件仅通知一次，不提供注销方法
function SpaUI:CallbackOnce(event, handler)
    if not event or not handler or type(handler) ~= "function" then return end
    if not self.EventListener then return end
    if not self.EventListener:IsEventRegistered(event) then
        self.EventListener:RegisterEvent(event)
    end
    if not self.OnceEvents then self.OnceEvents = {} end
    if not self.OnceEvents[event] then self.OnceEvents[event] = {} end
    local len = #self.OnceEvents[event]
    for i = 1, len do if self.OnceEvents[event][i] == handler then return end end
    tinsert(self.OnceEvents[event], handler)
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
