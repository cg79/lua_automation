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
local gpiocommands = require 'gpio_commands'

local hsistem = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'String-related functions for lua',
}


function hsistem.test()
  print("hsistem merge")
end

function hsistem.getGPS()
  return 0, 0
end

function hsistem.executeAfterXSeconds(seconds, commandType, parameters)
  print("executie dupa " .. seconds .. ' secunde')
  hexecute.tryExecute("sleep " .. seconds);

  print(commandType .. ' ' .. parameters)

  return hsistem.executeGeneric(commandType .. parameters)
end

function hsistem.executeGenericCommandAfterXSeconds(seconds, command)
  if (seconds < 0) then
    return
  end
  print("executie dupa " .. seconds)

  hexecute.tryExecute("sleep " .. seconds);

  print('command' .. ' ' .. command)

  return hsistem.executeGeneric(command)
end

function hsistem.executeFunctionAfterXSeconds(seconds, func)
  print("executie dupa " .. seconds)
  if (seconds < 0) then
    return
  end
  

  hexecute.tryExecute("sleep " .. seconds);

  return func()
end

function hsistem.logs(anlunazi)
  local fileName = htime.getLogFilePath(anlunazi)
  print('logs file: ' .. fileName)
  local response = hfile.readFile(fileName)

  response = hstring.replace(response, '{', '\n')
  response = hstring.replace(response, '}', '\n')
  -- response = hstring.replace(response, '\n', '#')

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
  -- response = hexecute.tryExecute("cat /sys/class/hwmon/hwmon0/device/in0_input")
  response = hfile.readFile('/sys/class/hwmon/hwmon0/device/in0_input')
  -- response = hexecute.tryExecute("ubus call ioman.gpio.din1 status")
  return response
end

-- https://community.teltonika-networks.com/33433/rut-955-battery-voltage-via-ssh
-- https://community.teltonika-networks.com/27473/what-command-read-input-voltage-rutx12-from-power-connector
function hsistem.tryExecuteGetVoltage()
  status, ret = xpcall(getVoltage, hsistem.errorFct)

  if (ret ~= nil) then
    return ret
  else
    return -1
  end
end

function hsistem.tryExecuteCommandFromServer(command)
  -- status, ret = pcall(executeCommandFromServer, command)
  status, ret = pcall(hsistem.executeCommandFromServer, command)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end

function hsistem.getIsStarted()
  response = hexecute.tryExecute("/sbin/gpio.sh get DOUT2")
  return response
end

function hsistem.tryExecuteGetIsStarted()
  status, ret = xpcall(hsistem.getIsStarted, hsistem.errorFct)

  if (ret ~= nil) then
    return ret
  else
    return -1
  end
end

function hsistem.getMemory()
  response = hexecute.tryExecute('top -l 1 | grep -E "^CPU|^Phys"')
  return response
end

function hsistem.tryExecuteGetMemory()
  status, ret = xpcall(hsistem.getMemory, hsistem.errorFct)
  -- print ('status')
  -- print (status)

  if (ret ~= nil) then
    return ret
  else
    return 0
  end
end

function hsistem.getSpace()
  response = hexecute.tryExecute('df -H')
  return response
end

function hsistem.tryExecuteGetSpace()
  status, ret = xpcall(hsistem.getSpace, hsistem.errorFct)
  -- print ('status')
  -- print (status)

  if (ret ~= nil) then
    return ret
  else
    return 0
  end
end

function hsistem.getSuntime()
  local val1 = hsettings.getSuntimeRise()
  local val2 = hsettings.getSuntime2()
  return val1 .. ',' .. val2;
end

