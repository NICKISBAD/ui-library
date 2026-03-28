repeat task.wait() until game:IsLoaded()

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- UI LIB
local UI = {}
function UI:Create(class, props, parent)
	local obj = Instance.new(class)
	for i,v in pairs(props or {}) do obj[i] = v end
	if parent then obj.Parent = parent end
	return obj
end
function UI:Corner(obj, r)
	return self:Create("UICorner",{CornerRadius=UDim.new(0,r or 8)}, obj)
end
function UI:Padding(obj, p)
	return self:Create("UIPadding", {
		PaddingTop = UDim.new(0,p),
		PaddingBottom = UDim.new(0,p),
		PaddingLeft = UDim.new(0,p),
		PaddingRight = UDim.new(0,p),
	}, obj)
end
function UI:List(obj, s)
	return self:Create("UIListLayout", {Padding = UDim.new(0,s), SortOrder = Enum.SortOrder.LayoutOrder}, obj)
end

-- THEMES
local Theme = "Dark"
local Themes = {
	Dark = {BG = Color3.fromRGB(22,22,24), Top = Color3.fromRGB(30,30,34), Card = Color3.fromRGB(34,34,38), Text = Color3.fromRGB(240,240,240), Button = Color3.fromRGB(45,45,50), Accent = Color3.fromRGB(90,140,255)},
	Light = {BG = Color3.fromRGB(235,235,235), Top = Color3.fromRGB(220,220,220), Card = Color3.fromRGB(255,255,255), Text = Color3.fromRGB(30,30,30), Button = Color3.fromRGB(210,210,210), Accent = Color3.fromRGB(0,0,0)}
}

-- SCREEN
local ScreenGui = UI:Create("ScreenGui", {Name = "SnazzyUI", ResetOnSpawn = false}, PlayerGui)

-- MAIN FRAME
local Main = UI:Create("Frame", {Size = UDim2.new(0,380,0,420), Position = UDim2.new(0.5,-190,0.5,-210), BackgroundColor3 = Themes[Theme].BG}, ScreenGui)
UI:Corner(Main,12)

-- TOPBAR
local Topbar = UI:Create("Frame",{Size = UDim2.new(1,0,0,40), BackgroundColor3 = Themes[Theme].Top},Main)
UI:Corner(Topbar,12)

local Title = UI:Create("TextLabel",{Size = UDim2.new(1,-120,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = "Jujutsu Incremental", TextColor3 = Themes[Theme].Text, Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left},Topbar)

local Buttons = UI:Create("Frame",{Size = UDim2.new(0,110,1,0), Position = UDim2.new(1,-110,0,0), BackgroundTransparency = 1},Topbar)
local Layout = UI:List(Buttons,6)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function TopButton(text)
	local Btn = UI:Create("TextButton",{Size = UDim2.new(0,32,0,32), BackgroundColor3 = Themes[Theme].Button, Text = text, TextColor3 = Themes[Theme].Text, Font = Enum.Font.GothamBold, TextSize = 14},Buttons)
	UI:Corner(Btn,8)
	return Btn
end

-- DRAG (mobile-friendly)
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging = true; dragStart=input.Position; startPos=Main.Position; dragInput=input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input==dragInput and dragging then update(input) end
	end)
	UIS.InputEnded:Connect(function(input)
		if input==dragInput then dragging=false end
	end)
end

-- SIDEBAR
local SidebarWidth = 50
local Sidebar = UI:Create("Frame", {Size = UDim2.new(0, SidebarWidth, 1, -40), Position = UDim2.new(0,0,0,40), BackgroundTransparency = 1}, Main)
UI:List(Sidebar,6)
local Tabs = {}

local function CreateTab(icon, name)
	local Btn = UI:Create("TextButton", {
		Size = UDim2.new(1,0,0,50),
		BackgroundColor3 = Themes[Theme].Button,
		Text = icon,
		TextColor3 = Themes[Theme].Text,
		Font = Enum.Font.GothamBold,
		TextSize = 20
	}, Sidebar)
	UI:Corner(Btn,8)

	local ContentFrame = UI:Create("Frame", {
		Size = UDim2.new(1,-SidebarWidth,1,0),
		Position = UDim2.new(0,SidebarWidth,0,40),
		BackgroundTransparency = 1,
		Visible = false
	}, Main)

	Tabs[Btn] = ContentFrame

	Btn.MouseButton1Click:Connect(function()
		for _,f in pairs(Tabs) do f.Visible = false end
		ContentFrame.Visible = true
	end)

	return ContentFrame
end

