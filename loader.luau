--  Oceana X 
--  loader.luau
-- version 1.0.0

repeat task.wait() until game:IsLoaded()

local pi = game.PlaceId


local urls = {
    nights = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/99%20Nights%20in%20the%20forest.luau",
    basketballbrain = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/bbasketball.luau",
    YouVSHomer = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/YouVSHomer.luau",
    GetRich = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/GetRich.luau",
    MYFBT = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/MyFishingBrainrots.luau",
    ETFBS = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/EscapeTsunamiForBrainrots.luau"

}
if pi == 121765167512457 or pi == 113463598817292 then -- Brainrotted BASKETBALL
    loadstring(game:HttpGet(urls.basketballbrain))()
end

if pi == 126509999114328 then -- 99 nights
    loadstring(game:HttpGet(urls.nights))()
end
if pi == 111530421351096 then -- uhh you vs HOMER 
    loadstring(game:HttpGet(urls.YouVSHomer))()
end

if pi == 97774755741014 then -- get rich
    loadstring(game:HttpGet(urls.GetRich))()
end 
if pi == 113489516847696 then -- my fishing brainrots
    loadstring(game:HttpGet(urls.MYFBT))()
    
end
if pi == 131623223084840 then -- escape tsunami for brianrots
    loadstring(game:HttpGet(urls.ETFBS))
end