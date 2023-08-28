RegisterNetEvent('rhd_simplejobs:server:registertoko', function( dataToko )
    exports.ox_inventory:RegisterShop(dataToko.id_toko, {
        name = dataToko.label_toko,
        inventory = dataToko.isi_toko
    })
end)

RegisterNetEvent('rhd_simplejobs:server:dapetItem', function ( namaItem, jumlahItem )
    if exports.ox_inventory:CanCarryItem(source, namaItem, jumlahItem) then
        exports.ox_inventory:AddItem(source, namaItem, jumlahItem)
    end
end)

RegisterNetEvent('rhd_simplejobs:server:gantiItem', function( itemLama, itemBaru, jumlahItem )
    if exports.ox_inventory:CanCarryItem(source, itemBaru, jumlahItem) then
        if exports.ox_inventory:RemoveItem(source, itemLama, jumlahItem) then
            exports.ox_inventory:AddItem(source, itemBaru, jumlahItem)
        end
    end
end)

RegisterNetEvent('rhd_simplejobs:server:hapusItem', function( namaItem, jumlahItem )
    exports.ox_inventory:RemoveItem(source, namaItem, jumlahItem)
end)