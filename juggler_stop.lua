local gpiocommands = require 'gpio_commands'


local jugglerstop = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Juggler stop functions for lua',
}

function jugglerstop.test()
  print("jugglerstop merge")
end

gpiocommands.tryclearDOUT2()


return jugglerstop
