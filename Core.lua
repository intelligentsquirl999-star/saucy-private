-- FIXED Sauce Core.lua – 17M+/s HUNTER (Dec 2025 – JOINS SERVERS NOW)
local PlaceId = 109983668079237  -- Steal a Brainrot (confirmed)
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local MIN_RATE = 17000000

-- Check HttpService enabled (critical fix)
if not Http.HttpEnabled then
    StarterGui:SetCore("SendNotification", {Title="Sauce Error", Text="HttpService disabled – enable in settings", Duration=10})
    return
end

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
    "piccione macchina","bombombini gusini","bombardiro crocodilo",
    -- Added Brainrot-specific rares
    "noobini pizzanini","brainrot god","magiani tankiani","dojonini assassini"
}

local running = true

local function getServers(retry)
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(Http.GetAsync, Http, url)
    if success then
        local data = Http:JSONDecode(result)
        print("Fetched "..#data.data.." servers")  -- Debug
        return data.data
    end
    print("API fail, retry "..retry)  -- Debug
    return {}
end

local function hasRare()
    for _, p in Players:GetPlayers() do
        if p ~= player then
            local function check(cont)
                for _, tool in cont:GetChildren() do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        for _, r in rare_names do 
                            if n:find(r) then 
                                print("Rare found: "..tool.Name)  -- Debug
                                return true 
                            end 
                        end
                        local v = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if v and v:IsA("NumberValue") and v.Value >= MIN_RATE then
                            print("High rate found: "..v.Value)  -- Debug
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

task.spawn(function()  -- Fixed deprecated spawn
    local retries = 0
    while running do
        task.wait(5)  -- Slower scan
        if not hasRare() then
            print("No rare – searching servers...")
            local servers = getServers(retries)
            local joined = false
            for _, srv in servers do
                if srv.playing < 60 and srv.id ~= game.JobId and srv.playing > 0 then  -- FIXED: <60 players, >0
                    print("Joining "..srv.playing.." player server: "..srv.id)  -- Debug
                    local tp_success, err = pcall(TS.TeleportToPlaceInstance, TS, PlaceId, srv.id, player)
                    if tp_success then
                        print("Teleport sent!")
                        joined = true
                        break
                    else
                        warn("Teleport fail: "..tostring(err))
                    end
                end
            end
            if not joined then
                print("No good servers – retrying...")
                retries = retries + 1
                if retries > 3 then retries = 0 end
            end
            task.wait(10)  -- Longer post-teleport wait
        else
            print("Rare detected – staying...")
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Sauce FIXED", 
    Text = "17M+/s hunter running – check console (F9) for debug", 
    Duration = 10
})
print("Sauce hunter ACTIVE – open F9 console to watch joins!")
