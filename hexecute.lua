

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
  local response = os.execute(command);
  return response;
 end

 function hexecute.tryExecute(command)

  status, ret = pcall(hexecute.execute, command)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end
 
 function hexecute.wait(second)
  hexecute.execute("sleep " .. second);
 end

  
return hexecute
  
  