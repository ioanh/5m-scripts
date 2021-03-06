Config = {}

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["roadsign"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
}

Config.MaxSpikes = 5

Config.HandCuffItem = 'handcuffs'

Config.LicenseRank = 0
Config.Locations = {
    ["duty"] = {
        [1] = vector3(-2674.91, 1336.16, 144.26),
    },
    ["vehicle"] = {
        [1] = vector4(-2669.51, 1304.99, 147.12, 267.23),
    },
    ["stash"] = {
        [1] = vector3(-2679.47, 1326.2, 144.26),
    },
    ["impound"] = {
        -- [1] = vector4(436.68, -1007.42, 27.32, 180.0),
        -- [2] = vector4(-436.14, 5982.63, 31.34, 136.0),
    },
    ["helicopter"] = {
        -- [1] = vector4(449.168, -981.325, 43.691, 87.234),
        -- [2] = vector4(-475.43, 5988.353, 31.716, 31.34),
    },
    ["armory"] = {
        [1] = vector3(-2675.49, 1330.93, 140.88),
    },
    ["trash"] = {
        [1] = vector3(-2676.83, 1314.61, 147.45),
    },
    ["fingerprint"] = {
        -- [1] = vector3(460.9667, -989.180, 24.92),
    },
    ["evidence"] = {
        -- [1] = vector3(442.1722, -996.067, 30.689),
        -- [2] = vector3(451.7031, -973.232, 30.689),
        -- [3] = vector3(455.1456, -985.462, 30.689),
    },
    ["stations"] = {
        -- [1] = {label = "police Station", coords = vector4(428.23, -984.28, 29.76, 3.5)},
        -- [2] = {label = "Prison", coords = vector4(1845.903, 2585.873, 45.672, 272.249)},
        -- [3] = {label = "police Station Paleto", coords = vector4(-451.55, 6014.25, 31.716, 223.81)},
    },
}

Config.ArmoryWhitelist = {}

Config.russianHelicopter = "POLMAV"

Config.SecurityCameras = {
    hideradar = false,
    cameras = {
        [1] = {label = "Russian Mafia CAM#1", coords = vector3(-2640.86, 1291.74, 154.12), r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true, isOnline = true},
    },
}

Config.AuthorizedVehicles = {
	-- Grade 0
	[0] = {
		["cullinan"] = "Rolls Royce Cullinan",
        ["c63s"] = "Mercedes-Benz C63S",
        ["jeepg"] = "Jeep Rubicon",
        ["rumpo3"] = "Van",
	},
	-- Grade 1
	[1] = {
		["cullinan"] = "Rolls Royce Cullinan",
        ["c63s"] = "Mercedes-Benz C63S",
        ["jeepg"] = "Jeep Rubicon",
        ["rumpo3"] = "Van",
	},
	-- Grade 2
	[2] = {
		["cullinan"] = "Rolls Royce Cullinan",
        ["c63s"] = "Mercedes-Benz C63S",
        ["jeepg"] = "Jeep Rubicon",
        ["rumpo3"] = "Van",
	},
	-- Grade 3
	[3] = {
		["cullinan"] = "Rolls Royce Cullinan",
        ["c63s"] = "Mercedes-Benz C63S",
        ["jeepg"] = "Jeep Rubicon",
        ["rumpo3"] = "Van",
	},
	-- Grade 4
	[4] = {
		["cullinan"] = "Rolls Royce Cullinan",
        ["c63s"] = "Mercedes-Benz C63S",
        ["jeepg"] = "Jeep Rubicon",
        ["rumpo3"] = "Van",
	}
}

Config.WhitelistedVehicles = {}

Config.AmmoLabels = {
    ["AMMO_PISTOL"] = "9x19mm parabellum bullet",
    ["AMMO_SMG"] = "9x19mm parabellum bullet",
    ["AMMO_RIFLE"] = "7.62x39mm bullet",
    ["AMMO_MG"] = "7.92x57mm mauser bullet",
    ["AMMO_SHOTGUN"] = "12-gauge bullet",
    ["AMMO_SNIPER"] = "Large caliber bullet",
}

Config.Radars = {
	-- vector4(-623.44421386719, -823.08361816406, 25.25704574585, 145.0),
	-- vector4(-652.44421386719, -854.08361816406, 24.55704574585, 325.0),
	-- vector4(1623.0114746094, 1068.9924316406, 80.903594970703, 84.0),
	-- vector4(-2604.8994140625, 2996.3391113281, 27.528566360474, 175.0),
	-- vector4(2136.65234375, -591.81469726563, 94.272926330566, 318.0),
	-- vector4(2117.5764160156, -558.51013183594, 95.683128356934, 158.0),
	-- vector4(406.89505004883, -969.06286621094, 29.436267852783, 33.0),
	-- vector4(657.315, -218.819, 44.06, 320.0),
	-- vector4(2118.287, 6040.027, 50.928, 172.0),
	-- vector4(-106.304, -1127.5530, 30.778, 230.0),
	-- vector4(-823.3688, -1146.980, 8.0, 300.0),
}

Config.CarItems = {
    -- [1] = {
    --     name = "heavyarmor",
    --     amount = 2,
    --     info = {},
    --     type = "item",
    --     slot = 1,
    -- },
    -- [2] = {
    --     name = "empty_evidence_bag",
    --     amount = 10,
    --     info = {},
    --     type = "item",
    --     slot = 2,
    -- },
    -- [3] = {
    --     name = "police_stormram",
    --     amount = 1,
    --     info = {},
    --     type = "item",
    --     slot = 3,
    -- },
}

Config.Items = {
    label = "?????????? ?????????? ??????????",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 25000,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    -- {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [2] = {
            name = "weapon_stungun",
            price = 2500,
            amount = 1,
            info = {
                serie = "",
            },
            type = "weapon",
            slot = 2,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 75000,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    -- {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [4] = {
            name = "weapon_smg",
            price = 55000,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    -- {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    -- {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 4,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [5] = {
            name = "weapon_assaultrifle",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    -- {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    -- {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                }
            },
            type = "weapon",
            slot = 5,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [6] = {
            name = "pistol_ammo",
            price = 50,
            amount = 5,
            info = {},
            type = "item",
            slot = 7,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [7] = {
            name = "smg_ammo",
            price = 50,
            amount = 5,
            info = {},
            type = "item",
            slot = 8,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [8] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 9,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [9] = {
            name = "rifle_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [10] = {
            name = "armor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [11] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [12] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 17,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        }
    }
}

Config.VehicleSettings = {
    ["car1"] = { --- Model name
        ["extras"] = {
            ["1"] = true, -- on/off
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        }
    },
    ["car2"] = {
        ["extras"] = {
            ["1"] = true,
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        }
    }
}
