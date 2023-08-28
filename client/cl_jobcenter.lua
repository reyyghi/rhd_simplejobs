local jobcenterped = nil

CreateThread(function()
    if Config.pakaijob then
        for k, v in pairs(Config.ambilPekerjaan) do

            local blip = AddBlipForCoord(v.lokasi.xyz)
            SetBlipSprite (blip, 407)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 1.2)
            SetBlipColour (blip, 27)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(locale('jobcenter_blipname'))
            EndTextCommandSetBlipName(blip)
            
            if lib.requestModel(v.pedmodel, 1500) then
                jobcenterped = CreatePed(1, v.pedmodel, v.lokasi.xy, v.lokasi.z - 1, v.lokasi.w, false, false)
                SetPedFleeAttributes(jobcenterped, 0, 0)
                SetPedDropsWeaponsWhenDead(jobcenterped, false)
                SetPedDiesWhenInjured(jobcenterped, false)
                SetEntityInvincible(jobcenterped , true)
                FreezeEntityPosition(jobcenterped, true)
                SetBlockingOfNonTemporaryEvents(jobcenterped, true)
            end

            exports.ox_target:addLocalEntity(jobcenterped, {
                {
                    label = locale('jobcenter_labeltarget'),
                    icon = 'fas fa-clipboard',
                    onSelect = function ()
                        local statuskerja = LocalPlayer.state.pekerja or false
                        LocalPlayer.state:set('pekerja', not statuskerja, not statuskerja)
                        Functions.notify(LocalPlayer.state.pekerja and locale('jobcenter_mulaibekerja') or locale('jobcenter_berhentikerja'))

                    end,
                    distance = 1.5
                }
            })
        end
    end
end)

RegisterNetEvent('esx:playerLoaded', function( )
    LocalPlayer.state:set('pekerja', false, true)
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set('pekerja', false, true)
end)