function hsistem.executeGetCommand(name, value)
  print('execute GET ' .. name)
  local response = ''

  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    response = hsistem.tryExecuteGetIsStarted()
    return response
  end

  if (name == 'luav') then
    -- "gpio 1 sau 0"
    response = hexecute.tryExecute('lua -v')
    if (response ~= nil) then
      response = tostring(response)
    end
    return response
  end


  if (name == 'name') then
    response = hsettings.getName() or hstring.randomChars()
    return response;
  end

  if (name == 'voltage') then
    return hsistem.tryExecuteGetVoltage()
  end

  if (name == 'phone') then
    response = hsettings.getPhoneNumber() or 'phone'
    return response;
  end

  if (name == 'region') then
    response = hsettings.getRegion() or ''
    return response
  end

  if (name == 'gps') then
    response = hgps.readCoordinatesFromFile()
    return response
  end

  if (name == 'master') then
    response = hsettings.getIsMaster() or 0
    return response
  end

  if (name == 'time') then
    response = htime.timeAsString()
    return response
  end

  if (name == 'datetime') then
    -- response = hexecute.tryExecute("date")
    response = htime.date()
    return response
  end

  if (name == 'gsmtime') then
    response = hgsm.tryExecuteGetGSMTime()
    if (response ~= nil) then
      response = tostring(response)
    end

    return response
  end

  if (name == 'timezone') then
    -- "gpio 1 sau 0"
    -- response = hexecute.tryExecute("date + '%Z %z'")
    response = htime.timezone()
    if (response ~= nil) then
      response = tostring(response)
    end
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
    return hsistem.getSuntime()
  end

  if (name == 'all') then
    local guid = hsettings.deviceGuid()
    local name = hsistem.executeGetCommand('name')
    return hsistem.getAll(guid, name)
  end

  if (name == 'barrier') then
    print('exec barrier')
    local temp = hsettings.getBarrier()
    print(temp)
    return temp
  end

  if (name == 'logs') then
    return hsistem.logs(value)
  end

  if (name == 'firmware') then
    return hsistem.execute('cat /etc/version')
  end

  local routerValue = hexecute.tryExecute(name)
  return routerValue;
end

function hsistem.getAll(guid, name)
  local phone = hsistem.executeGetCommand('phone')
  local region = hsistem.executeGetCommand('region')
  local master = hsistem.executeGetCommand('master')
  local coordinates = hgps.tryGetGpsCoordinates();
  -- .executeGetCommand('gps')

  local started = hsistem.tryExecuteGetIsStarted()
  local voltage = hsistem.tryExecuteGetVoltage();

  local vsuntime = hsistem.getSuntime()

  local barrier = hsettings.getBarrier()
  local hour = hsistem.getHour()

  -- print(name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour);

  -- local whoStr = '{"commandtype":"who","name":"router1"}\n';
  local whoStr = guid .. '|' .. name .. '|' .. phone .. '|' .. region .. '|'
  whoStr = whoStr ..
  master .. '|' .. coordinates .. '|' .. started .. '|' .. voltage .. '|' .. vsuntime .. '|' .. barrier .. '|' .. hour

  return whoStr
end

function hsistem.createWhoJsonString(guid, name)
  local phone = hsistem.executeGetCommand('phone')
  local region = hsistem.executeGetCommand('region')
  local master = hsistem.executeGetCommand('master')

  local started = hsistem.tryExecuteGetIsStarted()
  local voltage = hsistem.tryExecuteGetVoltage();

  local coordinates = hgps.tryGetGpsCoordinates();
  print('coordinates ' .. coordinates)

  local vsuntime = hsuntime.tryCalculateRiseAndSet(coordinates)

  local barrier = hsettings.getBarrier()
  local hour = hsistem.getHour()

  print(name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour);

  -- local whoStr = '{"commandtype":"who","name":"router1"}\n';
  local whoStr = hjson.createWhoCommand(guid, name, phone, region, master, coordinates, started, voltage, vsuntime,
    barrier,
    hour);

  return whoStr
end

function hsistem.executeSetCommand(name, value)
  if (name == 'gpio') then
    -- "gpio 1 sau 0"
    -- hexecute.tryExecute("/sbin/gpio.sh set DOUT2 " .. value)

    if (value == 1) then
      gpiocommands.tryStartGPIO()
    else
      gpiocommands.tryStopGPIO()
    end
    response = hsistem.tryExecuteGetIsStarted()

    if (response == -1) then
      response = value
    end
    return response
  end

  -- if (name == 'timezone') then
  --   -- "gpio 1 sau 0"
  --   hexecute.tryExecute("/sbin/gpio.sh set DOUT2 " .. value)
  --   return
  -- end

  if (name == 'name') then
    hsettings.setName(value)
    return hsettings.getName();
  end

  if (name == 'phone') then
    hsettings.setPhoneNumber(value)
    return hsettings.getPhoneNumber();
  end

  if (name == 'region') then
    hsettings.setRegion(value)
    return
  end

  if (name == 'master') then
    hsettings.setIsMaster(value)
    return
  end

  if (name == 'datetime') then
    -- date -s '2024-12-25 12:34:07'
    hexecute.tryExecute("date -s " .. "'" .. value .. "'")
    -- todo seteaza mackintosh clock
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

  if (name == 'suntime') then
    print(value)
    hsistem.updatesuntime(value)
    return
  end


  if (name == 'barrier') then
    print(value)
    hsistem.updatebarrier(value)
    return hsettings.getBarrier()
  end

  if (name == 'firmware') then
    hexecute.tryExecute('sysupgrade /tmp/RUT9XX_R_00.05.00.5_WEBUI.bin')
    return
  end

  return 'WARNING: command ' .. name .. ' is not implemented'