local function CreateScrollableSection(name, parent)  
    local Section = UI:Create("Frame", {  
        Name = "Card",  
        Size = UDim2.new(1,0,0,200),  -- initial height  
        BackgroundColor3 = Themes[Theme].Card  
    }, parent)  
    UI:Corner(Section,10)  
    UI:Padding(Section,10)  
  
    local Title = UI:Create("TextLabel", {  
        Text = name,  
        Size = UDim2.new(1,0,0,18),  
        BackgroundTransparency = 1,  
        TextColor3 = Themes[Theme].Text,  
        Font = Enum.Font.GothamSemibold,  
        TextSize = 12,  
        TextXAlignment = Enum.TextXAlignment.Left  
    }, Section)  
  
    -- Scrolling frame for contents  
    local Scroll = UI:Create("ScrollingFrame", {  
        Size = UDim2.new(1,0,1,-18),  
        Position = UDim2.new(0,0,0,18),  
        BackgroundTransparency = 1,  
        CanvasSize = UDim2.new(0,0,0,0),  
        ScrollBarThickness = 6,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, Section)  
	UI:Padding(Scroll, 6)
    local List = UI:List(Scroll, 4) -- spacing between labels  
    List.SortOrder = Enum.SortOrder.LayoutOrder  
  
    return Scroll  
end

-- SECTIONS, BUTTONS, TOGGLES, SLIDERS
local function CreateSection(name, parent)
	local Section = UI:Create("Frame",{Name="Card",AutomaticSize=Enum.AutomaticSize.Y,Size=UDim2.new(1,0,0,0), BackgroundColor3=Themes[Theme].Card})
	Section.Parent = parent
	UI:Corner(Section,10); UI:Padding(Section,10); UI:List(Section,8)
	UI:Create("TextLabel",{Text=name,Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,TextColor3=Themes[Theme].Text,Font=Enum.Font.GothamSemibold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},Section)
	return Section
end

local function CreateButton(parent,text,callback)
	local Btn = UI:Create("TextButton",{Size=UDim2.new(1,0,0,38), BackgroundColor3=Themes[Theme].Button, Text=text, TextColor3=Themes[Theme].Text, Font=Enum.Font.GothamSemibold, TextSize=14},parent)
	UI:Corner(Btn,8)
	Btn.MouseButton1Click:Connect(callback)
	return Btn
end

local function CreateToggle(parent, text, callback)
    local state = false
    local Holder = UI:Create("Frame",{Size=UDim2.new(1,0,0,40), BackgroundTransparency=1}, parent)
    
    local Label = UI:Create("TextLabel",{
        Size = UDim2.new(1,-60,1,0),
        Text = text,
        BackgroundTransparency = 1,
        TextColor3 = Themes[Theme].Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Holder)
    
    local Toggle = UI:Create("Frame",{
        Size = UDim2.new(0,44,0,22),
        Position = UDim2.new(1,-44,0.5,-11),
        BackgroundColor3 = Themes[Theme].Button,
        Active = true
    }, Holder)
    UI:Corner(Toggle, 20)

    local Circle = UI:Create("Frame",{
        Size = UDim2.new(0,18,0,18),
        Position = UDim2.new(0,2,0.5,-9),
        BackgroundColor3 = (Theme=="Light" and Color3.new(0,0,0) or Color3.new(1,1,1))
    }, Toggle)
    UI:Corner(Circle, 20)

    local function update()
        TweenService:Create(Circle, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
        }):Play()
        Toggle.BackgroundColor3 = state and Themes[Theme].Accent or Themes[Theme].Button
    end

    local function toggleState()
        state = not state
        update()
        if callback then callback(state) end
    end

    Toggle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            toggleState()
        end
    end)

    return {
        Set = function(v) state = v; update() end,
        Get = function() return state end,
        Holder = Holder
    }
end

function CreateTextBox(parent, placeholder)
    local Box = UI:Create("TextBox", {
        Size = UDim2.new(1,0,0,28),
        BackgroundColor3 = Themes[Theme].Button,
        TextColor3 = Themes[Theme].Text,
        Text = "",
        PlaceholderText = placeholder or "",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        ClearTextOnFocus = false
    }, parent)
    UI:Corner(Box,6)
    return Box
end

-- Simple helper to create a TextLabel inside a section
function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Text = text
    lbl.Parent = parent
    return lbl
end

