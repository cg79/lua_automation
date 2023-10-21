local hstring = require 'hstring'
local hfile = require 'hfile'
local hlog = require 'hlog'
local htime = require 'htime'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local hgps = require 'hgps'
local hsuntime = require 'hsuntime'
local hexecute = require 'hexecute'


local jugglerstart = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Juggler start functions for lua',
}


function jugglerstart.test()
  print("jugglerstart merge")
end





function jugglerstart.openDOUT2()
  local barrier = hsettings.getBarrier();
  if (barrier ~= nil) then
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
  hsistem.executeGeneric('/sbin/gpio.sh set DOUT2')
end

function jugglerstart.clearDOUT2()
  local barrier = hsettings.getBarrier();
  if (barrier ~= nil) then
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
  hsistem.executeGeneric('/sbin/gpio.sh clear DOUT2')
end

jugglerstart.openDOUT2()


return jugglerstart
