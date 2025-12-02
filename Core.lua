-- SAUCE Core.lua – PURE 100M+/s RATE ONLY (No Name List) – FINAL (Dec 2025)
if getgenv().SAUCE_PURERATE then return end
getgenv().SAUCE_PURERATE = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local MIN_RATE = 100000000  -- 100 million per second ONLY

local function has100MPlusPet()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "100M+/s PET FOUND!",
                                Text = tool.Name.." → "..rate.Value.." $/s – STEAL TIME!",
                                Duration = 40
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
    SG:SetCore("SendNotification",{Title="Sauce 100M+",Text="Hunting pure 100M+/s pets only...",Duration=10})

    while task.wait(1.5) do
        if has100MPlusPet() then
            SG:SetCore("SendNotification",{Title="SAUCE",Text="100M+/s DETECTED – STAYING HERE!",Duration=20})
            break
        end

        local servers = {}
        local success, data = pcall(function()
            return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and data and data.data then servers = data.data end

        local hopped = false
        for _, srv in servers do
            if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{Title="Sauce",Text="Hopping → "..srv.playing.." players",Duration=3})

                local ok = pcall(function()
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, PL)
                end)

                if ok then
                    hopped = true
                    break
                else
                    -- Auto-skip restricted servers silently
                    continue
                end
            end
        end

        if not hopped then task.wait(6) end
        task.wait(12)  -- Wait for server load
    end
end)

print("Sauce 100M+/s pure rate hunter ACTIVE – no name list, only raw $/s")
