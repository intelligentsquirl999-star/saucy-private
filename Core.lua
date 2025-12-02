-- SAUCE Core.lua – AUTO-ENABLES HTTPSERVICE (Dec 2025)
local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local MIN_RATE = 17000000

-- AUTO-ENABLE HTTPSERVICE (THIS IS THE FIX)
if not Http.HttpEnabled then
    pcall(function()
        Http:SetHttpEnabled(true)
    end)
end

-- Double-check it’s on
if not Http.HttpEnabled then
    StarterGui:SetCore("SendNotification", {Title="Sauce", Text="HttpService still off – enable manually in Game Settings", Duration=15})
    return
end

local rare_names = {
    "money money man","money money puggy","las sis","las capuchinas",
    "la vacca saturno saturnita","blackhole goat","bisonte giuppitere",
    "chachechi","trenostruzzo turbo","los matteos","noo my hotspot",
    "sahur combinasion","pot hotspot","los nooo my hotspotsitos",
    "la grande combinasion","nuclearo dinossauro","los hotspotsitos",
    "tralaledon","strawberry elephant","dragon cannelloni",
    "spaghetti tualetti","la supreme combinasion","los bros",
    "coco elefanto","piccione macchina","bombombini gusini",
    "bombardiro crocodilo","noobini pizzanini","brainrot god"
}

local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(Http.GetAsync, Http, url)
    if success then return Http:JSONDecode(result).data end
    return {}
end

local function hasRare()
    for _, p in Players:GetPlayers() do
        if p ~= player then
            local function check(c)
                for _, tool in c:GetChildren() do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        for _, r in rare_names do if n:find(r) then return true end end
                        local v = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if v and v.Value >= MIN_RATE then return true end
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
    while task.wait(6) do
        if not hasRare() then
            for _, srv in getServers() do
                if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                    print("Sauce → Joining server with "..srv.playing.." players")
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, player)
                    task.wait(12)
                    break
                end
            end
        end
    end
end)

StarterGui:SetCore("SendNotification", {Title="Sauce", Text="17M+/s hunter ACTIVE – HttpService auto-enabled", Duration=8})
print("Sauce hunter running – HttpService forced ON")
