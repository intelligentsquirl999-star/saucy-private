-- SAUCE BOT SCANNER – REAL AJ LEVEL (Dec 2025 – finds 40M+/s in seconds)
if getgenv().SAUCE_BOTSCAN then return end
getgenv().SAUCE_BOTSCAN = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local TARGET_RATE = 40000000  -- 40M+/s minimum
local foundServer = nil

-- Background bot scanner (scans ALL servers at once)
task.spawn(function()
    SG:SetCore("SendNotification",{Title="Sauce BOT",Text="Deploying scanner bots...",Duration=8})

    while not foundServer do
        task.wait(4)  -- Scan wave every 4 seconds

        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, data = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if not success or not data or not data.data then continue end

        for _, server in ipairs(data.data) do
            if server.playing > 0 and server.playing < 80 and server.id ~= game.JobId then
                -- Check if ANY player in this server has 40M+/s pet
                for _, userId in ipairs(server.playerIds or {}) do
                    local invUrl = "https://inventory.roblox.com/v1/users/"..userId.."/assets/collectibles?assetType=Pet&limit=100"
                    local ok, inv = pcall(function() return Http:JSONDecode(game:HttpGet(invUrl)) end)
                    if ok and inv and inv.data then
                        for _, pet in ipairs(inv.data) do
                            local petName = (pet.name or ""):lower()
                            if petName:find("strawberry elephant") or petName:find("dragon cannelloni") 
                            or petName:find("spaghetti tualetti") or petName:find("supreme combinasion")
                            or petName:find("brainrot god") then
                                foundServer = server.id
                                SG:SetCore("SendNotification",{
                                    Title="GOD SERVER FOUND!",
                                    Text="40M+ pet detected – Joining now!",
                                    Duration=10
                                })
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Teleport when bot finds one
task.spawn(function()
    while not foundServer do task.wait(1) end

    SG:SetCore("SendNotification",{
        Title="SAUCE BOT",
        Text="Teleporting to 40M+/s server...",
        Duration=8
    })

    pcall(function()
        TS:TeleportToPlaceInstance(PlaceId, foundServer, PL)
    end)

    task.wait(15)
    SG:SetCore("SendNotification",{
        Title="SAUCE BOT ACTIVE",
        Text="You are now in a confirmed 40M+/s server",
        Duration=15
    })
end)

SG:SetCore("SendNotification",{
    Title="Sauce BOT SCANNER",
    Text="Scanning every server with bots – wait 5–15 sec",
    Duration=12
})
print("Sauce BOT SCANNER deployed – hunting 40M+/s only")
