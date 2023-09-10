
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

function hjson.createWhoCommand(id, name, phone, region, master, coordinates) 
  local sid = hjson.createKeyValue('guid', id);
  local sctype = hjson.createKeyValue('commandtype', 'who');
  local sname = hjson.createKeyValue('name', name);
  local sphone = hjson.createKeyValue('phone', phone);
  local sregion = hjson.createKeyValue('region', region);
  local smaster = hjson.createKeyValue('master', master);
  local scoordinates = hjson.createKeyValue('coordinates', coordinates);

  local response = "{" .. sid .. "," .. sctype .. "," .. sname .. "," .. sphone .. "," .. sregion .. "," .. smaster .. "," .. scoordinates .. "}\n"
  return response .. "\n"
end



function hjson.createMessageFromRouterCommand(id, name, prop, value)
  local jcommandType = hjson.createKeyValue('commandtype', 'valuefromrouter') 
  local jid = hjson.createKeyValue('id', id);
  local jname = hjson.createKeyValue('name', name);
  local jprop = hjson.createKeyValue('prop', prop);
  local jvalue = hjson.createKeyValue('value', value);

  local response = "{"  .. jcommandType .. "," .. jid .. "," .. jname .. "," .. jprop .. "," .. jvalue .. "}\n"
  return response .. "\n"
end

  
return hjson
  
  