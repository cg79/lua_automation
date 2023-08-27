

local hexecute = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'os execute functions',
}
  
  
function hexecute.test()
  print("hexecute merge")
end


function hexecute.execute(command)
  --local ostime_vrbl = os.time() + second
  --print(ostime_vrbl);
  os.execute(command);
 end
 
 function hexecute.wait(second)
  hexecute.execute("sleep " .. second);
 end

  
return hexecute
  
  