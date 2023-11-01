
local http = require("socket.http")
local ltn12 = require 'ltn12'

-- sudo luarocks install luasocket


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


-- x = hhttp.get('http://fullsd.com/api/teltonika/tfiles')
-- print(x)

return hhttp
  
  