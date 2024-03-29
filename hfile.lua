
local hexecute = require 'hexecute'

local hfile = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'File-related functions for lua',
}
  
function hfile.test()
  print("hfile merge")
end

function hfile.readFile0(fileName)
  if hfile.exists(fileName) then
    local file = io.open(fileName, 'rb')
    io.input(file)
    local text = io.read()
    io.close(file)
    print(text)

    return text
  end
  return nil
end

function hfile.readFile(fileName)
  if hfile.exists(fileName) then
    local file = io.open(fileName, "r")
    local text = file:read("*a") -- The *a text makes it read the contents of the whole file.
    file:close() 

    return text
  end
  return nil
end

function hfile.writeToFile(fileName, text)
  local file = io.open(fileName, 'w')
  file:write(text)
  io.close(file)
end

function hfile.tryWriteToFile(fileName, text)
  status, ret = pcall(hfile.writeToFile, fileName, text)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end

function hfile.appendToFile(fileName, text)
  local file = io.open(fileName, 'a+')
  file:write(text .. '\n')
  io.close(file)
end

function hfile.deleteFile(fileName)
  os.remove(fileName)
end


function hfile.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
     if code == 13 then
        -- Permission denied, but it exists
        return true
     end
  end
  return ok, err
end

--- Check if a directory exists in this path
function hfile.isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path.."/")
end

function hfile.ensureDirectory(path)
  -- "/" works on both Unix and Windows
  if not hfile.exists(path) then
    hexecute.tryExecute("mkdir " .. path)
  end
end

function hfile.delete(path)
    os.remove(path)
end


function hfile.dir_exists_v1(path)
  if (lfs.attributes(path, "mode") == "directory") then
    return true
  end
  return false
end

return hfile
  
  