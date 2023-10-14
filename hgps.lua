
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

function hgps.executeGetGpsCoordinates()
  local gps_reouter = hexecute.execute('gpsgpsclt -h')
  return gps_reouter
end


function hgps.getGpsCoordinates()
  local gps_reouter = hgps.executeGetGpsCoordinates()
  if (gps_reouter ~= nil) then
    hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.GPS_FILE, gps_reouter)
  end
  return gps_reouter
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

return hgps
  
  