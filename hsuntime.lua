local hstring = require 'hstring'
local SunTime = require("libsuntime")
local hsettings = require 'hsettings'


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
  response = floor .. ':' .. minutes;

  local vals = hstring.splitBy(response, '.')

  return vals[1]
end

function hsuntime.calculateRiseAndSet(coordinates)

  local latitude = 46.76775971140317;
  local longitude = 23.553090097696654;

  if (coordinates ~= nil) then
    local latitudeLongitude = hstring.splitBy(coordinates, ',')
    latitude = latitudeLongitude[1];
    longitude = latitudeLongitude[2];
  end

  local timezone = 2;
  local altitude = 348
  local degree = true

  -- SunTime:setPosition("Cluj-Napoca", 46.76775971140317, 23.553090097696654, timezone, altitude, degree)

  SunTime:setPosition("Cluj-Napoca", latitude, longitude, timezone, altitude, degree)
  SunTime:setAdvanced()
  SunTime:setDate()

  SunTime:calculateTimes()

  local response = {}
  response[1] = hsuntime.percentToMinutes(SunTime.rise)
  response[2] = hsuntime.percentToMinutes(SunTime.set)

  hsettings.setSuntimeRise(SunTime.rise)
  hsettings.setSuntime2(SunTime.set)

  -- print(SunTime.rise, SunTime.set, SunTime.set_civil) -- or similar see calculateTime()
  -- print(hsuntime.percentToMinutes(SunTime.set))
  -- print(response[1])

  return response[1] .. ',' .. response[2];
end

function hsuntime.errorFct()
  print('error hsuntime')
end

function hsuntime.tryCalculateRiseAndSet(coordinates)
  status, ret = pcall(hsuntime.calculateRiseAndSet, coordinates)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end

-- hsuntime.calculateRiseAndSet()

return hsuntime
