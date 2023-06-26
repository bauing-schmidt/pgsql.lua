
local libpgsqllua = require 'libpgsqllua'

-- a fast-forward module, for now.

local res_mt = {

    __tostring = function (pg_res)
        return libpgsqllua.print (pg_res.ud, true, true, true, false, false, true, '|', '', '')
    end,
    __gc = function (pg_res) libpgsqllua.clear (pg_tbl.ud) end

}

local pg_mt = {

    __gc = function (pg_tbl) libpgsqllua.finish (pg_tbl.conn) end,
        
    __call = function (pg_tbl, command) 
        
        local ud, res, err = libpgsqllua.exec (pg_tbl.conn, command)

        local tbl = {
            ud = ud,
            status = res,
            error_message = err
        }

        setmetatable (tbl, res_mt)

        return tbl
    end,

    __index = {

        status = function (pg_tbl) return libpgsqllua.status (pg_tbl.conn) end,
        conninfo = function (pg_tbl) return libpgsqllua.conninfo (pg_tbl.conn) end,
        serverVersion = function (pg_tbl) return libpgsqllua.serverVersion (pg_tbl.conn) end,

    }

}

local setdbLogin = libpgsqllua.setdbLogin

function libpgsqllua.setdbLogin (...)

    local conn = setdbLogin (...)

    local tbl = {}

    tbl.conn = conn

    setmetatable (tbl, pg_mt)

    return tbl

end

return libpgsqllua