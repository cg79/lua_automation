

local hexecute = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'os execute functions',
}
  
  
function hexecute.test()
  print("hexecute merge")
end

function hexecute.executePOpen(command)
  local f = assert(io.popen(command, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
 end

 function hexecute.tryExecutePOpen(command)
  status, ret = pcall(hexecute.executePOpen, command)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end

function hexecute.execute(command)
  --local ostime_vrbl = os.time() + second
  --print(ostime_vrbl);
  local response = os.execute(command);
  -- print(response)
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
  
  