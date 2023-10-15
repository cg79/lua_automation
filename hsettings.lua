
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
  return response
end

function hsettings.setPhoneNumber(phone)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_PHONE, phone)
end

function hsettings.getPhoneNumber()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_PHONE)
  return response
end

function hsettings.setRegion(region)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_REGION, region)
end

function hsettings.getRegion()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_REGION)
  return response
end

function hsettings.setSuntimeRise(value)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_SUNTIME1, value)
end

function hsettings.getSuntimeRise()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_SUNTIME1)
  return response
end

function hsettings.getSuntime2()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_SUNTIME2)
  return response
end

function hsettings.setSuntime2(value)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_SUNTIME2, value)
end

function hsettings.getBarrier()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_BARRIER)
  return response or ''
end

function hsettings.setBarrier(value)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_BARRIER, value)
end


function hsettings.setIsMaster(region)
  hfile.writeToFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_MASTER, region)
end

function hsettings.getIsMaster()
  local response = hfile.readFile(hconstants.SETTINGS_DIRECTORY .. '/' .. hconstants.FILE_MASTER)
  return response
end


return hsettings
  
  