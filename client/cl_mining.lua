local pedtokopenambang = nil
local propaxe = nil
local laginambang = false
local lagicucibatu = false

local levelminigame = {'easy', 'easy', 'easy', 'easy', 'easy'}
local keyminigame = {'1', '2', '3', '4'}

local blipTambang = {}

local spawnaxe = function ()
    propaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true)        
    AttachEntityToEntity(propaxe, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.17, -0.04, -0.04, 180, 100.00, 120.0, true, true, false, true, 1, true)
end

local hapusaxe = function ()
    if propaxe then
        DetachEntity(propaxe, 1, true)
        DeleteEntity(propaxe)
        propaxe = nil
    end
end

local loopingAnim = function ()
    lib.requestAnimDict('melee@hatchet@streamed_core')
    CreateThread(function()
        while laginambang do
            TaskPlayAnim(cache.ped, 'melee@hatchet@streamed_core', 'plyr_rear_takedown_b', 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Wait(3000)
        end
    end)
end

local loopingMinigame = function ( data )
	local jumlah = data.jumlah or 0
	while jumlah > 0 do
		laginambang = true
		local success = lib.skillCheck(levelminigame[math.random(#levelminigame)], keyminigame)
		if success then
			jumlah -= 1
            TriggerServerEvent('rhd_simplejobs:server:dapetItem', data.item['nama'], data.item['jumlahdapet'])
		else
            jumlah = 0
            laginambang = false
            hapusaxe()
			return ClearPedTasks(cache.ped)
		end

        if jumlah == 0 then
            laginambang = false
            hapusaxe()
			return ClearPedTasks(cache.ped)
        end
		Wait(100)
	end
end

local cuciBatu = function ( JumlahBatu )

    JumlahBatu = JumlahBatu or 1
    if not Functions.HasItem('mining_stone', JumlahBatu) then return Functions.notify(locale('jobs_need_item', JumlahBatu, exports.ox_inventory:Items('mining_stone').label), 'error') end

    lagicucibatu = true

    local batuHancur = CreateObject(`prop_rock_5_smash1`, GetEntityCoords(cache.ped), true, true, true)
    AttachEntityToEntity(batuHancur, cache.ped, GetPedBoneIndex(cache.ped, 60309), 0.1, 0.0, 0.05, 90.0, -90.0, 90.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)

    local air = nil
    CreateThread(function()
        Wait(3000)

        RemoveNamedPtfxAsset('core')

        while lagicucibatu do
            UseParticleFxAssetNextCall("core")
            air = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", cache.ped, 0.0, 1.0, -0.2, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
            Wait(500)
        end
    end)
        

    Functions.progressbar(locale('penambang_progressbar_cucibatu'), 5000, {}, {}, function ()
        SetEntityAsMissionEntity(batuHancur, true, true)
        DeleteEntity(batuHancur)
        StopParticleFxLooped(air, false)
        lagicucibatu = not lagicucibatu
        ClearPedTasks(cache.ped)

        TriggerServerEvent('rhd_simplejobs:server:gantiItem', 'mining_stone', 'mining_washedstone', JumlahBatu)
    end, function ()
        SetEntityAsMissionEntity(batuHancur, true, true)
        DeleteEntity(batuHancur)
        StopParticleFxLooped(air, false)
        lagicucibatu = not lagicucibatu

        ClearPedTasks(cache.ped)
    end)
end

local leburBatu = function ( JumlahBatu )
    JumlahBatu = JumlahBatu or 1
    if not Functions.HasItem('mining_washedstone', JumlahBatu) then return Functions.notify(locale('jobs_need_item', JumlahBatu, exports.ox_inventory:Items('mining_washedstone').label), 'error') end
    Functions.progressbar(locale('penambang_progressbar_leburbatu'), 10000, {
        dict = 'amb@world_human_stand_fire@male@idle_a',
        clip = 'idle_a',
        flag = 16
    }, {}, function ()
        ClearPedTasks(cache.ped)

        local dapetItem = {
            bagusbanget = 'gold',
            bagusaja = 'iron',
            jelek = 'copper'
        }

        local chance = math.random(1, 15)

        if chance >= 1 and chance <= 5 then
            TriggerServerEvent('rhd_simplejobs:server:gantiItem', 'mining_washedstone', dapetItem.jelek, JumlahBatu * math.random(1, 3))
        elseif chance >= 5 and chance <= 10 then
            TriggerServerEvent('rhd_simplejobs:server:gantiItem', 'mining_washedstone', dapetItem.bagusaja, JumlahBatu * math.random(1, 3))
        elseif chance >= 10 and chance <= 15 then
            TriggerServerEvent('rhd_simplejobs:server:gantiItem', 'mining_washedstone', dapetItem.bagusbanget, JumlahBatu * math.random(1, 3))
        end
    end, function ()
        ClearPedTasks(cache.ped)
    end)
end

local loopingZonaPenambang = function ( self )
    if IsControlJustPressed(0, 38) then
        if Config.pakaijob then if not LocalPlayer.state.pekerja then return Functions.notify(locale('jobs_belum_ambil_kerja'), 'error') end end
        if self.tipeZona == 'ambil' then
            if not Functions.HasItem('mining_pickaxe', 1) then return Functions.notify(locale('jobs_need_item', 1, exports.ox_inventory:Items('mining_pickaxe').label), 'error') end
            spawnaxe()
            loopingAnim()
            loopingMinigame({
                jumlah = 5,
                item = {
                    nama = 'mining_stone',
                    jumlahdapet = math.random(1, 3) 
                }
            })
        elseif self.tipeZona == 'cuci' then
            cuciBatu(math.random(1, 5))
        elseif self.tipeZona == 'lebur' then
            leburBatu(math.random(1, 5))
        end
    end
end

local masukZonaPenambang = function ( self )
    local text = ''
    if self.tipeZona == 'ambil' then
        text = locale('penambang_drawtext_tambang_ambil')
    elseif self.tipeZona == 'cuci' then
        text = locale('penambang_drawtext_tambang_cuci')
    elseif self.tipeZona == 'lebur' then
        text = locale('penambang_drawtext_tambang_lebur')
    end
    Functions.drawtext(text, 'e')
end

local keluarzonaPenambang = function ()
    Functions.hidetext()
end

CreateThread(function ()
    for k, v in pairs(Config.penambang) do
        if k == 'toko' then
            TriggerServerEvent('rhd_simplejobs:server:registertoko', v)
            if lib.requestModel(v.pedmodel, 1500) then
                pedtokopenambang = CreatePed(1, v.pedmodel, v.lokasi_toko.xy, v.lokasi_toko.z - 1, v.lokasi_toko.w, false, false)
                SetPedFleeAttributes(pedtokopenambang, 0, 0)
                SetPedDropsWeaponsWhenDead(pedtokopenambang, false)
                SetPedDiesWhenInjured(pedtokopenambang, false)
                SetEntityInvincible(pedtokopenambang , true)
                FreezeEntityPosition(pedtokopenambang, true)
                SetBlockingOfNonTemporaryEvents(pedtokopenambang, true)
            end
            exports.ox_target:addLocalEntity(pedtokopenambang, {
                {
                    label = v.label_toko,
                    icon = 'fas fa-shopping-basket',
                    onSelect = function ()
                        print(v.id_toko)
                        exports.ox_inventory:openInventory('shop', {type = v.id_toko})
                    end,
                    distance = 1.5
                }
            })
        end
        if k == 'lokasi' then
            for tipe, data in pairs(v) do
                if tipe == 'ambil' then
                    for id, lokasi in pairs(data) do
                        lib.zones.poly({
                            points = lokasi.points,
                            thickness = lokasi.thickness,
                            debug = false,
                            inside = loopingZonaPenambang,
                            onEnter = masukZonaPenambang,
                            onExit = keluarzonaPenambang,
                            tipeZona = 'ambil'
                        })
                        for i= 1, #lokasi.points do
                            local coords = lokasi.points[i]
                            if not blipTambang[id] then
                                blipTambang[id] = AddBlipForCoord(coords.xyz)
                                SetBlipSprite (blipTambang[id], 286)
                                SetBlipDisplay(blipTambang[id], 4)
                                SetBlipScale  (blipTambang[id], 0.7)
                                SetBlipColour (blipTambang[id], 60)
                                SetBlipAsShortRange(blipTambang[id], true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(locale('penambang_blipname_tambang_ambil'))
                                EndTextCommandSetBlipName(blipTambang[id])
                            end
                        end
                    end
                end

                if tipe == 'cuci' then
                    for id, lokasi in pairs(data) do
                        lib.zones.poly({
                            points = lokasi.points,
                            thickness = lokasi.thickness,
                            debug = false,
                            inside = loopingZonaPenambang,
                            onEnter = masukZonaPenambang,
                            onExit = keluarzonaPenambang,
                            tipeZona = 'cuci'
                        })
                        for i= 1, #lokasi.points do
                            local coords = lokasi.points[i]
                            if not blipTambang[id] then
                                blipTambang[id] = AddBlipForCoord(coords.xyz)
                                SetBlipSprite (blipTambang[id], 286)
                                SetBlipDisplay(blipTambang[id], 4)
                                SetBlipScale  (blipTambang[id], 0.7)
                                SetBlipColour (blipTambang[id], 60)
                                SetBlipAsShortRange(blipTambang[id], true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(locale('penambang_blipname_tambang_cuci'))
                                EndTextCommandSetBlipName(blipTambang[id])
                            end
                        end
                    end
                end

                if tipe == 'lebur' then
                    for id, lokasi in pairs(data) do
                        lib.zones.poly({
                            points = lokasi.points,
                            thickness = lokasi.thickness,
                            debug = false,
                            inside = loopingZonaPenambang,
                            onEnter = masukZonaPenambang,
                            onExit = keluarzonaPenambang,
                            tipeZona = 'lebur'
                        })
                        for i= 1, #lokasi.points do
                            local coords = lokasi.points[i]
                            if not blipTambang[id] then
                                blipTambang[id] = AddBlipForCoord(coords.xyz)
                                SetBlipSprite (blipTambang[id], 286)
                                SetBlipDisplay(blipTambang[id], 4)
                                SetBlipScale  (blipTambang[id], 0.7)
                                SetBlipColour (blipTambang[id], 60)
                                SetBlipAsShortRange(blipTambang[id], true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(locale('penambang_blipname_tambang_lebur'))
                                EndTextCommandSetBlipName(blipTambang[id])
                            end
                        end
                    end
                end
            end
        end
    end
end)

