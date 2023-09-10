
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
    url = url,
    sink = ltn12.sink.table(body)
  }

  local response = table.concat(body)
  return response;
end

function hhttp.downloadFile(url, filename)
  local body, code = http.request(url)
  if not body then error(code) end

  -- save the content to a file
  local f = assert(io.open(filename, 'wb')) -- open in "binary" mode
  f:write(body)
  f:close()
end


-- hhttp.get('http://localhost:3001/api/teltonika/tfiles')

return hhttp
  
  