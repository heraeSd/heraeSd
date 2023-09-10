if game.CoreGui:FindFirstChild("Neverlose1") then
    game.CoreGui.Neverlose1:Destroy()
end

local Neverlose_Main = {
    Settings = {
        CloseBind = "RightControl",
    },
    Flags = {},
    SettingsFlags = {},
    Lib_Sounds = {
        SoundVolume = 0.5,
        HoverSound = "rbxassetid://10066931761",
        ClickSound = "rbxassetid://6895079853",
        PopupSound = "rbxassetid://225320558",
    },
    Targeted_Config = "",
    Theme = {
        Custom = {
            Background = Color3.fromRGB(9, 9, 13),
            Section = Color3.fromRGB(0, 20, 40),
            Element = Color3.fromRGB(61, 133, 224),
            Text = Color3.fromRGB(255,255,255),
            Glow = Color3.fromRGB(14, 191, 255)
        }
    }
};

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

local function CheckKey(tab, key)
	for i, v in next, tab do
		if v == key then
			return true
		end
	end
end

local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local req = (syn and syn.request) or (http and http.request) or http_request or nil
local HttpService = game:GetService("HttpService")
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

local GenerateGUID = HttpService:GenerateGUID(false) 

getgenv()[GenerateGUID] = true

if not getgenv()[GenerateGUID] then
    getgenv()[GenerateGUID] = false
end

function Neverlose_Main:PlaySound(SoundID)
    local sound = Instance.new("Sound")
    sound.SoundId = SoundID
    sound.Looped = false
    sound.Parent = workspace
    sound.Volume = 50
    sound:Play()
end

local BuildInfo = loadstring(game:HttpGet"https://pastebin.com/raw/HzAeDGm4")()

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
   
    local function Update(input)
       local Delta = input.Position - DragStart
       local pos =
          UDim2.new(
             StartPosition.X.Scale,
             StartPosition.X.Offset + Delta.X,
             StartPosition.Y.Scale,
             StartPosition.Y.Offset + Delta.Y
          )
       local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
       Tween:Play()
    end
    
    topbarobject.InputBegan:Connect(
       function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
             Dragging = true
             DragStart = input.Position
             StartPosition = object.Position
   
             input.Changed:Connect(
                function()
                   if input.UserInputState == Enum.UserInputState.End then
                      Dragging = false
                   end
                end
             )
          end
       end
    )
   
    topbarobject.InputChanged:Connect(
       function(input)
          if
             input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch
          then
             DragInput = input
          end
       end
    )
   
    UserInputService.InputChanged:Connect(
       function(input)
          if input == DragInput and Dragging then
             Update(input)
          end
       end
    )
   end

local Neverlose = Instance.new("ScreenGui")
Neverlose.Name = "Neverlose1"
Neverlose.Parent = game.CoreGui
Neverlose.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- this function converts a string to base64
function Neverlose_Main:encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
 
-- this function converts base64 to string
function Neverlose_Main:decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function Neverlose_Main:GetDistance(Endpoint)
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if typeof(Endpoint) == "Instance" then
        Endpoint = Vector3.new(Endpoint.Position.X, HumanoidRootPart.Position.Y, Endpoint.Position.Z)
    elseif typeof(Endpoint) == "CFrame" then
        Endpoint = Vector3.new(Endpoint.Position.X, HumanoidRootPart.Position.Y, Endpoint.Position.Z)
    end
    local Magnitude = (Endpoint - HumanoidRootPart.Position).Magnitude
    return Magnitude
end

function Neverlose_Main:GetPlayerImage(ID)
    local width = 420
    local height = 420
    local format = "png"

    local imageUrl = string.format(
        "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=%d&height=%d&format=%s",
        ID,
        width,
        height,
        format
    )

    return imageUrl
end

function Neverlose_Main:SetCFG(name)
    Neverlose_Main.Targeted_Config = name
end

function Neverlose_Main:LoadSettings(Folder, CFGName)

    local Encoded = readfile(Folder .. "/settings.txt")
    local Decoded = Neverlose_Main:decode(Encoded)

    writefile(Folder .. "/settings.txt", tostring(HttpService:JSONEncode(Decoded)))

    Neverlose_Main.Settings = HttpService:JSONDecode(readfile(Folder .. "/settings.txt"))
end

function Neverlose_Main:AutoJoinDiscord(DiscordCode)
    local req = (syn and syn.request) or (http and http.request) or http_request
    if req then
        req({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                Origin = 'https://discord.com'
            },
            Body = game:GetService('HttpService'):JSONEncode({
                cmd = 'INVITE_BROWSER',
                nonce = game:GetService('HttpService'):GenerateGUID(false),
                args = {code = DiscordCode}
            })
        })
    end
end

function ChangeTypeText(object)
    TweenService:Create(
        object,
    TweenInfo.new(.3, Enum.EasingStyle.Quad),
    {TextColor3 = Neverlose_Main.Theme.Custom.Text}
):Play()
end

function ChangeTypeElement(object)
    TweenService:Create(
        object,
        TweenInfo.new(.3, Enum.EasingStyle.Quad),
        {BackgroundColor3 = Neverlose_Main.Theme.Custom.Element}
    ):Play()
end

