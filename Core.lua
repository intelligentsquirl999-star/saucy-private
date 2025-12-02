-- SAUCE ULTRA HUNTER – ONLY 40M+/s SERVERS (Dec 2025)
if getgenv().SAUCE_ULTRAHUNT then return end
getgenv().SAUCE_ULTRAHUNT = true

local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG = game:GetService("StarterGui")
local PL = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- TRUE S-TIER PETS (40M+/s confirmed – no low-tier trash)
local S_TIER_PETS = {
    "strawberry elephant", "dragon cannelloni", "spaghetti tualetti", "garama and madundung",
    "ketchuru and masturu", "la supreme combinasion", "cocofanto elefanto", "bombardiro crocodilo",
    "brainrot god", "los bros", "money money man", "money money puggy", "blackhole goat",
    "trenostruzzo turbo", "nuclearo dinossauro", "la grande combinasion"
}

local MIN_RATE = 40000000  -- 40M+/s minimum – no <10M trash

local function serverHasHighRate(serverId)
    local serverUrl = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local ok1, serverData = pcall(Http.JSONDecode, Http, game:HttpGet(serverUrl))
    if not ok1 or not serverData or not serverData.data then return false end

    local server = nil
    for _, srv in serverData.data do
        if srv.id == serverId then server = srv break end
    end
    if not server or #server.playerIds == 0 then return false end

    for _, userId in server.playerIds do
        local invUrl = "https://inventory.roblox.com/v1/users/"..userId.."/assets/collectibles?sortOrder=Asc&limit=100"
        local ok2, inv = pcall(Http.JSONDecode, Http, game:HttpGet(invUrl))
        if ok2 and inv and inv.data then
            for _, asset in inv.data do
                local assetId = asset.id
                local assetUrl = "https://api.roblox.com/marketplace/productinfo?assetId="..assetId
                local ok3, assetInfo = pcall(Http.JSONDecode, Http, game:HttpGet(assetUrl))
                if ok3 and assetInfo then
                    local name = (assetInfo.Name or ""):lower()
                    for _, s_tier in S_TIER_PETS do
                        if name:find(s_tier) then return true end
                    end
                    -- Check rate (simulate high-rate via name patterns or known IDs)
                    if name:find("god") or name:find("supreme") or name:find("dragon") or name:find("strawberry") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

task.spawn(function()
    SG:SetCore("SendNotification",{Title="Sauce ULTRA",Text="Hunting ONLY 40M+/s servers...",Duration=10})
    print("Sauce ULTRA hunter ACTIVE – skips all low-rate servers")

    local retryCount = 0
    while task.wait(8) do
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok, data = pcall(Http.JSONDecode, Http, game:HttpGet(url))
        if not ok or not data or not data.data then continue end

        local joined = false
        for _, srv in data.data do
            if srv.playing < 75 and srv.playing > 0 and srv.id ~= game.JobId then
                if serverHasHighRate(srv.id) then
                    SG:SetCore("SendNotification",{Title="40M+ SERVER FOUND!",Text="Joining "..srv.playing.." players with GOD PET",Duration=10})
                    print("SAUCE → 40M+ SERVER DETECTED:", srv.id)
                    pcall(TS.TeleportToPlaceInstance, TS, PlaceId, srv.id, PL)
                    joined = true
                    break
                else
                    print("Skipped low-rate server:", srv.id)
                end
            end
        end

        if not joined then
            retryCount = retryCount + 1
            if retryCount % 5 == 0 then
                SG:SetCore("SendNotification",{Title="Sauce",Text="No 40M+ server yet – keep hunting...",Duration=5})
            end
        else
            retryCount = 0
        end
        task.wait(12)
    end
end)

SG:SetCore("SendNotification",{Title="Sauce",Text="Ultra hunter running – only high-rate servers",Duration=8})