end

function hsistem.reboot()
  hexecute.tryExecute("reboot")
end

function hsistem.executeGeneric(command)
  return hexecute.tryExecute(command)
end

function hsistem.executeGpio(command)
  local space = " ";
  local command = "/sbin/gpio.sh" .. space .. command;

  return hexecute.tryExecute(command);
end

function hsistem.updatesettings(command)
  local vals = hstring.splitBy(command, '|')

  hsistem.executeSetCommand('name', vals[1])
  hsistem.executeSetCommand('phone', vals[2])
  hsistem.executeSetCommand('master', vals[3])
  hsistem.executeSetCommand('region', vals[4])
  if (vals[5] ~= '') then
    print('update coordinates ' .. vals[5])
    hsistem.executeSetCommand('gps', vals[5])
  end
end

function hsistem.updategps(command)
  hsistem.executeSetCommand('gps', command)
end

function hsistem.updatesuntime(suntimeValues)
  local arr = hstring.splitBy(suntimeValues, ',')
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
  return vals;
end

function hsistem.executeCommandFromServer(command)
  if (command == nil) then
    print("command is nil. wtf? ");
    return
  end

  print('executeCommandFromServer ' .. command)

  local cmdtypeandcmd = hstring.splitBy(command, '>')
  local cmdtype       = cmdtypeandcmd[1];
  local command       = cmdtypeandcmd[2];
  -- local responsePropName = cmdtypeandcmd[3];
  print(cmdtype);

  if (cmdtype == 'reboot') then
    hsistem.reboot()
    return nil
  end

  if (cmdtype == 'ping') then
    return hsistem.createKeyValueResponse('ping', 'pong');
  end

  if (cmdtype == 'generic') then
    response = hsistem.executeGeneric(command)
    if (response == nil) then
      return nil
    end
    return hsistem.createKeyValueResponse('generic', response);
  end

  if (cmdtype == 'gpio') then
    response = hsistem.executeGpio(command)
    if (response == nil) then
      return nil
    end
    return hsistem.createKeyValueResponse('gpio', response);
  end

  if (cmdtype == 'fotocell') then
    response = hsistem.executeGpio(command)
    if (response == nil) then
      return nil
    end
    return hsistem.createKeyValueResponse('fotocell', response);
  end

  if (cmdtype == 'modbus') then
    -- hsistem.executeGpio(command)
    -- execute the modbus command
    return
  end

  if (cmdtype == 'updatesettings') then
    hsistem.updatesettings(command)
    return nil;
  end

  if (cmdtype == 'updatesuntime') then
    hsistem.updatesuntime(command)
    return nil;
  end

  if (cmdtype == 'updatebarrier') then
    hsistem.updatebarrier(command)
    return nil;
  end


  if (cmdtype == 'updategps') then
    hsistem.updategps(command)
    return nil;
  end

  if (cmdtype == 'logs') then
    return hsistem.logs(command)
  end

  if (cmdtype == 'get') then
    vals = hstring.splitBy(command, '|')
    response = hsistem.executeGetCommand(vals[1], vals[2])
    if (response == nil) then
      return nil
    end
    propName = vals[2] or 'get'
    return hsistem.createKeyValueResponse(propName, response);
  end

  if (cmdtype == 'set') then
    -- set:name,ion
    print('set command: ' .. command)
    setValues = hstring.splitBy(command, '|')
    response = hsistem.executeSetCommand(setValues[1], setValues[2])
    if (response == nil) then
      return nil
    end
    propName = setValues[3] or 'set'
    return hsistem.createKeyValueResponse(propName, response);
  end

  if (name == 'download') then
    hdownload.start()
    hsistem.reboot()
    return
  end
end

function hsistem.getHour()
  local response = htime.timeAsString() .. ',' .. hgsm.tryExecuteGetGSMTime() .. ',' .. hgps.tryGetGpsTime()
  return response
end

--  print(hsistem.getHour())

return hsistem
