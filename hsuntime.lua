local SunTime = require("libsuntime")

local hsuntime = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'suntime',
}
  
function hsuntime.test()
  print("hsuntime merge")
end


function hsuntime.start()
    time_zone = 0
    altitude = 348
    degree = true
    SunTime:setPosition("Cluj-Napoca", 46.76775971140317, 23.553090097696654, timezone, altitude, degree)

    SunTime:setAdvanced()

    SunTime:setDate()

    SunTime:calculateTimes()
    print(SunTime.rise, SunTime.set, SunTime.set_civil) -- or similar see calculateTime()
end

hsuntime.start()

return hsuntime
  
  