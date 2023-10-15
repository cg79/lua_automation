
local hlog = require 'hlog'
local hstring = require 'hstring'
local hjson = require 'hjson'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local socket = require("socket") 
local hgps = require('hgps')
local hsuntime = require('hsuntime')

-- local host = "7.tcp.eu.ngrok.io";
-- local port = 14456;
 
-- https://w3.impa.br/~diego/software/luasocket/introduction.html
-- https://web.tecgraf.puc-rio.br/luasocket/old/luasocket-1.0/

print(socket._VERSION)

function createWhoJsonString()
  local name = hsistem.executeGetCommand('name')
  local phone = hsistem.executeGetCommand('phone')
  local region = hsistem.executeGetCommand('region')
  local master = hsistem.executeGetCommand('master')
  local coordinates = hgps.tryGetGpsCoordinates();
  -- .executeGetCommand('gps')
  local id = hsettings.deviceId()
  local started = hsistem.tryExecuteGetIsStarted()
  local voltage = hsistem.tryExecuteGetVoltage();
  
  local latitudeLongitude = hstring.splitBy(coordinates, ',')
  local suntime = hsuntime.calculateRiseAndSet(latitudeLongitude[1], latitudeLongitude[2])
  -- print('suntime')
  -- print(suntime)
  local vsuntime = suntime[1] .. ',' .. suntime[2]
  
  local barrier = hsettings.getBarrier()
  local hour = hsistem.getHour()
  
  print(name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour);
  
  -- local whoStr = '{"commandtype":"who","name":"router1"}\n';
  local whoStr = hjson.createWhoCommand(id, name, phone, region, master, coordinates, started, voltage, vsuntime, barrier, hour  );

  return whoStr
end

local whoStr = createWhoJsonString()

local masterSocket = socket.tcp();
local tcp = assert(masterSocket)  
  -- local connection = nil;

function resetConnection()
  tcp:close();
  masterSocket = socket.tcp();
  tcp = assert(masterSocket)  
end

function connectToServer()
  print(hconstants.SERVER .. "," .. hconstants.PORT)
  
  local tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);

  print("AJUNGE AIIIIICI")
  -- print(masterSocket.getstats())
  -- print('status' .. connection.status)
  while (tempConnection == nil) do
    hexecute.wait(hconstants.RECCONNECT_DELAY);

    hlog.logToFile('TCP_CLIENT. Se incearca conexiunea la server');
    tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);
    print(tempConnection);
  end

  connection = tempConnection;
  
  hlog.logToFile('TCP_CLIENT. CONEXIUNE STABILITA');
  tcp:send(whoStr);

  -- hexecute.wait(hconstants.RECCONNECT_DELAY);
end

connectToServer();


function execute_gpio(command)
  print(command);     

  local array  = hstring.splitBy(command, ' ')
  local action = array[1];
  print(action .. 'x');

  if (action == 'reboot') then
    print('comanda de reboot');
    hexecute.execute(action);
  else

    local routerValueMessage = '{"commandtype":"valuefromrouter","name":"router1", "value":1}\n';
    tcp:send(routerValueMessage);

    local space = " ";
    local command = "/sbin/gpio.sh" .. space .. command;     

    hexecute.execute(command);
  end
end

-- local mcount = 0;
-- function monitor()
--  if mcount > 0 then 
--    return;
--  end

--  mcount = 0;
--  while mcount < 2 do
--   os.execute("sleep 5")
--   local resp = execute("/sbin/gpio.sh get DOUT2")
--   print(resp)
    
--   local whoStr = [[{"commandtype":"monitor","name":"router1", "value":"]] .. resp.. [["}]]
--   tcp:send(whoStr .. "\n");
--   mcount = mcount +1;
--  end 
--  mcount = 0;
-- end

 
-- ###################################
function receiveCommandsFromServer()
  while true do     
    local s, status, partial = tcp:receive()     
   
    local commandFromServer = s or partial;
    print('commandFromServer' .. commandFromServer)
    -- hlog.logToFile(commandFromServer)
  
    if (status == 'closed') then
      resetConnection();
      connectToServer();
      
    else
      -- execute_gpio(commandFromServer)
      local commandResponse = hsistem.executeCommandFromServer(commandFromServer)
      if(commandResponse ~= nil) then
        -- local message = hjson.
        print('id' .. id)
        local msg = hjson.createMessageFromRouterCommand(id,name, vals)
        print('sending ' .. msg)
        tcp:send(msg);
      end
    end
    
   end
end


receiveCommandsFromServer();


 






