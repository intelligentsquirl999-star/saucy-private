-- SAUCE FINAL GOD HUNTER – ONLY 100M+/s + TRUE S-TIER (Dec 2025)
if getgenv().SAUCE_ULTRA then return end
getgenv().SAUCE_ULTRA = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- CURRENT REAL S-TIER / GOD PETS (Dec 2025 – confirmed by every trading server)
local TRUE_GOD_PETS = {
    "strawberry elephant",          -- 1B+ value
    "dragon cannelloni",            -- 800M–1.5B
    "spaghetti tualetti",           -- 700M–1.2B
    "garama and madundung",         -- 600M–1B
    "ketchuru and masturu",         -- 600M–1B
    "la supreme combinasion",       -- 500M–900M
    "cocofanto elefanto",           -- 400M–800M
    "bombardiro crocodilo",         -- 400M–700M
    "brainrot god",                 -- 300M–600M
    "los bros",                     -- 250M–500M
    "money money man",              -- 200M–400M
    "money money puggy",            -- 180M–350M
    "blackhole goat"                -- 150M–300Utc
}

local MIN_RATE = 100000000  -- 100M+/s minimum (only the absolute best)

local function hasTrueGod()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        for _, god in TRUE_GOD_PETS do
                            if name:find(god) then
                                SG:SetCore("SendNotification",{
                                    Title = "TRUE GOD PET FOUND!",
                                    Text = tool.Name.." – STAYING FOREVER",
                                    Duration = 60
                                })
                                game:GetService("SoundService"):PlayLocalSound(game:GetService("SoundService"):CreateSound("rbxassetid://6026984221"))
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "100M+/s GOD PET!",
                                Text = tool.Name.." → "..string.format("%.1f", rate.Value/1000000).."M/s",
                                Duration = 60
                            })
                            game:GetService("SoundService"):PlayLocalSound(game:GetService("SoundService"):CreateSound("rbxassetid://6026984221"))
                            return true
                        end
                    end
                end
            end
            check(p.Backpack)
            if p.Character then check(p.Character) end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(2) do
        if hasTrueGod() then
            SG:SetCore("SendNotification",{
                Title = "SAUCE",
                Text = "TRUE GOD PET / 100M+ FOUND – HOPPING STOPPED",
                Duration = 30
            })
            break
        end

        local servers = {}
        local ok, data = pcall(function() return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end)
        if ok and data and data.data then servers = data.data end

        local hopped = false
        for _, srv in servers do
            if srv.playing < 75 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{Title="Sauce",Text="Hopping → "..srv.playing.." players",Duration=5})
                pcall(function() TS:TeleportToPlaceInstance(PlaceId, srv.id, PL) end)
                hopped = true
                break
            end
        end
        task.wait(hopped and 15 or 10)
    end
end)

SG:SetCore("SendNotification",{
    Title = "SAUCE GOD HUNTER",
    Text = "Active – stops ONLY on 100M+/s or TRUE S-Tier pets",
    Duration = 12
})
