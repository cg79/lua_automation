
local hstring = require 'hstring'
local hhttp = require 'hhttp'


local hdownload = {
    __VERSION     = '1.0',
    __DESCRIPTION = 'Download new files',
}
  
function hdownload.test()
  print("hdownload merge")
end


function hdownload.downloadFiles(str)
  -- str = url:filename,
  local  urlAndFileArr = hstring.splitBy(str, ',')
  local length = #(urlAndFileArr)
  -- print(length);

  for nameCount = 1, length do
    
    local strUrlANdFile = urlAndFileArr[nameCount];
    local urlAndFile = hstring.splitBy(strUrlANdFile, '|')
    print (urlAndFile[1])
    hhttp.downloadFile(urlAndFile[1], urlAndFile[2])
  end

end

function hdownload.start()
  local filesFromServer = hhttp.get('http://localhost:3001/api/teltonika/tfiles');
  -- hdownload.downloadFiles('http://pbs.twimg.com/media/CCROQ8vUEAEgFke.jpg|ggg.jpg')
end

hdownload.start()


return hdownload
  
  