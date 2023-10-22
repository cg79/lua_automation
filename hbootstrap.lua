


local hexecute = require 'hexecute'
local hlog = require 'hlog'


local hboot = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'bootlua',
}
  
function hboot.test()
  print("hlog merge")
end

--  1: se adauga symlinkul
-- hboot.execute("ln -s /Users/claudiugombos/work/arduino/lua_automation lua_automation")

-- hsettings.setName('pl')
-- hsettings.setPhoneNumber('pl')
-- hsettings.setRegion('pl')
-- hsettings.setIsMaster('pl')


-- local test = os.clock()
-- print(test)
-- hexecute.execute('lua tcp_client.lua &')
-- local test = hjson.createMessageFromRouterCommand('a', 'b', 'c')
-- print(test)

-- local test = hjson.createMessageFromRouterCommand('xxx', 'yyy', 'zzz')
-- print(test)

hlog.logToFile('!!! PORNIRE ROUTER !!!');

hexecute.execute('lua tcp_client.lua & lua hscheduler.lua &')

return hboot
  
  