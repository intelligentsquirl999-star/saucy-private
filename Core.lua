-- SAUCE Core.lua – FIXED TELEPORT (Skips Restricted Servers) (Dec 2025)
if getgenv().SAUCE_TELEFIX then return end
getgenv().SAUCE_TELEFIX = true

local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG = game:GetService("StarterGui")
local PL = game.Players.LocalPlayer
local PlaceId = 109983668079237

pcall(function() Http:SetHttpEnabled(true) end)

local MIN_RATE = 100000000  -- 100M+/s Brainrot only

local function has100MBrainrot()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(cont)
                for _, tool in cont:GetChildren() do
                    if tool:IsA("Tool") then
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            SG:SetCore("SendNotification",{
                                Title = "100M+/s BRAINROT FOUND!",
                                Text = tool.Name.." → "..rate.Value.." $/s – STEAL IT!",
                                Duration = 30
                            })
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
    SG:SetCore("SendNotification",{Title="Sauce 100M+",Text="Hunting 100M+/s Brainrot – skips restricted servers",Duration=10})
    
    while task.wait(3) do
        if has100MBrainrot() then
            SG:SetCore("SendNotification",{Title="SAUCE",Text="100M+ FOUND – STAY HERE!",Duration=20})
            break
        end

        -- Get fresh servers
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok, data = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if not ok or not data or not data.data then continue end

        local joined = false
        for _, srv in data.data do
            if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                SG:SetCore("SendNotification",{Title="Sauce",Text="Trying "..srv.playing.."p server...",Duration=3})
                
                -- TRY TELEPORT + AUTO-SKIP IF RESTRICTED
                local tp_ok, tp_err = pcall(TS.TeleportToPlaceInstance, TS, PlaceId, srv.id, PL)
                if tp_ok then
                    joined = true
                    break
                else
                    if tp_err:find("restricted") or tp_err:find("773") then
                        print("Skipped restricted server:", srv.id)  -- F9 console
                        continue  -- TRY NEXT SERVER
                    end
                end
            end
        end
        
        if not joined then
            SG:SetCore("SendNotification",{Title="Sauce",Text="All restricted – retrying in 5s...",Duration=4})
            task.wait(5)
        else
            task.wait(12)  -- Load time
        end
    end
end)

print("Sauce 100M+ hunter with restricted bypass ACTIVE")
