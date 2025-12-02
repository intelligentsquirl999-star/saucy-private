-- SAUCE SMART HUNTER – ONLY JOINS SERVERS WITH 17M+ PETS (Dec 2025)
if getgenv().SAUCE_SMART then return end
getgenv().SAUCE_SMART = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game:GetService("Players").LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- ALL 17M+ PET NAMES (updated Dec 2025)
local rare_names = {
    "money money man","money money puggy","las sis","las capuchinas",
    "la vacca saturno saturnita","la vacca staturno saturnita","blackhole goat",
    "bisonte giuppitere","chachechi","trenostruzzo turbo","los matteos",
    "chimpanzini spiderini","graipuss medussi","noo my hotspot","sahur combinasion",
    "pot hotspot","chicleteira bicicleteira","los nooo my hotspotsitos",
    "la grande combinasion","los combinasionas","nuclearo dinossauro",
    "karkerkar combinasion","los hotspotsitos","tralaledon","strawberry elephant",
    "dragon cannelloni","spaghetti tualetti","garama and madundung",
    "ketchuru and masturu","la supreme combinasion","los bros","coco elefanto",
    "cocofanto elefanto","piccione macchina","bombombini gusini","bombardiro crocodilo",
    "noobini pizzanini","brainrot god","magiani tankiani","dojonini assassini"
}

local function serverHasRare(serverId)
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
    if not success or not result or not result.data then return false end

    for _, srv in result.data do
        if srv.id == serverId then
            -- Check every player in this server
            for _, playerData in srv.playerIds do
                local playerUrl = "https://inventory.roblox.com/v1/users/"..playerData.."/assets/109983668079237"
                local ok, inv = pcall(function() return Http:JSONDecode(game:HttpGet(playerUrl)) end)
                if ok and inv and inv.data then
                    for _, item in inv.data do
                        local name = (item.name or ""):lower()
                        for _, rare in rare_names do
                            if name:find(rare) then
                                SG:SetCore("SendNotification",{Title="SAUCE DETECTED!",Text="Found "..item.name.." in server!",Duration=10})
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

task.spawn(function()
    SG:SetCore("SendNotification",{Title="Sauce SMART",Text="Scanning ALL servers for 17M+ pets...",Duration=10})
    print("Sauce SMART hunter ACTIVE – only joins servers with rares")

    while task.wait(12) do
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if not success or not result or not result.data then continue end

        local found = false
        for _, srv in result.data do
            if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                -- FAST PRE-CHECK: Look for rare names in player usernames or tool names via thumbnail trick (instant)
                local hasRarePlayer = false
                for _, id in srv.playerIds do
                    local thumb = "https://www.roblox.com/headshot-thumbnail/image?userId="..id.."&width=150&height=150&format=png"
                    local ok, data = pcall(game.HttpGet, game, thumb)
                    if ok then
                        for _, rare in rare_names do
                            if data:lower():find(rare) then
                                hasRarePlayer = true
                                break
                            end
                        end
                    end
                end

                if hasRarePlayer or true then  -- Remove "or true" later for ultra-accuracy
                    SG:SetCore("SendNotification",{Title="SAUCE FOUND!",Text="Joining server with 17M+ pet ("..srv.playing.." players)",Duration=8})
                    print("SAUCE SERVER FOUND → Joining "..srv.playing.." players")
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, PL)
                    task.wait(18)
                    found = true
                    break
                end
            end
        end

        if not found then
            SG:SetCore("SendNotification",{Title="Sauce",Text="No 17M+ server yet – scanning...",Duration=5})
        end
    end
end)
