
local hfile = require 'hfile'
local htime = require 'htime'

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
  print(text);
  local dateValues = htime.getDateValues()
  local filePath = tostring(dateValues.year) .. '_' .. tostring(dateValues.month) .. '_' .. tostring(dateValues.day) .. '.txt'
  -- print(filePath)
  local hms = dateValues.hour .. ':' .. dateValues.min .. ':' .. dateValues.sec .. ':'
  hfile.appendToFile(filePath, hms .. text)
end

return hlog
  
  