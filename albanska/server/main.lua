-- Variables
local Plates = {}
local PlayerStatus = {}
local Casings = {}
local BloodDrops = {}
local FingerDrops = {}
local Objects = {}
local QBCore = exports['qb-core']:GetCoreObject()

-- Functions
local function UpdateBlips()
    local dutyPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if (v.PlayerData.job.name == "albanska" or v.PlayerData.job.name == "ambulance") and v.PlayerData.job.onduty then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            dutyPlayers[#dutyPlayers+1] = {
                source = v.PlayerData.source,
                label = v.PlayerData.metadata["callsign"],
                job = v.PlayerData.job.name,
                location = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
            }
        end
    end
    TriggerClientEvent("albanska:client:UpdateBlips", -1, dutyPlayers)
end

local function CreateBloodId()
    if BloodDrops then
        local bloodId = math.random(10000, 99999)
        while BloodDrops[bloodId] do
            bloodId = math.random(10000, 99999)
        end
        return bloodId
    else
        local bloodId = math.random(10000, 99999)
        return bloodId
    end
end

local function CreateFingerId()
    if FingerDrops then
        local fingerId = math.random(10000, 99999)
        while FingerDrops[fingerId] do
            fingerId = math.random(10000, 99999)
        end
        return fingerId
    else
        local fingerId = math.random(10000, 99999)
        return fingerId
    end
end

local function CreateCasingId()
    if Casings then
        local caseId = math.random(10000, 99999)
        while Casings[caseId] do
            caseId = math.random(10000, 99999)
        end
        return caseId
    else
        local caseId = math.random(10000, 99999)
        return caseId
    end
end

local function CreateObjectId()
    if Objects then
        local objectId = math.random(10000, 99999)
        while Objects[objectId] do
            objectId = math.random(10000, 99999)
        end
        return objectId
    else
        local objectId = math.random(10000, 99999)
        return objectId
    end
end

local function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    return result
end

local function GetCurrentCops()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "albanska" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    return amount
end

local function DnaHash(s)
    local h = string.gsub(s, ".", function(c)
        return string.format("%02x", string.byte(c))
    end)
    return h
end

-- Commands
QBCore.Commands.Add("spikestrip", Lang:t("commands.place_spike"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
            TriggerClientEvent('albanska:client:SpawnSpikeStrip', src)
        end
    end
end)

QBCore.Commands.Add("grantlicense", Lang:t("commands.license_grant"), {{name = "id", help = Lang:t('info.player_id')}, {name = "license", help = Lang:t('info.license_type')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == "driver" or args[2] == "weapon" then
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
            if licenseTable[args[2]] then
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.license_already"), "error")
                return
            end
            licenseTable[args[2]] = true
            SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("success.granted_license"), "success")
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.grant_license"), "success")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license_type"), "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.rank_license", "error"))
    end
end)

QBCore.Commands.Add("revokelicense", Lang:t("commands.license_revoke"), {{name = "id", help = Lang:t('info.player_id')}, {name = "license", help = Lang:t('info.license_type')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == "driver" or args[2] == "weapon" then
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
            if not licenseTable[args[2]] then
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license"), "error")
                return
            end
            licenseTable[args[2]] = false
            SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("error.revoked_license"), "error")
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.revoke_license"), "success")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license"), "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.rank_revoke", "error"))
    end
end)

