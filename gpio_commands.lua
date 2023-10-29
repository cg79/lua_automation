local hstring = require 'hstring'
-- local hfile = require 'hfile'
local hlog = require 'hlog'
local htime = require 'htime'
local hsettings = require 'hsettings'
-- local hgps = require 'hgps'
-- local hsuntime = require 'hsuntime'
local hexecute = require 'hexecute'


local gpiocommands = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'GPIOr-related functions for lua',
}


function gpiocommands.test()
  print("gpiocommands merge")
end

function gpiocommands.startGPIO()
  local allowStartGPIO = gpiocommands.allowStartGPIO()

  if(allowStartGPIO == false) then
    hlog.logToFile('PREVENIRE PORNIRE');
    return
  end

  hlog.logToFile('SUNTIME - PORNIRE DOUT2');
  -- hexecute.execute('/sbin/gpio.sh set DOUT2')
  hexecute.execute("/sbin/gpio.sh set DOUT2 1")
end

function gpiocommands.tryStartGPIO()
  status, ret = pcall(gpiocommands.startGPIO)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end

function gpiocommands.allowStartGPIO()
  local barrier = hsettings.getBarrier();
  if (barrier == nil or barrier == '') then
    return true
  end

  local vals = hstring.splitBy(barrier, ',');
  local t1 = htime.createTimeFromHMS(vals[1]);
  local t2 = htime.createTimeFromHMS(vals[2]);
  local seconds1 = htime.getSeccondsUntilDate(t1)
  local seconds2 = htime.getSeccondsUntilDate(t2)
  print(seconds1 .. '   ' .. htime.secondsToHHMMSS(seconds1) .. ' b1')
  print(seconds2 .. '   ' .. htime.secondsToHHMMSS(seconds2) .. ' b2')

  if(seconds1 <0 and seconds2 < 0) then
    return true
  end

  if(seconds1 >0 and seconds2 > 0) then
    return true
  end

  return false;
end

function gpiocommands.allowStopGPIO()
  local barrier = hsettings.getBarrier();
  if (barrier == nil or barrier == '') then
    return true
  end

  local vals = hstring.splitBy(barrier, ',');
  local t1 = htime.createTimeFromHMS(vals[1]);
  local t2 = htime.createTimeFromHMS(vals[2]);
  local seconds1 = htime.getSeccondsUntilDate(t1)
  local seconds2 = htime.getSeccondsUntilDate(t2)
  print(seconds1 .. '   ' .. htime.secondsToHHMMSS(seconds1) .. ' b1')
  print(seconds2 .. '   ' .. htime.secondsToHHMMSS(seconds2) .. ' b2')

  if(seconds1 < 0 and seconds2 > 0) then
    return true
  end

  return false;
end



function gpiocommands.stopGPIO()
  local allowStopGPIO = gpiocommands.allowStopGPIO()

  if(allowStopGPIO == false) then
    hlog.logToFile('PREVENIRE OPRIRE');
    return
  end


  hlog.logToFile('SUNTIME - OPRIRE DOUT2');
  -- hexecute.execute('/sbin/gpio.sh clear DOUT2')
  hexecute.execute("/sbin/gpio.sh set DOUT2 0")
end

function gpiocommands.tryStopGPIO()
  status, ret = pcall(gpiocommands.stopGPIO)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end


return gpiocommands
