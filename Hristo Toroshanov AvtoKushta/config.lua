Config = {}
Config.UsingTarget = false -- If you are using qb-target (uses entity zones to target vehicles)
Config.Commission = 0.10 -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-29.53, -1103.67, 26.42) -- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24 -- time in hours between payment being due
Config.MinimumDown = 10 -- minimum percentage allowed down
Config.MaximumPayments = 24 -- maximum payments allowed
Config.Shops = {
    ['pdm'] = {
        ['Type'] = 'free-use',  -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = { --polygon that surrounds the shop
                vector2(-56.727394104004, -1086.2325439453),
                vector2(-60.612808227539, -1096.7795410156),
                vector2(-58.26834487915, -1100.572265625),
                vector2(-35.927803039551, -1109.0034179688),
                vector2(-34.427627563477, -1108.5111083984),
                vector2(-32.02657699585, -1101.5877685547),
                vector2(-33.342102050781, -1101.0377197266),
                vector2(-31.292987823486, -1095.3717041016)
            },
            ['minZ'] = 25.0,  -- min height of the shop zone
            ['maxZ'] = 28.0  -- max height of the shop zone
        },
        ['Job'] = 'none', -- Name of job or none
        ['ShopLabel'] = 'Premium Deluxe Motorsport', -- Blip name
        ['showBlip'] = true,  --- true or false
        ['Categories'] = { -- Categories available to browse
            ['sportsclassics'] = 'Sports Classics',
            ['sedans'] = 'Sedans',
            ['coupes'] = 'Coupes',
            ['suvs'] = 'SUVs',
            ['offroad'] = 'Offroad',
            ['muscle'] = 'Muscle',
            ['compacts'] = 'Compacts',
            ['motorcycles'] = 'Motorcycles',
            ['vans'] = 'Vans',
            ['cycles'] = 'Bicycles'
        },
        ['TestDriveTimeLimit'] = 0.5, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-45.67, -1098.34, 26.42), -- Blip Location
        ['ReturnLocation'] = vector3(-44.74, -1082.58, 26.68), -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5), -- Spawn location when vehicle is bought
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-45.65, -1093.66, 25.44, 69.5), -- where the vehicle will spawn on display
                defaultVehicle = 'adder', -- Default display vehicle
                chosenVehicle = 'adder', -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-48.27, -1101.86, 25.44, 294.5),
                defaultVehicle = 'schafter2',
                chosenVehicle = 'schafter2',
            },
            [3] = {
                coords = vector4(-39.6, -1096.01, 25.44, 66.5),
                defaultVehicle = 'comet2',
                chosenVehicle = 'comet2',
            },
            [4] = {
                coords = vector4(-51.21, -1096.77, 25.44, 254.5),
                defaultVehicle = 'vigero',
                chosenVehicle = 'vigero',
            },
            [5] = {
                coords = vector4(-40.18, -1104.13, 25.44, 338.5),
                defaultVehicle = 't20',
                chosenVehicle = 't20',
            },
            [6] = {
                coords = vector4(-43.31, -1099.02, 25.44, 52.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            },
            [7] = {
                coords = vector4(-50.66, -1093.05, 25.44, 222.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            },
            [8] = {
                coords = vector4(-44.28, -1102.47, 25.44, 298.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            }
        },
    },
   ['luxury'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Zone'] = {
            ['Shape'] = {
                vector2(-787.85559082032, -247.81187438964),
                vector2(-787.91497802734, -247.86921691894),
                vector2(-779.1900024414, -244.10165405274),
                vector2(-776.41522216796, -220.62818908692),
                vector2(-786.14172363282, -202.76622009278),
                vector2(-808.62670898438, -211.6842803955)
            },
            ['minZ'] = 37.150302886962,
            ['maxZ'] = 37.172267913818
        },
        ['Job'] = 'cardealer', -- Name of job or none
        ['ShopLabel'] = 'Автокъща Торошанов',
        ['showBlip'] = true,  --- true or false
        ['Categories'] = {
            ['custom'] = 'custom',
        },
        ['TestDriveTimeLimit'] = 0.5,
        ['Location'] = vector3(-786.99, -226.92, 37.15),
        ['ReturnLocation'] = vector3(-1231.46, -349.86, 37.33),
        ['VehicleSpawn'] = vector4(-1231.46, -349.86, 37.33, 26.61),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-791.54, -217.96, 36.45, 82.63),
                defaultVehicle = 'taycan',
                chosenVehicle = 'taycan',
            },
            [2] = {
                coords = vector4(-787.79, -207.19, 36.15, 120.05),
                defaultVehicle = 'ocnlamtmc',
                chosenVehicle = 'ocnlamtmc',
            },
            [3] = {
                coords = vector4(-779.71, -219.21, 36.15, 69.22),
                defaultVehicle = '18performante',
                chosenVehicle = '18performante',
            },
            [4] = {
                coords = vector4(-804.25, -212.99, 36.15, 262.94),
                defaultVehicle = 'm3f80',
                chosenVehicle = 'm3f80',
            },
            [5] = {
                coords = vector4(-802.94, -216.11, 36.15, 255.31),
                defaultVehicle = 'bmwm8',
                chosenVehicle = 'bmwm8',
            },
            [6] = {
                coords = vector4(-796.71, -227.39, 36.15, 332.5),
                defaultVehicle = 'rocket',
                chosenVehicle = 'rocket',
            },
            [7] = {
                coords = vector4(-794.06, -230.28, 36.15, 335.52),
                defaultVehicle = 'c63s',
                chosenVehicle = 'c63s',
            },
            [8] = {
                coords = vector4(-792.01, -233.66, 36.15, 339.23),
                defaultVehicle = 'gle21',
                chosenVehicle = 'gle21',
            },
            [9] = {
                coords = vector4(-790.02, -237.33, 36.15, 340.24),
                defaultVehicle = 'mlnovitec',
                chosenVehicle = 'mlnovitec',
            },
            [10] = {
                coords = vector4(-788.2, -240.86, 36.15, 342.4),
                defaultVehicle = 'cullinan',
                chosenVehicle = 'cullinan',
            },
            [11] = {
                coords = vector4(-786.37, -244.94, 36.15, 333.07),
                defaultVehicle = 'jeepg',
                chosenVehicle = 'jeepg',
            },
        }
    } -- Add your next table under this comma
}
