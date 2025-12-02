-- SAUCE Core.lua – TRUE S-TIER / GOD PET HUNTER (Dec 2025)
if getgenv().SAUCE_GODHUNTER then return end
getgenv().SAUCE_GODHUNTER = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- TRUE GOD PETS (40M–200M+/s) – confirmed by every tier list & trading server (Dec 2025)
local GOD_PETS = {
    -- 100M+/s tier
    "strawberry elephant","dragon cannelloni","spaghetti tualetti",
    "garama and madundung","ketchuru and masturu","la supreme combinasion",
    "bombardiro crocodilo","cocofanto elefanto","piccione macchina",
    "bombombini gusini","los bros","brainrot god",

    -- 70M–100M+/s tier
    "money money man","money money puggy","blackhole goat","trenostruzzo turbo",
    "nuclearo dinossauro","la grande combinasion","los nooo my hotspotsitos",
    "chicleteira bicicleteira","pot hotspot","sahur combinasion",

    -- 40M–70M+/s tier (still insane)
    "las capuchinas","las sis","bisonte giuppitere","la vacca saturno saturnita",
    "la vacca staturno saturnita","chimpanzini spiderini","graipuss medussi",
    "noo my hotspot","los matteos","chachechi","tralaledon"
}

local MIN_RATE = 40000000  -- 40M+/s minimum

local function hasGodPet()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(cont)
                for _, tool in cont:GetChildren() do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        for _, rare in GOD_PETS do
                            if name:find(rare) then
                                SG:SetCore("SendNotification",{
                                    Title = "GOD PET FOUND!",
                                    Text = tool.Name.." (S-TIER)",
                                    Duration = 30
                                })
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "40M+/s FOUND!",
                                Text = tool.Name.." → "..string.format("%.1f", rate.Value/1000000).."M/s",
                                Duration = 30
                            })
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
        if hasGodPet() then
            SG:SetCore("SendNotification",{
                Title = "SAUCE",
                Text = "GOD PET / 40M+ DETECTED – STAYING HERE FOREVER",
                Duration = 20
            })
            break  -- Stops hopping permanently
        end

        local servers = {}
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok, data = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if ok and data and data.data then servers = data.data end

        local hopped = false
        for _, srv in servers do
            if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{
                    Title = "Sauce",
                    Text = "Hopping → "..srv.playing.." players",
                    Duration = 5
                })
                local success, err = pcall(function()
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, PL)
                end)
                if success then hopped = true break end
            end
        end

        if not hopped then task.wait(10) end
        task.wait(15)
    end
end)

SG:SetCore("SendNotification",{
    Title = "Sauce GOD HUNTER",
    Text = "Active – stops only on 40M+/s or S-Tier pets",
    Duration = 10
})
print("Sauce GOD HUNTER loaded – hunting only true rares")
