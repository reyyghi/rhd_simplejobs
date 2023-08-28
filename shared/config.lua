Config = {}

Config.pakaijob = true --- ubah ke false jika tidak ingin memakai sistem job (langsung bisa bekerja tanpa mengambil pekerjaan)

Config.ambilPekerjaan = {
    [1] = {
        lokasi = vec4(-267.7611, -964.1541, 31.2231, 300.2822),
        pedmodel = 'cs_barry',
    }
}

Config.penambang = {
    toko = {
        id_toko = 'toko_penambang',
        label_toko = 'Toko Penambang',
        isi_toko = {
            { name = 'mining_pickaxe', price = 5000 },
            { name = 'water', price = 100 },
            { name = 'burger', price = 150 }
        },
        lokasi_toko = vec4(2966.2019, 2755.1582, 43.2419, 235.5999),
        pedmodel = 's_m_m_gardener_01'
    },
    lokasi = {
        ambil = {
            ['lokasi_ambil_1'] = {
                points = {
                    vec3(2933.0, 2758.0, 44.0),
                    vec3(2935.0, 2759.0, 44.0),
                    vec3(2937.0, 2753.0, 44.0),
                    vec3(2936.0, 2745.0, 44.0),
                    vec3(2937.0, 2741.0, 44.0),
                    vec3(2933.0, 2741.0, 44.0),
                },
                thickness = 10.0,
            },
            ['lokasi_ambil_2'] = {
                points = {
                    vec3(2975.0, 2737.5, 45.0),
                    vec3(2977.75, 2741.5, 45.0),
                    vec3(2978.25, 2746.25, 45.0),
                    vec3(2980.0, 2748.5, 45.0),
                    vec3(2986.0, 2751.5, 45.0),
                    vec3(2985.0, 2753.0, 45.0),
                    vec3(2980.0, 2750.0, 45.0),
                    vec3(2977.0, 2747.0, 45.0),
                },
                thickness = 6.75,
            }
        },
        cuci = {
            ['lokasi_cuci_1'] = {
                points = {
                    vec3(1962.5, 482.0, 161.0),
                    vec3(1967.0, 475.0, 161.0),
                    vec3(1971.0, 472.0, 161.0),
                    vec3(1973.0, 473.0, 161.0),
                    vec3(1972.0, 470.0, 161.0),
                    vec3(1968.9000244141, 467.0, 161.0),
                    vec3(1952.0, 468.0, 161.0),
                    vec3(1957.0, 478.0, 161.0),
                    vec3(1957.0, 485.0, 161.0),
                    vec3(1962.0999755859, 487.0, 161.0),
                    vec3(1962.0999755859, 487.0, 161.0),
                },
                thickness = 6.1,
            }
        },
        lebur = {
            ['lokasi_lebur_1'] = {
                points = {
                    vec3(1114.1999511719, -2007.8000488281, 31.0),
                    vec3(1111.0, -2006.0, 31.0),
                    vec3(1109.0, -2007.0, 31.0),
                    vec3(1108.0, -2008.0, 31.0),
                    vec3(1108.5, -2010.5, 31.0),
                    vec3(1111.25, -2012.5, 31.0),
                },
                thickness = 4.0,
            }
        }
    }
}

Config.pekerjakayu = {
    toko = {
        id_toko = 'toko_pekerja_kayu',
        label_toko = 'Toko Pekerja Kayu',
        isi_toko = {
            { name = 'weapon_battleaxe', price = 5000 },
            { name = 'water', price = 100 },
            { name = 'burger', price = 150 }
        },
        lokasi_toko = vec4(-557.6263, 5362.7666, 70.2166, 45.1365),
        pedmodel = 's_m_m_gardener_01'
    },
    lokasi = {
        ambil = {
            ['lokasi_ambil_1'] = {
                points = {
                    vec3(-547.65002441406, 5373.0498046875, 70.0),
                    vec3(-552.20001220703, 5374.5, 70.0),
                    vec3(-555.34997558594, 5365.2998046875, 70.0),
                    vec3(-554.29998779297, 5365.0, 70.0),
                    vec3(-554.95001220703, 5363.0, 70.0),
                    vec3(-557.0, 5365.0, 70.0),
                    vec3(-553.5, 5375.0, 70.0),
                    vec3(-550.95001220703, 5376.2001953125, 70.0),
                    vec3(-548.0, 5375.0, 70.0),
                },
                thickness = 4.0,
            },
        },
        proses = {
            ['lokasi_proses_1'] = {
                points = {
                    vec3(-567.59997558594, 5331.2001953125, 70.0),
                    vec3(-571.70001220703, 5332.6000976562, 70.0),
                    vec3(-572.5, 5330.0, 70.0),
                    vec3(-568.59997558594, 5328.6000976562, 70.0),
                },
                thickness = 4.0,
            }
        },
    }
}


lib.locale()