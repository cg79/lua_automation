
local hfile = require 'hfile'
local htime = require 'htime'
local hconstants = require 'hconstants'

local hlog = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'File-related functions for lua',
}
  
  
function hlog.test()
  print("hlog merge")
end

function hlog.log(text)
  print(text)
end

function hlog.logToFile(text)
  -- print(hconstants.LOGS_DIRECTORY);
  local dateValues = htime.getDateValues()
  local filePath = htime.getLogFilePath();

  -- print(filePath)
  -- local filePath = 'hlogs/' .. tostring(dateValues.year) .. '-' .. tostring(dateValues.month) .. '-' .. tostring(dateValues.day) .. '.txt'
  -- print(filePath)
  print(text)
  local hms = dateValues.hour .. ':' .. dateValues.min .. ':' .. dateValues.sec .. ':'
  hfile.appendToFile(filePath, hms .. text)
end

function hlog.deletePreviousXDays(x)
  if(x == nil) then
    x = 1
  end

  local fileName = htime.getPreviousDaysDate(x)
  hfile.deleteFile(fileName)
end

-- print(type("Hello world"))

return hlog
  
  