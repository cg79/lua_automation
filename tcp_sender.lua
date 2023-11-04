local hlog = require 'hlog'
local hstring = require 'hstring'
local hjson = require 'hjson'
local hconstants = require 'hconstants'
local hsistem = require 'hsistem'
local hsettings = require 'hsettings'
local socket = require("socket")

print('TCP_SENDER ' .. socket._VERSION)

local name = hsistem.executeGetCommand('name')
local guid = hsettings.deviceGuid()



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
    local status = hsistem.executeGetCommand('gpio') or '-1';
    local statusMessage = hjson.createStatusMessage(guid, status);

    hlog.logToFile('TCP_SENDER. CONEXIUNE STABILITA');
    tcp:send(statusMessage);

    -- hexecute.tryExecute('os.exit()')
    os.exit()
  end


  -- hexecute.wait(hconstants.RECCONNECT_DELAY);
end

connectAndSendStatus();
