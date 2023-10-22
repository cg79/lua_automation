
local hsettings = require 'hsettings'
local hschedulersave = require 'hschedulersave'
local hexecute = require 'hexecute'
local hgps = require 'hgps'
local hstring = require 'hstring'
local hdownload = require 'hdownload'
local hfile = require 'hfile'
local hgsm = require 'hgsm'
local htime = require 'htime'
local hsuntime = require('hsuntime')
local hjson = require 'hjson'

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
  if(seconds <0) then
    return
  end
  print("executie dupa " .. seconds)
  
  hexecute.execute("sleep " .. seconds);

  print('command' .. ' ' ..  command)

  return hsistem.executeGeneric(command)
 end

 function hsistem.executeFunctionAfterXSeconds(seconds, func)
  if(seconds <0) then
    return
  end
  print("executie dupa " .. seconds)
  
  hexecute.execute("sleep " .. seconds);

  return func()
 end

 function hsistem.logs(anlunazi)
    local fileName = htime.getLogFilePath(anlunazi)
    print('logs file: ' .. fileName)
    local response = hfile.readFile(fileName)

    response = hstring.replace(response,'{', '[')
    response = hstring.replace(response,'}', ']')
    response = hstring.replace(response,'\n', '#')

    return response
 end


 function hsistem.errorFct()
  -- //log
  print('error dout')
 end


 function hsistem.errorVoltage()
  -- //log
   print('error v')
 end

function getVoltage()
  -- response = hexecute.execute("cat /sys/class/hwmon/hwmon0/device/in0_input")
  response = hfile.readFile('/sys/class/hwmon/hwmon0/device/in0_input')
  -- response = hexecute.execute("ubus call ioman.gpio.din1 status")
  return response
end

-- https://community.teltonika-networks.com/33433/rut-955-battery-voltage-via-ssh
-- https://community.teltonika-networks.com/27473/what-command-read-input-voltage-rutx12-from-power-connector
function hsistem.tryExecuteGetVoltage() 
  status, ret = xpcall(getVoltage, hsistem.errorFct)

  if(ret ~= nil) then 
    return ret
  else 
    return -1
  end
end


function hsistem.tryExecuteCommandFromServer(command)
  -- status, ret = pcall(executeCommandFromServer, command)
  status, ret = pcall(hsistem.executeCommandFromServer, command)

  if(status ~= false and ret ~= nil) then 
    return ret
  else 
    return nil
  end
end

function hsistem.getIsStarted()
  response = hexecute.execute("/sbin/gpio.sh get DOUT2")
  return response
end

function hsistem.tryExecuteGetIsStarted() 
  status, ret = xpcall(hsistem.getIsStarted, hsistem.errorFct)
  
    if(ret ~= nil) then 
      return ret
    else 
      return -1
    end
end

function hsistem.getMemory()
  response = hexecute.execute('top -l 1 | grep -E "^CPU|^Phys"')
  return response
end

function hsistem.tryExecuteGetMemory() 
  status, ret = xpcall(hsistem.getMemory, hsistem.errorFct)
    -- print ('status')
    -- print (status)
  
    if(ret ~= nil) then 
      return ret
    else 
      return 0
    end
end


function hsistem.getSpace()
  response = hexecute.execute('df -H')
  return response
end

function hsistem.tryExecuteGetSpace() 
  status, ret = xpcall(hsistem.getSpace, hsistem.errorFct)
    -- print ('status')
    -- print (status)
  
    if(ret ~= nil) then 
      return ret
    else 
      return 0
    end
