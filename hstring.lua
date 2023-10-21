
local hstring = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'String-related functions for lua',
  }
  
  
function hstring.test()
  print("hstring merge")
end

function hstring.replace(s, oldValue, newValue)
  return string.gsub(s, oldValue, newValue);
end;

function hstring.splitBy(str, delimiter)
  local arr = {}
  local i = 1;
  local regex = '([^'..delimiter..']+)';
  for word in string.gmatch(str, regex) do
      --print(word)
      arr[i]= word;
      i = i+1;
  end
  -- print(arr)
  return arr
end

function hstring.arrToString(arr)
  n = #(arr)
  for i=1,n do
      print(arr[i])
  end
end

function hstring.textUntil(input, text) 
  local position = string.find(input,text)
  local response = string.sub(input,0,position -1 )
  return response 
end

-- local array  = splitBy('cat,dog', ',')
-- arrToString(array)

-- local array1  = splitBy('8:40', ':')
-- arrToString(array1)




  
return hstring
  
  