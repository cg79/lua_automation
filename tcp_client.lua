
local hlog = require 'hlog'
local hstring = require 'hstring'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'
local hsistem = require 'hsistem'
local socket = require("socket") 
-- local host = "7.tcp.eu.ngrok.io";
-- local port = 14456;
 
-- https://w3.impa.br/~diego/software/luasocket/introduction.html
-- https://web.tecgraf.puc-rio.br/luasocket/old/luasocket-1.0/

local name = hsistem.executeGetCommand('name') or 'guest'
print(name)
local phone = hsistem.executeGetCommand('phone')
local region = hsistem.executeGetCommand('region')
local master = hsistem.executeGetCommand('master')


local masterSocket = socket.tcp();
local tcp = assert(masterSocket)  
-- local connection = nil;

-- local whoStr = '{"commandtype":"who","name":"router1"}\n';
local whoStr = "{\"commandtype\":\"who" .. name .. "\"}"

-- local pingCommand = '{"commandtype":"ping","name":"router1"}\n';

function resetConnection()
  tcp:close();
  masterSocket = socket.tcp();
  tcp = assert(masterSocket)  
end

function connectToServer()
  
  local tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);
  -- print(masterSocket.getstats())
  -- print('status' .. connection.status)
  

  while (tempConnection == nil) do
    hexecute.wait(10);

    hlog.logToFile('TCP_CLIENT. Se incearca conexiunea la server');
    tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);
    print(tempConnection);
  end

  -- local x = tcp:send(pingCommand);
  -- print(x)
  connection = tempConnection;
  
  hlog.logToFile('TCP_CLIENT. CONEXIUNE STABILITA');
  tcp:send(whoStr);

  hexecute.wait(10);
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

local mcount = 0;
function monitor()
  
 if mcount > 0 then 
   return;
 end

 mcount = 0;
 while mcount < 2 do
  os.execute("sleep 5")
  local resp = execute("/sbin/gpio.sh get DOUT2")
  print(resp)
    
  local whoStr = [[{"commandtype":"monitor","name":"router1", "value":"]] .. resp.. [["}]]
  tcp:send(whoStr .. "\n");
  mcount = mcount +1;

 end 
 mcount = 0;
end

 
-- ###################################
function receiveCommandsFromServer()
  while true do     
    local s, status, partial = tcp:receive()     
   
    local commandFromServer = s or partial;
    print('commandFromServer' .. commandFromServer)
  
    if (status == 'closed') then
      resetConnection();
      connectToServer();
      
    else
      execute_gpio(commandFromServer)
    end
    
   end
end


receiveCommandsFromServer();


 