end


 function hsistem.executeGetCommand(name, value)
  print('execute GET ' .. name)
  local response = ''

  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    response = hsistem.tryExecuteGetIsStarted()
    return response
  end

  if (name == 'name') then
    response = hsettings.getName(value) or 'name'
    return response;
  end

  if (name == 'voltage') then
    return hsistem.tryExecuteGetVoltage() 
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
    response = hexecute.execute("date +%T")
    return response
  end

  if (name == 'datetime') then
    response = hexecute.execute("date")
    return response
  end

  if (name == 'gsmtime') then
    response = hgsm.tryExecuteGetGSMTime() 
    return response
  end

  if (name == 'version') then
    response = hsettings.getSoftVersion()
    return response
  end

  if (name == 'memory') then
    response = hsistem.tryExecuteGetMemory()
    return response
  end 

  if (name == 'space') then
    response = hsistem.tryExecuteGetSpace()
    return response
  end 

  if (name == 'suntime') then
    val1 =  hsettings.getSuntimeRise()
    val2 =  hsettings.getSuntime2()
    return val1 .. ',' .. val2;
  end

  if (name == 'all') then
    local id = hsettings.deviceId()
    local name = hsistem.executeGetCommand('name')
    return hsistem.getAll(id, name)
  end

  if (name == 'barrier') then
    print('exec barrier')
    local temp = hsettings.getBarrier()
    print(temp)
    return temp
  end

  if(name == 'logs') then
    return hsistem.logs(value)
  end

 end



 function hsistem.getAll(id, name)
  local phone = hsistem.executeGetCommand('phone')
  local region = hsistem.executeGetCommand('region')
  local master = hsistem.executeGetCommand('master')
  local coordinates = hgps.tryGetGpsCoordinates();
  -- .executeGetCommand('gps')
  
  local started = hsistem.tryExecuteGetIsStarted()
  local voltage = hsistem.tryExecuteGetVoltage();
  
  local latitudeLongitude = hstring.splitBy(coordinates, ',')
  local suntime = hsuntime.calculateRiseAndSet(latitudeLongitude[1], latitudeLongitude[2])
  hsettings.setSuntimeRise(suntime[1])
  hsettings.setSuntime2(suntime[2])
  -- print('suntime')
  -- print(suntime)
  local vsuntime = suntime[1] .. ',' .. suntime[2]
  
  local barrier = hsettings.getBarrier()
  local hour = hsistem.getHour()
  
  -- print(name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour);
  
  -- local whoStr = '{"commandtype":"who","name":"router1"}\n';
  local whoStr = id .. '|' .. name .. '|' .. phone.. '|' .. region.. '|' .. master.. '|' .. coordinates .. '|' .. started.. '|' .. voltage .. '|' .. vsuntime .. '|' .. barrier.. '|' .. hour

  return whoStr
end

 function hsistem.createWhoJsonString(id, name)
  local phone = hsistem.executeGetCommand('phone')
  local region = hsistem.executeGetCommand('region')
  local master = hsistem.executeGetCommand('master')
  local coordinates = hgps.tryGetGpsCoordinates();
  print('coordinates ' .. coordinates)

  
  
  local started = hsistem.tryExecuteGetIsStarted()
  local voltage = hsistem.tryExecuteGetVoltage();
  
  

  local latitudeLongitude = hstring.splitBy(coordinates, ',')
  local suntime = hsuntime.calculateRiseAndSet(latitudeLongitude[1], latitudeLongitude[2])
  hsettings.setSuntimeRise(suntime[1])
  hsettings.setSuntime2(suntime[2])
  -- print('suntime')
  -- print(suntime)
  local vsuntime = suntime[1] .. ',' .. suntime[2]
  
  print('b')

  local barrier = hsettings.getBarrier()
  local hour = hsistem.getHour()
  
  print(name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour);
  
  -- local whoStr = '{"commandtype":"who","name":"router1"}\n';
  local whoStr = hjson.createWhoCommand(id, name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour  );

  return whoStr
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

  -- if (name == 'sms') then
  --   return
  -- end

  if(name == 'suntime') then
    print(value)
    hsistem.updatesuntime(value)
  end


  if(name == 'barrier') then
    print(value)
    hsistem.updatebarrier(value)
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
  
  print('executeCommandFromServer ' .. command)

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


  if(cmdtype == 'updategps') then
    hsistem.updategps(command)
    return nil;
  end

  if(cmdtype == 'logs') then
    return hsistem.logs(command)
  end

  if(cmdtype == 'get') then
    vals = hstring.splitBy(command, '|')
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

 
 function hsistem.getHour() 
  local response = htime.timeAsString() .. ',' .. hgsm.tryExecuteGetGSMTime()  .. ',' .. hgps.tryGetGpsTime()
  return response
 end

--  print(hsistem.getHour())

return hsistem
  
  