local hstring = require 'hstring'
local hfile = require 'hfile'
local hlog = require 'hlog'
local htime = require 'htime'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local hgps = require 'hgps'
local hsuntime = require 'hsuntime'
local hexecute = require 'hexecute'
local gpiocommands = require 'gpio_commands'


local hscheduler = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Scheduler-related functions for lua',
  __DIRECTORY   = './h_schedules'
}


function hscheduler.test()
  print("hscheduler merge")
end

function hscheduler.stringCommandAsObject(command)
  -- [8:12:3,1,1]
  local splitTable = hstring.splitBy(command, ',')

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
  local splitTable = hstring.splitBy(command, ',')

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
  return hscheduler.__DIRECTORY .. '/' .. dayIndex
end

function hscheduler.getCommandsForDay(dayNo)
  local fileName = ''
  local fileExists = false
  local dayIndex = dayNo
  while (dayIndex > 0) do
    fileName = getSchedulerFileName(dayIndex)

    fileExists = hfile.exists(fileName)
    -- print(fileName,  fileExists)
    if fileExists then
      return hfile.readFile(fileName)
    end
    dayIndex = dayIndex - 1
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

  if (commandsFromFile ~= nil) then
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

  hsettings.setSuntimeRise(suntime[1])
  hsettings.setSuntime2(suntime[2])

  -- hsettings.setSuntimeRise('13:25')
  -- hsettings.setSuntime2('13:26')


  print(suntime[1])
  print(suntime[2])
end


function hscheduler.testTime()

  -- local now = htime.timeToString()
  local now = htime.localTime()
  local nowPlus5Sec = htime.addSecondsToDate(now, 5)
  print(nowPlus5Sec)
  local sss = htime.getSeccondsUntilDate(nowPlus5Sec)
  print(sss)

  local test = htime.getSeccondsUntilDateAsString(htime.timeToString(nowPlus5Sec))
  print(test)
end

function hscheduler.start()

  hscheduler.gpsAndSuntimeAndScheduler()
  local time1 = hsettings.getSuntimeRise()
  local time2 = hsettings.getSuntime2()

  local now = htime.localTime()
  local nowPlus5Sec = htime.addSecondsToDate(now, 5)
  time1 = htime.timeToString(nowPlus5Sec)
  local nowPlus10Sec = htime.addSecondsToDate(now, 10)
  time2 = htime.timeToString(nowPlus10Sec)

  hlog.logToFile('SUNTIME - TIME1 ' .. time1);
  hlog.logToFile('SUNTIME - TIME2 ' .. time2);

  local sec1 = htime.getSeccondsUntilDateAsString(time1)
  local sec2 = htime.getSeccondsUntilDateAsString(time2)

  hsistem.executeFunctionAfterXSeconds(sec1, gpiocommands.tryopenDOUT2)
  hexecute.execute('lua tcp_sender.lua & ')

  hsistem.executeFunctionAfterXSeconds(sec2, gpiocommands.tryclearDOUT2)
  hexecute.execute('lua tcp_sender.lua & ')

  local until4AM = htime.getSecondsUntil4AM();
  print(until4AM)
  hlog.logToFile('SUNTIME - ASTEPTARE PANA la 4AM ' .. until4AM);
  hexecute.wait(until4AM);

  hscheduler.start()
end

hscheduler.start()


return hscheduler
