local http = require("socket.http")
local ltn12 = require 'ltn12'
-- local cjson = require "cjson"

local body = {}
local res, code, headers, status = http.request{
  url = "http://localhost:3001/api/teltonika/tfiles",
  sink = ltn12.sink.table(body)
}

local response = table.concat(body)
print(response)