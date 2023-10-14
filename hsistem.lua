
local hsettings = require 'hsettings'
local hschedulersave = require 'hschedulersave'
local hexecute = require 'hexecute'
local hgps = require 'hgps'
local hstring = require 'hstring'
local hdownload = require 'hdownload'
local hfile = require 'hfile'

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
  print("executie dupa " .. seconds .. ' secunde')
  hexecute.execute("sleep " .. seconds);

  print(commandType .. ' ' ..  parameters)

  return hsistem.executeGeneric(command)
 end

 function hsistem.executeGenericCommandAfterXSeconds(seconds, command)
  print("executie dupa " .. seconds)
  
  hexecute.execute("sleep " .. seconds);

  print('command' .. ' ' ..  command)

  return hsistem.executeGeneric(command)
 end

 function hsistem.executeFunctionAfterXSeconds(seconds, func)
  print("executie dupa " .. seconds)
  
  hexecute.execute("sleep " .. seconds);

  return func()
 end

 function hsistem.logs(anlunazi)
    anlunazi = htime.getLogFilePath(anlunazi)
    response = hfile.readFile(anlunazi)

    return response
 end

 function hsistem.executeGetCommand(name, value)
  local response = ''

  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    
    response = hexecute.execute("/sbin/gpio.sh get DOUT2")
    -- print(response)
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

  if (name == 'suntime') then
    val1 =  hsettings.getSuntimeRise()
    val2 =  hsettings.getSuntime2()
    return val1 .. ',' .. val2;
  end

  if (name == 'barrier') then
    return hsettings.getBarrier()
  end

  if (name == 'logs') then
    return hsistem.logs(value)
  end

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

  if(name == 'suntime') then
    print(value)
    hsistem.updatesuntime(value)
  end


  if(name == 'barrier') then
    print(value)
    hsistem.updatebarrier(value)
  end
  


 end


 function hsistem.executeCommand(getOrSet, name, value)
  if (name == 'reboot') then
    hexecute.execute("reboot")
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

 function hsistem.executeGeneric(command)
  return hexecute.execute(command)
 end

 function hsistem.executeGpio(command)
  local space = " ";
  local command = "/sbin/gpio.sh" .. space .. command;     

  return hexecute.execute(command);
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

 function hsistem.updatesuntime(suntimeValues)
  arr = hstring.splitBy(suntimeValues, ',')
  hsettings.setSuntimeRise(arr[1])
  hsettings.setSuntime2(arr[2])

  hsistem.executeCommandFromServer('reboot');
 end

 function hsistem.updatebarrier(barrier)
  -- 9:0:0,18:0:0
  -- arr = hstring.splitBy(suntimeValues, ',')
  hsettings.setBarrier(barrier)
 end
 


 function hsistem.createKeyValueResponse(key, value)
    vals = {}
    vals[1] = key
    vals[2] = value
    return  vals;
 end


 function hsistem.executeCommandFromServer(command)
  if(command == nil) then
    print("command is nil. wtf? ");
    return
  end
  
  print(command);     

  local cmdtypeandcmd  = hstring.splitBy(command, ':')
  local cmdtype = cmdtypeandcmd[1];
  local command = cmdtypeandcmd[2];
  print(cmdtype);

  if (cmdtype == 'reboot') then
    hsistem.reboot()
    return nil
  end

  if (cmdtype == 'ping') then
    return  hsistem.createKeyValueResponse('ping', 'pong');
  end

  if (cmdtype == 'generic') then
    response = hsistem.executeGeneric(command)
    if(response == nil) then
        return nil
    end
    return hsistem.createKeyValueResponse('generic', response);
  end

  if (cmdtype == 'gpio') then
    response = hsistem.executeGpio(command)
    if(response == nil) then
        return nil
    end
    return hsistem.createKeyValueResponse('gpio', response);
  end

  if (cmdtype == 'fotocell') then
    response = hsistem.executeGpio(command)
    if(response == nil) then
        return nil
    end
    return hsistem.createKeyValueResponse('fotocell', response);
  end

  if (cmdtype == 'modbus') then
    -- hsistem.executeGpio(command)
    -- execute the modbus command
    return
  end

  if(cmdtype == 'updatesettings') then
    hsistem.updatesettings(command)
    return nil;
  end

  if(cmdtype == 'updatesuntime') then
    hsistem.updatesuntime(command)
    return nil;
  end

  if(cmdtype == 'updatebarrier') then
    hsistem.updatebarrier(command)
    return nil;
  end


  if(cmdtype == 'gps') then
    hsistem.updategps(command)
    return nil;
  end

  if(cmdtype == 'get') then
    vals = hstring.splitBy(command, ',')
    response = hsistem.executeGetCommand(vals[1], vals[2])
    if(response == nil) then
        return nil
    end
    propName = vals[2] or 'get'
    return hsistem.createKeyValueResponse(propName, response);
  end

  if(cmdtype == 'set') then
    -- set:name,ion
    print('set command: ' .. command)
    setValues = hstring.splitBy(command, '|')
    response = hsistem.executeSetCommand(setValues[1], setValues[2])
    if(response == nil) then
        return nil
    end
    return hsistem.createKeyValueResponse('set', response);
  end

  if (name == 'download') then
    hdownload.start()
    hsistem.reboot()
    return
  end
  


 end

  
return hsistem
  
  