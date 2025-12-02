-- Sauce Core.lua – 17M+/s NAME + RATE HUNTER (Dec 2025)
local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MIN_RATE = 17000000

local rare_names = {
    "money money man","money money puggy","las sis","las capuchinas",
    "la vacca saturno saturnita","la vacca staturno saturnita","blackhole goat",
    "bisonte giuppitere","chachechi","trenostruzzo turbo","los matteos",
    "chimpanzini spiderini","graipuss medussi","noo my hotspot",
    "sahur combinasion","pot hotspot","chicleteira bicicleteira",
    "los nooo my hotspotsitos","la grande combinasion","los combinasionas",
    "nuclearo dinossauro","karkerkar combinasion","los hotspotsitos",
    "tralaledon","strawberry elephant","dragon cannelloni",
    "spaghetti tualetti","garama and madundung","ketchuru and masturu",
    "la supreme combinasion","los bros","coco elefanto","cocofanto elefanto",
    "piccione macchina","bombombini gusini","bombardiro crocodilo"
}

local running = true

local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(Http.GetAsync, Http, url)
    if success then return Http:JSONDecode(result).data end
    return {}
end

local function hasRare()
    for _, p in Players:GetPlayers() do
        if p ~= player then
            local function check(cont)
                for _, tool in cont:GetChildren() do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        for _, r in rare_names do if n:find(r) then return true end end
                        local v = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if v and v:IsA("NumberValue") and v.Value >= MIN_RATE then return true end
                    end
                end
            end
            check(p.Backpack)
            if p.Character then check(p.Character) end
        end
    end
    return false
end

spawn(function()
    while running and task.wait(3.5) do
        if not hasRare() then
            for _, srv in getServers() do
                if srv.playing < 40 and srv.id ~= game.JobId then
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, player)
                    task.wait(8)
                    break
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Sauce 17M+/s", Text = "Hunter running – scanning names + rates", Duration = 8
})
print("Sauce 17M+/s hunter ACTIVE")
