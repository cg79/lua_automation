
local hfile = require 'hfile'
local hconstants = require 'hconstants'


local hsettings = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'settings',
}
  
  
function hsettings.test()
  print("hsettings merge")
end

function hsettings.log(text)
  print(text)
end

function hsettings.deviceId()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_ID);
  if(response == nil) then
    response = hconstants.uuid()
    hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_ID, response)
  end
  
  return response
end

function hsettings.setName(name)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_NAME, name)
end

function hsettings.getName()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_NAME)
end

function hsettings.setPhoneNumber(phone)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_PHONE, phone)
end

function hsettings.getPhoneNumber()
  hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_PHONE)
end

function hsettings.setRegion(region)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_REGION, region)
end

function hsettings.getRegion()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_REGION)
end


function hsettings.setIsMaster(region)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_MASTER, region)
end

function hsettings.getIsMaster()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_MASTER)
end


return hsettings
  
  