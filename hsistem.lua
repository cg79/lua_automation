
local hsettings = require 'hsettings'
local hschedulersave = require 'hschedulersave'
local hexecute = require 'hexecute'

local hsistem = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'String-related functions for lua',
}
  
  
function hsistem.test()
  print("hsistem merge")
end

function hsistem.getGPS()
  return 0,0
end


 


 function hsistem.executeAfterXSeconds(seconds, commandType, parameters)
  print("ok0=========== " .. seconds)
  hexecute.execute("sleep " .. seconds);
  -- print(commandType .. parameters)
 end


 function hsistem.executeSetCommand(name, value)
  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    hexecute.execute("/sbin/gpio.sh set DOUT2 " .. value)
    return
  end

  if (name == 'name') then
    hsettings.setName(value)
    return
  end

  if (name == 'phone') then
    hsettings.setPhoneNumber(value)
    return
  end

  if (name == 'region') then
    hsettings.setRegion(value)
    return
  end

  if (name == 'master') then
    hsettings.setIsMaster(value)
    return
  end

  if (name == 'clock') then
     local gsmTime = 'gsm time'
    -- seteaza mackintosh clock
    return
  end

  if (name == 'schedule') then
    hschedulersave.saveCommandsToDisc(value)
    return
  end

 end

 function hsistem.executeGetCommand(name)
  local response = ''

  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    response = hsistem.execute("/sbin/gpio.sh get DOUT2")
    return response
  end

  if (name == 'name') then
    response = hsettings.getName(value)
    return response;
  end

  if (name == 'phone') then
    response = hsettings.getPhoneNumber(value)
    return response;
  end

  if (name == 'region') then
    response = hsettings.getRegion(value)
    return response
  end

  if (name == 'master') then
    response = hsettings.getIsMaster(value)
    return response
  end

  if (name == 'time') then
    response = os.clock()
    return response
  end

  if (name == 'gsmtime') then
    response = 'gsm time'
    return response
  end

 end


 function hsistem.executeCommand(getOrSet, name, value)

  if (name == 'reboot') then
    hexecute.execute("reboot")
    return
  end

  if (name == 'download') then
    hexecute.execute("reboot")
    return
  end

  if(getOrSet == 'set') then
    hsistem.executeSetCommand(name, value)
    return
  end

  if(getOrSet == 'get') then
    hsistem.executeGetCommand(name)
    return
  end


 end

  
return hsistem
  
  