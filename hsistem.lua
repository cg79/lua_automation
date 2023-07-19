
local hsistem = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'String-related functions for lua',
  }
  
  
function hsistem.test()
  print("hsistem merge")
end

function hsistem.execute(command)
  --local ostime_vrbl = os.time() + second
  --print(ostime_vrbl);
  os.execute(command);
 end
 
 function hsistem.wait(second)
  hsistem.execute("sleep " .. second);
 end

 function hsistem.executeAfterXSeconds(seconds, commandType, parameters)
  print("ok0=========== " .. seconds)
  hsistem.execute("sleep " .. seconds);
  -- print(commandType .. parameters)
 end

  
return hsistem
  
  