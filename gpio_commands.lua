local hstring = require 'hstring'
-- local hfile = require 'hfile'
local hlog = require 'hlog'
local htime = require 'htime'
local hsistem = require 'hsistem'
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


function gpiocommands.openDOUT2()
  local barrier = hsettings.getBarrier();

  hlog.logToFile('executie open DOUT2 ' .. barrier)
  if (barrier ~= nil and barrier ~= '') then
    
    -- verificare daca este permisa executia gpio
    local vals = hstring.splitBy(barrier, ',');
    local t1 = htime.createTimeFromHMS(vals[1]);

    local seconds = htime.getSeccondsUntilDate(t1)
    if (seconds < 0) then
      hlog.logToFile('!!! incercare de pornire DOUT2 !!!');
      return;
    end
  end

  hlog.logToFile('SUNTIME - PORNIRE DOUT2');
  hexecute.execute('/sbin/gpio.sh set DOUT2')
end

function gpiocommands.tryopenDOUT2()
  status, ret = pcall(gpiocommands.openDOUT2)

  if(status ~= false and ret ~= nil) then 
    return ret
  else 
    return nil
  end
end

function gpiocommands.clearDOUT2()
  local barrier = hsettings.getBarrier();
  if (barrier ~= nil and barrier ~= '') then
    -- verificare daca este permisa executia gpio
    local vals = hstring.splitBy(barrier, ',');
    local t1 = htime.createTimeFromHMS(vals[2]);

    local seconds = htime.getSeccondsUntilDate(t1)
    if (seconds > 0) then
      hlog.logToFile('!!! incercare de oprire DOUT2 !!!');
      return;
    end
  end

  hlog.logToFile('SUNTIME - OPRIRE DOUT2');
  hexecute.execute('/sbin/gpio.sh clear DOUT2')
end

function gpiocommands.tryclearDOUT2()
  status, ret = pcall(gpiocommands.clearDOUT2)

  if(status ~= false and ret ~= nil) then 
    return ret
  else 
    return nil
  end
end


return gpiocommands
