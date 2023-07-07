
local hstring = require 'hstring'


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
   time= time + seconds;
  return time;
end

function htime.getDateValues()
  return os.date("*t")

  -- https://www.lua.org/manual/5.4/manual.html#pdf-os.date
  -- year, month (1–12), day (1–31), hour (0–23), min (0–59), sec (0–61, due to leap seconds), wday (weekday, 1–7, Sunday is 
  -- 1), yday (day of the year, 1–366), and isdst (daylight saving flag, a boolean)
end 

function htime.createDateFromValues(year, month, day, hour, minute)             
  return os.time({year=2001, month=9, day=11, hour=13, minute=46})
end

function htime.createTimeFromHMSValues(hour, minute, second)
  local date= htime.getDateValues()
  return os.time({year=date.year, month=date.month, day=date.day, hour=hour, min=minute, sec=second})
end

function htime.createTimeFromHMS(hms)
  -- hms = '8:12:13'
  local  splitTable = hstring.splitBy(hms, ':')
  
  return htime.createTimeFromHMSValues(splitTable[1],splitTable[2],splitTable[3])
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
 return seconds;                          
end
                                       

function htime.secondsBetweenTwoTimeStamp(t1,t2)
 local seconds = (t2-t1)/1000;            
 return seconds;                          
end                                       

function htime.executeAfterXSecconds(seconds, func)
 wait(seconds)
 func()
end  

function printtest() 
  print(timeToString(localTime()) .. " test")
end

-- print(timeToString(localTime()));

-- executeAfterXSecconds(2, printtest)

-- local after1Minute = addSecondsToDate(localTime(), 60)
-- print("after 60 sec " .. dateToString(after1Minute))

-- print("local time " .. dateToString(localTime()))

-- local newDate= createTimeFromHMS(12,00,00)
 
-- print("date as string " ..  dateToString(newDate))
-- print("asta merge bine? " .. getSeccondsUntilDate(newDate))
-- print("one minute " .. getSeccondsUntilDate(after1Minute))
-- print("UTC local time " .. timeToString(getUTCLocalTime()))

  
return htime
  
  