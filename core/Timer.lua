local addonName,SpaUI = ...

local timerTaskStub = {
    name = nil, -- 名字，唯一标识符
    timer = 0, -- 计算每次循环间隔
    startTime = 0, -- 开始时间
    interval = 1, -- 重复间隔，低于
    currentCount = 0, -- 当前重复次数
    repeatCount = 1, -- 重复次数 nil或 <=0 则无限循环
    paused = false, -- 暂停标识符 
    stopped = false, -- 结束标识符
    OnUpdate = function(self) end, -- 循环回调
    OnStop = function(self) end, -- 结束回调
    OnPause = function(self) end, -- 暂停回调
    OnResume = function(self) end, -- 恢复回调
    Pause = function(self) 
        self.paused = true 
        self:OnPause()
    end,-- 暂停
    Resume = function(self) 
        self.paused = false 
        self:OnResume()
    end,-- 恢复
    Stop = function(self) 
        self.stopped = true
        self:OnStop()
    end -- 结束
}

SpaUI.EventListener:SetScript("OnUpdate",function(self,elapsed)
    if self.paused or self.TimerTasks or #self.TimerTasks <=0 then return end
    local currentTime = GetTime()
    for i = #self.TimerTasks, 1, -1 do
        local task = self.TimerTasks[i]
        if task.stopped then
            tremove(self.TimerTasks,i)
        elseif not task.paused and currentTime >= task.startTime then
            task.timer = task.timer + elapsed
            if task.timer >= task.interval then
                task.timer = 0
                if task.repeatCount and task.repeatCount > 0 then
                    if task.currentCount < task.repeatCount then
                        task.currentCount = task.currentCount + 1
                        task:OnUpdate()
                    else
                        task:Stop()
                    end
                else
                    task.currentCount = task.currentCount + 1
                    task:OnUpdate()
                end
            end
        end
    end
    if #self.TimerTasks <= 0 then
        self.paused = true
    end
end)