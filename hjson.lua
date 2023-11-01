
local hjson = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'Json-related functions for lua',
  }
  
  
function hjson.test()
  print("hjson merge")
end

function hjson.createKeyValue(key, value) 
  -- key, value ==> "key": "value"
  print(key .. value)
  local response = "\"" .. key .. "\"" .. ":" .. "\"" .. value .. "\"" 
  return response
end

function hjson.createWhoCommand(guid, name, phone, region, master, coordinates, started, voltage, suntime, barrier, hour) 

  voltage = 1234;
  local sid = hjson.createKeyValue('guid', guid);
  local sctype = hjson.createKeyValue('commandtype', 'who');
  local sname = hjson.createKeyValue('name', name);
  local sphone = hjson.createKeyValue('phone', phone);
  local sregion = hjson.createKeyValue('region', region);
  local smaster = hjson.createKeyValue('master', master);
  local scoordinates = hjson.createKeyValue('coordinates', coordinates)
  local vs = hjson.createKeyValue('started', started)
  local vt = hjson.createKeyValue('voltage', voltage)
  local vSuntime = hjson.createKeyValue('suntime', suntime)
  local vBarrier = hjson.createKeyValue('barrier', barrier)
  local vhour = hjson.createKeyValue('hour', hour)



  local response = "{" .. sid .. "," .. vs .. "," .. vt.. ",\n"
  response = response .. sctype .. "," .. sname .. "," .. sphone .. "," .. sregion .. ",\n"
  response = response .. smaster .. "," .. scoordinates .. ",\n"
  response = response .. vSuntime .. "," .. vBarrier .. "," .. vhour .. "}\n"

  print(response)
  -- return response .. "\n"
  return response
end

function hjson.createStatusMessage(guid, gpioValue) 
  local sid = hjson.createKeyValue('guid', guid);
  local status = hjson.createKeyValue('commandtype', 'valuefromrouter');
  local gpio = hjson.createKeyValue('started', gpioValue);

  local response = "{" .. sid .. "," .. status .. "," .. gpio .. "}\n"
  return response .. "\n"
end

function hjson.createMessageFromRouterCommandold(guid, name, vals)
  local jcommandType = hjson.createKeyValue('commandtype', 'valuefromrouter') 
  local jguid = hjson.createKeyValue('guid', guid);
  local jname = hjson.createKeyValue('name', name);
  local jprop = hjson.createKeyValue('prop', vals[1]);
  local jvalue = hjson.createKeyValue('value', vals[2]);

  local response = "{"  .. jcommandType .. "," .. jguid .. "," .. jname .. "," .. jprop .. "," .. jvalue .. "}\n"
  return response .. "\n"
end


function hjson.createMessageFromRouterCommand(guid, v1,v2)
  local jcommandType = hjson.createKeyValue('commandtype', 'valuefromrouter')
  local jid = hjson.createKeyValue('guid', guid);
  
  local jprop = hjson.createKeyValue(v1, v2);
  local jname = hjson.createKeyValue('name', v1);
  local jvalue = hjson.createKeyValue('value', v2 or '');

  print('jval ' .. jvalue)

  local response = "{"  .. jcommandType .. "," .. jid .. "," .. jprop .. "," .. jname ..","..  jvalue .. "}\n"
  return response .. "\n"
end

  
return hjson
  
  