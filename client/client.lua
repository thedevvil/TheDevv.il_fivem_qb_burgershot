local QBCore = exports['qb-core']:GetCoreObject()
local sellstart = false
local PlayerJob = {}

AddEventHandler('onResourceStart', function(resource) --if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)


CreateThread(function()
    local enterZone = false
    local Notify = nil
    while true do
        local sleep = 1250
        local inZone = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local coords = GetBlipInfoIdCoord(sellblip)
        local burgerbreadDist = #(PlayerPos - Config.BurgerMarker["burgerbread"])
        local burgermeatDist = #(PlayerPos - Config.BurgerMarker["burgermeat"])
        local burgersaladDist = #(PlayerPos - Config.BurgerMarker["burgersalad"])
        local patatoDist = #(PlayerPos - Config.BurgerMarker["patato"])
        local friedpatatoesDist = #(PlayerPos - Config.BurgerMarker["btpatates"])
        local burgercolaDist = #(PlayerPos - Config.BurgerMarker["burgercola"])
        local burgerDist = #(PlayerPos - Config.BurgerMarker["burger"])
        local burgerpackedDist = #(PlayerPos - Config.BurgerMarker["packedburger"])
        local burgerSell = #(PlayerPos - Config.BurgerMarker["sellburger"])
        local burgerDelivery = #(PlayerPos - vec3(coords[1], coords[2], coords[3]))
        local pressedKeyE = IsControlJustPressed(0, 38)
    if PlayerJob.name == "burgershot" then
        if burgerbreadDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Hamburger Ekmeği' if pressedKeyE then addItem(5000,"burgerbread",'Hamburger Ekmeği') end
        end
        if burgermeatDist < 1 then sleep = 5 inZone  = true  
            Notify = 'Hamburger Eti' if pressedKeyE then  addItem(5000,"burgermeat",'Hamburger Eti') end
        end
        if burgersaladDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Hamburger Salatası' if pressedKeyE then addItem(5000,"burgersalad",'Hamburger Salatası') end
        end
        if patatoDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Patates' if pressedKeyE then addItem(5000,"patato",'Patates') end
        end
        if friedpatatoesDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Patates Kızartması' if pressedKeyE then checkItem("patato","btpatates",'Patates Kızartması') end
        end
        if burgercolaDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Kola' if pressedKeyE then addItem(5000,"burgercola",'Kola') end
        end
        if burgerDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Burger' if pressedKeyE then checkBurger("burger",'Burger') end
        end
        if burgerpackedDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Menü Paketle' if pressedKeyE then checkPack("packedburger","Menü Paketle") end
        end
    end
        if inZone and not enterZone then
            enterZone = true
            TriggerEvent('text:show', "<b style='color:#44e467;'>[E] </b>"..Notify, "")
        end
        if not inZone and enterZone then
            enterZone = false
            TriggerEvent('text:hide')
        end
        Wait(sleep)
    end
end)

addItem = function(time,additem,text) 
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("burger", text, time, false, true, 
        {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, 
        {animDict = "mp_arresting",anim = "a_uncuff",flags = 49,}, {}, {}, function() -- Done
        StopAnimTask(ped, "mp_arresting", "a_uncuff", 1.0)
        TriggerServerEvent('burgershot:server:additem',additem)
    end)
end

checkItem = function(checkitem,additem,text)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb then
            TriggerServerEvent('burgershot:server:removeitem',checkitem)
            addItem(8000,additem,text) 
        else
            QBCore.Functions.Notify("Sahip değilsin "..checkitem, "error")
        end
    end,checkitem)
end

checkBurger = function(additem)
    QBCore.Functions.TriggerCallback('burgershot:server:checkBurger', function(cb)  
        if cb then
            addItem(8000,additem) 
        else
            QBCore.Functions.Notify("Yeteri kadar malzemen yok..", "error")
        end
    end)
end


checkPack = function(additem,text)
    QBCore.Functions.TriggerCallback('burgershot:server:checkPack', function(cb)  
        if cb then
            addItem(8000,additem,text) 
        else
            QBCore.Functions.Notify("Yeteri kadar malzemen yok..", "error")
        end
    end)
end

sellBurger = function(checkitem)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb and not sellstart then
            local random = math.random(1,#Config.Locations)
            sellcoords = {x = Config.Locations[random][1],y = Config.Locations[random][2],z = Config.Locations[random][3],h = Config.Locations[random][4]}
            sellblip = CreateSellBlip(sellcoords.x, sellcoords.y, sellcoords.z)
            SetNewWaypoint(sellcoords.x, sellcoords.y)
            sellstart = true
            QBCore.Functions.Notify("Yeni adres GPS işaretlendi", "success")
        else
            QBCore.Functions.Notify("Yeterli malzemen yok veya "..checkitem.." aktif siparişin var", "error")
        end
    end,checkitem)
end

checkDelivery = function(checkitem)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb and sellstart then
            local ped = PlayerPedId()
            QBCore.Functions.Progressbar("delivery","Burger", 6000, false, true, 
            {disableMovement = true,disableCarMovement = true,disableMouse = false, disableCombat = true,}, 
            {animDict = "mp_common",anim = "givetake1_a",flags = 49,}, {}, {}, function() -- Done
            StopAnimTask(ped, "mp_common", "givetake1_a", 1.0)
            RemoveBlip(sellblip) 
            TriggerServerEvent('burgershot:server:removeitem',checkitem) 
            TriggerServerEvent('burgershot:server:givemoney')
            sellstart = false 
        end)
        else
            QBCore.Functions.Notify("Sahip değilsin "..checkitem, "error")
        end
    end,checkitem)
end

CreateSellBlip = function(x,y,z)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, 489)
	SetBlipColour(blip, 1)
	AddTextEntry('MYBLIP', "Siparişi Götür")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

-- CreateThread(function()
--     local modelHash = GetHashKey("u_f_o_eileen")
--     RequestModel(modelHash)
--       while not HasModelLoaded(modelHash) do
--         Wait(10)
--       end
--     local ped = CreatePed(4, modelHash, 9.95, -1604.68, 28.38, 230.2, false, false)
--     SetEntityInvincible(ped, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
--     FreezeEntityPosition(ped, true)
--     local blip = AddBlipForCoord(12.92127, -1602.86, 29.374)
--     SetBlipSprite(blip, 208)
--     SetBlipAsShortRange(blip, true)
--     SetBlipScale(blip, 0.6)
--     SetBlipColour(blip, 44)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString("Burger")
--     EndTextCommandSetBlipName(blip)
-- end)
