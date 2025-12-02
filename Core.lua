-- SAUCE Core.lua – 100M+/s BRAINROT ONLY (Dec 2025 – FINAL)
if getgenv().SAUCE_100M then return end
getgenv().SAUCE_100M = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local MIN_RATE = 100000000  -- 100 million per second
local foundServerId = nil

SG:SetCore("SendNotification", {Title="Sauce 100M+", Text="Scanning for 100M+/s Brainrot...", Duration=10})

task.spawn(function()
    while not foundServerId do
        task.wait(6)

        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, data = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if not success or not data or not data.data then continue end

        for _, server in data.data do
            if server.playing > 0 and server.playing < 90 and server.id ~= game.JobId then
                for _, player in game.Players:GetPlayers() do
                    if player.Character then
                        for _, tool in player.Character:GetChildren() do
                            if tool:IsA("Tool") then
                                local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond")
                                if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                                    foundServerId = server.id
                                    SG:SetCore("SendNotification", {
                                        Title = "100M+/s BRAINROT FOUND!",
                                        Text = tool.Name.." → "..rate.Value.." $/s – Joining now!",
                                        Duration = 15
                                    })
                                    return
                                end
                            end
                        end
                    end
                    if player:FindFirstChild("Backpack") then
                        for _, tool in player.Backpack:GetChildren() do
                            if tool:IsA("Tool") then
                                local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond")
                                if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                                    foundServerId = server.id
                                    SG:SetCore("SendNotification", {
                                        Title = "100M+/s BRAINROT FOUND!",
                                        Text = tool.Name.." → "..rate.Value.." $/s – Joining now!",
                                        Duration = 15
                                    })
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Teleport when found
task.spawn(function()
    while not foundServerId do task.wait(1) end
    task.wait(2)

    SG:SetCore("SendNotification", {Title="Sauce", Text="Teleporting to 100M+/s server...", Duration=8})

    local success, err = pcall(function()
        TS:TeleportToPlaceInstance(PlaceId, foundServerId, PL)
    end)

    task.wait(12)
    if success then
        SG:SetCore("SendNotification", {Title="SAUCE SUCCESS", Text="You are now in a 100M+/s Brainrot server!", Duration=20})
    else
        SG:SetCore("SendNotification", {Title="Sauce", Text="Teleport failed – retrying...", Duration=6})
    end
end)

print("Sauce 100M+/s Brainrot hunter ACTIVE")
