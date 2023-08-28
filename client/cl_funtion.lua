Functions = {}

Functions.notify = function ( pesan , type, durasi )
    return TriggerEvent('mn:shownotif', pesan, type, durasi)
end

Functions.drawtext = function ( pesan, icon )
    lib.showTextUI(pesan, {
        position = "left-center",
        icon = icon or '',
        style = {
            borderRadius = 3,
            backgroundColor = '#028cf5',
            color = 'white'
        }
    })
end

Functions.hidetext = function ()
    lib.hideTextUI()
end

Functions.HasItem = function ( namaItem, Jumlah )
    if not namaItem then return error('Nama item perlu di isi') end

    Jumlah = Jumlah or 0
    return exports.ox_inventory:Search('count', namaItem) >= Jumlah
end

Functions.progressbar = function (label, durasi, anim, prop, onFinish, onCancel)
    if lib.progressBar({
        duration = durasi,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true
        },
        anim = anim,
        prop = prop
    }) then
        onFinish()
    else
        onCancel()
    end
end