local function CreateSlider(parent, text, min, max, callback)
    local value = min
    local dragging = false

    local Holder = UI:Create("Frame",{Size=UDim2.new(1,0,0,50), BackgroundTransparency=1, Active=true}, parent)
    local Label = UI:Create("TextLabel",{
        Size=UDim2.new(1,0,0,20),
        BackgroundTransparency=1,
        Text=text.." : "..value,
        TextColor3=Themes[Theme].Text,
        Font=Enum.Font.Gotham,
        TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left
    }, Holder)

    local Bar = UI:Create("Frame",{
        Size=UDim2.new(1,0,0,6),
        Position=UDim2.new(0,0,1,-10),
        BackgroundColor3=(Theme=="Light" and Color3.new(0,0,0) or Themes[Theme].Button),
        Active=true
    }, Holder)
    UI:Corner(Bar,10)

    local Fill = UI:Create("Frame",{Size=UDim2.new(0,0,1,0), BackgroundColor3=Themes[Theme].Accent}, Bar)
    UI:Corner(Fill,10)

    local function set(x)
        local percent = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * percent
        value = math.floor(value)  -- remove this line if you want floats
        Fill.Size = UDim2.new(percent,0,1,0)
        Label.Text = text.." : "..value
        if callback then callback(value) end
    end

    Bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            set(i.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            set(i.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)

    return {
        Holder = Holder,
        Get = function() return value end,
        Set = function(v)
            value = math.clamp(v,min,max)
            local percent = (value - min)/(max - min)
            Fill.Size = UDim2.new(percent,0,1,0)
            Label.Text = text.." : "..value
        end
    }
end

function SelectDefaultTab(Tab)
	Tab.Visible = true
end

-- NOTIFICATIONS
local notifications = {}
function notify(text,color)
	color = color or Themes[Theme].Accent
	local notif = UI:Create("Frame", {Size=UDim2.new(0,220,0,40), BackgroundColor3=Themes[Theme].Card, AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,20,1,20), ZIndex=10}, ScreenGui)
	UI:Corner(notif, 8)
	UI:Create("TextLabel",{Size=UDim2.new(1,-8,1,-8), Position=UDim2.new(0,4,0,4), BackgroundTransparency=1, Text=text, TextColor3=Themes[Theme].Text, Font=Enum.Font.Gotham, TextScaled=true, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Center, ZIndex=11}, notif)
	local bar = UI:Create("Frame",{Size=UDim2.new(1,0,0,3), Position=UDim2.new(0,0,1,-3), BackgroundColor3=color, ZIndex=12}, notif)
	UI:Corner(bar,4)
	table.insert(notifications,1,notif)
	local spacing = 50
	for i,v in ipairs(notifications) do
		local goalX = 1
		local goalY = -20 - ((i-1)*spacing)
		TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(goalX,-20,1,goalY)}):Play()
	end
	task.spawn(function()
		task.wait(3)
		if notif then
			TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1,250,1,notif.Position.Y.Offset)}):Play()
			task.wait(0.5)
			notif:Destroy()
			for i=#notifications,1,-1 do
				if notifications[i]==notif then table.remove(notifications,i) end
			end
		end
	end)
end

-- store the currently active tab

-- TOPBAR BUTTONS
local minimized=false
local normalSize = Main.Size
local Min = TopButton("-")
Min.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		for _,f in pairs(Tabs) do f.Visible = false end
		Sidebar.Visible = false
		TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(normalSize.X.Scale, normalSize.X.Offset, 0, 40)}):Play()
	else
		Sidebar.Visible = true
		TweenService:Create(Main, TweenInfo.new(0.2), {Size = normalSize}):Play()
		if CurrentTab then
			CurrentTab.Visible = true  -- restore last selected tab
		end
	end
end)

local ThemeBtn = TopButton("✧")
ThemeBtn.MouseButton1Click:Connect(function()
	Theme = (Theme=="Dark") and "Light" or "Dark"
	ThemeBtn.Text = (Theme=="Dark") and "✧" or "☀"
	for _,f in pairs(Tabs) do
		for _,c in pairs(f:GetDescendants()) do
			if c:IsA("TextLabel") or c:IsA("TextButton") then c.TextColor3=Themes[Theme].Text end
			if c:IsA("TextButton") then c.BackgroundColor3=Themes[Theme].Button end
			if c.Name=="Card" then c.BackgroundColor3=Themes[Theme].Card end
		end
	end
	Main.BackgroundColor3 = Themes[Theme].BG
	Topbar.BackgroundColor3 = Themes[Theme].Top
end)

local Close = TopButton("X")
Close.MouseButton1Click:Connect(function() Main.Visible=false end)

-- expose an API for outside usage
return {
    CreateTab = CreateTab,
    CreateSection = CreateSection,
    CreateButton = CreateButton,
    CreateToggle = CreateToggle,
    CreateSlider = CreateSlider,
    CreateTextBox = CreateTextBox,
    SelectDefaultTab = SelectDefaultTab,
    CreateScrollSection = CreateScrollableSection,
    notify = notify
}