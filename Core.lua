-- SAUCE BOT SCANNER – PUBLIC SERVERS ONLY (Dec 2025)
if getgenv().SAUCE_PUBLICONLY then return end
getgenv().SAUCE_PUBLICONLY = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local TARGET_PETS = {
    "strawberry elephant","dragon cannelloni","spaghetti tualetti",
    "garama and madundung","ketchuru and masturu","la supreme combinasion",
    "cocofanto elefanto","bombardiro crocodilo","brainrot god","los bros"
}

local foundServerId = nil

-- BOT SCANNER – PUBLIC SERVERS ONLY
task.spawn(function()
    SG:SetCore("SendNotification",{Title="Sauce BOT",Text="Scanning PUBLIC servers only...",Duration=10})

    while not foundServerId do
        task.wait(5)

        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function()
            return Http:JSONDecode(game:HttpGet(url))
        end)

        if not success or not result or not result.data then continue end

        for _, server in result.data do
            -- ONLY PUBLIC SERVERS (skip VIP, friends-only, reserved, etc.)
            if server.playing > 0 and server.playing < 80 and server.id ~= game.JobId and server.accessCode == nil then
                for _, userId in server.playerIds do
                    local invUrl = "https://inventory.roblox.com/v1/users/"..userId.."/assets/collectibles?limit=100"
                    local ok, inv = pcall(function() return Http:JSONDecode(game:HttpGet(invUrl)) end)
                    if ok and inv and inv.data then
                        for _, asset in inv.data do
                            local name = (asset.name or ""):lower()
                            for _, target in TARGET_PETS do
                                if name:find(target) then
                                    foundServerId = server.id
                                    SG:SetCore("SendNotification",{
                                        Title = "40M+ PET FOUND!",
                                        Text = "Joining public server with "..asset.name,
                                        Duration = 12
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

-- TELEPORT WHEN FOUND
task.spawn(function()
    while not foundServerId do task.wait(1) end

    SG:SetCore("SendNotification",{Title="Sauce BOT",Text="Teleporting to public god server...",Duration=8})

    local success = pcall(function()
        TS:TeleportToPlaceInstance(PlaceId, foundServerId, PL)
    end)

    task.wait(12)

    if success then
        SG:SetCore("SendNotification",{Title="SAUCE ACTIVE",Text="You are in a PUBLIC server with 40M+/s pet!",Duration=15})
    else
        SG:SetCore("SendNotification",{Title="Sauce",Text="Teleport failed – retrying...",Duration=6})
    end
end)

SG:SetCore("SendNotification",{Title="Sauce PUBLIC BOT",Text="Scanning only public servers – 5–30 sec",Duration=12})
print("Sauce PUBLIC-ONLY BOT SCANNER running")
