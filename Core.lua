-- SAUCE Core.lua – GUARANTEED TELEPORT FIX (Dec 2025)
local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- FORCE HTTPSERVICE ON
pcall(function() Http:SetHttpEnabled(true) end)
if not Http.HttpEnabled then
    StarterGui:SetCore("SendNotification",{Title="Sauce",Text="Http failed – try another executor",Duration=10})
    return
end

local function getServers()
    local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(PlaceId)
    local s,r = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
    if s and r and r.data then return r.data end
    return {}
end

task.spawn(function()
    while task.wait(8) do
        local servers = getServers()
        if #servers == 0 then
            print("Sauce: No servers found – retrying...")
        else
            for _, srv in ipairs(servers) do
                if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                    print("Sauce → Hopping to server with "..srv.playing.." players")
                    StarterGui:SetCore("SendNotification",{Title="Sauce",Text="Hopping to "..srv.playing.." player server...",Duration=5})
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, Players.LocalPlayer)
                    task.wait(15)  -- give teleport time
                    break
                end
            end
        end
    end
end)

StarterGui:SetCore("SendNotification",{Title="Sauce 17M+/s",Text="Hunter ACTIVE – hopping servers now",Duration=8})
print("Sauce hunter running – check notifications + F9")
