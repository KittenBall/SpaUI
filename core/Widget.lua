local addonName, SpaUI = ...


local DEFAULT_LINE_COLOR_R = 105
local DEFAULT_LINE_COLOR_G = 105
local DEFAULT_LINE_COLOR_B = 105
local DEFAULT_LINE_COLOR_A = 255
local DEFAULT_LINE_COLOR = "696969"
local DEFAULT_VERTICAL_LINE_WIDTH = 1
local DEFAULT_HORIZONTAL_LINE_HEIGHT = 1

-- RGB颜色转16进制
function SpaUI:RGBToHex(r, g, b)
    r = r <= 255 and r >= 0 and r or 0
    g = g <= 255 and g >= 0 and g or 0
    b = b <= 255 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r, g, b)
end

-- 字符串颜色格式化
-- return non nil
function SpaUI:formatColorTextByRGB(text, r, g, b)
    if not text then return "" end
    r = r <= 255 and r >= 0 and r or 0
    g = g <= 255 and g >= 0 and g or 0
    b = b <= 255 and b >= 0 and b or 0
    return string.format("\124cff%02x%02x%02x%s\124r", r, g, b, text)
end

-- RGB颜色(百分比)转16进制
function SpaUI:RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- 字符串颜色格式化
-- return non nil
function SpaUI:formatColorTextByRGBPerc(text, r, g, b)
    if not text then return "" end
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("\124cff%02x%02x%02x%s\124r", r * 255, g * 255, b * 255 , text)
end

-- 
local function RGBToPerc(r,g,b)
    r = r <= 255 and r >=0 and r/255 or 0
    g = g <= 255 and g >= 0 and g/255 or 0
    b = b <= 255 and b >=0 and b/255 or 0
    return r, g, b
end

-- 创建水平线
-- parent 父控件
-- width 宽 可以不传，默认为0
-- height 高，可以不传，默认为1
-- r,g,b 可以不传
function SpaUI:CreateHorizontalLine(parent, width, height, r, g, b, a)
    if parent then
        local line = parent:CreateTexture()
        line:SetHeight(height or DEFAULT_HORIZONTAL_LINE_HEIGHT)
        line:SetWidth(width or 0)
        r,g,b = RGBToPerc(r or DEFAULT_LINE_COLOR_R, g or DEFAULT_LINE_COLOR_G, b or DEFAULT_LINE_COLOR_B)
        line:SetColorTexture(r,g,b, a or DEFAULT_LINE_COLOR_A)
        return line
    end
end

-- 创建垂直线
-- parent 父控件
-- width 宽 可以不传，默认为1
-- height 高，可以不传，默认为0
-- r,g,b 可以不传
function SpaUI:CreateVerticalLine(parent, height, width, r, g, b, a)
    if parent then
        local line = parent:CreateTexture()
        line:SetHeight(height or 0)
        line:SetWidth(width or DEFAULT_VERTICAL_LINE_WIDTH)
        r,g,b = RGBToPerc(r or DEFAULT_LINE_COLOR_R, g or DEFAULT_LINE_COLOR_G, b or DEFAULT_LINE_COLOR_B)
        line:SetColorTexture(r,g,b, a or DEFAULT_LINE_COLOR_A)
        return line
    end
end
