
local hsistem = require 'hsistem'

local hfile = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'File-related functions for lua',
}
  
function hfile.test()
  print("hfile merge")
end

function hfile.readFile(fileName)
  local file = io.open(fileName, 'r')
  io.input(file)
  local text = io.read()
  io.close(file)

  return text
end

function hfile.writeToFile(fileName, text)
  local file = io.open(fileName, 'w')
  file:write(text)
  io.close(file)
end

function hfile.appendToFile(fileName, text)
  local file = io.open(fileName, 'a+')
  file:write(text .. '\n')
  io.close(file)
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
    hsistem.execute("mkdir " .. path)
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
  
  