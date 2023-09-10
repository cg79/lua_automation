
local hsettings = require 'hsettings'
local hschedulersave = require 'hschedulersave'
local hexecute = require 'hexecute'
local hgps = require 'hgps'
local hstring = require 'hstring'

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

  if (name == 'gps') then
    hgps.writeCoordinatesToFile(value)
    return
  end

  if (name == 'sms') then
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
    response = hsettings.getName(value) or 'name'
    return response;
  end

  if (name == 'phone') then
    response = hsettings.getPhoneNumber(value) or 'phone'
    return response;
  end

  if (name == 'region') then
    response = hsettings.getRegion(value) or '-'
    return response
  end

  if (name == 'gps') then
    response = hgps.readCoordinatesFromFile() 
    return response
  end

  if (name == 'master') then
    response = hsettings.getIsMaster(value) or 0
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

  if (name == 'memory') then
    response = 'os memory'
    return response
  end

 end


 function hsistem.executeCommand(getOrSet, name, value)
  if (name == 'reboot') then
    hexecute.execute("reboot")
    return
  end

  if (name == 'download') then
    hexecute.execute("download")
    return
  end

  if (name == 'firmware') then
    hexecute.execute("firmware")
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


 function hsistem.reboot()
  hexecute.execute("reboot")
 end

 function hsistem.executeGpio(command)
  local space = " ";
    local command = "/sbin/gpio.sh" .. space .. command;     

    hexecute.execute(command);
 end

 function hsistem.updatesettings(command)
  local vals = hstring.splitBy(command, '|')
  
  hsistem.executeSetCommand('name', vals[1])
  hsistem.executeSetCommand('phone', vals[2])
  hsistem.executeSetCommand('master', vals[3])
  hsistem.executeSetCommand('region', vals[4])
  if(vals[5] ~= '') then
    hsistem.executeSetCommand('coordinates', vals[5])
  end
 end

 function hsistem.updategps(command)
    hsistem.executeSetCommand('gps', command)
 end


 function hsistem.executeCommandFromServer(command)
  if(command == nil) then
    print("command is nil. wtf? ");  
  end
  print(command);     

  local cmdtypeandcmd  = hstring.splitBy(command, ':')
  local cmdtype = cmdtypeandcmd[1];
  local command = cmdtypeandcmd[2];
  print(cmdtype);

  if (cmdtype == 'reboot') then
    hsistem.reboot()
    return
  end

  if (cmdtype == 'ping') then
    return 'pong'
  end

    -- local routerValueMessage = '{"commandtype":"valuefromrouter","name":"router1", "value":1}\n';
    -- tcp:send(routerValueMessage);

  if (cmdtype == 'gpio') then
    hsistem.executeGpio(command)
    return
  end

  if (cmdtype == 'fotocell') then
    hsistem.executeGpio(command)
    return
  end

  if (cmdtype == 'modbus') then
    -- hsistem.executeGpio(command)
    -- execute the modbus command
    return
  end

  if(cmdtype == 'updatesettings') then
    hsistem.updatesettings(command)
    return
  end

  if(cmdtype == 'gps') then
    hsistem.updategps(command)
    return
  end
  


 end

--  function hsistem.executeCommandFromServer(command)
--   if(command == nil) then
--     print("command is nil. wtf? ");  
--   end
--   print(command);     

--   local array  = hstring.splitBy(command, ' ')
--   local action = array[1];
--   print(action .. 'x');

--   if (action == 'reboot') then
--     print('comanda de reboot');
--     hexecute.execute(action);
--   else

--     -- local routerValueMessage = '{"commandtype":"valuefromrouter","name":"router1", "value":1}\n';
--     -- tcp:send(routerValueMessage);

--     local space = " ";
--     local command = "/sbin/gpio.sh" .. space .. command;     

--     hexecute.execute(command);
--   end


--  end

  
return hsistem
  
  