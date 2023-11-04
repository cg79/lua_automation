local gpiocommands = require 'gpio_commands'
local hexecute = require 'hexecute'

local jugglerstop = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Juggler stop functions for lua',
}

function jugglerstop.test()
  print("jugglerstop merge")
end

gpiocommands.tryStopGPIO()
hexecute.tryExecute('lua tcp_sender.lua')


return jugglerstop
