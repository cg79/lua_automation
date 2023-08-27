
local hconstants = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'constants',
    LOGS_DIRECTORY = 'h_logs',
    GPS_DIRECTORY = 'h_gps',
    SETTINGS_DIRECTORY = 'h_settings',
    FILE_NAME = 'name.txt',
    FILE_PHONE = 'phone.txt',
    FILE_REGION = 'region.txt',
    FILE_MASTER = 'master.txt',
    GPS_FILE = 'h_gps/info.txt',
    SERVER = 'loclhost',
    PORT = 8007
}
  
  
function hconstants.test()
  print("hconstants merge")
end

return hconstants
  
  