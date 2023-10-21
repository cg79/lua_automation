
local hlog = require 'hlog'
local hstring = require 'hstring'
local hjson = require 'hjson'
local hconstants = require 'hconstants'
local hexecute = require 'hexecute'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local socket = require("socket") 

print('TCP_SENDER ' .. socket._VERSION)

local name = hsistem.executeGetCommand('name')
local id = hsettings.deviceId()



local masterSocket = socket.tcp();
local tcp = assert(masterSocket)  

function connectAndSendStatus()
  
  local tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);
  -- print(masterSocket.getstats())
  -- print('status' .. connection.status)
  -- while (tempConnection == nil) do
  --   hexecute.wait(hconstants.RECCONNECT_DELAY);

  --   hlog.logToFile('TCP_SENDER. Se incearca conexiunea la server');
  --   tempConnection = tcp:connect(hconstants.SERVER, hconstants.PORT);
  --   print(tempConnection);
  -- end

  -- local connection = tempConnection;

  if (tempConnection ~= nil) then
    local status = hsistem.executeGetCommand('gpio') or 'unknown';
    local statusMessage = hjson.createStatusMessage(id, status);
    
    hlog.logToFile('TCP_SENDER. CONEXIUNE STABILITA');
    tcp:send(statusMessage);
  end


  -- hexecute.wait(hconstants.RECCONNECT_DELAY);
end

connectAndSendStatus();





 






