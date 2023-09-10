
local http = require("socket.http")
local ltn12 = require 'ltn12'


local hhttp = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'http ',
}
  
function hhttp.test()
  print("hhttp merge")
end

function hhttp.get(url)
  local body = {}
    local res, code, headers, status = http.request{
    url = "",
    sink = ltn12.sink.table(body)
  }

  local response = table.concat(body)
  print(response)
  return response;
end


-- hhttp.get('http://localhost:3001/api/teltonika/tfiles')

return hhttp
  
  