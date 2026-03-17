-- =================== Zeno Secure Loader ===================

local SCRIPT_URL = "https://pastefy.app/YOUR_SCRIPT/raw"
local VERIFY_URL = "https://pastefy.app/YOUR_KEYS/raw"

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- =================== GUI ===================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 140)
Frame.Position = UDim2.new(0.5, -130, 0.5, -70)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "🔐 Zeno Hub"
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Box = Instance.new("TextBox", Frame)
Box.Size = UDim2.new(0.85,0,0,30)
Box.Position = UDim2.new(0.075,0,0.35,0)
Box.PlaceholderText = "Enter Key..."
Box.BackgroundColor3 = Color3.fromRGB(25,25,25)
Box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Box)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.85,0,0,30)
Btn.Position = UDim2.new(0.075,0,0.65,0)
Btn.Text = "🚀 Unlock"
Btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
Btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Btn)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-20)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextScaled = true

-- =================== KEY CHECK ===================
local function isValidKey(userKey)
    local success, data = pcall(function()
        return game:HttpGet(VERIFY_URL)
    end)

    if not success then return false end

    for key in string.gmatch(data, "[^\r\n]+") do
        if key == userKey then
            return true
        end
    end

    return false
end

Btn.MouseButton1Click:Connect(function()
    local USER_KEY = Box.Text:gsub("%s+", "")

    if not isValidKey(USER_KEY) then
        Status.Text = "❌ Invalid Key"
        return
    end

    Status.Text = "✅ Loading..."

    -- 🔐 pass key to main script
    getgenv().ZENO_KEY = USER_KEY

    local success, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)

    if not success then
        Status.Text = "❌ Script Error"
        warn(err)
    else
        ScreenGui:Destroy()
    end
end)
