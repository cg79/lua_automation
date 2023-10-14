
local hstring = require 'hstring'
local hhttp = require 'hhttp'
local hconstants = require 'hconstants'


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

  for nameCount = 1, length do
    local strUrlANdFile = urlAndFileArr[nameCount];
    local urlAndFile = hstring.splitBy(strUrlANdFile, '|')
    hhttp.downloadFile(urlAndFile[1], urlAndFile[2])
  end

end

function hdownload.start()
  local filesFromServer = hhttp.get(hconstants.SERVER_FILES_URL);
  hdownload.downloadFiles(filesFromServer)
end

-- hdownload.start()


return hdownload
  
  