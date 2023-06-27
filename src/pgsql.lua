
local libpgsqllua = require 'libpgsqllua'

-- a fast-forward module, for now.

local res_mt = {

    __tostring = function (pg_res)
        return libpgsqllua.print (pg_res.ud, true, true, true, false, false, true, '|', '', '')
    end,

    __gc = function (pg_res) libpgsqllua.clear (pg_tbl.ud); pg_tbl.ud = nil end,

    __call = function (pg_res, usenames)

        if usenames == nil then usenames = true end

        return libpgsqllua.tuples (pg_res.ud, usenames) 
    end,

    __index = {

        errorMessage = function (pg_res) return libpgsqllua.resultErrorMessage (pg_res.ud) end,
        print = function (pg_res, ...) return libpgsqllua.print (pg_res.ud, ...) end,
        status = function (pg_res) return libpgsqllua.resultStatus (pg_res.ud) end,
        cmdStatus = function (pg_res) return libpgsqllua.cmdStatus (pg_res.ud) end,
        cmdTuples = function (pg_res) return tonumber(libpgsqllua.cmdTuples (pg_res.ud)) end,

    }

}

local pg_mt = {

    __gc = function (pg_tbl) libpgsqllua.finish (pg_tbl.conn); pg_tbl.conn = nil end,
        
    __call = function (pg_tbl, command) 
        
        local res_ud = libpgsqllua.exec (pg_tbl.conn, command)

        local tbl = {
            ud = res_ud,
        }

        setmetatable (tbl, res_mt)

        return tbl
    end,

    __index = {

        status = function (pg_tbl) return libpgsqllua.status (pg_tbl.conn) end,
        conninfo = function (pg_tbl) return libpgsqllua.conninfo (pg_tbl.conn) end,
        serverVersion = function (pg_tbl) return libpgsqllua.serverVersion (pg_tbl.conn) end,
        errorMessage = function (pg_tbl) return libpgsqllua.errorMessage (pg_tbl.conn) end,
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