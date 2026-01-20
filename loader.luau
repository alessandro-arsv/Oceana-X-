--  Oceana X 
--  loader.luau
-- version 1.0.0

repeat task.wait() until game:IsLoaded()

local pi = game.PlaceId


local urls = {
    nights = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/99%20Nights%20in%20the%20forest.luau",
    basketballbrain = "https://raw.githubusercontent.com/alessandro-arsv/Oceana-X-/refs/heads/main/bbasketball.luau",
    YouVSHomer = ""
}
if pi == 121765167512457 or pi == 113463598817292 then -- Brainrotted BASKETBALL
    loadstring(game:HttpGet(urls.basketballbrain))()
end

if pi == 126509999114328 then -- 99 nights
    loadstring(game:HttpGet(urls.nights))()
end
if pi == 111530421351096 then -- uhh you vs HOMER 
    loadstring(game:HttpGet(""))()
end