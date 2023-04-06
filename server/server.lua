local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('burgershot:server:additem', function(additem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(additem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[additem], "add")
end)

RegisterNetEvent('burgershot:server:removeitem', function(removeitem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(removeitem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[removeitem], "remove")
end)

RegisterNetEvent('burgershot:server:givemoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tiprandom = math.random(1,50)
    local burgermoney = math.random(Config.BurgerMoneyMin,Config.BurgerMoneyMax)
    Player.Functions.AddMoney("cash", burgermoney, "burger-money")
    TriggerClientEvent('QBCore:Notify', src, "Hamburgeri teslim ettin! Yeni sipariş için şubeye dönmelisin.", "success")
    TriggerClientEvent('QBCore:Notify', src, "Kazandın $"..burgermoney)
    if tiprandom >= 25 then
        Player.Functions.AddMoney("cash", Config.BurgerTip, "burger-tip")
        TriggerClientEvent('QBCore:Notify', src, "Bahşiş kazandın $"..Config.BurgerTip)
    end
end)

QBCore.Functions.CreateCallback('burgershot:server:checkBurger', function(source, cb)
    local src = source
    local Player =  QBCore.Functions.GetPlayer(src)
    local burgerbread = Player.Functions.GetItemByName("burgerbread")
    local burgermeat = Player.Functions.GetItemByName("burgermeat")
    local burgersalad = Player.Functions.GetItemByName("burgersalad")
    if burgerbread ~= nil and burgermeat ~= nil  and burgersalad ~= nil then
        Player.Functions.RemoveItem("burgerbread", 1)
        Player.Functions.RemoveItem("burgermeat", 1)
        Player.Functions.RemoveItem("burgersalad", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["burgerbread"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["burgermeat"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["burgersalad"], "remove")
        cb(true)
    else
        cb(false)
    end
end)


QBCore.Functions.CreateCallback('burgershot:server:checkPack', function(source, cb)
    local src = source
    local Player =  QBCore.Functions.GetPlayer(src)
    local burgerbread = Player.Functions.GetItemByName("burgercola")
    local burgermeat = Player.Functions.GetItemByName("btpatates")
    local burgersalad = Player.Functions.GetItemByName("burger")
    if burgerbread ~= nil and burgermeat ~= nil  and burgersalad ~= nil then
        Player.Functions.RemoveItem("burgercola", 1)
        Player.Functions.RemoveItem("btpatates", 1)
        Player.Functions.RemoveItem("burger", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["burgercola"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["btpatates"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["burger"], "remove")
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('burgershot:server:checkPatato', function(source, cb)
    local src = source
    local Player =  QBCore.Functions.GetPlayer(src)
    local patato = Player.Functions.GetItemByName("patato")
    if patato ~= nil then
        Player.Functions.RemoveItem("patato", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["patato"], "remove")
        cb(true)
    else
        cb(false)
    end
end)