QBCore.Commands.Add("pobject", Lang:t("commands.place_object"), {{name = "type",help = Lang:t("info.poobject_object")}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local type = args[1]:lower()
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        if type == "cone" then
            TriggerClientEvent("albanska:client:spawnCone", src)
        elseif type == "barrier" then
            TriggerClientEvent("albanska:client:spawnBarrier", src)
        elseif type == "roadsign" then
            TriggerClientEvent("albanska:client:spawnRoadSign", src)
        elseif type == "tent" then
            TriggerClientEvent("albanska:client:spawnTent", src)
        elseif type == "light" then
            TriggerClientEvent("albanska:client:spawnLight", src)
        elseif type == "delete" then
            TriggerClientEvent("albanska:client:deleteObject", src)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("cuff", Lang:t("commands.cuff_player"), {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:CuffPlayer", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("escort", Lang:t("commands.escort"), {}, false, function(source, args)
    local src = source
    TriggerClientEvent("albanska:client:EscortPlayer", src)
end)

QBCore.Commands.Add("callsign", Lang:t("commands.callsign"), {{name = "name", help = Lang:t('info.callsign_name')}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("callsign", table.concat(args, " "))
end)

QBCore.Commands.Add("clearcasings", Lang:t("commands.clear_casign"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("evidence:client:ClearCasingsInArea", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("jail", Lang:t("commands.jail_player"), {{name = "id", help = Lang:t('info.player_id')}, {name = "time", help = Lang:t('info.jail_time')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if time > 0 then
            TriggerClientEvent("albanska:client:JailCommand", src, playerId, time)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('info.jail_time_no'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("unjail", Lang:t("commands.unjail_player"), {{name = "id", help = Lang:t('info.player_id')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        local playerId = tonumber(args[1])
        TriggerClientEvent("prison:client:UnjailPerson", playerId)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("clearblood", Lang:t("commands.clearblood"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("evidence:client:ClearBlooddropsInArea", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("seizecash", Lang:t("commands.seizecash"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:SeizeCash", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("sc", Lang:t("commands.softcuff"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:CuffPlayerSoft", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("cam", Lang:t("commands.camera"), {{name = "camid", help = Lang:t('info.camera_id')}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:ActiveCamera", src, tonumber(args[1]))
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("flagplate", Lang:t("commands.flagplate"), {{name = "plate", help = Lang:t('info.plate_number')}, {name = "reason", help = Lang:t('info.flag_reason')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        local reason = {}
        for i = 2, #args, 1 do
            reason[#reason+1] = args[i]
        end
        Plates[args[1]:upper()] = {
            isflagged = true,
            reason = table.concat(reason, " ")
        }
        TriggerClientEvent('QBCore:Notify', src, Lang:t("info.vehicle_flagged", {vehicle = args[1]:upper(), reason = table.concat(reason, " ")}))
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("unflagplate", Lang:t("commands.unflagplate"), {{name = "plate", help = Lang:t('info.plate_number')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        if Plates and Plates[args[1]:upper()] then
            if Plates[args[1]:upper()].isflagged then
                Plates[args[1]:upper()].isflagged = false
                TriggerClientEvent('QBCore:Notify', src, Lang:t("info.unflag_vehicle", {vehicle = args[1]:upper()}))
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.vehicle_not_flag"), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.vehicle_not_flag"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("plateinfo", Lang:t("commands.plateinfo"), {{name = "plate", help = Lang:t('info.plate_number')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        if Plates and Plates[args[1]:upper()] then
            if Plates[args[1]:upper()].isflagged then
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.vehicle_flagged', {plate = args[1]:upper(), reason = Plates[args[1]:upper()].reason}), 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.vehicle_not_flag"), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.vehicle_not_flag"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("depot", Lang:t("commands.depot"), {{name = "price", help = Lang:t('info.impound_price')}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:ImpoundVehicle", src, false, tonumber(args[1]))
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("impound", Lang:t("commands.impound"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:ImpoundVehicle", src, true)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("paytow", Lang:t("commands.paytow"), {{name = "id", help = Lang:t('info.player_id')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        local playerId = tonumber(args[1])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if OtherPlayer then
            if OtherPlayer.PlayerData.job.name == "tow" then
                OtherPlayer.Functions.AddMoney("bank", 500, "albanska-tow-paid")
                TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, Lang:t("success.tow_paid"), 'success')
                TriggerClientEvent('QBCore:Notify', src, Lang:t("info.tow_driver_paid"))
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_towdriver"), 'error')
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("paylawyer", Lang:t("commands.paylawyer"), {{name = "id",help = Lang:t('info.player_id')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if OtherPlayer then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", 500, "albanska-lawyer-paid")
                TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, Lang:t("success.tow_paid"), 'success')
                TriggerClientEvent('QBCore:Notify', src, Lang:t("info.paid_lawyer"))
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_lawyer"), "error")
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("anklet", Lang:t("commands.anklet"), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:CheckDistance", src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("ankletlocation", Lang:t("commands.ankletlocation"), {{name = "cid", help = Lang:t('info.citizen_id')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        if args[1] then
            local citizenid = args[1]
            local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            if Target then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("albanska:client:SendTrackerLocation", Target.PlayerData.source, src)
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_anklet"), 'error')
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("removeanklet", Lang:t("commands.removeanklet"), {{name = "cid", help = Lang:t('info.citizen_id')}}, true,function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        if args[1] then
            local citizenid = args[1]
            local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            if Target then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("albanska:client:SendTrackerLocation", Target.PlayerData.source, src)
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_anklet"), 'error')
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("takedrivinglicense", Lang:t("commands.drivinglicense"), {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty then
        TriggerClientEvent("albanska:client:SeizeDriverLicense", source)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.on_duty_albanska_only"), 'error')
    end
end)

QBCore.Commands.Add("takedna", Lang:t("commands.takedna"), {{name = "id", help = Lang:t('info.player_id')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if ((Player.PlayerData.job.name == "albanska") and Player.PlayerData.job.onduty) and OtherPlayer then
        if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
            local info = {
                label = Lang:t('info.dna_sample'),
                type = "dna",
                dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid)
            }
            if Player.Functions.AddItem("filled_evidence_bag", 1, false, info) then
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.have_evidence_bag"), "error")
        end
    end
end)

RegisterNetEvent('albanska:server:SendTrackerLocation', function(coords, requestId)
    local Target = QBCore.Functions.GetPlayer(source)
    local msg = Lang:t('info.target_location', {firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname})
    local alertData = {
        title = Lang:t('info.anklet_location'),
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        description = msg
    }
    TriggerClientEvent("albanska:client:TrackerMessage", requestId, msg, coords)
    TriggerClientEvent("qb-phone:client:addalbanskaAlert", requestId, alertData)
end)

QBCore.Commands.Add('911p', Lang:t("commands.albanska_report"), {{name='message', help=Lang:t("commands.message_sent")}}, false, function(source, args)
	local src = source
	if args[1] then message = table.concat(args, " ") else message = Lang:t("commands.civilian_call") end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'albanska' and v.PlayerData.job.onduty then
            local alertData = {title = Lang:t("commands.emergency_call"), coords = {coords.x, coords.y, coords.z}, description = message}
            TriggerClientEvent("qb-phone:client:addalbanskaAlert", v.PlayerData.source, alertData)
            TriggerClientEvent('albanska:client:albanskaAlert', v.PlayerData.source, coords, message)
        end
    end
end)

-- Items
QBCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("albanska:client:CuffPlayerSoft", src)
    end
end)

QBCore.Functions.CreateUseableItem("moneybag", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info and item.info ~= "" then
            if Player.PlayerData.job.name ~= "albanska" then
                if Player.Functions.RemoveItem("moneybag", 1, item.slot) then
                    Player.Functions.AddMoney("cash", tonumber(item.info.cash), "used-moneybag")
                end
            end
        end
    end
end)

-- Callbacks
QBCore.Functions.CreateCallback('albanska:server:isPlayerDead', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

QBCore.Functions.CreateCallback('albanska:GetPlayerStatus', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    local statList = {}
    if Player then
        if PlayerStatus[Player.PlayerData.source] and next(PlayerStatus[Player.PlayerData.source]) then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                statList[#statList+1] = PlayerStatus[Player.PlayerData.source][k].text
            end
        end
    end
    cb(statList)
end)

QBCore.Functions.CreateCallback('albanska:IsSilencedWeapon', function(source, cb, weapon)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemInfo = Player.Functions.GetItemByName(QBCore.Shared.Weapons[weapon]["name"])
    local retval = false
    if itemInfo then
        if itemInfo.info and itemInfo.info.attachments then
            for k, v in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP_02" or
                    itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP" or
                    itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP_02" or
                    itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP" then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('albanska:GetDutyPlayers', function(source, cb)
    local dutyPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "albanska" and v.PlayerData.job.onduty then
            dutyPlayers[#dutyPlayers+1] = {
                source = Player.PlayerData.source,
                label = Player.PlayerData.metadata["callsign"],
                job = Player.PlayerData.job.name
            }
        end
    end
    cb(dutyPlayers)
end)

QBCore.Functions.CreateCallback('albanska:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE state = ?', {2}, function(result)
        if result[1] then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

QBCore.Functions.CreateCallback('albanska:IsPlateFlagged', function(source, cb, plate)
    local retval = false
    if Plates and Plates[plate] then
        if Plates[plate].isflagged then
            retval = true
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('albanska:GetCops', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "albanska" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

QBCore.Functions.CreateCallback('albanska:server:IsalbanskaForcePresent', function(source, cb)
    local retval = false
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "albanska" and v.PlayerData.job.grade.level >= 2 then
            retval = true
            break
        end
    end
    cb(retval)
end)

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            MySQL.Async.execute("DELETE FROM stashitems WHERE stash='albanskatrash'")
        end)
    end
end)

RegisterNetEvent('albanska:server:albanskaAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'albanska' and v.PlayerData.job.onduty then
            local alertData = {title = Lang:t('info.new_call'), coords = {coords.x, coords.y, coords.z}, description = text}
            TriggerClientEvent("qb-phone:client:addalbanskaAlert", v.PlayerData.source, alertData)
            TriggerClientEvent('albanska:client:albanskaAlert', v.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('albanska:server:TakeOutImpound', function(plate)
    local src = source
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate  = ?', {0, plate})
    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.impound_vehicle_removed"), 'success')
end)

RegisterNetEvent('albanska:server:CuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    if CuffedPlayer then
        if Player.Functions.GetItemByName("handcuffs") or Player.PlayerData.job.name == "albanska" then
            TriggerClientEvent("albanska:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
        end
    end
end)

RegisterNetEvent('albanska:server:EscortPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if (Player.PlayerData.job.name == "albanska" or Player.PlayerData.job.name == "ambulance") or (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"]) then
            TriggerClientEvent("albanska:client:GetEscorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_cuffed_dead"), 'error')
        end
    end
end)

RegisterNetEvent('albanska:server:KidnapPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or
            EscortPlayer.PlayerData.metadata["inlaststand"] then
            TriggerClientEvent("albanska:client:GetKidnappedTarget", EscortPlayer.PlayerData.source, Player.PlayerData.source)
            TriggerClientEvent("albanska:client:GetKidnappedDragger", Player.PlayerData.source, EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_cuffed_dead"), 'error')
        end
    end
end)

RegisterNetEvent('albanska:server:SetPlayerOutVehicle', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("albanska:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_cuffed_dead"), 'error')
        end
    end
end)

RegisterNetEvent('albanska:server:PutPlayerInVehicle', function(playerId)
    local src = source
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("albanska:client:PutInVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_cuffed_dead"), 'error')
        end
    end
end)

RegisterNetEvent('albanska:server:BillPlayer', function(playerId, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "albanska" then
        if OtherPlayer then
            OtherPlayer.Functions.RemoveMoney("bank", price, "paid-bills")
            TriggerEvent('qb-bossmenu:server:addAccountMoney', "albanska", price)
            TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, Lang:t("info.fine_received", {fine = price}))
        end
    end
end)

RegisterNetEvent('albanska:server:JailPlayer', function(playerId, time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then
        currentDate.day = 30
    end

    if Player.PlayerData.job.name == "albanska" then
        if OtherPlayer then
            OtherPlayer.Functions.SetMetaData("injail", time)
            OtherPlayer.Functions.SetMetaData("criminalrecord", {
                ["hasRecord"] = true,
                ["date"] = currentDate
            })
            TriggerClientEvent("albanska:client:SendToJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("info.sent_jail_for", {time = time}))
        end
    end
end)

RegisterNetEvent('albanska:server:SetHandcuffStatus', function(isHandcuffed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData("ishandcuffed", isHandcuffed)
    end
end)

RegisterNetEvent('heli:spotlight', function(state)
    local serverID = source
    TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)

-- RegisterNetEvent('albanska:server:FlaggedPlateTriggered', function(camId, plate, street1, street2, blipSettings)
--     local src = source
--     for k, v in pairs(QBCore.Functions.GetPlayers()) do
--         local Player = QBCore.Functions.GetPlayer(v)
--         if Player then
--             if (Player.PlayerData.job.name == "albanska" and Player.PlayerData.job.onduty) then
--                 if street2 then
--                     TriggerClientEvent("112:client:SendalbanskaAlert", v, "flagged", {
--                         camId = camId,
--                         plate = plate,
--                         streetLabel = street1 .. " " .. street2
--                     }, blipSettings)
--                 else
--                     TriggerClientEvent("112:client:SendalbanskaAlert", v, "flagged", {
--                         camId = camId,
--                         plate = plate,
--                         streetLabel = street1
--                     }, blipSettings)
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('albanska:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("info.cash_found", {cash = SearchedPlayer.PlayerData.money["cash"]}))
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("info.being_searched"))
    end
end)

RegisterNetEvent('albanska:server:SeizeCash', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local moneyAmount = SearchedPlayer.PlayerData.money["cash"]
        local info = { cash = moneyAmount }
        SearchedPlayer.Functions.RemoveMoney("cash", moneyAmount, "albanska-cash-seized")
        Player.Functions.AddItem("moneybag", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["moneybag"], "add")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("info.cash_confiscated"))
    end
end)

RegisterNetEvent('albanska:server:SeizeDriverLicense', function(playerId)
    local src = source
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
        if driverLicense then
            local licenses = {["driver"] = false, ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]}
            SearchedPlayer.Functions.SetMetaData("licences", licenses)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("info.driving_license_confiscated"))
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_driver_license"), 'error')
        end
    end
end)

RegisterNetEvent('albanska:server:RobPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "albanska-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "albanska-player-robbed")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("info.cash_robbed", {money = money}))
        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t("info.stolen_money", {stolen = money}))
    end
end)

RegisterNetEvent('albanska:server:UpdateBlips', function()
    -- KEEP FOR REF BUT NOT NEEDED ANYMORE.
end)

RegisterNetEvent('albanska:server:spawnObject', function(type)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("albanska:client:spawnObject", src, objectId, type, src)
end)

RegisterNetEvent('albanska:server:deleteObject', function(objectId)
    TriggerClientEvent('albanska:client:removeObject', -1, objectId)
end)

RegisterNetEvent('albanska:server:Impound', function(plate, fullImpound, price, body, engine, fuel)
    local src = source
    local price = price and price or 0
    if IsVehicleOwned(plate) then
        if not fullImpound then
            MySQL.Async.execute(
                'UPDATE player_vehicles SET state = ?, depotprice = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?',
                {0, price, body, engine, fuel, plate})
            TriggerClientEvent('QBCore:Notify', src, Lang:t("info.vehicle_taken_depot", {price = price}))
        else
            MySQL.Async.execute(
                'UPDATE player_vehicles SET state = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?',
                {2, body, engine, fuel, plate})
            TriggerClientEvent('QBCore:Notify', src, Lang:t("info.vehicle_seized"))
        end
    end
end)

RegisterNetEvent('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterNetEvent('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {
        dna = citizenid,
        bloodtype = bloodtype
    }
    TriggerClientEvent("evidence:client:AddBlooddrop", -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterNetEvent('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent("evidence:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterNetEvent('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList and next(blooddropList) then
        for k, v in pairs(blooddropList) do
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, v)
            BloodDrops[v] = nil
        end
    end
end)

RegisterNetEvent('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, bloodInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, bloodId)
            BloodDrops[bloodId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.have_evidence_bag"), "error")
    end
end)

RegisterNetEvent('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, fingerInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveFingerprint", -1, fingerId)
            FingerDrops[fingerId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.have_evidence_bag"), "error")
    end
end)

RegisterNetEvent('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local casingId = CreateCasingId()
    local weaponInfo = QBCore.Shared.Weapons[weapon]
    local serieNumber = nil
    if weaponInfo then
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["name"])
        if weaponItem then
            if weaponItem.info and weaponItem.info ~= "" then
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("evidence:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)

RegisterNetEvent('albanska:server:UpdateCurrentCops', function()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "albanska" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    TriggerClientEvent("albanska:SetCopCount", -1, amount)
end)

RegisterNetEvent('evidence:server:ClearCasings', function(casingList)
    if casingList and next(casingList) then
        for k, v in pairs(casingList) do
            TriggerClientEvent("evidence:client:RemoveCasing", -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterNetEvent('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, casingInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveCasing", -1, casingId)
            Casings[casingId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.have_evidence_bag"), "error")
    end
end)

RegisterNetEvent('albanska:server:showFingerprint', function(playerId)
    local src = source
    TriggerClientEvent('albanska:client:showFingerprint', playerId, src)
    TriggerClientEvent('albanska:client:showFingerprint', src, playerId)
end)

RegisterNetEvent('albanska:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fid = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent('albanska:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('albanska:client:showFingerprintId', src, fid)
end)

RegisterNetEvent('albanska:server:SetTracker', function(targetId)
    local src = source
    local Target = QBCore.Functions.GetPlayer(targetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('QBCore:Notify', targetId, Lang:t("success.anklet_taken_off"), 'success')
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.took_anklet_from", {firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname}), 'success')
        TriggerClientEvent('albanska:client:SetTracker', targetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('QBCore:Notify', targetId, Lang:t("success.put_anklet"), 'success')
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.put_anklet_on", {firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname}), 'success')
        TriggerClientEvent('albanska:client:SetTracker', targetId, true)
    end
end)

RegisterNetEvent('albanska:server:SyncSpikes', function(table)
    TriggerClientEvent('albanska:client:SyncSpikes', -1, table)
end)

-- Threads
CreateThread(function()
    while true do
        Wait(1000 * 60 * 10)
        local curCops = GetCurrentCops()
        TriggerClientEvent("albanska:SetCopCount", -1, curCops)
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        UpdateBlips()
    end
end)