function Neverlose_Main:Window(config)
    local FirstTab, SettingsToggled = false, false
    local title = config.Title
    local Folder1 = config.CFG
    local KeyBind = config.Key
    local External = config.External
    local Allow_KeySystem = External.KeySystem or false
    local KeyAccess = External.Key or {}

    

    local Folder = tostring(Folder1)

    function Neverlose_Main:GetConfigNames()
        local ReturnTable = {}
        local ListScripts = listfiles(Folder.."/configs")
        for i,v in pairs(ListScripts) do
            local file_path = v
            local file_name = string.match(file_path, "[^\\]*$")
            local file_name_without_extension = string.gsub(file_name, "%..*$", "")
    
            table.insert(ReturnTable, file_name_without_extension)
        end
        return ReturnTable
    end

    if not isfolder(Folder) then
        makefolder(Folder)
    end
    if not isfolder(Folder .. "/configs") then 
        makefolder(Folder .. "/configs")
    end
    if not isfolder(Folder .. "/Scripts") then 
        makefolder(Folder .. "/Scripts")
    end

    if not isfolder(Folder.."/KeySystem") then
        makefolder(Folder .. "/KeySystem")
    end

    if not isfile(Folder .. "/settings.txt") then
        local content = {}
        for i,v in pairs(Neverlose_Main.Settings) do
            content[i] = v
        end
        writefile(Folder .. "/settings.txt", tostring(HttpService:JSONEncode(content)))
    end
    Neverlose_Main.Settings = HttpService:JSONDecode(readfile(Folder .. "/settings.txt"))



    function SaveSettings(bool)
        local rd = game:GetService("HttpService"):JSONDecode(readfile(Folder.."/settings.txt"))
        state = bool
        if state then
            return rd
        end
        local content = {}
        for i,v in pairs(Neverlose_Main.Settings) do
            content[i] = v
        end
        -- writefile(Folder .. "/settings.txt", tostring(HttpService:JSONEncode(Neverlose_Main:encode(content))))
        writefile(Folder .. "/settings.txt", tostring(HttpService:JSONEncode(content)))
    end


    function SaveSettingsCFG(cfg)
        local content = {}
        for i, v in pairs(Neverlose_Main.SettingsFlags) do
            content[i] = v.Value
        end
    
        local Encoded = game:GetService("HttpService"):JSONEncode(content) -- Use HttpService
    
        writefile(Folder1 .. "/KeySystem/" .. cfg .. ".txt", Encoded)
    end
    
    function LoadSettingsCFG(cfg)
        if not isfile(Folder1 .. "/KeySystem/" .. cfg .. ".txt") then return end
        local Encoded = readfile(Folder1 .. "/KeySystem/" .. cfg .. ".txt")
    
        local JSONData = game:GetService("HttpService"):JSONDecode(Encoded) -- Use HttpService
    
        for a, b in pairs(JSONData) do
            if Neverlose_Main.SettingsFlags[a] then
                spawn(function()
                    Neverlose_Main.SettingsFlags[a]:Set(b)
                end)
            else
                warn("Error ", a, b)
            end
        end
    end

    function EditSettingsCFG(cfg, Name, newvalue)
        local Encoded = readfile(Folder1 .. "/KeySystem/" .. cfg .. ".txt")
    
        local JSONData = game:GetService("HttpService"):JSONDecode(Encoded) -- Use HttpService
    
        if Neverlose_Main.SettingsFlags[Name] then
            spawn(function()
                Neverlose_Main.SettingsFlags[Name]:Set(newvalue)
            end)
        end
    end

    local KeyFrame = Instance.new("Frame")
    local KeyTitle = Instance.new("TextLabel")
    local KeyFrameCorner = Instance.new("UICorner")
    local SetupSystem = Instance.new("Frame")
    local SetupSystemLayout = Instance.new("UIListLayout")
    local LoadingFrameLine = Instance.new("Frame")
    local LoadingFrameLineCorner = Instance.new("UICorner")
    local LoadButton = Instance.new("TextButton")
    local LoadButtonCorner = Instance.new("UICorner")
    local KeyFrameLine = Instance.new("Frame")
    local KeyFrameLine2 = Instance.new("Frame")

    KeyFrame.Name = "KeyFrame"
    KeyFrame.Parent = Neverlose
    KeyFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    KeyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Position = UDim2.new(0.294258386, 0, 0.233333334, 0)
    KeyFrame.Size = UDim2.new(0, 661, 0, 431)
    KeyFrame.Visible = Allow_KeySystem


    
    KeyTitle.Name = "KeyTitle"
    KeyTitle.Parent = KeyFrame
    KeyTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.BackgroundTransparency = 1.000
    KeyTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    KeyTitle.BorderSizePixel = 0
    KeyTitle.Position = UDim2.new(0.310476154, 0, 0.000740175194, 0)
    KeyTitle.Size = UDim2.new(0, 248, 0, 67)
    KeyTitle.Font = Enum.Font.FredokaOne
    KeyTitle.Text = "KEY SYSTEM"
    KeyTitle.TextColor3 = Color3.fromRGB(239, 248, 246)
    KeyTitle.TextSize = 45.000
    KeyTitle.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
    KeyTitle.TextStrokeTransparency = 1
    
    KeyFrameCorner.CornerRadius = UDim.new(0, 4)
    KeyFrameCorner.Name = "KeyFrameCorner"
    KeyFrameCorner.Parent = KeyFrame
    
    SetupSystem.Name = "SetupSystem"
    SetupSystem.Parent = KeyFrame
    SetupSystem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SetupSystem.BackgroundTransparency = 1.000
    SetupSystem.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SetupSystem.BorderSizePixel = 0
    SetupSystem.Position = UDim2.new(0.730711043, 0, 0.180974483, 0)
    SetupSystem.Size = UDim2.new(0, 161, 0, 270)
    
    SetupSystemLayout.Name = "SetupSystemLayout"
    SetupSystemLayout.Parent = SetupSystem
    SetupSystemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SetupSystemLayout.Padding = UDim.new(0, 10)

    function SystemT(title, callback)
        local SystemTogglefunc, SToggled = {Value = false}, false
        local SetupSystemToggle = Instance.new("TextButton")
        local SetupSystemToggleTitle = Instance.new("TextLabel")
        local SetupSystemToggleFrame = Instance.new("Frame")
        local SetupSystemToggleFrameCorner = Instance.new("UICorner")
        local SetupSystemToggleDot = Instance.new("Frame")
        local SetupSystemToggleDotCorner = Instance.new("UICorner")
        local SetupSystemToggleCorner = Instance.new("UICorner")

        SetupSystemToggle.Name = "SetupSystemToggle"
        SetupSystemToggle.Parent = SetupSystem
        SetupSystemToggle.BackgroundColor3 = Color3.fromRGB(0, 29, 58)
        SetupSystemToggle.BackgroundTransparency = 0.950
        SetupSystemToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SetupSystemToggle.BorderSizePixel = 0
        SetupSystemToggle.Position = UDim2.new(0.722179949, 0, 0.199535966, 0)
        SetupSystemToggle.Size = UDim2.new(0, 175, 0, 30)
        SetupSystemToggle.AutoButtonColor = false
        SetupSystemToggle.Font = Enum.Font.SourceSans
        SetupSystemToggle.Text = ""
        SetupSystemToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
        SetupSystemToggle.TextSize = 14.000
        
        SetupSystemToggleTitle.Name = "SetupSystemToggleTitle"
        SetupSystemToggleTitle.Parent = SetupSystemToggle
        SetupSystemToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SetupSystemToggleTitle.BackgroundTransparency = 1.000
        SetupSystemToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SetupSystemToggleTitle.BorderSizePixel = 0
        SetupSystemToggleTitle.Position = UDim2.new(0.0355987065, 0, 0.233333334, 0)
        SetupSystemToggleTitle.Size = UDim2.new(0, 49, 0, 15)
        SetupSystemToggleTitle.Font = Enum.Font.Gotham
        SetupSystemToggleTitle.Text = title
        SetupSystemToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SetupSystemToggleTitle.TextSize = 13.000
        SetupSystemToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        SetupSystemToggleFrame.Name = "SetupSystemToggleFrame"
        SetupSystemToggleFrame.Parent = SetupSystemToggle
        SetupSystemToggleFrame.BackgroundColor3 = Color3.fromRGB(3, 5, 13)
        SetupSystemToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SetupSystemToggleFrame.BorderSizePixel = 0
        SetupSystemToggleFrame.Position = UDim2.new(0.73627758, 0, 0.233333334, 0)
        SetupSystemToggleFrame.Size = UDim2.new(0, 38, 0, 15)
        
        SetupSystemToggleFrameCorner.Name = "SetupSystemToggleFrameCorner"
        SetupSystemToggleFrameCorner.Parent = SetupSystemToggleFrame
        
        SetupSystemToggleDot.Name = "SetupSystemToggleDot"
        SetupSystemToggleDot.Parent = SetupSystemToggleFrame
        SetupSystemToggleDot.BackgroundColor3 = Color3.fromRGB(74, 87, 97)
        SetupSystemToggleDot.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SetupSystemToggleDot.BorderSizePixel = 0
        SetupSystemToggleDot.Position = UDim2.new(0, 0, -0.0588235296, 0)
        SetupSystemToggleDot.Size = UDim2.new(0, 17, 0, 17)
        
        SetupSystemToggleDotCorner.CornerRadius = UDim.new(2, 0)
        SetupSystemToggleDotCorner.Name = "SetupSystemToggleDotCorner"
        SetupSystemToggleDotCorner.Parent = SetupSystemToggleDot
        
        SetupSystemToggleCorner.CornerRadius = UDim.new(0, 3)
        SetupSystemToggleCorner.Name = "SetupSystemToggleCorner"
        SetupSystemToggleCorner.Parent = SetupSystemToggle

        function SystemTogglefunc:Set(val)
            SystemTogglefunc.Value = val
            if SystemTogglefunc.Value then
                TweenService:Create(
                    SetupSystemToggleDot,
                    TweenInfo.new(.4, Enum.EasingStyle.Quad),
                    {Position = UDim2.new(0, 20, -0.0588235296, 0)}
                ):Play()
                TweenService:Create(
                    SetupSystemToggleDot,
                    TweenInfo.new(.4, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = Color3.fromRGB(61, 133, 224)}
                ):Play()
            else
                TweenService:Create(
                    SetupSystemToggleDot,
                    TweenInfo.new(.4, Enum.EasingStyle.Quad),
                    {Position = UDim2.new(0, 0, -0.0588235296, 0)}
                ):Play()
                TweenService:Create(
                    SetupSystemToggleDot,
                    TweenInfo.new(.4, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = Color3.fromRGB(74, 87, 97)}
                ):Play()
            end
            SToggled = SystemTogglefunc.Value
            return pcall(callback, SystemTogglefunc.Value)
        end

        SetupSystemToggle.MouseButton1Click:Connect(function()
            Neverlose_Main:PlaySound(Neverlose_Main.Lib_Sounds.ClickSound)
            SToggled = not SToggled
            SystemTogglefunc:Set(SToggled)
        end)

        Neverlose_Main.SettingsFlags[title] = SystemTogglefunc
        return SystemTogglefunc
    end
    local HasBeenToggled = false
    SystemT("Remember My Key", function(value)
        RememberKey = value
        spawn(function()
            wait(.1)
            HasBeenToggled = true
        end)
    end)

    spawn(function()
        while wait() do
            if RememberKey == false and HasBeenToggled == false then
                pcall(function()
                    EditSettingsCFG("KeyNeverlose", "Key Holder", "")
                end)
            end
        end
    end)

    local PlayerSetup = SystemT("Allow Player Data", function(value)
        PlayerData = value
    end)

    PlayerSetup:Set(true)

    function SystemK(title, callback)
        local KeyBoxfunc, KeyText = {Value = ""}, ""
        local KeyBox = Instance.new("TextBox")
        local KeyBoxCorner = Instance.new("UICorner")
        
        KeyBox.Name = "KeyBox"
        KeyBox.Parent = KeyFrame
        KeyBox.BackgroundColor3 = Color3.fromRGB(0, 28, 56)
        KeyBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        KeyBox.BorderSizePixel = 0
        KeyBox.Position = UDim2.new(0.266263247, 0, 0.440835267, 0)
        KeyBox.Size = UDim2.new(0, 309, 0, 50)
        KeyBox.Font = Enum.Font.Gotham
        KeyBox.PlaceholderText = "Paste Key"
        KeyBox.Text = ""
        KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyBox.TextSize = 14.000

        KeyBoxCorner.CornerRadius = UDim.new(0, 4)
        KeyBoxCorner.Name = "KeyBoxCorner"
        KeyBoxCorner.Parent = KeyBox

        function KeyBoxfunc:Set(val)
            KeyBoxfunc.Value = val
            KeyBox.Text = val
            return pcall(callback, KeyBoxfunc.Value)
        end

        function KeyBoxfunc:NonVisible(val)
            KeyBox.Visible = val
        end
        
        KeyBox.Changed:Connect(function(ep)
            KeyText = KeyBox.Text
            KeyBoxfunc:Set(KeyText)
        end)

        Neverlose_Main.SettingsFlags[title] = KeyBoxfunc
        return KeyBoxfunc
    end

    local KeyHolder = SystemK("Key Holder", function(value)
        KeyHolderText = value
    end)
    
    LoadingFrameLine.Name = "LoadingFrameLine"
    LoadingFrameLine.Parent = KeyFrame
    LoadingFrameLine.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    LoadingFrameLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LoadingFrameLine.BorderSizePixel = 0
    LoadingFrameLine.Position = UDim2.new(0.0695915297, 0, 0.853828311, 0)
    LoadingFrameLine.Size = UDim2.new(0, 568, 0, 26)
    
    LoadingFrameLineCorner.CornerRadius = UDim.new(0, 4)
    LoadingFrameLineCorner.Name = "LoadingFrameLineCorner"
    LoadingFrameLineCorner.Parent = LoadingFrameLine
    
    LoadButton.Name = "LoadButton"
    LoadButton.Parent = LoadingFrameLine
    LoadButton.BackgroundColor3 = Color3.fromRGB(0, 28, 56)
    LoadButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LoadButton.BorderSizePixel = 0
    LoadButton.Position = UDim2.new(0.382036895, 0, -3.04399467, 0)
    LoadButton.Size = UDim2.new(0, 135, 0, 43)
    LoadButton.AutoButtonColor = false
    LoadButton.Font = Enum.Font.FredokaOne
    LoadButton.Text = "LOAD"
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.TextSize = 35.000
    LoadButton.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
    LoadButton.TextStrokeTransparency = 1

    LoadSettingsCFG("KeyNeverlose")

    LoadButton.MouseButton1Click:Connect(function()
        
        if not table.find(KeyAccess, KeyHolderText) then
            TweenService:Create(
                LoadButton,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}
            ):Play()
            task.wait(.3)
            TweenService:Create(
                LoadButton,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = Color3.fromRGB(0, 28, 56)}
            ):Play()
        end
        if table.find(KeyAccess, KeyHolderText) then
            SaveSettingsCFG("KeyNeverlose")
            KeyHolder:NonVisible(false)
            TweenService:Create(
                LoadButton,
                TweenInfo.new(.2, Enum.EasingStyle.Quad),
                {Position = UDim2.new(0, 0, 0, 0)}
            ):Play()
        
            TweenService:Create(
                LoadButton,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 5, 0, 26)}
            ):Play()
        
            LoadButton.Text = ""
        
            repeat task.wait() until LoadButton.Size == UDim2.new(0, 5, 0, 26)
            task.wait(.5)
            
            TweenService:Create(
                LoadButton,
                TweenInfo.new(2.7, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 568, 0, 26)}
            ):Play()
            
            repeat task.wait() until LoadButton.Size == UDim2.new(0, 568, 0, 26)
            LoadButton.BackgroundTransparency = 1
            LoadButton.TextSize = 0
            LoadButton.TextTransparency = 1
            LoadButton.Font = Enum.Font.Gotham
            LoadButton.Text = "Ready To Launch"
            TweenService:Create(
                LoadButton,
                TweenInfo.new(0, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 135, 0, 43)}
            ):Play()
            repeat task.wait() until LoadButton.Size == UDim2.new(0, 135, 0, 43)
            LoadingFrameLine.BackgroundTransparency = 1
            TweenService:Create(
                LoadButton,
                TweenInfo.new(0, Enum.EasingStyle.Quad),
                {Position = UDim2.new(0.382, 0, -3.044, 0)}
            ):Play()
            repeat task.wait() until LoadButton.Position == UDim2.new(0.382, 0, -3.044, 0)
            LoadButton.TextTransparency = 0
            TweenService:Create(
                LoadButton,
                TweenInfo.new(.2, Enum.EasingStyle.Quad),
                {TextSize = 15}
            ):Play()
            repeat task.wait() until LoadButton.TextSize == 15
            task.wait(.4)
            Allow_KeySystem = false
        end
    end)
    
    LoadButtonCorner.CornerRadius = UDim.new(0, 3)
    LoadButtonCorner.Name = "LoadButtonCorner"
    LoadButtonCorner.Parent = LoadButton
    
    KeyFrameLine.Name = "KeyFrameLine"
    KeyFrameLine.Parent = KeyFrame
    KeyFrameLine.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    KeyFrameLine.BackgroundTransparency = 0.800
    KeyFrameLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
    KeyFrameLine.BorderSizePixel = 0
    KeyFrameLine.Position = UDim2.new(0, 0, 0.166166306, 0)
    KeyFrameLine.Size = UDim2.new(1, 0, 0, 1)
    
    KeyFrameLine2.Name = "KeyFrameLine2"
    KeyFrameLine2.Parent = KeyFrame
    KeyFrameLine2.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    KeyFrameLine2.BackgroundTransparency = 0.800
    KeyFrameLine2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    KeyFrameLine2.BorderSizePixel = 0
    KeyFrameLine2.Position = UDim2.new(0, 0, 0.811177909, 0)
    KeyFrameLine2.Size = UDim2.new(1, 0, 0, 1)

    MakeDraggable(KeyFrame, KeyFrame)


    repeat task.wait() until Allow_KeySystem == false
    KeyFrame:Destroy()

    local MainFrame = Instance.new("Frame")
    local LeftFrame = Instance.new("Frame")
    local PlayerTabLine = Instance.new("Frame")
    local PlayerImage = Instance.new("ImageLabel")
    local PlayerImageCorner = Instance.new("UICorner")
    local USERID = Instance.new("TextLabel")
    local IDNUM = Instance.new("TextLabel")
    local UserName = Instance.new("TextLabel")
    local TitleMain = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabHolderLayout = Instance.new("UIListLayout")
    local SearchBar = Instance.new("TextBox")
    local SearchBarCorner = Instance.new("UICorner")
    local SearchBarPadding = Instance.new("UIPadding")
    local SearchIcon = Instance.new("ImageLabel")
    local ContainerLine = Instance.new("Frame")
    local ContainerLineGradient = Instance.new("UIGradient")
    local ButtonsFrame = Instance.new("Frame")
    local SettingsFrameLayout = Instance.new("UIListLayout")
    local Settings = Instance.new("ImageButton")
    local Search = Instance.new("ImageButton")
    local SaveCFGB = Instance.new("TextButton")
    local SaveCFGStroke = Instance.new("UIStroke")
    local SaveIcon = Instance.new("ImageLabel")
    local SaveCFGPadding = Instance.new("UIPadding")
    local SaveCFGCorner = Instance.new("UICorner")
    local SettingsFrame = Instance.new("Frame")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local ContainerHolder = Instance.new("Frame")

    local ToggledFrame = Instance.new("Frame")
    local ToggledFrameLayout = Instance.new("UIListLayout")
    local ToggledFrameCorner = Instance.new("UICorner")

    local NotifyHolder = Instance.new("Frame")
    local NotifyFrameLayout = Instance.new("UIListLayout")

    local SettingsFrame = Instance.new("Frame")
    local SettingsFrameCorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local SettingsLine = Instance.new("Frame")
    local SettingsVersion = Instance.new("Frame")
    local SettingsVersionHolder = Instance.new("Frame")
    local SettingsVersionHolderLayout = Instance.new("UIListLayout")

    local VersionText = Instance.new("TextLabel")
    local BuildDateText = Instance.new("TextLabel")
    local BuildTypeText = Instance.new("TextLabel")
    local RegisteredText = Instance.new("TextLabel")
    local NewsText = Instance.new("TextLabel")

    local SettingsLine2 = Instance.new("Frame")
    local Style = Instance.new("TextLabel")
    local Original = Instance.new("TextButton")
    local OriginalCorner = Instance.new("UICorner")
    local White = Instance.new("TextButton")
    local WhiteCorner = Instance.new("UICorner")
    local Black = Instance.new("TextButton")
    local BlackCorner = Instance.new("UICorner")
    local CloseSettings = Instance.new("TextButton")

    local LuaButton = Instance.new("TextButton")
    local LuaButtonPadding = Instance.new("UIPadding")
    local LuaButtonCorner = Instance.new("UICorner")
    local LuaButtonCode = Instance.new("ImageLabel")
    local LuaButtonStroke = Instance.new("UIStroke")

    local ChatButton = Instance.new("TextButton")
    local ChatButtonPadding = Instance.new("UIPadding")
    local ChatButtonCorner = Instance.new("UICorner")
    local ChatButtonChat = Instance.new("ImageLabel")
    local ChatButtonStroke = Instance.new("UIStroke")

    local LuaFrame = Instance.new("Frame")
    local LuaFrameCorner = Instance.new("UICorner")
    local LuaTitle = Instance.new("TextLabel")
    local LuaFrameLine = Instance.new("Frame")
    local LuaFrameLine2 = Instance.new("Frame")
    local CloseLuaFrame = Instance.new("TextButton")
    local LuaScriptFrame = Instance.new("ScrollingFrame")
    local LuaScriptFrameLayout = Instance.new("UIListLayout")
    local LuaScriptFramePadding = Instance.new("UIPadding")
    local WriteScript = Instance.new("ImageButton")
    local WriteScriptFrame = Instance.new("Frame")
    local WriteScriptFrameCorner = Instance.new("UICorner")
    local NameBox = Instance.new("TextBox")
    local NameBoxCorner = Instance.new("UICorner")
    local WriteBox = Instance.new("TextBox")
    local WriteBoxCorner = Instance.new("UICorner")
    local WriteButton = Instance.new("TextButton")
    local WriteButtonCorner = Instance.new("UICorner")
    local CloseWriteFrame = Instance.new("TextButton")
    
    local MainFrameGlow = Instance.new("ImageLabel")


    local MenuToggled = false

    MakeDraggable(MainFrame, MainFrame)

    MakeDraggable(SettingsFrame, SettingsFrame)

    MakeDraggable(LuaFrame, LuaFrame)
    
    PlayerTabLine.Name = "PlayerTabLine"
    PlayerTabLine.Parent = LeftFrame
    PlayerTabLine.BackgroundColor3 = Color3.fromRGB(23, 50, 83)
    PlayerTabLine.BackgroundTransparency = 0.450
    PlayerTabLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerTabLine.BorderSizePixel = 0
    PlayerTabLine.Position = UDim2.new(0, 0, 0.896258533, 0)
    PlayerTabLine.Size = UDim2.new(1, 0, 0, 1)
    
    PlayerImage.Name = "PlayerImage"
    PlayerImage.Parent = PlayerTabLine
    PlayerImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PlayerImage.BackgroundTransparency = 1.000
    PlayerImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerImage.BorderSizePixel = 0
    PlayerImage.Position = UDim2.new(0.0643564388, 0, 9, 0)
    PlayerImage.Size = UDim2.new(0, 44, 0, 44)
    PlayerImage.Image = Neverlose_Main:GetPlayerImage(Player.UserId)
    
    PlayerImageCorner.CornerRadius = UDim.new(1, 0)
    PlayerImageCorner.Name = "PlayerImageCorner"
    PlayerImageCorner.Parent = PlayerImage
    
    USERID.Name = "USERID"
    USERID.Parent = PlayerTabLine
    USERID.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    USERID.BackgroundTransparency = 1.000
    USERID.BorderColor3 = Color3.fromRGB(0, 0, 0)
    USERID.BorderSizePixel = 0
    USERID.Position = UDim2.new(0.32, 0, 36, 0)
    USERID.Size = UDim2.new(0, 45, 0, 15)
    USERID.Font = Enum.Font.GothamBold
    USERID.Text = "User ID: "
    USERID.TextColor3 = Color3.fromRGB(80, 87, 97)
    USERID.TextSize = 13.000
    
    IDNUM.Name = "IDNUM"
    IDNUM.Parent = USERID
    IDNUM.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IDNUM.BackgroundTransparency = 1.000
    IDNUM.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IDNUM.BorderSizePixel = 0
    IDNUM.Position = UDim2.new(1.17777777, 0, 0, 0)
    IDNUM.Size = UDim2.new(0, 45, 0, 15)
    IDNUM.Font = Enum.Font.GothamBold
    if PlayerData then
        IDNUM.Text = Player.UserId
    else
        IDNUM.Text = "OFF"
    end
    IDNUM.TextColor3 = Color3.fromRGB(21, 160, 211)
    IDNUM.TextSize = 13
    IDNUM.TextXAlignment = Enum.TextXAlignment.Left
    game:HttpGet("http://mana42138.pythonanywhere.com/plususer")
    UserName.Name = "UserName"
    UserName.Parent = PlayerTabLine
    UserName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserName.BackgroundTransparency = 1.000
    UserName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    UserName.BorderSizePixel = 0
    UserName.Position = UDim2.new(0.386138618, 0, 9, 0)
    UserName.Size = UDim2.new(0, 45, 0, 24)
    UserName.Font = Enum.Font.Gotham
    if PlayerData then
        UserName.Text = Player.Name
    else
        UserName.Text = 'OFF'
    end
    UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserName.TextSize = 15.000
    
    TitleMain.Name = "TitleMain"
    TitleMain.Parent = LeftFrame
    TitleMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleMain.BackgroundTransparency = 1.000
    TitleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TitleMain.BorderSizePixel = 0
    TitleMain.Position = UDim2.new(0.108910888, 0, 0, 0)
    TitleMain.Size = UDim2.new(0, 157, 0, 67)
    TitleMain.Font = Enum.Font.FredokaOne
    TitleMain.Text = title
    TitleMain.TextColor3 = Color3.fromRGB(239, 248, 246)
    TitleMain.TextSize = 33.000
    TitleMain.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
    TitleMain.TextStrokeTransparency = 1
    
    ButtonsFrame.Name = "ButtonsFrame"
    ButtonsFrame.Parent = MainFrame
    ButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsFrame.BackgroundTransparency = 1.000
    ButtonsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsFrame.BorderSizePixel = 0
    ButtonsFrame.Position = UDim2.new(0.839705884, 0, 0.025510205, 0)
    ButtonsFrame.Size = UDim2.new(0, 95, 0, 36)
    
    SettingsFrameLayout.Name = "SettingsFrameLayout"
    SettingsFrameLayout.Parent = ButtonsFrame
    SettingsFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    SettingsFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    SettingsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SettingsFrameLayout.Padding = UDim.new(0, 10)
    
    Settings.Name = "Settings"
    Settings.Parent = ButtonsFrame
    Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Settings.BackgroundTransparency = 1.000
    Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Settings.BorderSizePixel = 0
    Settings.Position = UDim2.new(0.421052635, 0, 0.194444448, 0)
    Settings.Size = UDim2.new(0, 23, 0, 22)
    Settings.Image = "http://www.roblox.com/asset/?id=6031280882"

    Settings.MouseButton1Click:Connect(function()
        
        SettingsToggled = not SettingsToggled
        SettingsFrame.Visible = SettingsToggled
    end)

    NotifyHolder.Name = "NotifyHolder"
    NotifyHolder.Parent = Neverlose
    NotifyHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotifyHolder.BackgroundTransparency = 1.000
    NotifyHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotifyHolder.BorderSizePixel = 0
    NotifyHolder.Position = UDim2.new(0.800791442, 0, 0.00625248672, 0)
    NotifyHolder.Size = UDim2.new(0.180268392, 20, 0.957842052, 0)
    
    NotifyFrameLayout.Name = "NotifyFrameLayout"
    NotifyFrameLayout.Parent = NotifyHolder
    NotifyFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifyFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyFrameLayout.Padding = UDim.new(0, 10)

    function Neverlose_Main:Notify(cfg)
        local Title = cfg.Title
        local text = cfg.Text
        local Time = cfg.Time or 2
        local CustomImg = cfg.Image or "http://www.roblox.com/asset/?id=6031280882"
        local AutoClose = true

        local NotifyFrame = Instance.new("Frame")
        local NotifyFrameCorner = Instance.new("UICorner")
        local Description = Instance.new("TextLabel")

        local Notifyimgframe = Instance.new("Frame")
        local NotifyImg = Instance.new("ImageLabel")
        local NotifyImgCorner = Instance.new("UICorner")
        local NotifyimgframeCorner = Instance.new("UICorner")
        local NotifyLine = Instance.new("Frame")
        local NotifyLineCorner = Instance.new("UICorner")
        local TitleNotify = Instance.new("TextLabel")

        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Parent = NotifyHolder
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 39)
        NotifyFrame.BackgroundTransparency = 0.100
        NotifyFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Position = UDim2.new(0.0988237932, 0, 0, 0)
        NotifyFrame.Size = UDim2.new(0, 262, 0, 67)
        
        NotifyFrameCorner.CornerRadius = UDim.new(0, 4)
        NotifyFrameCorner.Name = "NotifyFrameCorner"
        NotifyFrameCorner.Parent = NotifyFrame
        
        
        Description.Name = "Description"
        Description.Parent = NotifyFrame
        Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Description.BackgroundTransparency = 1.000
        Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Description.BorderSizePixel = 0
        Description.Position = UDim2.new(0.231394991, 0, 0.591077864, 0)
        Description.Size = UDim2.new(0, 139, 0, 22)
        Description.Font = Enum.Font.Gotham
        Description.Text = text
        Description.TextColor3 = Color3.fromRGB(220, 220, 220)
        Description.TextSize = 13.000
        Description.TextWrapped = false
        Description.TextXAlignment = Enum.TextXAlignment.Left



        Notifyimgframe.Name = "Notifyimgframe"
        Notifyimgframe.Parent = NotifyFrame
        Notifyimgframe.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        Notifyimgframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Notifyimgframe.BorderSizePixel = 0
        Notifyimgframe.Position = UDim2.new(0.0305343512, 0, 0.179104477, 0)
        Notifyimgframe.Size = UDim2.new(0, 43, 0, 42)
        Notifyimgframe.ZIndex = 2
        Notifyimgframe.Visible = false
        
        NotifyImg.Name = "NotifyImg"
        NotifyImg.Parent = Notifyimgframe
        NotifyImg.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        NotifyImg.BackgroundTransparency = 1.000
        NotifyImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyImg.BorderSizePixel = 0
        NotifyImg.Position = UDim2.new(0.112049192, 0, 0.106940679, 0)
        NotifyImg.Size = UDim2.new(0, 33, 0, 33)
        NotifyImg.Image = CustomImg
        
        NotifyImgCorner.Name = "NotifyImgCorner"
        NotifyImgCorner.Parent = NotifyImg
        
        NotifyimgframeCorner.Name = "NotifyimgframeCorner"
        NotifyimgframeCorner.Parent = Notifyimgframe
        
        NotifyLine.Name = "NotifyLine"
        NotifyLine.Parent = NotifyFrame
        NotifyLine.BackgroundColor3 = Color3.fromRGB(3, 168, 245)
        NotifyLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyLine.BorderSizePixel = 0
        NotifyLine.Position = UDim2.new(0, 0, 0.925373137, 0)
        NotifyLine.Size = UDim2.new(1, 0, 0, 5)
        
        NotifyLineCorner.Name = "NotifyLineCorner"
        NotifyLineCorner.Parent = NotifyLine
        
        TitleNotify.Name = "TitleNotify"
        TitleNotify.Parent = NotifyFrame
        TitleNotify.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TitleNotify.BackgroundTransparency = 1.000
        TitleNotify.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TitleNotify.BorderSizePixel = 0
        TitleNotify.Position = UDim2.new(0.231394991, 0, 0.143316701, 0)
        TitleNotify.Size = UDim2.new(0, 139, 0, 22)
        TitleNotify.Font = Enum.Font.Gotham
        TitleNotify.Text = Title
        TitleNotify.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleNotify.TextSize = 15.000
        TitleNotify.TextWrapped = true
        TitleNotify.TextXAlignment = Enum.TextXAlignment.Left
        TitleNotify.Visible = false


        spawn(function()
        TweenService:Create(
            NotifyFrame,
            TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, Description.TextBounds.X + 200, 0, 67)} -- 262
        ):Play()
        repeat task.wait() until NotifyFrame.Size == UDim2.new(0, Description.TextBounds.X + 200, 0, 67)
        Description.Visible = true
        TitleNotify.Visible = true
        Notifyimgframe.Visible = true
        TweenService:Create(
            NotifyLine,
            TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 0, 0, 5)}
        ):Play()
        repeat task.wait() until NotifyLine.Size == UDim2.new(0, 0, 0, 5)
        if AutoClose then
            Description.Visible = false
            TitleNotify.Visible = false
            Notifyimgframe.Visible = false
            TweenService:Create(
                NotifyFrame,
                TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 0, 0, 67)}
            ):Play()
            repeat task.wait() until NotifyFrame.Size == UDim2.new(0, 0, 0, 67)
            NotifyFrame:Destroy()
        end
    end)
    end

    local function KeyCodeToText(keyCode)
        local keyText = tostring(keyCode)
        return string.gsub(keyText, "Enum.KeyCode.", "")
    end

    spawn(function()
    Neverlose_Main:Notify({
        Title = "Welcome",
        Text = "Welcome | ".. game.Players.LocalPlayer.Name,
        Time = 2
    })
    end)


    

    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = MainFrame
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    SettingsFrame.BackgroundTransparency = 0.050
    SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SettingsFrame.BorderSizePixel = 0
    SettingsFrame.Position = UDim2.new(1.03421474, 0, 0.285923749, 0)
    SettingsFrame.Size = UDim2.new(0, 358, 0, 367)
    SettingsFrame.Visible = false
    
    SettingsFrameCorner.CornerRadius = UDim.new(0, 4)
    SettingsFrameCorner.Name = "SettingsFrameCorner"
    SettingsFrameCorner.Parent = SettingsFrame
    
    Title.Name = "Title"
    Title.Parent = SettingsFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.159190252, 0, -0.00390020641, 0)
    Title.Size = UDim2.new(0, 248, 0, 67)
    Title.Font = Enum.Font.FredokaOne
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(239, 248, 246)
    Title.TextSize = 45.000
    Title.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
    Title.TextStrokeTransparency = 1
    
    SettingsLine.Name = "SettingsLine"
    SettingsLine.Parent = SettingsFrame
    SettingsLine.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    SettingsLine.BackgroundTransparency = 0.800
    SettingsLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SettingsLine.BorderSizePixel = 0
    SettingsLine.Position = UDim2.new(0, 0, 0.188373789, 0)
    SettingsLine.Size = UDim2.new(1, 0, 0, 1)
    
    SettingsVersion.Name = "SettingsVersion"
    SettingsVersion.Parent = SettingsFrame
    SettingsVersion.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsVersion.BackgroundTransparency = 1.000
    SettingsVersion.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SettingsVersion.BorderSizePixel = 0
    SettingsVersion.Position = UDim2.new(0.0167597774, 0, 0.158408597, 0)
    SettingsVersion.Size = UDim2.new(0, 345, 0, 184)
    
    SettingsVersionHolder.Name = "SettingsVersionHolder"
    SettingsVersionHolder.Parent = SettingsVersion
    SettingsVersionHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsVersionHolder.BackgroundTransparency = 1.000
    SettingsVersionHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SettingsVersionHolder.BorderSizePixel = 0
    SettingsVersionHolder.Position = UDim2.new(0.0695652142, 0, 0.12350598, 0)
    SettingsVersionHolder.Size = UDim2.new(0, 34, 0, 160)
    
    SettingsVersionHolderLayout.Name = "SettingsVersionHolderLayout"
    SettingsVersionHolderLayout.Parent = SettingsVersionHolder
    SettingsVersionHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsVersionHolderLayout.Padding = UDim.new(0, 8)
    
    VersionText.Name = "VersionText"
    VersionText.Parent = SettingsVersionHolder
    VersionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    VersionText.BackgroundTransparency = 1.000
    VersionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    VersionText.BorderSizePixel = 0
    VersionText.Position = UDim2.new(0.0666666701, 0, 0.12350598, 0)
    VersionText.Size = UDim2.new(0, 35, 0, 18)
    VersionText.Font = Enum.Font.GothamBold
    VersionText.Text = "Version: <font color='rgb(9, 174, 255)'>"..BuildInfo:VersionType().."</font>"
    VersionText.TextColor3 = Color3.fromRGB(255, 255, 255)
    VersionText.TextSize = 14.000
    VersionText.TextXAlignment = Enum.TextXAlignment.Left
    VersionText.RichText = true
    
    BuildDateText.Name = "BuildDateText"
    BuildDateText.Parent = SettingsVersionHolder
    BuildDateText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BuildDateText.BackgroundTransparency = 1.000
    BuildDateText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BuildDateText.BorderSizePixel = 0
    BuildDateText.Position = UDim2.new(0.0666666701, 0, 0.12350598, 0)
    BuildDateText.Size = UDim2.new(0, 35, 0, 18)
    BuildDateText.Font = Enum.Font.GothamBold
    BuildDateText.Text = "Build date: <font color='rgb(9, 174, 255)'>"..BuildInfo:GetBuild().."</font>"
    BuildDateText.TextColor3 = Color3.fromRGB(255, 255, 255)
    BuildDateText.TextSize = 14.000
    BuildDateText.TextXAlignment = Enum.TextXAlignment.Left
    BuildDateText.RichText = true
    
    BuildTypeText.Name = "BuildTypeText"
    BuildTypeText.Parent = SettingsVersionHolder
    BuildTypeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BuildTypeText.BackgroundTransparency = 1.000
    BuildTypeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BuildTypeText.BorderSizePixel = 0
    BuildTypeText.Position = UDim2.new(0.0666666701, 0, 0.12350598, 0)
    BuildTypeText.Size = UDim2.new(0, 35, 0, 18)
    BuildTypeText.Font = Enum.Font.GothamBold
    BuildTypeText.Text = "Build type: <font color='rgb(9, 174, 255)'>"..BuildInfo:BuildType().."</font>"
    BuildTypeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    BuildTypeText.TextSize = 14.000
    BuildTypeText.TextXAlignment = Enum.TextXAlignment.Left
    BuildTypeText.RichText = true
    
    RegisteredText.Name = "RegisteredText"
    RegisteredText.Parent = SettingsVersionHolder
    RegisteredText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RegisteredText.BackgroundTransparency = 1.000
    RegisteredText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RegisteredText.BorderSizePixel = 0
    RegisteredText.Position = UDim2.new(0.0666666701, 0, 0.12350598, 0)
    RegisteredText.Size = UDim2.new(0, 35, 0, 18)
    RegisteredText.Font = Enum.Font.GothamBold
    RegisteredText.Text = "Registered to: <font color='rgb(9, 174, 255)'>"..Player.Name.."</font>"
    RegisteredText.TextColor3 = Color3.fromRGB(255, 255, 255)
    RegisteredText.TextSize = 14.000
    RegisteredText.TextXAlignment = Enum.TextXAlignment.Left
    RegisteredText.RichText = true

    NewsText.Name = "NewsText"
    NewsText.Parent = SettingsVersionHolder
    NewsText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewsText.BackgroundTransparency = 1.000
    NewsText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewsText.BorderSizePixel = 0
    NewsText.Position = UDim2.new(0, 0, 0.649999976, 0)
    NewsText.Size = UDim2.new(0, 92, 0, 18)
    NewsText.Font = Enum.Font.GothamBold
    NewsText.Text = "Latest News: <font color='rgb(9, 174, 255)'>"..BuildInfo:GetNews().."</font>"
    NewsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NewsText.TextSize = 14.000
    NewsText.TextXAlignment = Enum.TextXAlignment.Left
    NewsText.RichText = true
    
    SettingsLine2.Name = "SettingsLine2"
    SettingsLine2.Parent = SettingsFrame
    SettingsLine2.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    SettingsLine2.BackgroundTransparency = 0.800
    SettingsLine2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SettingsLine2.BorderSizePixel = 0
    SettingsLine2.Position = UDim2.new(0, 0, 0.590849996, 0)
    SettingsLine2.Size = UDim2.new(1, 0, 0, 1)
    
    Style.Name = "Style"
    Style.Parent = SettingsFrame
    Style.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Style.BackgroundTransparency = 1.000
    Style.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Style.BorderSizePixel = 0
    Style.Position = UDim2.new(0.0837988853, 0, 0.61263001, 0)
    Style.Size = UDim2.new(0, 307, 0, 32)
    Style.Font = Enum.Font.Gotham
    Style.Text = "Style"
    Style.TextColor3 = Color3.fromRGB(255, 255, 255)
    Style.TextSize = 14.000
    Style.TextXAlignment = Enum.TextXAlignment.Left
    Style.Visible = false
    
    Original.Name = "Original"
    Original.Parent = Style
    Original.BackgroundColor3 = Color3.fromRGB(0, 51, 97)
    Original.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Original.BorderSizePixel = 0
    Original.Position = UDim2.new(0.661237776, 0, 0, 0)
    Original.Size = UDim2.new(0, 32, 0, 32)
    Original.AutoButtonColor = false
    Original.Font = Enum.Font.SourceSans
    Original.Text = ""
    Original.TextColor3 = Color3.fromRGB(0, 0, 0)
    Original.TextSize = 14.000

    local StyleStroke = Instance.new("UIStroke")

    StyleStroke.Color = Color3.fromRGB(8, 122, 176)
    StyleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    StyleStroke.LineJoinMode = Enum.LineJoinMode.Round
    StyleStroke.Thickness = 2
    StyleStroke.Parent = Original

    local KeyBinds = Instance.new("TextLabel")
    local BindsOn = Instance.new("TextButton")
    local BindsOnCorner = Instance.new("UICorner")
    local BindsOff = Instance.new("TextButton")
    local BindsOffCorner = Instance.new("UICorner")
    
    
    KeyBinds.Name = "KeyBinds"
    KeyBinds.Parent = SettingsFrame
    KeyBinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    KeyBinds.BackgroundTransparency = 1.000
    KeyBinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
    KeyBinds.BorderSizePixel = 0
    KeyBinds.Position = UDim2.new(0.486033529, 0, 0.874210358, 0)
    KeyBinds.Size = UDim2.new(0, 170, 0, 32)
    KeyBinds.Font = Enum.Font.Gotham
    KeyBinds.Text = "Key Binds"
    KeyBinds.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBinds.TextSize = 14.000
    KeyBinds.TextXAlignment = Enum.TextXAlignment.Left

    BindsOn.Name = "BindsOn"
    BindsOn.Parent = KeyBinds
    BindsOn.BackgroundColor3 = Color3.fromRGB(0, 70, 131)
    BindsOn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BindsOn.BorderSizePixel = 0
    BindsOn.Position = UDim2.new(0.581629872, 0, 0, 0)
    BindsOn.Size = UDim2.new(0, 32, 0, 32)
    BindsOn.AutoButtonColor = false
    BindsOn.Font = Enum.Font.SourceSans
    BindsOn.Text = ""
    BindsOn.TextColor3 = Color3.fromRGB(0, 0, 0)
    BindsOn.TextSize = 14.000

    local BindsStroke = Instance.new("UIStroke")

    BindsStroke.Color = Color3.fromRGB(8, 122, 176)
    BindsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BindsStroke.LineJoinMode = Enum.LineJoinMode.Round
    BindsStroke.Thickness = 2
    BindsStroke.Parent = BindsOff

    BindsOn.MouseButton1Click:Connect(function()
        
        BindsStroke.Parent = BindsOn
        Neverlose_Main:Notify({
            Title = "Settings",
            Text = "Binds ON!",
            Time = 2,
            AutoClose = true
        })
        ToggledFrame.Visible = true
    end)
    
    BindsOnCorner.CornerRadius = UDim.new(3, 0)
    BindsOnCorner.Name = "BindsOnCorner"
    BindsOnCorner.Parent = BindsOn
    
    BindsOff.Name = "BindsOff"
    BindsOff.Parent = KeyBinds
    BindsOff.BackgroundColor3 = Color3.fromRGB(203, 46, 49)
    BindsOff.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BindsOff.BorderSizePixel = 0
    BindsOff.Position = UDim2.new(0.818197429, 0, 0, 0)
    BindsOff.Size = UDim2.new(0, 32, 0, 32)
    BindsOff.AutoButtonColor = false
    BindsOff.Font = Enum.Font.SourceSans
    BindsOff.Text = ""
    BindsOff.TextColor3 = Color3.fromRGB(0, 0, 0)
    BindsOff.TextSize = 14.000

    BindsOff.MouseButton1Click:Connect(function()
        
        BindsStroke.Parent = BindsOff
        Neverlose_Main:Notify({
            Title = "Settings",
            Text = "Binds OFF!",
            Time = 2,
            AutoClose = true
        })
        ToggledFrame.Visible = false
    end)
    
    BindsOffCorner.CornerRadius = UDim.new(3, 0)
    BindsOffCorner.Name = "BindsOffCorner"
    BindsOffCorner.Parent = BindsOff

    LuaButton.Name = "LuaButton"
    LuaButton.Parent = SettingsFrame
    LuaButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LuaButton.BackgroundTransparency = 1.000
    LuaButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LuaButton.BorderSizePixel = 0
    LuaButton.Position = UDim2.new(0.0837988853, 0, 0.723393798, 0)
    LuaButton.Size = UDim2.new(0, 124, 0, 38)
    LuaButton.Font = Enum.Font.GothamBold
    LuaButton.Text = "Lua"
    LuaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LuaButton.TextSize = 17.000
    LuaButton.TextXAlignment = Enum.TextXAlignment.Left

    LuaButtonStroke.Color = Color3.fromRGB(38, 81, 135)
    LuaButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    LuaButtonStroke.LineJoinMode = Enum.LineJoinMode.Round
    LuaButtonStroke.Thickness = 1
    LuaButtonStroke.Parent = LuaButton
    
    LuaButtonPadding.Name = "LuaButtonPadding"
    LuaButtonPadding.Parent = LuaButton
    LuaButtonPadding.PaddingLeft = UDim.new(0, 7)
    
    LuaButtonCorner.CornerRadius = UDim.new(0, 4)
    LuaButtonCorner.Name = "LuaButtonCorner"
    LuaButtonCorner.Parent = LuaButton
    
    LuaButtonCode.Name = "LuaButtonCode"
    LuaButtonCode.Parent = LuaButton
    LuaButtonCode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LuaButtonCode.BackgroundTransparency = 1.000
    LuaButtonCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LuaButtonCode.BorderSizePixel = 0
    LuaButtonCode.Position = UDim2.new(0.675213695, 0, 0.121649489, 0)
    LuaButtonCode.Size = UDim2.new(0, 28, 0, 28)
    LuaButtonCode.Image = "http://www.roblox.com/asset/?id=6022668955"

    LuaButton.MouseButton1Click:Connect(function()
        
        SettingsFrame.Visible = false
        SettingsToggled = false
        LuaFrame.Visible = true
    end)

    ChatButton.Name = "ChatButton"
    ChatButton.Parent = SettingsFrame
    ChatButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ChatButton.BackgroundTransparency = 1.000
    ChatButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ChatButton.BorderSizePixel = 0
    ChatButton.Position = UDim2.new(0.0837988853, 0, 0.866676092, 0)
    ChatButton.Size = UDim2.new(0, 124, 0, 38)
    ChatButton.Font = Enum.Font.GothamBold
    ChatButton.Text = "Chat"
    ChatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ChatButton.TextSize = 17.000
    ChatButton.TextXAlignment = Enum.TextXAlignment.Left
    
    ChatButtonPadding.Name = "ChatButtonPadding"
    ChatButtonPadding.Parent = ChatButton
    ChatButtonPadding.PaddingLeft = UDim.new(0, 7)
    
    ChatButtonCorner.CornerRadius = UDim.new(0, 4)
    ChatButtonCorner.Name = "ChatButtonCorner"
    ChatButtonCorner.Parent = ChatButton

    ChatButtonStroke.Color = Color3.fromRGB(38, 81, 135)
    ChatButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ChatButtonStroke.LineJoinMode = Enum.LineJoinMode.Round
    ChatButtonStroke.Thickness = 1
    ChatButtonStroke.Parent = ChatButton
    
    ChatButtonChat.Name = "ChatButtonChat"
    ChatButtonChat.Parent = ChatButton
    ChatButtonChat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ChatButtonChat.BackgroundTransparency = 1.000
    ChatButtonChat.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ChatButtonChat.BorderSizePixel = 0
    ChatButtonChat.Position = UDim2.new(0.726495743, 0, 0.280721575, 0)
    ChatButtonChat.Size = UDim2.new(0, 22, 0, 21)
    ChatButtonChat.Image = "http://www.roblox.com/asset/?id=6035181869"
    
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseSettings.BackgroundTransparency = 1.000
    CloseSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseSettings.BorderSizePixel = 0
    CloseSettings.Position = UDim2.new(0.91900003, 0, -0.0270000007, 0)
    CloseSettings.Size = UDim2.new(0, 35, 0, 36)
    CloseSettings.AutoButtonColor = false
    CloseSettings.Font = Enum.Font.GothamBold
    CloseSettings.Text = "x"
    CloseSettings.TextColor3 = Color3.fromRGB(46, 125, 194)
    CloseSettings.TextSize = 20.000

    CloseSettings.MouseButton1Click:Connect(function()
        
        SettingsFrame.Visible = false
        SettingsToggled = false
    end)

    --[[
        Lua Scripting
    ]]--


        
        LuaFrame.Name = "LuaFrame"
        LuaFrame.Parent = MainFrame
        LuaFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        LuaFrame.BackgroundTransparency = 0.050
        LuaFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LuaFrame.BorderSizePixel = 0
        LuaFrame.Position = UDim2.new(1.05754292, 0, 0.0571847521, 0)
        LuaFrame.Size = UDim2.new(0, 540, 0, 502)
        LuaFrame.Visible = false
        
        LuaFrameCorner.CornerRadius = UDim.new(0, 4)
        LuaFrameCorner.Name = "LuaFrameCorner"
        LuaFrameCorner.Parent = LuaFrame
        
        LuaTitle.Name = "LuaTitle"
        LuaTitle.Parent = LuaFrame
        LuaTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LuaTitle.BackgroundTransparency = 1.000
        LuaTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LuaTitle.BorderSizePixel = 0
        LuaTitle.Position = UDim2.new(0.270148396, 0, -0.000112343594, 0)
        LuaTitle.Size = UDim2.new(0, 248, 0, 67)
        LuaTitle.Font = Enum.Font.FredokaOne
        LuaTitle.Text = "LUA"
        LuaTitle.TextColor3 = Color3.fromRGB(239, 248, 246)
        LuaTitle.TextSize = 45.000
        LuaTitle.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
        LuaTitle.TextStrokeTransparency = 1
        
        LuaFrameLine.Name = "LuaFrameLine"
        LuaFrameLine.Parent = LuaFrame
        LuaFrameLine.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        LuaFrameLine.BackgroundTransparency = 0.800
        LuaFrameLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LuaFrameLine.BorderSizePixel = 0
        LuaFrameLine.Position = UDim2.new(0, 0, 0.136003897, 0)
        LuaFrameLine.Size = UDim2.new(1, 0, 0, 1)
        
        LuaFrameLine2.Name = "LuaFrameLine2"
        LuaFrameLine2.Parent = LuaFrame
        LuaFrameLine2.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        LuaFrameLine2.BackgroundTransparency = 1.000
        LuaFrameLine2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LuaFrameLine2.BorderSizePixel = 0
        LuaFrameLine2.Position = UDim2.new(0, 0, 0.809246898, 0)
        LuaFrameLine2.Size = UDim2.new(1, 0, 0, 1)
        
        CloseLuaFrame.Name = "CloseLuaFrame"
        CloseLuaFrame.Parent = LuaFrame
        CloseLuaFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseLuaFrame.BackgroundTransparency = 1.000
        CloseLuaFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseLuaFrame.BorderSizePixel = 0
        CloseLuaFrame.Position = UDim2.new(0.947, 0, -0.01, 0)
        CloseLuaFrame.Size = UDim2.new(0, 35, 0, 36)
        CloseLuaFrame.AutoButtonColor = false
        CloseLuaFrame.Font = Enum.Font.GothamBold
        CloseLuaFrame.Text = "x"
        CloseLuaFrame.TextColor3 = Color3.fromRGB(46, 125, 194)
        CloseLuaFrame.TextSize = 24

        CloseLuaFrame.MouseButton1Click:Connect(function()
            
            LuaFrame.Visible = false
        end)

        WriteScript.Name = "WriteScript"
        WriteScript.Parent = LuaFrame
        WriteScript.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        WriteScript.BackgroundTransparency = 1.000
        WriteScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WriteScript.BorderSizePixel = 0
        WriteScript.Position = UDim2.new(0.850000024, 0, 0.00999999978, 0)
        WriteScript.Size = UDim2.new(0, 20, 0, 20)
        WriteScript.Image = "http://www.roblox.com/asset/?id=6034328955"
        WriteScript.ImageColor3 = Color3.fromRGB(46, 125, 194)

        WriteScript.MouseButton1Click:Connect(function()
            
            WriteScriptFrame.Visible = true
            LuaScriptFrame.Visible = false
        end)

        WriteScriptFrame.Name = "WriteScriptFrame"
        WriteScriptFrame.Parent = LuaFrame
        WriteScriptFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 25)
        WriteScriptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WriteScriptFrame.BorderSizePixel = 0
        WriteScriptFrame.Position = UDim2.new(0.057407748, 0, 0.173306838, 0)
        WriteScriptFrame.Size = UDim2.new(0, 476, 0, 266)
        WriteScriptFrame.Visible = false
        
        WriteScriptFrameCorner.Name = "WriteScriptFrameCorner"
        WriteScriptFrameCorner.Parent = WriteScriptFrame
        
        NameBox.Name = "NameBox"
        NameBox.Parent = WriteScriptFrame
        NameBox.BackgroundColor3 = Color3.fromRGB(12, 86, 126)
        NameBox.BackgroundTransparency = 0.800
        NameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NameBox.BorderSizePixel = 0
        NameBox.Position = UDim2.new(0.271008402, 0, 0.548872173, 0)
        NameBox.Size = UDim2.new(0, 217, 0, 35)
        NameBox.Font = Enum.Font.SourceSans
        NameBox.PlaceholderText = "Write Script Name"
        NameBox.Text = ""
        NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameBox.TextSize = 14.000
        NameBox.TextWrapped = true
        
        NameBoxCorner.CornerRadius = UDim.new(0, 7)
        NameBoxCorner.Name = "NameBoxCorner"
        NameBoxCorner.Parent = NameBox
        
        WriteBox.Name = "WriteBox"
        WriteBox.Parent = WriteScriptFrame
        WriteBox.BackgroundColor3 = Color3.fromRGB(12, 86, 126)
        WriteBox.BackgroundTransparency = 0.800
        WriteBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WriteBox.BorderSizePixel = 0
        WriteBox.Position = UDim2.new(0.271008402, 0, 0.0601503775, 0)
        WriteBox.Size = UDim2.new(0, 217, 0, 72)
        WriteBox.Font = Enum.Font.SourceSans
        WriteBox.PlaceholderText = "Paste Script Here!"
        WriteBox.Text = ""
        WriteBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        WriteBox.TextSize = 14.000
        WriteBox.TextWrapped = true
        
        WriteBoxCorner.CornerRadius = UDim.new(0, 7)
        WriteBoxCorner.Name = "WriteBoxCorner"
        WriteBoxCorner.Parent = WriteBox
        
        WriteButton.Name = "WriteButton"
        WriteButton.Parent = WriteScriptFrame
        WriteButton.BackgroundColor3 = Color3.fromRGB(6, 45, 66)
        WriteButton.BackgroundTransparency = 0.550
        WriteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WriteButton.BorderSizePixel = 0
        WriteButton.Position = UDim2.new(0.359243691, 0, 0.815789461, 0)
        WriteButton.Size = UDim2.new(0, 135, 0, 40)
        WriteButton.AutoButtonColor = false
        WriteButton.Font = Enum.Font.Gotham
        WriteButton.Text = "Write Script"
        WriteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        WriteButton.TextSize = 14.000

        WriteButton.MouseButton1Click:Connect(function()
            
            WriteScriptFrame.Visible = false
            LuaScriptFrame.Visible = true
            writefile(Folder1.."/Scripts/"..NameBox.Text..".txt", WriteBox.Text)
        end)
        
        WriteButtonCorner.Name = "WriteButtonCorner"
        WriteButtonCorner.Parent = WriteButton
        
        CloseWriteFrame.Name = "CloseWriteFrame"
        CloseWriteFrame.Parent = WriteScriptFrame
        CloseWriteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseWriteFrame.BackgroundTransparency = 1.000
        CloseWriteFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseWriteFrame.BorderSizePixel = 0
        CloseWriteFrame.Position = UDim2.new(0.932388961, 0, -0.0249921177, 0)
        CloseWriteFrame.Size = UDim2.new(0, 35, 0, 36)
        CloseWriteFrame.AutoButtonColor = false
        CloseWriteFrame.Font = Enum.Font.GothamBold
        CloseWriteFrame.Text = "x"
        CloseWriteFrame.TextColor3 = Color3.fromRGB(46, 125, 194)
        CloseWriteFrame.TextSize = 20.000

        CloseWriteFrame.MouseButton1Click:Connect(function()
            
            WriteScriptFrame.Visible = false
            LuaScriptFrame.Visible = true
        end)
        
        LuaScriptFrame.Name = "LuaScriptFrame"
        LuaScriptFrame.Parent = LuaFrame
        LuaScriptFrame.Active = true
        LuaScriptFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LuaScriptFrame.BackgroundTransparency = 1.000
        LuaScriptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LuaScriptFrame.BorderSizePixel = 0
        LuaScriptFrame.Position = UDim2.new(0.0229357686, 0, 0.164772704, 0)
        LuaScriptFrame.Size = UDim2.new(0, 521, 0, 412)
        LuaScriptFrame.ScrollBarThickness = 0
        
        LuaScriptFrameLayout.Name = "LuaScriptFrameLayout"
        LuaScriptFrameLayout.Parent = LuaScriptFrame
        LuaScriptFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LuaScriptFrameLayout.Padding = UDim.new(0, 15)

        local RefreshScripts = Instance.new("ImageButton")
        
        RefreshScripts.Name = "RefreshScripts"
        RefreshScripts.Parent = LuaFrame
        RefreshScripts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RefreshScripts.BackgroundTransparency = 1.000
        RefreshScripts.BorderColor3 = Color3.fromRGB(0, 0, 0)
        RefreshScripts.BorderSizePixel = 0
        RefreshScripts.Position = UDim2.new(0.91, 0, 0.005, 0)
        RefreshScripts.Size = UDim2.new(0, 25, 0, 25)
        RefreshScripts.Image = "http://www.roblox.com/asset/?id=6031097226"
        RefreshScripts.ImageColor3 = Color3.fromRGB(46, 125, 194)

        local ListScripts = listfiles(Folder.."/Scripts")

        RefreshScripts.MouseButton1Click:Connect(function()
            
            spawn(function()
                TweenService:Create(
                    RefreshScripts,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {Rotation = 360}
                ):Play()
                repeat wait() until RefreshScripts.Rotation == 360
                RefreshScripts.Rotation = 0
            end)

            local ListScripts = listfiles(Folder.."/Scripts")
            for i,v in pairs(LuaScriptFrame:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                end
            end
            for i,v in pairs(ListScripts) do
                local file_path = v
                local file_name = string.match(file_path, "[^\\]*$")
                local file_name_without_extension = string.gsub(file_name, "%..*$", "")
    
                local Script = Instance.new("TextButton")
                local ScriptCorner = Instance.new("UICorner")
                local ScriptTitle = Instance.new("TextLabel")
                local LoadScript = Instance.new("TextButton")
                local LoadText = Instance.new("TextLabel")
                local LoadScriptCorner = Instance.new("UICorner")
                local LoadImage = Instance.new("ImageLabel")
                local ScriptSettings = Instance.new("ImageButton")
                local SettignsLuaFrame = Instance.new("Frame")
                local SettignsLuaFrameLayout = Instance.new("UIListLayout")
                local DeleteLua = Instance.new("ImageButton")
                local EditScript = Instance.new("ImageButton")
                local ShareScript = Instance.new("ImageButton")
    
                Script.Name = "Script"
                Script.Parent = LuaScriptFrame
                Script.BackgroundColor3 = Color3.fromRGB(4, 18, 36)
                Script.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Script.BorderSizePixel = 0
                Script.Position = UDim2.new(0, 0, 7.11365473e-08, 0)
                Script.Size = UDim2.new(0, 509, 0, 44)
                Script.AutoButtonColor = false
                Script.Font = Enum.Font.SourceSans
                Script.Text = ""
                Script.TextColor3 = Color3.fromRGB(0, 0, 0)
                Script.TextSize = 14.000
                
                local ScriptStroke = Instance.new("UIStroke")
        
                ScriptStroke.Color = Color3.fromRGB(4, 28, 44)
                ScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ScriptStroke.LineJoinMode = Enum.LineJoinMode.Round
                ScriptStroke.Thickness = 1
                ScriptStroke.Parent = Script
                
                ScriptCorner.Name = "ScriptCorner"
                ScriptCorner.Parent = Script
                
                ScriptTitle.Name = "ScriptTitle"
                ScriptTitle.Parent = Script
                ScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ScriptTitle.BackgroundTransparency = 1.000
                ScriptTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ScriptTitle.BorderSizePixel = 0
                ScriptTitle.Position = UDim2.new(0.0308056865, 0, 0.240259692, 0)
                ScriptTitle.Size = UDim2.new(0, 61, 0, 21)
                ScriptTitle.Font = Enum.Font.GothamBold
                ScriptTitle.Text = file_name_without_extension
                ScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ScriptTitle.TextSize = 15.000
                ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                LoadScript.Name = "LoadScript"
                LoadScript.Parent = Script
                LoadScript.BackgroundColor3 = Color3.fromRGB(3, 123, 182)
                LoadScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
                LoadScript.Position = UDim2.new(0.824462891, 0, 0.159090906, 0)
                LoadScript.Size = UDim2.new(0, 82, 0, 30)
                LoadScript.AutoButtonColor = false
                LoadScript.Font = Enum.Font.SourceSans
                LoadScript.Text = ""
                LoadScript.TextColor3 = Color3.fromRGB(0, 0, 0)
                LoadScript.TextSize = 14.000
    
                LoadScript.MouseButton1Click:Connect(function()
                    
                    if LoadText.Text == "Load" then
                        getgenv().Lua = getgenv().LuaSection:Tab(file_name_without_extension)
                        local goo, bad = pcall(function()
                            wait(1)
                            loadfile(v)()
                        end)
                        Neverlose_Main:Notify({
                            Title = "Settings",
                            Text = file_name_without_extension.." loaded",
                            Time = 2,
                            AutoClose = true
                        })
                        if goo == false then
                            Neverlose_Main:Notify({
                                Title = "Settings",
                                Text = "Error: "..file_name_without_extension..bad,
                                Time = 2,
                                AutoClose = true
                            })
                            for i,v in pairs(TabHolder.Lua:GetChildren()) do
                                if v.Name == file_name_without_extension then
                                    v:Destroy()
                                end
                            end
                        end
                        LoadText.Text = "UnLoad"
                        LoadImage.Visible = false
                    else
                        -- ContainerHolder
                        for i,v in pairs(TabHolder.Lua:GetChildren()) do
                            if v.Name == file_name_without_extension then
                                v:Destroy()
                            end
                        end
    
                        for i,v in pairs(ContainerHolder:GetChildren()) do
                            if v.Name == file_name_without_extension then
                                v:Destroy()
                            end
                        end
                        Neverlose_Main:Notify({
                            Title = "Settings",
                            Text = file_name_without_extension.." Unloaded",
                            Time = 2,
                            AutoClose = true
                        })
                        LoadText.Text = "Load"
                        LoadImage.Visible = true
                    end
                end)
                
                LoadText.Name = "LoadText"
                LoadText.Parent = LoadScript
                LoadText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LoadText.BackgroundTransparency = 1.000
                LoadText.BorderColor3 = Color3.fromRGB(0, 0, 0)
                LoadText.BorderSizePixel = 0
                LoadText.Position = UDim2.new(0.434085011, 0, 0.233333334, 0)
                LoadText.Size = UDim2.new(0, 37, 0, 15)
                LoadText.Font = Enum.Font.GothamBold
                LoadText.Text = "Load"
                LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
                LoadText.TextSize = 14.000
                LoadText.TextXAlignment = Enum.TextXAlignment.Right
                
                LoadScriptCorner.CornerRadius = UDim.new(0, 5)
                LoadScriptCorner.Name = "LoadScriptCorner"
                LoadScriptCorner.Parent = LoadScript
                
                LoadImage.Name = "LoadImage"
                LoadImage.Parent = LoadScript
                LoadImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LoadImage.BackgroundTransparency = 1.000
                LoadImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
                LoadImage.BorderSizePixel = 0
                LoadImage.Position = UDim2.new(0, 0, 0.100000001, 0)
                LoadImage.Size = UDim2.new(0, 30, 0, 23)
                LoadImage.Image = "http://www.roblox.com/asset/?id=6026663699"
                
                ScriptSettings.Name = "ScriptSettings"
                ScriptSettings.Parent = Script
                ScriptSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ScriptSettings.BackgroundTransparency = 1.000
                ScriptSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ScriptSettings.BorderSizePixel = 0
                ScriptSettings.Position = UDim2.new(0.768745601, 0, 0.295454532, 0)
                ScriptSettings.Size = UDim2.new(0, 18, 0, 18)
                ScriptSettings.Image = "http://www.roblox.com/asset/?id=6031280882"
                local ScriptSettignsToggled = false

                ScriptSettings.MouseButton1Click:Connect(function()
                    
                    ScriptSettignsToggled = not ScriptSettignsToggled
                    SettignsLuaFrame.Visible = ScriptSettignsToggled
                end)
                
                SettignsLuaFrame.Name = "SettignsLuaFrame"
                SettignsLuaFrame.Parent = Script
                SettignsLuaFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SettignsLuaFrame.BackgroundTransparency = 1.000
                SettignsLuaFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SettignsLuaFrame.BorderSizePixel = 0
                SettignsLuaFrame.Position = UDim2.new(0.267190576, 0, 0.181818187, 0)
                SettignsLuaFrame.Size = UDim2.new(0, 231, 0, 29)
                SettignsLuaFrame.Visible = false
                
                SettignsLuaFrameLayout.Name = "SettignsLuaFrameLayout"
                SettignsLuaFrameLayout.Parent = SettignsLuaFrame
                SettignsLuaFrameLayout.FillDirection = Enum.FillDirection.Horizontal
                SettignsLuaFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                SettignsLuaFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SettignsLuaFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                SettignsLuaFrameLayout.Padding = UDim.new(0, 13)
                
                DeleteLua.Name = "DeleteLua"
                DeleteLua.Parent = SettignsLuaFrame
                DeleteLua.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DeleteLua.BackgroundTransparency = 1.000
                DeleteLua.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DeleteLua.BorderSizePixel = 0
                DeleteLua.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
                DeleteLua.Size = UDim2.new(0, 20, 0, 20)
                DeleteLua.Image = "http://www.roblox.com/asset/?id=6035067843"
                DeleteLua.ImageColor3 = Color3.fromRGB(255, 69, 72)
        
                DeleteLua.MouseButton1Click:Connect(function()
                    
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = "Deleted Script!",
                        Time = 2,
                        AutoClose = true
                    })
                    for i,v in pairs(TabHolder.Lua:GetChildren()) do
                        if v.Name == file_name_without_extension then
                            v:Destroy()
                        end
                    end

                    for i,v in pairs(ContainerHolder:GetChildren()) do
                        if v.Name == file_name_without_extension then
                            v:Destroy()
                        end
                    end
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = file_name_without_extension.." Unloaded",
                        Time = 2,
                        AutoClose = true
                    })
                    LoadText.Text = "Load"
                    LoadImage.Visible = true
                    delfile(v)
                    Script:Destroy()
                end)
                
                EditScript.Name = "EditScript"
                EditScript.Parent = SettignsLuaFrame
                EditScript.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                EditScript.BackgroundTransparency = 1.000
                EditScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
                EditScript.BorderSizePixel = 0
                EditScript.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
                EditScript.Size = UDim2.new(0, 20, 0, 20)
                EditScript.Image = "http://www.roblox.com/asset/?id=6034328955"
                EditScript.ImageColor3 = Color3.fromRGB(16, 76, 141)
        
                EditScript.MouseButton1Click:Connect(function()
                    
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = "Still in Testing!",
                        Time = 2,
                        AutoClose = true
                    })
                end)
                
                ShareScript.Name = "ShareScript"
                ShareScript.Parent = SettignsLuaFrame
                ShareScript.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ShareScript.BackgroundTransparency = 1.000
                ShareScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ShareScript.BorderSizePixel = 0
                ShareScript.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
                ShareScript.Size = UDim2.new(0, 20, 0, 20)
                ShareScript.Image = "http://www.roblox.com/asset/?id=6034230648"
                ShareScript.ImageColor3 = Color3.fromRGB(16, 76, 141)
        
                ShareScript.MouseButton1Click:Connect(function()
                    
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = "Copied to clipboard!",
                        Time = 2,
                        AutoClose = true
                    })
                    local readedfile = readfile(v)
                    setclipboard(readedfile)
                end)
            end
    
        end)

        for i,v in pairs(ListScripts) do
            local file_path = v
            local file_name = string.match(file_path, "[^\\]*$")
            local file_name_without_extension = string.gsub(file_name, "%..*$", "")
    
            print(file_name_without_extension)

            local Script = Instance.new("TextButton")
            local ScriptCorner = Instance.new("UICorner")
            local ScriptTitle = Instance.new("TextLabel")
            local LoadScript = Instance.new("TextButton")
            local LoadText = Instance.new("TextLabel")
            local LoadScriptCorner = Instance.new("UICorner")
            local LoadImage = Instance.new("ImageLabel")
            local ScriptSettings = Instance.new("ImageButton")
            local SettignsLuaFrame = Instance.new("Frame")
            local SettignsLuaFrameLayout = Instance.new("UIListLayout")
            local DeleteLua = Instance.new("ImageButton")
            local EditScript = Instance.new("ImageButton")
            local ShareScript = Instance.new("ImageButton")

            Script.Name = "Script"
            Script.Parent = LuaScriptFrame
            Script.BackgroundColor3 = Color3.fromRGB(4, 18, 36)
            Script.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Script.BorderSizePixel = 0
            Script.Position = UDim2.new(0, 0, 7.11365473e-08, 0)
            Script.Size = UDim2.new(0, 509, 0, 44)
            Script.AutoButtonColor = false
            Script.Font = Enum.Font.SourceSans
            Script.Text = ""
            Script.TextColor3 = Color3.fromRGB(0, 0, 0)
            Script.TextSize = 14.000
            
            local ScriptStroke = Instance.new("UIStroke")
    
            ScriptStroke.Color = Color3.fromRGB(4, 28, 44)
            ScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            ScriptStroke.LineJoinMode = Enum.LineJoinMode.Round
            ScriptStroke.Thickness = 1
            ScriptStroke.Parent = Script
            
            ScriptCorner.Name = "ScriptCorner"
            ScriptCorner.Parent = Script
            
            ScriptTitle.Name = "ScriptTitle"
            ScriptTitle.Parent = Script
            ScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScriptTitle.BackgroundTransparency = 1.000
            ScriptTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ScriptTitle.BorderSizePixel = 0
            ScriptTitle.Position = UDim2.new(0.0308056865, 0, 0.240259692, 0)
            ScriptTitle.Size = UDim2.new(0, 61, 0, 21)
            ScriptTitle.Font = Enum.Font.GothamBold
            ScriptTitle.Text = file_name_without_extension
            ScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ScriptTitle.TextSize = 15.000
            ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            LoadScript.Name = "LoadScript"
            LoadScript.Parent = Script
            LoadScript.BackgroundColor3 = Color3.fromRGB(3, 123, 182)
            LoadScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
            LoadScript.Position = UDim2.new(0.824462891, 0, 0.159090906, 0)
            LoadScript.Size = UDim2.new(0, 82, 0, 30)
            LoadScript.AutoButtonColor = false
            LoadScript.Font = Enum.Font.SourceSans
            LoadScript.Text = ""
            LoadScript.TextColor3 = Color3.fromRGB(0, 0, 0)
            LoadScript.TextSize = 14.000

            LoadScript.MouseButton1Click:Connect(function()
                
                if LoadText.Text == "Load" then
                    getgenv().Lua = getgenv().LuaSection:Tab(file_name_without_extension)
                    local goo, bad = pcall(function()
                        wait(1)
                        loadfile(v)()
                    end)
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = file_name_without_extension.." loaded",
                        Time = 2,
                        AutoClose = true
                    })
                    if goo == false then
                        Neverlose_Main:Notify({
                            Title = "Settings",
                            Text = "Error: "..file_name_without_extension..bad,
                            Time = 2,
                            AutoClose = true
                        })
                        for i,v in pairs(TabHolder.Lua:GetChildren()) do
                            if v.Name == file_name_without_extension then
                                v:Destroy()
                            end
                        end
                    end
                    LoadText.Text = "UnLoad"
                    LoadImage.Visible = false
                else
                    -- ContainerHolder
                    for i,v in pairs(TabHolder.Lua:GetChildren()) do
                        if v.Name == file_name_without_extension then
                            v:Destroy()
                        end
                    end

                    for i,v in pairs(ContainerHolder:GetChildren()) do
                        if v.Name == file_name_without_extension then
                            v:Destroy()
                        end
                    end
                    Neverlose_Main:Notify({
                        Title = "Settings",
                        Text = file_name_without_extension.." Unloaded",
                        Time = 2,
                        AutoClose = true
                    })
                    LoadText.Text = "Load"
                    LoadImage.Visible = true
                end
            end)
            
            LoadText.Name = "LoadText"
            LoadText.Parent = LoadScript
            LoadText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LoadText.BackgroundTransparency = 1.000
            LoadText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            LoadText.BorderSizePixel = 0
            LoadText.Position = UDim2.new(0.434085011, 0, 0.233333334, 0)
            LoadText.Size = UDim2.new(0, 37, 0, 15)
            LoadText.Font = Enum.Font.GothamBold
            LoadText.Text = "Load"
            LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LoadText.TextSize = 14.000
            LoadText.TextXAlignment = Enum.TextXAlignment.Right
            
            LoadScriptCorner.CornerRadius = UDim.new(0, 5)
            LoadScriptCorner.Name = "LoadScriptCorner"
            LoadScriptCorner.Parent = LoadScript
            
            LoadImage.Name = "LoadImage"
            LoadImage.Parent = LoadScript
            LoadImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LoadImage.BackgroundTransparency = 1.000
            LoadImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
            LoadImage.BorderSizePixel = 0
            LoadImage.Position = UDim2.new(0, 0, 0.100000001, 0)
            LoadImage.Size = UDim2.new(0, 30, 0, 23)
            LoadImage.Image = "http://www.roblox.com/asset/?id=6026663699"
            
            ScriptSettings.Name = "ScriptSettings"
            ScriptSettings.Parent = Script
            ScriptSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScriptSettings.BackgroundTransparency = 1.000
            ScriptSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ScriptSettings.BorderSizePixel = 0
            ScriptSettings.Position = UDim2.new(0.768745601, 0, 0.295454532, 0)
            ScriptSettings.Size = UDim2.new(0, 18, 0, 18)
            ScriptSettings.Image = "http://www.roblox.com/asset/?id=6031280882"

            local ScriptSettignsToggled = false

            ScriptSettings.MouseButton1Click:Connect(function()
                
                ScriptSettignsToggled = not ScriptSettignsToggled
                SettignsLuaFrame.Visible = ScriptSettignsToggled
            end)
            
            SettignsLuaFrame.Name = "SettignsLuaFrame"
            SettignsLuaFrame.Parent = Script
            SettignsLuaFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SettignsLuaFrame.BackgroundTransparency = 1.000
            SettignsLuaFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SettignsLuaFrame.BorderSizePixel = 0
            SettignsLuaFrame.Position = UDim2.new(0.267190576, 0, 0.181818187, 0)
            SettignsLuaFrame.Size = UDim2.new(0, 231, 0, 29)
            SettignsLuaFrame.Visible = false
            
            SettignsLuaFrameLayout.Name = "SettignsLuaFrameLayout"
            SettignsLuaFrameLayout.Parent = SettignsLuaFrame
            SettignsLuaFrameLayout.FillDirection = Enum.FillDirection.Horizontal
            SettignsLuaFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SettignsLuaFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SettignsLuaFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            SettignsLuaFrameLayout.Padding = UDim.new(0, 13)
            
            DeleteLua.Name = "DeleteLua"
            DeleteLua.Parent = SettignsLuaFrame
            DeleteLua.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DeleteLua.BackgroundTransparency = 1.000
            DeleteLua.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DeleteLua.BorderSizePixel = 0
            DeleteLua.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
            DeleteLua.Size = UDim2.new(0, 20, 0, 20)
            DeleteLua.Image = "http://www.roblox.com/asset/?id=6035067843"
            DeleteLua.ImageColor3 = Color3.fromRGB(255, 69, 72)
    
            DeleteLua.MouseButton1Click:Connect(function()
                
                Neverlose_Main:Notify({
                    Title = "Settings",
                    Text = "Deleted Script!",
                    Time = 2,
                    AutoClose = true
                })
                
                for i,v in pairs(TabHolder.Lua:GetChildren()) do
                    if v.Name == file_name_without_extension then
                        v:Destroy()
                    end
                end

                for i,v in pairs(ContainerHolder:GetChildren()) do
                    if v.Name == file_name_without_extension then
                        v:Destroy()
                    end
                end
                Neverlose_Main:Notify({
                    Title = "Settings",
                    Text = file_name_without_extension.." Unloaded",
                    Time = 2,
                    AutoClose = true
                })
                
                delfile(v)
                Script:Destroy()
            end)
            
            EditScript.Name = "EditScript"
            EditScript.Parent = SettignsLuaFrame
            EditScript.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            EditScript.BackgroundTransparency = 1.000
            EditScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
            EditScript.BorderSizePixel = 0
            EditScript.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
            EditScript.Size = UDim2.new(0, 20, 0, 20)
            EditScript.Image = "http://www.roblox.com/asset/?id=6034328955"
            EditScript.ImageColor3 = Color3.fromRGB(16, 76, 141)
    
            EditScript.MouseButton1Click:Connect(function()
                
                Neverlose_Main:Notify({
                    Title = "Settings",
                    Text = "Still in Testing!",
                    Time = 2,
                    AutoClose = true
                })
            end)
            
            ShareScript.Name = "ShareScript"
            ShareScript.Parent = SettignsLuaFrame
            ShareScript.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ShareScript.BackgroundTransparency = 1.000
            ShareScript.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ShareScript.BorderSizePixel = 0
            ShareScript.Position = UDim2.new(0.0216450226, 0, 0.103448279, 0)
            ShareScript.Size = UDim2.new(0, 20, 0, 20)
            ShareScript.Image = "http://www.roblox.com/asset/?id=6034230648"
            ShareScript.ImageColor3 = Color3.fromRGB(16, 76, 141)
    
            ShareScript.MouseButton1Click:Connect(function()
                
                Neverlose_Main:Notify({
                    Title = "Settings",
                    Text = "Copied to clipboard!",
                    Time = 2,
                    AutoClose = true
                })
                local readedfile = readfile(v)
                setclipboard(readedfile)
            end)
            ShareScript.MouseEnter:Connect(function()
                Neverlose_Main:PlaySound(Neverlose_Main.Lib_Sounds.HoverSound)
            end)
        end
        
        LuaScriptFramePadding.Name = "LuaScriptFramePadding"
        LuaScriptFramePadding.Parent = LuaScriptFrame
        LuaScriptFramePadding.PaddingLeft = UDim.new(0, 5)
        LuaScriptFramePadding.PaddingTop = UDim.new(0, 5)




        local ChatFrame = Instance.new("Frame")
        local ChatFrameCorner = Instance.new("UICorner")
        local ChatTitle = Instance.new("TextLabel")
        local ChatFrameLine = Instance.new("Frame")
        local ChatFrameLine2 = Instance.new("Frame")
        local CloseChatFrame = Instance.new("TextButton")
        local ChatFrameFrame = Instance.new("ScrollingFrame")
        local ChatFrameLayout = Instance.new("UIListLayout")
        local ChatFramePadding = Instance.new("UIPadding")

        local ClearChat = Instance.new("ImageButton")
        local ChatBoxText = Instance.new("TextBox")
        local ChatBoxTextCorner = Instance.new("UICorner")
        local ChatBoxTextPadding = Instance.new("UIPadding")

        local SendChatButton = Instance.new("ImageButton")
        local ChatFrameLine_2 = Instance.new("Frame")

        ChatButton.Visible = true
        
        ChatButton.MouseButton1Click:Connect(function()
            
            ChatFrame.Visible = false
            -- SettingsFrame.Visible = false
            -- SettingsToggled = false
            Neverlose_Main:Notify({
                Title = "Neverlose",
                Text = "Feature Temporarily Disabled!"
            })
        end)
        
        ChatFrame.Name = "ChatFrame"
        ChatFrame.Parent = MainFrame
        ChatFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        ChatFrame.BackgroundTransparency = 0.050
        ChatFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatFrame.BorderSizePixel = 0
        ChatFrame.Position = UDim2.new(1.09486794, 0, 0.171554208, 0)
        ChatFrame.Size = UDim2.new(0, 540, 0, 447)
        ChatFrame.Visible = false
        MakeDraggable(ChatFrame, ChatFrame)
        
        ChatFrameCorner.CornerRadius = UDim.new(0, 4)
        ChatFrameCorner.Name = "ChatFrameCorner"
        ChatFrameCorner.Parent = ChatFrame
        
        ChatTitle.Name = "ChatTitle"
        ChatTitle.Parent = ChatFrame
        ChatTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ChatTitle.BackgroundTransparency = 1.000
        ChatTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatTitle.BorderSizePixel = 0
        ChatTitle.Position = UDim2.new(0.270148396, 0, -0.000112343594, 0)
        ChatTitle.Size = UDim2.new(0, 248, 0, 67)
        ChatTitle.Font = Enum.Font.FredokaOne
        ChatTitle.Text = "CHATTING"
        ChatTitle.TextColor3 = Color3.fromRGB(239, 248, 246)
        ChatTitle.TextSize = 45.000
        ChatTitle.TextStrokeColor3 = Color3.fromRGB(27, 141, 240)
        
        ChatFrameLine.Name = "ChatFrameLine"
        ChatFrameLine.Parent = ChatFrame
        ChatFrameLine.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        ChatFrameLine.BackgroundTransparency = 0.800
        ChatFrameLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatFrameLine.BorderSizePixel = 0
        ChatFrameLine.Position = UDim2.new(0, 0, 0.136003897, 0)
        ChatFrameLine.Size = UDim2.new(1, 0, 0, 1)
        
        ChatFrameLine2.Name = "ChatFrameLine2"
        ChatFrameLine2.Parent = ChatFrame
        ChatFrameLine2.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        ChatFrameLine2.BackgroundTransparency = 1.000
        ChatFrameLine2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatFrameLine2.BorderSizePixel = 0
        ChatFrameLine2.Position = UDim2.new(0, 0, 0.809246898, 0)
        ChatFrameLine2.Size = UDim2.new(1, 0, 0, 1)
        
        CloseChatFrame.Name = "CloseChatFrame"
        CloseChatFrame.Parent = ChatFrame
        CloseChatFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseChatFrame.BackgroundTransparency = 1.000
        CloseChatFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseChatFrame.BorderSizePixel = 0
        CloseChatFrame.Position = UDim2.new(0.944993913, 0, -0.00995453913, 0)
        CloseChatFrame.Size = UDim2.new(0, 35, 0, 36)
        CloseChatFrame.AutoButtonColor = false
        CloseChatFrame.Font = Enum.Font.GothamBold
        CloseChatFrame.Text = "x"
        CloseChatFrame.TextColor3 = Color3.fromRGB(46, 125, 194)
        CloseChatFrame.TextSize = 20.000

        CloseChatFrame.MouseButton1Click:Connect(function()
            
            ChatFrame.Visible = false
        end)
        
        ChatFrameFrame.Name = "ChatFrameFrame"
        ChatFrameFrame.Parent = ChatFrame
        ChatFrameFrame.Active = true
        ChatFrameFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ChatFrameFrame.BackgroundTransparency = 1.000
        ChatFrameFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatFrameFrame.BorderSizePixel = 0
        ChatFrameFrame.Position = UDim2.new(0.0229357686, 0, 0.164772734, 0)
        ChatFrameFrame.Size = UDim2.new(0, 521, 0, 292)
        ChatFrameFrame.ScrollBarThickness = 0
        
        ChatFrameLayout.Name = "ChatFrameLayout"
        ChatFrameLayout.Parent = ChatFrameFrame
        ChatFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ChatFrameLayout.Padding = UDim.new(0, 15)
        
        ChatFramePadding.Name = "ChatFramePadding"
        ChatFramePadding.Parent = ChatFrameFrame
        ChatFramePadding.PaddingLeft = UDim.new(0, 5)
        ChatFramePadding.PaddingTop = UDim.new(0, 10)

        getgenv().processedMessages = {}

        local loop = coroutine.create(function()
            while wait(math.random(1, 2)) do
                local data = req({
                    Url = "https://chatting.madsbrriinckbas.repl.co/api/poll/",
                    Method = "GET"
                })
                local data = game:GetService("HttpService"):JSONDecode(data.Body)
                for i,v in pairs(data.messages) do
                    if not getgenv().processedMessages[v.uid] then
                        getgenv().processedMessages[v.uid] = true -- Mark the message as processed

                        local ChatSocketFrame = Instance.new("Frame")
                        local ChatText = Instance.new("TextLabel")
                        local ChatSocketFrameCorner = Instance.new("UICorner")
                        local NameText = Instance.new("TextLabel")
                        local NameTextCorner = Instance.new("UICorner")

                        ChatSocketFrame.Name = "ChatSocketFrame"
                        ChatSocketFrame.Parent = ChatFrameFrame --game:GetService("CoreGui").Neverlose1.MainFrame.ChatFrame.ChatFrameFrame
                        ChatSocketFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        ChatSocketFrame.BackgroundTransparency = 1.000
                        ChatSocketFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        ChatSocketFrame.BorderSizePixel = 0
                        ChatSocketFrame.Position = UDim2.new(0, 0, -1.08218359e-07, 0)
                        ChatSocketFrame.Size = UDim2.new(0, 407, 0, 35)

                        local ChatSocketFrameStroke = Instance.new("UIStroke")
        
                        ChatSocketFrameStroke.Color = Color3.fromRGB(49, 100, 177)
                        ChatSocketFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        ChatSocketFrameStroke.LineJoinMode = Enum.LineJoinMode.Round
                        ChatSocketFrameStroke.Thickness = 1
                        ChatSocketFrameStroke.Parent = ChatSocketFrame
                        ChatSocketFrameStroke.Transparency = 0.35

                        ChatText.Name = "ChatText"
                        ChatText.Parent = ChatSocketFrame
                        ChatText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        ChatText.BackgroundTransparency = 1.000
                        ChatText.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        ChatText.BorderSizePixel = 0
                        ChatText.Position = UDim2.new(0.0270270277, 0, 0.297147036, 0)
                        ChatText.Size = UDim2.new(0, 41, 0, 16)
                        ChatText.Font = Enum.Font.Gotham
                        ChatText.Text = tostring(v.msg)
                        ChatText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        ChatText.TextSize = 14.000
                        ChatText.TextXAlignment = Enum.TextXAlignment.Left
                        ChatText.RichText = true
                        
                        ChatSocketFrameCorner.CornerRadius = UDim.new(0, 3)
                        ChatSocketFrameCorner.Name = "ChatSocketFrameCorner"
                        ChatSocketFrameCorner.Parent = ChatSocketFrame

                        NameText.Name = "NameText"
                        NameText.Parent = ChatSocketFrame
                        NameText.BackgroundColor3 = Color3.fromRGB(14, 14, 21)
                        NameText.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        NameText.BorderSizePixel = 0
                        NameText.Position = UDim2.new(0.0489999838, 0, -0.229999647, 0)
                        NameText.Size = UDim2.new(0, 66, 0, 14)
                        NameText.Font = Enum.Font.SourceSans
                        NameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        NameText.TextSize = 14.000
                        NameText.RichText = true

                        if Player.UserId == 2254026356 then
                            NameText.Text = "<font color='rgb(255,60,60)'>"..Player.Name.."</font>"
                        else
                            NameText.Text = "<font color='rgb(60,60,255)'>"..Player.Name.."</font>"
                        end

                        NameText.Size = UDim2.new(0, NameText.TextBounds.X + 20, 0, 14)

                        local NameTextStroke = Instance.new("UIStroke")
        
                        NameTextStroke.Color = Color3.fromRGB(49, 100, 177)
                        NameTextStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        NameTextStroke.LineJoinMode = Enum.LineJoinMode.Round
                        NameTextStroke.Thickness = 1
                        NameTextStroke.Parent = NameText
                        NameTextStroke.Transparency = 0.35
                        
                        NameTextCorner.Name = "NameTextCorner"
                        NameTextCorner.Parent = NameText

                        ChatFrameFrame.CanvasSize = UDim2.new(0, 0, 0, ChatFrameLayout.AbsoluteContentSize.Y + 30)
                    end
                end
            end
        end)
        coroutine.resume(loop)
        
        ClearChat.Name = "ClearChat"
        ClearChat.Parent = ChatFrame
        ClearChat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ClearChat.BackgroundTransparency = 1.000
        ClearChat.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ClearChat.BorderSizePixel = 0
        ClearChat.Position = UDim2.new(0.898000002, 0, 0.00499999989, 0)
        ClearChat.Size = UDim2.new(0, 25, 0, 25)
        ClearChat.Image = "http://www.roblox.com/asset/?id=6035181870"
        ClearChat.ImageColor3 = Color3.fromRGB(46, 125, 194)

        ClearChat.MouseButton1Click:Connect(function()
            
            for i,v in pairs(ChatFrameFrame:GetChildren()) do
                if v:IsA("Frame") then
                    v:Destroy()
                end
            end
        end)
        
        ChatBoxText.Name = "ChatBoxText"
        ChatBoxText.Parent = ChatFrame
        ChatBoxText.BackgroundColor3 = Color3.fromRGB(15, 40, 66)
        ChatBoxText.BackgroundTransparency = 0.300
        ChatBoxText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatBoxText.BorderSizePixel = 0
        ChatBoxText.Position = UDim2.new(0.129629627, 0, 0.86577183, 0)
        ChatBoxText.Size = UDim2.new(0, 405, 0, 38)
        ChatBoxText.ClearTextOnFocus = false
        ChatBoxText.Font = Enum.Font.Gotham
        ChatBoxText.Text = ""
        ChatBoxText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ChatBoxText.TextSize = 14.000
        ChatBoxText.TextXAlignment = Enum.TextXAlignment.Left

        ChatBoxText.FocusLost:Connect(function(ep)
            if ep then
                local Data = HttpService:JSONEncode({
                    msg = ChatBoxText.Text
                })
                req({
                    Url = "https://chatting.madsbrriinckbas.repl.co/api/send/",
                    Method = 'POST',
                    Body = Data,
                    Headers = {
                        ['Content-Type'] = 'application/json'
                    }
                })
                ChatBoxText.Text = ""
            end
        end)
        
        ChatBoxTextCorner.CornerRadius = UDim.new(0, 5)
        ChatBoxTextCorner.Name = "ChatBoxTextCorner"
        ChatBoxTextCorner.Parent = ChatBoxText

        ChatBoxTextPadding.Name = "ChatBoxTextPadding"
        ChatBoxTextPadding.Parent = ChatBoxText
        ChatBoxTextPadding.PaddingLeft = UDim.new(0, 12)
        
        SendChatButton.Name = "SendChatButton"
        SendChatButton.Parent = ChatBoxText
        SendChatButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SendChatButton.BackgroundTransparency = 1.000
        SendChatButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SendChatButton.BorderSizePixel = 0
        SendChatButton.Position = UDim2.new(0.925999999, 0, 0.163000003, 0)
        SendChatButton.Size = UDim2.new(0, 25, 0, 25)
        SendChatButton.Image = "http://www.roblox.com/asset/?id=6035067832"
        SendChatButton.ImageColor3 = Color3.fromRGB(46, 125, 194)

        SendChatButton.MouseButton1Click:Connect(function()
            
            local Data = HttpService:JSONEncode({
                msg = ChatBoxText.Text
            })
            req({
                Url = "https://chatting.madsbrriinckbas.repl.co/api/send/",
                Method = 'POST',
                Body = Data,
                Headers = {
                    ['Content-Type'] = 'application/json'
                }
            })
            ChatBoxText.Text = ""
        end)
        
        ChatFrameLine_2.Name = "ChatFrameLine"
        ChatFrameLine_2.Parent = ChatFrame
        ChatFrameLine_2.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        ChatFrameLine_2.BackgroundTransparency = 0.800
        ChatFrameLine_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChatFrameLine_2.BorderSizePixel = 0
        ChatFrameLine_2.Position = UDim2.new(-0.00185185182, 0, 0.818330586, 0)
        ChatFrameLine_2.Size = UDim2.new(1, 0, 0, 1)

        spawn(function()task.wait(.5)Neverlose_Main:AutoJoinDiscord("qq6WgyMwkw")end)

        Neverlose_Main:Notify({
            Title = "Welcome",
            Text = "Menu Key | LeftControl",
            Time = 2
        })
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                --// Background \\--
                KeyFrame.BackgroundColor3 = Neverlose_Main.Theme.Custom.Background
                MainFrame.BackgroundColor3 = Neverlose_Main.Theme.Custom.Background
                LeftFrame.BackgroundColor3 = Neverlose_Main.Theme.Custom.Background

                TweenService:Create(
                    MainFrameGlow,
                    TweenInfo.new(.4, Enum.EasingStyle.Quad),
                    {ImageColor3 = Neverlose_Main.Theme.Custom.Glow}
                ):Play()
                --// Section \\--


                --// Element \\
                -- Neverlose_Main.Theme.Custom.Section
                -- Neverlose_Main.Theme.Custom.Element
                -- Neverlose_Main.Theme.Custom.Text
            end)
        end
    end)
    return TabsSec
end
return Neverlose_Main
