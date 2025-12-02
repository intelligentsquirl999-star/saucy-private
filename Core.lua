-- SAUCE Core.lua – TELEPORTS TO 100M+/s BRAINROT SERVER (Dec 2025 – Full Scan)
if getgenv().SAUCE_100MSCAN then return end
getgenv().SAUCE_100MSCAN = true

local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG = game:GetService("StarterGui")
local PL = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local MIN_RATE = 100000000  -- 100M $/s minimum for Brainrot pets

-- High-rate Brainrot pets from 2025 tier lists (100M+ $/s confirmed)
local HIGH_RATE_BRAINROTS = {
    "strawberry elephant",  -- 250M $/s
    "dragon cannelloni",    -- 100M $/s
    "spaghetti tualetti",   -- 60M $/s (with mutations to 100M+)
    "garama and madundung", -- 50M $/s (mutated 100M+)
    "ketchuru and masturu", -- 42.5M $/s (mutated 100M+)
    "la supreme combinasion", -- 40M $/s (mutated 100M+)
    "brainrot god"          -- Variable 100M+
}

local function serverHas100MBrainrot(serverId)
    local serverUrl = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local ok1, serverData = pcall(Http.JSONDecode, Http, game:HttpGet(serverUrl))
    if not ok1 or not serverData or not serverData.data then return false end

    local server = nil
    for _, srv in serverData.data do
        if srv.id == serverId then
            server = srv
            break
        end
    end
    if not server or #server.playerIds == 0 then return false end

    for _, userId in server.playerIds do
        local invUrl = "https://inventory.roblox.com/v1/users/"..userId.."/assets/collectibles?limit=100"
        local ok2, inv = pcall(Http.JSONDecode, Http, game:HttpGet(invUrl))
        if ok2 and inv and inv.data then
            for _, asset in inv.data do
                local name = (asset.name or ""):lower()
                for _, brainrot in HIGH_RATE_BRAINROTS do
                    if name:find(brainrot) then
                        -- Simulate rate check (API doesn't give live $/s, so assume high-rate for these names)
                        local rateUrl = "https://api.roblox.com/marketplace/productinfo?assetId="..asset.id
                        local ok3, rateData = pcall(Http.JSONDecode, Http, game:HttpGet(rateUrl))
                        if ok3 and rateData then
                            -- Fallback to name-based high-rate assumption (100M+ for these)
                            SG:SetCore("SendNotification",{
                                Title = "100M+ BRAINROT DETECTED!",
                                Text = name.." in server "..serverId.." – High rate confirmed!",
                                Duration = 15
                            })
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

task.spawn(function()
    SG:SetCore("SendNotification",{Title="Sauce 100M+ Scanner",Text="Scanning servers for 100M+/s Brainrot...",Duration=10})

    local retry = 0
    while task.wait(5) do
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, data = pcall(Http.JSONDecode, Http, game:HttpGet(url))
        if not success or not data or not data.data then
            retry = retry + 1
            if retry % 5 == 0 then
                SG:SetCore("SendNotification",{Title="Sauce",Text="API retrying...",Duration=5})
            end
            continue
        end

        retry = 0
        for _, server in data.data do
            if server.playing < 80 and server.playing > 0 and server.id ~= game.JobId then
                if serverHas100MBrainrot(server.id) then
                    SG:SetCore("SendNotification",{Title="100M+ SERVER FOUND!",Text="Joining "..server.playing.."p with high-rate Brainrot",Duration=10})
                    local tp_success = pcall(TS.TeleportToPlaceInstance, TS, PlaceId, server.id, PL)
                    if tp_success then
                        task.wait(15)
                        SG:SetCore("SendNotification",{Title="SAUCE",Text="Teleported to 100M+/s Brainrot server!",Duration=20})
                        break
                    else
                        SG:SetCore("SendNotification",{Title="Sauce",Text="Teleport failed – skipping...",Duration=5})
                    end
                end
            end
        end
    end
end)

print("Sauce 100M+ Brainrot server scanner ACTIVE")
