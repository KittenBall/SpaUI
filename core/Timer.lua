local addonName,SpaUI = ...

-- 期望最低帧数
local FPS = 30

local TimerTaskStub = {
    name = nil, -- 名字，唯一标识符
    timer = 0, -- 计算每次循环间隔
    startTime = 0, -- 开始时间
    interval = 1, -- 重复间隔，低于期望帧数会被矫正
    currentCount = 0, -- 当前重复次数
    repeatCount = 1, -- 重复次数 <=0 则无限循环
    paused = false, -- 暂停标识符 不要直接在本文件外更改其状态，请调用Pause方法！
    stopped = false, -- 结束标识符 不要直接在本文件外更改其状态，请调用Stop方法！
    OnUpdate = function(self) end, -- 循环回调
    OnStop = function(self) end, -- 结束回调
    OnPause = function(self) end, -- 暂停回调
    OnResume = function(self) end, -- 恢复回调
    OnReStart = function(self) end, -- 重新开始
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
    end, -- 结束
    ReStart = function (self)
        self.currentCount = 0
        self.stopped = false
        self.paused = false
        self.timer = self.interval
        self:OnReStart()
    end,-- 重新开始
    IsPaused = function(self)
        return self.paused
    end,-- 是否暂停
    IsStopped = function(self)
        return self.stopped
    end, --是否结束
    GetName = function(self)
        return self.name
    end
}

SpaUI.EventListener:SetScript("OnUpdate",function(self,elapsed)
    if self.paused or not SpaUI.TimerTasks or #SpaUI.TimerTasks <=0 then return end
    local currentTime = GetTime()
    for i = #SpaUI.TimerTasks, 1, -1 do
        local task = SpaUI.TimerTasks[i]
        if task.stopped then
            tremove(SpaUI.TimerTasks,i)
        elseif not task.paused and currentTime >= task.startTime then
            task.timer = task.timer + elapsed
            if task.timer >= task.interval then
                task.timer = 0
                if task.repeatCount and task.repeatCount > 0 then
                    if task.currentCount < task.repeatCount then
                        task.currentCount = task.currentCount + 1
                        task:OnUpdate()
                    end    
                    if task.currentCount >= task.repeatCount then
                        task.stopped = true
                        task:OnStop()
                   end 
                else
                    task.currentCount = task.currentCount + 1
                    task:OnUpdate()
                end
            end
        end
    end

    -- 队列里没有任务，暂停
    if #SpaUI.TimerTasks <= 0 then
        self.paused = true
    end
end)

-- 设置默认值
local function SetTimerTaskStub(timerTask)
    setmetatable(timerTask,{
        __index = function(self,key)
            local value = TimerTaskStub[key]
            self[key] = value
            return value
        end
    })
end

-- 添加定时任务
-- autoReStart:如果为true，则如果有同名任务，则其ReStart，否则将其Stop，然后将timerTask加入队列
function SpaUI:AddTimerTask(timerTask,autoReStart)
    assert(timerTask, "TimerTask can not be nil!")
    assert(timerTask.name, "TimerTask.name can not be nil")

    if not SpaUI.TimerTasks then 
        SpaUI.TimerTasks = {}
    end

    if autoReStart then
        for i,v in ipairs(SpaUI.TimerTasks) do
            if timerTask.name == v.name then
                return v:ReStart()
            end
        end
    else
        for i,v in ipairs(SpaUI.TimerTasks) do
            if timerTask.name == v.name then
                v:Stop()
            end
        end
    end

    SetTimerTaskStub(timerTask)
    local ms = 1/FPS
    if not timerTask.interval or timerTask.interval < ms then
        timerTask.interval = ms
    end
    -- 重要，否则需要过一次interval的时间后才会第一次回调
    timerTask.timer = timerTask.interval
    tinsert(SpaUI.TimerTasks,timerTask)
    SpaUI.EventListener.paused = false
end

-- 延迟delay(s)后开始任务，仅回调一次
function SpaUI:Delay(name,delay,onUpdate)
    local task = {}
    task.name = name
    task.startTime = GetTime() + delay
    task.OnUpdate = onUpdate
    self:AddTimerTask(task)
end

-- 延迟delay(s)后开始任务，回调repeatCount次
function SpaUI:Schedule(name,delay,interval,repeatCount,onUpdate)
    local task = {}
    task.name = name
    task.startTime = GetTime() + delay
    task.interval = interval
    task.repeatCount = repeatCount
    task.OnUpdate = onUpdate
    self:AddTimerTask(task)
end

function SpaUI:GetTimerTask(name)
    if not name then return end
    if not SpaUI.TimerTasks then
        SpaUI.TimerTasks = {}
    end
    for _,task in ipairs(SpaUI.TimerTasks) do
        if task.name == name then
            return task
        end
    end
end