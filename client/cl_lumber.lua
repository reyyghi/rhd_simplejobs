local pedtokopekerjakayu = nil

local blipPekerjaKayu = {}

local ambilkayu = function ()
    local success = lib.skillCheck({'easy'}, {'1', '2', '3', '4'})
    if not success then return end 

    Functions.progressbar(locale('pekerjakayu_progress_ambil'), 10000, {
        dict = 'melee@hatchet@streamed_core',
        clip = 'plyr_rear_takedown_b'
    }, {}, function ()
        ClearPedTasks(cache.ped)
        TriggerServerEvent('rhd_simplejobs:server:dapetItem', 'lumber', math.random(1, 5))
    end, function ()
        ClearPedTasks(cache.ped)
    end)
end

local prosesKayu = function ( JumlahKayu )
    JumlahKayu = JumlahKayu or 1
    if not Functions.HasItem('lumber', JumlahKayu) then return Functions.notify(locale('jobs_need_item', JumlahKayu, exports.ox_inventory:Items('lumber').label), 'error') end

    local success = lib.skillCheck({'easy'}, {'1', '2', '3', '4'})
    if not success then return end

    ExecuteCommand('e clipboard')
    Functions.progressbar(locale('pekerjakayu_progress_proses'), 5000, {}, {}, function ()
        ClearPedTasks(cache.ped)

        TriggerServerEvent('rhd_simplejobs:server:hapusItem', 'lumber', JumlahKayu)
        TriggerServerEvent('rhd_simplejobs:server:dapetItem', 'treebark', JumlahKayu * 5)
        TriggerServerEvent('rhd_simplejobs:server:dapetItem', 'woodplank', JumlahKayu * 3)
    end, function ()
        ClearPedTasks(cache.ped)
    end)
end

local loopingZonaPenambang = function ( self )
    if IsControlJustPressed(0, 38) then
        if Config.pakaijob then if not LocalPlayer.state.pekerja then return Functions.notify(locale('jobs_belum_ambil_kerja'), 'error') end end
        if self.tipeZona == 'ambil' then
            if not Functions.HasItem('WEAPON_BATTLEAXE', 1) then return Functions.notify(locale('jobs_need_item', 1, exports.ox_inventory:Items('weapon_battleaxe').label), 'error') end
            if cache.weapon ~= GetHashKey('WEAPON_BATTLEAXE') then TriggerEvent('ox_inventory:disarm') return Functions.notify(locale('pekerjakayu_ambil_butuhkapak'), 'error') end

            ambilkayu()
        elseif self.tipeZona == 'proses' then
            prosesKayu(math.random(1, 5))
        end
    end
end

local masukZonaPenambang = function ( self )
    local text = ''
    if self.tipeZona == 'ambil' then
        text = locale('pekerjakayu_drawtext_ambil')
    elseif self.tipeZona == 'proses' then
        text = locale('pekerjakayu_drawtext_proses')
    end
    Functions.drawtext(text, 'e')
end

local keluarzonaPenambang = function ()
    Functions.hidetext()
end

CreateThread(function ()
    for k, v in pairs(Config.pekerjakayu) do
        if k == 'toko' then
            TriggerServerEvent('rhd_simplejobs:server:registertoko', v)
            if lib.requestModel(v.pedmodel, 1500) then
                pedtokopekerjakayu = CreatePed(1, v.pedmodel, v.lokasi_toko.xy, v.lokasi_toko.z - 1, v.lokasi_toko.w, false, false)
                SetPedFleeAttributes(pedtokopekerjakayu, 0, 0)
                SetPedDropsWeaponsWhenDead(pedtokopekerjakayu, false)
                SetPedDiesWhenInjured(pedtokopekerjakayu, false)
                SetEntityInvincible(pedtokopekerjakayu , true)
                FreezeEntityPosition(pedtokopekerjakayu, true)
                SetBlockingOfNonTemporaryEvents(pedtokopekerjakayu, true)
            end
            exports.ox_target:addLocalEntity(pedtokopekerjakayu, {
                {
                    label = v.label_toko,
                    icon = 'fas fa-shopping-basket',
                    onSelect = function ()
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
                            if not blipPekerjaKayu[id] then
                                blipPekerjaKayu[id] = AddBlipForCoord(coords.xyz)
                                SetBlipSprite (blipPekerjaKayu[id], 286)
                                SetBlipDisplay(blipPekerjaKayu[id], 4)
                                SetBlipScale  (blipPekerjaKayu[id], 0.7)
                                SetBlipColour (blipPekerjaKayu[id], 2)
                                SetBlipAsShortRange(blipPekerjaKayu[id], true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(locale('pekerjakayu_blipname_ambilkayu'))
                                EndTextCommandSetBlipName(blipPekerjaKayu[id])
                            end
                        end
                    end
                end

                if tipe == 'proses' then
                    for id, lokasi in pairs(data) do
                        lib.zones.poly({
                            points = lokasi.points,
                            thickness = lokasi.thickness,
                            debug = false,
                            inside = loopingZonaPenambang,
                            onEnter = masukZonaPenambang,
                            onExit = keluarzonaPenambang,
                            tipeZona = 'proses'
                        })
                        for i= 1, #lokasi.points do
                            local coords = lokasi.points[i]
                            if not blipPekerjaKayu[id] then
                                blipPekerjaKayu[id] = AddBlipForCoord(coords.xyz)
                                SetBlipSprite (blipPekerjaKayu[id], 286)
                                SetBlipDisplay(blipPekerjaKayu[id], 4)
                                SetBlipScale  (blipPekerjaKayu[id], 0.7)
                                SetBlipColour (blipPekerjaKayu[id], 2)
                                SetBlipAsShortRange(blipPekerjaKayu[id], true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(locale('pekerjakayu_blipname_proseskayu'))
                                EndTextCommandSetBlipName(blipPekerjaKayu[id])
                            end
                        end
                    end
                end
            end
        end
    end
end)