
local hboot = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'bootlua',
}
  
function hboot.test()
  print("hlog merge")
end

function hboot.execute(command)
  --local ostime_vrbl = os.time() + second
  --print(ostime_vrbl);
  os.execute(command);
 end



--  1: se adauga symlinkul
-- hboot.execute("ln -s /Users/claudiugombos/work/arduino/lua_automation lua_automation")

--  2. se executa scriptul de mai jos
 hboot.execute('lua lua_automation/test.lua &')



-- hboot.execute("ls -l /Users/claudiugombos/work/arduino/lua_automation")

-- hboot.execute('cd lua_automation & ls')
-- 
-- hboot.execute('cd lua_automation & ls')

return hboot
  
  