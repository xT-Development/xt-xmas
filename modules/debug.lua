local debug = require 'configs.shared'.debug
local log = print

function debugTxt(txt, debugType)
    if not debug then return end
    local color = (debugType == 'error') and '^1' or (debugType == 'warning') and '^3' or '^5'
    local string = (debugType == 'success') and 'SUCCESS' or (debugType == 'error') and 'ERROR' or (debugType == 'warning') and 'WARNING' or 'INFO'

    log(('%s[%s]^0 %s'):format(color, string, txt))
end