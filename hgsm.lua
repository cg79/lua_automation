-- https://wiki.teltonika-networks.com/view/Gsmctl_commands

--todo
-- implementare metode de gsm cum ar fi temperatura, situatia sms-urilor si logurile lor?

local hexecute = require 'hexecute'

local hgsm = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'GSM methods',
}
  
  
function hgsm.test()
  print("hgsm merge")
end

function hgsm.executeGetGSMTime()
  local gps_reouter = hexecute.execute('gsmctl -T 2')
  return gps_reouter
end

function hgsm.errorFct()
  print('error gps')
end

function hgsm.tryExecuteGetGSMTime() 
  status, ret = xpcall(hgsm.executeGetGSMTime, hgsm.errorFct)
  print ('status')

  if(ret ~= nil) then 
    return ret
  else 
    return '0:0'
  end
end


return hgsm
  
  