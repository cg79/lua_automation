
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
    FILE_SOFT_VERSION = 'version.txt',
    GPS_FILE = 'gps.txt',
    SERVER = 'localhost',
    RECCONNECT_DELAY = 60,
    SERVER_URL = 'https://fullsd.com',
    PORT = 8007,
    -- SERVER_URL_PROD = '134.209.246.72',
    SERVER_URL_PROD = 'tcp://0.tcp.eu.ngrok.io',
    PORT_PROD = 11163,
    -- PORT_PROD = 8007,
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

-- sudo ufw allow 8008
-- sudo ufw deny 8008


-- stream {
--     server {
--       listen 8008;
--       proxy_pass 127.0.0.1:8007;        
--       proxy_protocol on;
--     }
-- }