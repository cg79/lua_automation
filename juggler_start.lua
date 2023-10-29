local gpiocommands = require 'gpio_commands'


local jugglerstart = {
  __VERSION     = '1.0',
  __DESCRIPTION = 'Juggler start functions for lua',
}

function jugglerstart.test()
  print("jugglerstart merge")
end

gpiocommands.tryStartGPIO()


return jugglerstart
