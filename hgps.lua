
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

function hgps.getGPSCoordinates()
  local gps_reouter = hexecute.execute('gps')
  return gps_reouter
end


function hgps.saveCoordinatesToFile()
  local gps_reouter = hgps.getGPSCoordinates()
  if (gps_reouter ~= '0,0') then
    hfile.writeToFile(hconstants.GPS_FILE, gps_reouter) 
  end
end

function hgps.writeCoordinatesToFile(coordinates)
  hfile.writeToFile(hconstants.GPS_FILE, coordinates) 
end

function hgps.readCoordinatesFromFile()
    local fileContent = hfile.readFile(hconstants.GPS_FILE) 
    return fileContent or '0';
end



return hgps
  
  