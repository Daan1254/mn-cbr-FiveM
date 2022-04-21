MN = {}


MN.maxFouten = 5 -- Praktijk

MN.maxTheoriefouten = 1


MN.markers = {
    {
        coords = vector3(239.3096, -1381.055, 33.74176),
        draw = "~b~E~w~ >> CBR openen",
        key = 38,
        trigger = "mn-cbr:client:openCBR",
    }
}


MN.PraktijkData = {
    ['dmv'] = {
        price = 200
    },
    ['drive'] = {
        price = 2000,
        vehicle = 't20'
    },
    ['drive_bike'] = {
        price = 1500,
        vehicle = 'bati'
    },
    ['drive_truck'] = {
        price = 3000,
        vehicle = 'Boxville'
    },
}


MN.Routes = {
    ['drive'] = {
        {coords = vector4(229.4105, -1395.148, 30.49322, 143.8938), maxspeed = 50},
        {coords = vector3(203.1783, -1415.408, 29.34153), maxspeed = 80},
        {coords= vector3(124.4746, -1370.15, 29.16521), maxspeed = 80}
    },
    ['drive_truck'] = {
        {coords = vector4(229.4105, -1395.148, 30.49322, 143.8938), maxspeed = 50},
        {coords = vector3(203.1783, -1415.408, 29.34153), maxspeed = 80},
        {coords= vector3(124.4746, -1370.15, 29.16521), maxspeed = 80}
    },
    ['drive_bike'] = {
        {coords = vector4(229.4105, -1395.148, 30.49322, 143.8938), maxspeed = 50},
        {coords = vector3(203.1783, -1415.408, 29.34153), maxspeed = 80},
        {coords= vector3(124.4746, -1370.15, 29.16521), maxspeed = 80}
    },
}