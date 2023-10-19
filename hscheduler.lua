local hstring = require 'hstring'
local hfile = require 'hfile'
local hlog = require 'hlog'
local htime = require 'htime'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local hgps = require 'hgps'
local hsuntime = require 'hsuntime'
local hexecute = require 'hexecute'


local hscheduler = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'Scheduler-related functions for lua',
    __DIRECTORY = './h_schedules'
  }
  
  
function hscheduler.test()
  print("hscheduler merge")
end

function hscheduler.stringCommandAsObject(command) 
-- [8:12:3,1,1]
  local  splitTable = hstring.splitBy(command, ',')

  -- for i=1,#(splitTable) do
    -- print(splitTable[i])
  -- end

  local time = htime.createTimeFromHMS(splitTable[1])
  local commandType = splitTable[2]
  local parameters = splitTable[3]

  local response = {
    time = time,
    commandType = commandType,
    parameters = parameters
  }

  -- print(response.time .. ' - ' .. response.commandType .. ' - ' .. response.parameters or 'x')
  return response;

end

function hscheduler.createGenericObjectCommand(command) 
  -- 8:12:3,/sbin/gpio.sh set DOUT2
    local  splitTable = hstring.splitBy(command, ',')
  
    -- for i=1,#(splitTable) do
      -- print(splitTable[i])
    -- end
  
    print(splitTable[1])
    local time = htime.createTimeFromHMS(splitTable[1])
    local command = splitTable[2]
  
    local response = {
      time = time,
      command = command,
    }
  
    -- print(response.time .. ' - ' .. response.command)
    return response;
  
  end

function createAnArrayOfObjectsFromADailyCommand(input)
  -- {72,[8:12:3,1,1],[8:15:3,1,0]}
  local arr = {}
  local dayValue = 0;
  local obj = nil


  for capture in string.gmatch(input, "%[(.-)%]") do
         print('capture: ' .. capture)
         obj = hscheduler.stringCommandAsObject(capture)

    table.insert(arr, obj)
  end
  
  -- for k, v in pairs(arr) do
  --     print(k,v)
  -- end

  return arr
end

function getSchedulerFileName(dayIndex)
  return hscheduler.__DIRECTORY  .. '/' .. dayIndex
end


function hscheduler.getCommandsForDay(dayNo)
  local fileName = ''
  local fileExists = false
  local dayIndex = dayNo
  while (dayIndex > 0) do
    fileName = getSchedulerFileName(dayIndex)
   
    fileExists = hfile.exists(fileName)
    -- print(fileName,  fileExists)
    if  fileExists then
      return hfile.readFile(fileName)
    end
    dayIndex = dayIndex -1
  end
  return nil
end

function hscheduler.executeObjectCommand(obj)
  local afterHowManySeconds = htime.getSeccondsUntilDate(obj.time)
  hsistem.executeAfterXSeconds(afterHowManySeconds, obj.commandType, obj.parameters)
  -- if index < #arr then
  -- end
end


function hscheduler.scheduleObjects(arr)
  hscheduler.executeObjectCommand(arr[1])
end

function hscheduler.loadCommandsForDay(dayNo)
  local commandsFromFile = hscheduler.getCommandsForDay(dayNo)
  print('commandsFromFile: ' .. commandsFromFile)

  if(commandsFromFile ~= nil) then
    local commandsArray = createAnArrayOfObjectsFromADailyCommand(commandsFromFile)
    hscheduler.scheduleObjects(commandsArray)
  end
end


function hscheduler.startOld()
  local dayOfYear = htime.dayOfTheYear()

  hscheduler.loadCommandsForDay(dayOfYear)
end

function hscheduler.gpsAndSuntimeAndScheduler()
  -- scrie coordonatele gps in fisier
  hgps.tryGetGpsCoordinates();

  -- citeste coordonatele GPS din fisier
  local gpsCoordinates = hgps.readCoordinatesFromFile()
  -- latitude, longitude 

  print('gpsCoordinates: ' .. gpsCoordinates)

  local latitudeLongitude = hstring.splitBy(gpsCoordinates, ',')

  local suntime = hsuntime.calculateRiseAndSet(latitudeLongitude[1], latitudeLongitude[2])

  -- hsettings.setSuntimeRise(suntime[1])
  -- hsettings.setSuntime2(suntime[2])

  -- hsettings.setSuntimeRise('13:25')
  -- hsettings.setSuntime2('13:26')


  print(suntime[1])
  print(suntime[2])

end

function hscheduler.openDOUT2()
  barrier = hsettings.getBarrier();
  if(barrier ~= nil) then
    -- verificare daca este permisa executia gpio
    vals = hstring.splitBy(barrier, ',');
    t1 = htime.createTimeFromHMS(vals[1]);

    seconds = htime.getSeccondsUntilDate(t1)
    if(seconds < 0) then
      hlog.logToFile('!!! incercare de pornire DOUT2 !!!');
      return;
    end
  end

  hsistem.executeGeneric('/sbin/gpio.sh set DOUT2')
end

function hscheduler.clearDOUT2()
  barrier = hsettings.getBarrier();
  if(barrier ~= nil) then
    -- verificare daca este permisa executia gpio
    vals = hstring.splitBy(barrier, ',');
    t1 = htime.createTimeFromHMS(vals[2]);

    seconds = htime.getSeccondsUntilDate(t1)
    if(seconds > 0) then
      hlog.logToFile('!!! incercare de oprire DOUT2 !!!');
      return;
    end
  end
  hsistem.executeGeneric('/sbin/gpio.sh clear DOUT2')
end


function hscheduler.sheduleCommand(command, func)
  if command == nil then
    command = '13:10:1,/sbin/gpio.sh set DOUT2'
  end

  obj = hscheduler.createGenericObjectCommand(command)
  afterHowManySeconds = htime.getSeccondsUntilDate(obj.time)

  if(afterHowManySeconds < 0) then 
    print('afterHowManySeconds < 0')
    return
  end
  
  hsistem.executeFunctionAfterXSeconds(afterHowManySeconds, func)

  hexecute.execute('lua hscheduler.lua &')
end


function hscheduler.start()

  hscheduler.gpsAndSuntimeAndScheduler()

  time1 = hsettings.getSuntimeRise()
  time2 = hsettings.getSuntime2()

  command1 = time1 .. ',/sbin/gpio.sh set DOUT2'
  command2 = time2 .. ',/sbin/gpio.sh clear DOUT2'

  hscheduler.sheduleCommand(command1, openDOUT2);
  hexecute.execute('lua tcp_sender.lua & ')


  hscheduler.sheduleCommand(command2, clearDOUT2);
  hexecute.execute('lua tcp_sender.lua & ')

  until4AM = htime.getSecondsUntil4AM();
  hexecute.wait(until4AM);

  hscheduler.start()
end

hscheduler.start()

  
return hscheduler
  
  