-- SAUCE Core.lua – STRICT 40M+/s RATE ONLY (Dec 2025 – No Low-Income Trash)
if getgenv().SAUCE_RATEFIX then return end
getgenv().SAUCE_RATEFIX = true

local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG = game:GetService("StarterGui")
local PL = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- S-TIER PET NAMES (40M+ $/s confirmed)
local HIGH_RATE_PETS = {
    "strawberry elephant", "dragon cannelloni", "spaghetti tualetti", "garama and madundung",
    "ketchuru and masturu", "la supreme combinasion", "cocofanto elefanto", "bombardiro crocodilo",
    "brainrot god", "los bros", "money money man", "money money puggy", "blackhole goat",
    "trenostruzzo turbo", "nuclearo dinossauro", "la grande combinasion"
}

local MIN_RATE = 40000000  -- 40M $/s MINIMUM

local function hasHighRatePet()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        for _, high in HIGH_RATE_PETS do
                            if name:find(high) then
                                SG:SetCore("SendNotification",{
                                    Title = "HIGH-RATE PET FOUND!",
                                    Text = tool.Name.." (40M+ $/s)",
                                    Duration = 30
                                })
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "40M+/s PET LIVE!",
                                Text = tool.Name.." → "..tostring(rate.Value).." $/s",
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
    while task.wait(1.5) do
        if hasHighRatePet() then
            SG:SetCore("SendNotification",{
                Title = "SAUCE",
                Text = "40M+ $/s FOUND – STAY & STEAL!",
                Duration = 20
            })
            break
        end

        local servers = {}
        local ok, data = pcall(function() 
            return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and data and data.data then servers = data.data end

        local hopped = false
        for _, srv in servers do
            if srv.playing < 60 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{Title="Sauce",Text="Hopping to "..srv.playing.."p server",Duration=4})
                pcall(TS.TeleportToPlaceInstance, TS, PlaceId, srv.id, PL)
                hopped = true
                break
            end
        end
        if not hopped then task.wait(5) end
        task.wait(12)
    end
end)

SG:SetCore("SendNotification",{
    Title = "Sauce 40M+ Hunter",
    Text = "Active – ignores <40M $/s pets (RATE only)",
    Duration = 10
})
print("Sauce rate hunter loaded – 40M+ $/s detection ON")
