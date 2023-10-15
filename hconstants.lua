
local hconstants = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'constants',
    LOGS_DIRECTORY = 'h_logs',
    GPS_DIRECTORY = 'h_gps',
    SETTINGS_DIRECTORY = 'h_settings',
    FILE_NAME = 'name.txt',
    FILE_PHONE = 'phone.txt',
    FILE_REGION = 'region.txt',
    FILE_SUNTIME1 = 'suntime1.txt',    
    FILE_SUNTIME2 = 'suntime2.txt',
    FILE_BARRIER = 'barrier.txt',
    FILE_MASTER = 'master.txt',
    FILE_ID = 'id.txt',
    GPS_FILE = 'gps.txt',
    SERVER = 'localhost',
    PORT = 8007,
    RECCONNECT_DELAY = 60,
    SERVER_URL = 'https://fullsd.com',
    SERVER_FILES_URL = 'https://fullsd.com/api/teltonika/tfiles'
}
  
  
function hconstants.test()
  print("hconstants merge")
end

local random = math.random
function hconstants.uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

return hconstants
  
  