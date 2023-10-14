local hstring = require 'hstring'
local SunTime = require("libsuntime")


local hsuntime = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'suntime',
}
  
function hsuntime.test()
  print("hsuntime merge")
end

function hsuntime.percentToMinutes(rise)
  
  floor = math.floor(rise)
  percent = rise - floor
  -- 100 .. 60
  -- 25  .. x

  minutes = percent * 60 
  response = floor .. ':' ..  minutes;

  local vals = hstring.splitBy(response, '.')

  return vals[1]
end

function hsuntime.calculateRiseAndSet(latitude, longitude)
    timezone = 2;
    altitude = 348
    degree = true

    if latitude == nil then
      latitude = 46.76775971140317
    end

    if longitude == nil then
      longitude = 46.76775971140317
    end

    -- SunTime:setPosition("Cluj-Napoca", 46.76775971140317, 23.553090097696654, timezone, altitude, degree)
    
    SunTime:setPosition("Cluj-Napoca", latitude, longitude, timezone, altitude, degree)
    SunTime:setAdvanced()
    SunTime:setDate()

    SunTime:calculateTimes()

    local response = {}
    response[1] = hsuntime.percentToMinutes(SunTime.rise)
    response[2] = hsuntime.percentToMinutes(SunTime.set)

    -- print(SunTime.rise, SunTime.set, SunTime.set_civil) -- or similar see calculateTime()
    -- print(hsuntime.percentToMinutes(SunTime.set))
    -- print(response[1])

    return response;
end

hsuntime.calculateRiseAndSet()

return hsuntime
  
  