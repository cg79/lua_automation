local hstring = require 'hstring'
local hfile = require 'hfile'
local htime = require 'htime'

local hschedulersave = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'Scheduler-related functions for lua',
    __DIRECTORY = './h_schedules'
  }
  
  
function hschedulersave.test()
  print("hschedulersave merge")
end

function stringCommandsToTable(input)
  local arr = {}
  local dayValue = 0;

  for capture in string.gmatch(input, "%{(.-)%}") do
      --    print(capture)
     dayValue = hstring.textUntil(capture,',')
     arr[dayValue] = capture;
  end
  
  -- for k, v in pairs(arr) do
  --     print(k,v)
  -- end

  return arr
end

function stringCommandAsObject(command) 
-- [8:12:3,1,1]
local  splitTable = hstring.splitBy(command, ',')

-- for i=1,#(splitTable) do
  -- print(splitTable[i])
-- end

  local time = htime.createTimeFromHMS(splitTable[1])
  local commandType = splitTable[2]
  local parameters = splitTable[3]


 return {
  time = time,
  commandType = commandType,
  parameters = parametrii
 }

end

function createAnArrayOfObjectsFromADailyCommand(input)
  -- {72,[8:12:3,1,1],[8:15:3,1,0]}
  local arr = {}
  local dayValue = 0;
  local obj = nil


  for capture in string.gmatch(input, "%[(.-)%]") do
         print(capture)
         obj = stringCommandAsObject(capture)

    table.insert(arr, obj)
  end
  
  -- for k, v in pairs(arr) do
  --     print(k,v)
  -- end

  return arr
end

function getSchedulerFileName(dayIndex)
  return hschedulersave.__DIRECTORY  .. '/' .. dayIndex
end

function saveTableToDisc(table) 
  for k, v in pairs(table) do
      print(k,v)
      local fileName = getSchedulerFileName(k)
      -- print(fileName)
      hfile.writeToFile(fileName, v)
  end
end

function hschedulersave.saveCommandsToDisc(input)
  hfile.ensureDirectory(hscheduler.__DIRECTORY)

  -- hfile.delete(hscheduler.__DIRECTORY)
  -- hfile.delete("del.lua")

  local input = "{72,[8:12:3,1,1],[8:15:3,1,0]},{75,[8:12:3,1,1],[8:15:3,1,1]}"
  local table = stringCommandsToTable(input)

  saveTableToDisc(table)
end

return hschedulersave
  
  