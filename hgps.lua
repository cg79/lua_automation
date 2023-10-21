
local hfile = require 'hfile'
local htime = require 'htime'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'

local hgps = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'GPS methods',
}
  
function hgps.test()
  print("hgps merge")
end

function hgps.errorFct()
  print('error gps')
end

function hgps.executeGetGpsCoordinates()
  local gps_reouter = hexecute.execute('gpsgpsclt -h')
  return gps_reouter
end


function hgps.tryExecuteGetGPS() 
  status, ret = xpcall(hgps.executeGetGpsCoordinates, hgps.errorFct)

  -- print(status)
  -- print ('ret  ')

  if(ret ~= nil) then 
    return ret
  else 
    return nil
  end
end


function hgps.tryGetGpsCoordinates()
  local gps_reouter = hgps.tryExecuteGetGPS()
  if (gps_reouter ~= nil) then
    hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.GPS_FILE, gps_reouter)
    return gps_reouter
  end
  return hgps.readCoordinatesFromFile()
end

function hgps.writeCoordinatesToFile(coordinates)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.GPS_FILE, coordinates)
end

function hgps.readCoordinatesFromFile()
    local fileContent = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.GPS_FILE) 
    return fileContent or '46.76775971140317,23.553090097696654';
end

function hgps.getGpsTime()
  local response = hexecute.execute('gpsgpsclt -h')
  return response
end

function hgps.tryGetGpsTime() 
  status, ret = xpcall(getGpsTime, hgps.errorFct)

  -- print(status)

  if(ret ~= nil) then 
    return ret
  else 
    return '0:0'
  end
end


-- print(hgps.tryExecuteGetGPS())

return hgps
  
  