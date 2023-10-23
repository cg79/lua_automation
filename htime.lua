local hstring = require 'hstring'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'

local htime = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Time-related functions for lua',
}


function htime.test()
  print("htime merge")
end

function htime.dateToString(date)
  return os.date('%Y-%m-%d %H:%M:%S', date)
end

function htime.addSecondsToDate(time, seconds)
  time = time + seconds;
  return time;
end

function htime.getDateValues()
  return os.date("*t")

  -- https://www.lua.org/manual/5.4/manual.html#pdf-os.date
  -- year, month (1–12), day (1–31), hour (0–23), min (0–59), sec (0–61, due to leap seconds), wday (weekday, 1–7, Sunday is
  -- 1), yday (day of the year, 1–366), and isdst (daylight saving flag, a boolean)
end

function htime.getLogFileName(dateValues)
  local filePath = tostring(dateValues.year) ..
  '-' .. tostring(dateValues.month) .. '-' .. tostring(dateValues.day) .. '.txt'
  return filePath;
end

function htime.getLogFilePath(fileName)
  local dateValues = htime.getDateValues()
  -- print('fileName ', fileName)

  if (fileName == nil) then
    fileName = htime.getLogFileName(dateValues)
  end


  local filePath = hconstants.LOGS_DIRECTORY .. '/' .. fileName
  return filePath
end

function htime.createDateFromValues(year, month, day, hour, minute)
  return os.time({ year = 2001, month = 9, day = 11, hour = 13, minute = 46 })
end

function htime.createTimeFromHMSValues(hour, minute, second)
  local date = htime.getDateValues()
  -- print(date.hour .. ' - ' .. date.min)

  local response = os.time({ year = date.year, month = date.month, day = date.day, hour = hour, min = minute, sec =
  second })

  return response
end

function htime.createTimeFromHMS(hms)
  -- hms = '8:12:13'
  local splitTable = hstring.splitBy(hms, ':')

  return htime.createTimeFromHMSValues(splitTable[1], splitTable[2], splitTable[3])
end

function htime.dayOfTheYear()
  -- https://www.lua.org/manual/5.4/manual.html#pdf-os.date
  return os.date("*t").yday
end

function htime.localTime()
  return os.time()
end

function htime.getUTCLocalTime()
  return os.time(os.date('!*t'))
end

function htime.timeToString(time)
  local stamp = os.date("%H:%M:%S", time)
  return stamp;
end

function htime.getSeccondsUntilDate(t1)
  local seconds = os.difftime(t1, htime.localTime())
  return math.floor(seconds);
end

function htime.getPreviousDaysDate(x)
  local response = os.date("%Y-%m-%d",os.time()- x * 24*60*60)
  print(response)
  return response
end

function htime.getSeccondsUntilDateAsString(dateAsString)
  local t1 = htime.createTimeFromHMS(dateAsString)
  local seconds = os.difftime(t1, htime.localTime())
  return seconds;
end

function htime.secondsBetweenTwoTimeStamp(t1, t2)
  local seconds = (t2 - t1) / 1000;
  return seconds;
end

function htime.executeAfterXSecconds(seconds, func)
  hexecute.wait(seconds)
  func()
end

function htime.getSecondsUntil4AM()
  -- now = htime.localTime();
  local midnight = htime.createTimeFromHMS('23:59:00');
  local r1 = htime.getSeccondsUntilDate(midnight)

  -- print(r1)
  return r1 + 4 * 60 * 60;
end

function htime.timeAsString()
  return htime.timeToString(htime.localTime())
end

-- htime.getSecondsUntil4AM();


return htime
