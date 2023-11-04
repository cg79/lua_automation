local hexecute = require 'hexecute'
local hlog = require 'hlog'
local hfile = require 'hfile'
local hsettings = require 'hsettings'
local hconstants = require 'hconstants'
local hsistem = require 'hsistem'


local hboot = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'bootlua',
}

function hboot.test()
  print("hlog merge")
end

hfile.ensureDirectory(hconstants.LOGS_DIRECTORY)
hfile.ensureDirectory(hconstants.SETTINGS_DIRECTORY)
hsettings.deviceGuid();

hexecute.wait(10)

hlog.logToFile('!!! CORELARE TIMP !!!');

hsistem.corelateTime()

hlog.logToFile('!!! PORNIRE SERVER !!!');

hexecute.tryExecute('lua tcp_client.lua &')

hexecute.wait(30)

hexecute.tryExecute('lua hscheduler.lua &')

return hboot
