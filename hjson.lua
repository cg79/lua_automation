
local hjson = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'Json-related functions for lua',
  }
  
  
function hjson.test()
  print("hjson merge")
end



function hjson.createKeyValue(key, value) 
  -- key, value ==> "key": "value"
  local response = "\"" .. key .. "\"" .. ":" .. "\"" .. value .. "\"" 
  return response
end

function hjson.createWhoCommand(name) 
  local tem = hjson.createKeyValue('name', name);

  local response = "{\"commandtype\":\"who\","  .. tem .. "}\n"
  return response
end

function hjson.createMessageFromRouterCommand(name, prop, value)
  local jcommandType = hjson.createKeyValue('commandtype', 'valuefromrouter') 
  local jname = hjson.createKeyValue('name', name);
  local jprop = hjson.createKeyValue('prop', prop);
  local jvalue = hjson.createKeyValue('value', value);

  local response = "{"  .. jcommandType .. "," .. jname .. "," .. jprop .. "," .. jvalue .. "}\n"
  return response
end

  
return hjson
  
  