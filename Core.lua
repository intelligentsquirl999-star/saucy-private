-- SAUCE FINAL HUNTER – STOPS ONLY ON REAL 17M+ RARES (Dec 2025)
if getgenv().SAUCE_HUNTER then return end
getgenv().SAUCE_HUNTER = true

local TS   = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG   = game:GetService("StarterGui")
local PL   = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

-- ALL CURRENT 17M+ BRAINROT PET NAMES (Dec 2025)
local rares = {
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

local function hasRare()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        for _, rare in rares do
                            if name:find(rare) then
                                SG:SetCore("SendNotification",{Title="SAUCE FOUND!", Text=tool.Name.." (17M+)", Duration=30})
                                print("SAUCE FOUND:", tool.Name)
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate.Value >= 17000000 then
                            SG:SetCore("SendNotification",{Title="SAUCE FOUND!", Text=tool.Name.." → "..rate.Value.." per sec", Duration=30})
                            print("SAUCE FOUND (RATE):", tool.Name, rate.Value)
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

task.spawn(function()
    while task.wait(2) do
        if hasRare() then
            SG:SetCore("SendNotification",{Title="SAUCE", Text="17M+ FOUND – HOPPING STOPPED", Duration=15})
            print("17M+ pet found – staying in this server!")
            break  -- STOPS HOPPING FOREVER WHEN FOUND
        else
            local servers = {}
            local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            local s,r = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
            if s and r and r.data then servers = r.data end

            for _, srv in servers do
                if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                    SG:SetCore("SendNotification",{Title="Sauce", Text="Hopping → "..srv.playing.." players", Duration=5})
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, PL)
                    task.wait(15)
                    break
                end
            end
        end
    end
end)

SG:SetCore("SendNotification",{Title="Sauce 17M+", Text="Hunter ACTIVE – will STOP when rare found", Duration=8})
