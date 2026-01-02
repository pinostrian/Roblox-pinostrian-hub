-- Custom Rayfield-Style Library (Loadstring)
local Rayfield = {}
Rayfield.__index = Rayfield

function Rayfield:CreateWindow(config)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local player = Players.LocalPlayer

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomRayfieldUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromScale(0.45,0.55)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = Color3.fromRGB(15,18,25)
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageTransparency = 0.6
    Shadow.Size = UDim2.fromScale(1.1,1.1)
    Shadow.Position = UDim2.fromScale(-0.05,-0.05)
    Shadow.BackgroundTransparency = 1
    Shadow.Parent = Main

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = config.Name or "Custom Window"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(0,220,255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromScale(0.05,0.04)
    Title.Size = UDim2.fromScale(0.6,0.1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    -- Tabs container
    local Tabs = Instance.new("Frame")
    Tabs.Size = UDim2.fromScale(0.25,0.75)
    Tabs.Position = UDim2.fromScale(0.05,0.18)
    Tabs.BackgroundColor3 = Color3.fromRGB(20,25,35)
    Tabs.Parent = Main
    Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0,14)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.fromScale(0.6,0.75)
    Content.Position = UDim2.fromScale(0.35,0.18)
    Content.BackgroundColor3 = Color3.fromRGB(20,25,35)
    Content.Parent = Main
    Instance.new("UICorner", Content).CornerRadius = UDim.new(0,14)

    -- Dragging logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Window API
    local WindowAPI = {}
    WindowAPI.Tabs = {}

    function WindowAPI:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.fromScale(0.9,0.12)
        TabBtn.Position = UDim2.fromScale(0.05,(#Tabs:GetChildren()-1)*0.13)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30,35,50)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.fromRGB(220,220,220)
        TabBtn.Parent = Tabs
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,10)

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.fromScale(1,1)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = Content

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            tabContent.Visible = true
        end)

        local tabTable = {}
        tabTable.Content = tabContent

        function tabTable:CreateButton(txt, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.fromScale(0.9,0.12)
            Btn.Position = UDim2.fromScale(0.05,(#tabContent:GetChildren())*0.13)
            Btn.BackgroundColor3 = Color3.fromRGB(30,35,50)
            Btn.Text = txt
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.fromRGB(220,220,220)
            Btn.Parent = tabContent
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,180,220)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(30,35,50)}):Play()
            end)
            Btn.MouseButton1Click:Connect(callback)
        end

        function tabTable:CreateToggle(txt, default, callback)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.fromScale(0.9,0.12)
            toggle.Position = UDim2.fromScale(0.05,(#tabContent:GetChildren())*0.13)
            toggle.BackgroundColor3 = Color3.fromRGB(30,35,50)
            toggle.Text = txt.." : "..(default and "ON" or "OFF")
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            toggle.TextColor3 = Color3.fromRGB(220,220,220)
            toggle.Parent = tabContent
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

            local state = default
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = txt.." : "..(state and "ON" or "OFF")
                toggle.BackgroundColor3 = state and Color3.fromRGB(0,200,255) or Color3.fromRGB(30,35,50)
                callback(state)
            end)
        end

        return tabTable
    end

    return WindowAPI
end

return Rayfield
