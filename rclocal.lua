

function symLink()
 os.execute("ln -s ../lua_automation/*.* .")
end

function trySymLink()

  status, ret = pcall(symLink)

  if (status ~= false and ret ~= nil) then
    return ret
  else
    return nil
  end
end


trySymLink()


os.execute("lua hbootstrap.lua")