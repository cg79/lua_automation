
local hlog = require 'hlog'
local hstring = require 'hstring'
local hjson = require 'hjson'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local socket = require("socket")
local hfile = require 'hfile'


local mode = 'local'

if(mode == 'local') then 
  SERVER_URL = 'localhost'
  PORT = 8007;
else 
  SERVER_URL = '134.209.246.72'
  PORT = 8007;
end


-- local host = "7.tcp.eu.ngrok.io";
-- local port = 14456;
 
-- https://w3.impa.br/~diego/software/luasocket/introduction.html
-- https://web.tecgraf.puc-rio.br/luasocket/old/luasocket-1.0/

hfile.ensureDirectory(hconstants.LOGS_DIRECTORY)
hfile.ensureDirectory(hconstants.SETTINGS_DIRECTORY)
hsettings.deviceGuid();


hlog.deletePreviousXDays(15)

print(socket._VERSION)

local guid = hsettings.deviceGuid()
local name = hsistem.executeGetCommand('name')

local whoStr = hsistem.createWhoJsonString(guid, name)

local masterSocket = socket.tcp();
local tcp = assert(masterSocket);
local connection = nil;

function resetConnection()
  tcp:close();
  masterSocket = socket.tcp();
  tcp = assert(masterSocket)  
end

function connectToServer()
  
  local tempConnection = tcp:connect(SERVER_URL, PORT);

  -- print(masterSocket.getstats())
  -- print('status' .. connection.status)
  local count = 0;
  while (tempConnection == nil and count < 3) do
    hexecute.wait(hconstants.RECCONNECT_DELAY);

    hlog.logToFile('TCP_CLIENT. Se incearca conexiunea la server ' .. SERVER_URL .. ' ' .. PORT);
    tempConnection = tcp:connect(SERVER_URL, PORT);
    print('count ' .. count);

    count = count + 1
  end

  connection = tempConnection;
  
  hlog.logToFile('TCP_CLIENT. CONEXIUNE STABILITA');
  tcp:send(whoStr);

  -- hexecute.wait(hconstants.RECCONNECT_DELAY);
end


connectToServer();


-- ###################################
function receiveCommandsFromServer()
  while true do     
    local s, status, partial = tcp:receive()     
   
    local commandFromServer = s or partial;

    if(commandFromServer == '' or commandFromServer == nil) then
      return;
    end
    
    print('commandFromServer' .. commandFromServer)
    hlog.logToFile('commandFromServer' .. commandFromServer)
  
    if (status == 'closed') then
      resetConnection();
      connectToServer();
    else
      local commandResponse = hsistem.tryExecuteCommandFromServer(commandFromServer)
      
      if (commandResponse == nil) then
        print('nil response for ' .. commandFromServer)
      end

      if(commandResponse ~= nil) then
        -- local message = hjson.
        print('commandResponse 1 ' .. commandResponse[1])
        print('commandResponse 2 ' .. commandResponse[2])

        local msg = hjson.createMessageFromRouterCommand(guid, commandResponse)
        print('sending ' .. msg)
        tcp:send(msg);
      end
    end
    
   end
end


receiveCommandsFromServer();


 






