-- SAUCE Core.lua – FINAL ULTRA FAST 40M+/s HUNTER (Dec 2025)
if getgenv().SAUCE_FAST then return end
getgenv().SAUCE_FAST = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- TRUE 40M+ $/s PETS (confirmed income rate)
local HIGH_RATE_PETS = {
    "strawberry elephant","dragon cannelloni","spaghetti tualetti","garama and madundung",
    "ketchuru and masturu","la supreme combinasion","cocofanto elefanto","bombardiro crocodilo",
    "brainrot god","los bros","money money man","money money puggy","blackhole goat",
    "trenostruzzo turbo","nuclearo dinossauro","la grande combinasion"
}

local MIN_RATE = 40000000  -- 40 million per second minimum

local function hasHighRatePet()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function scan(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        for _, rare in HIGH_RATE_PETS do
                            if name:find(rare) then
                                SG:SetCore("SendNotification",{
                                    Title = "40M+ PET FOUND!",
                                    Text = tool.Name.." (S-Tier)",
                                    Duration = 30
                                })
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "40M+/s DETECTED!",
                                Text = tool.Name.." → "..rate.Value.." $/s",
                                Duration = 30
                            })
                            return true
                        end
                    end
                end
            end
            scan(p.Backpack)
            if p.Character then scan(p.Character) end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(1) do  -- Scans every 1 second (super fast)
        if hasHighRatePet() then
            SG:SetCore("SendNotification",{
                Title = "SAUCE",
                Text = "40M+ $/s FOUND – STAYING HERE!",
                Duration = 20
            })
            break
        end

        -- Fast hop to low-player servers
        local servers = {}
        local success, data = pcall(function()
            return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and data and data.data then servers = data.data end

        for _, srv in servers do
            if srv.playing < 65 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{
                    Title = "Sauce",
                    Text = "Hopping → "..srv.playing.." players",
                    Duration = 4
                })
                pcall(TS.TeleportToPlaceInstance, TS, PlaceId, srv.id, PL)
                task.wait(10)  -- Fast reload
                break
            end
        end
    end
end)

SG:SetCore("SendNotification",{
    Title = "Sauce 40M+ Hunter",
    Text = "Ultra fast mode active – only 40M+/s pets",
    Duration = 10
})
print("Sauce ultra fast hunter loaded – 40M+/s only")
