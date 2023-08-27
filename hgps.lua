
local hfile = require 'hfile'
local htime = require 'htime'
local hsistem = require 'hsistem'
local hconstants = require 'hconstants'

local hgps = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'GPS methods',
}
  
  
function hgps.test()
  print("hgps merge")
end

function hgps.getGPSCoordinates()
  local gps_reouter = hsistem.getGPS()
  return gps_reouter
end


function hgps.writeCoordinatesToFile()
  local gps_reouter = hgps.getGPSCoordinates()
  if (gps_reouter ~= '0,0') then
    hfile.writeToFile(hconstants.GPS_FILE, gps_reouter) 
  end
end

function hgps.readCoordinatesFromFile()
    local fileContent = hfile.readFile(hconstants.GPS_FILE) 
    return fileContent;
end



return hgps
  
  