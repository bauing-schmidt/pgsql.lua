
local lu = require 'luaunit'
local pgsql = require 'pgsql'
local lambda = require 'operator'

Test_lua = {}


function Test_lua:test_gc ()


    local mt = {
        __gc = function (t) error 'garbage from tests' end,
    }

    local o = { }

    setmetatable (o, mt)
    
end


function Test_lua:test_connection_status ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')
    lu.assertEquals (pgconn:status (), 0)
    
end


function Test_lua:test_connection_info ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')
    lu.assertEquals (pgconn:conninfo (), {})
    
end


function Test_lua:test_serverVersion ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')
    lu.assertEquals (pgconn:serverVersion (), 150002)
    
end


function Test_lua:test_exec_simple ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')

    local res = pgconn [[

        select * from pdm.ccnode limit 100;

    ]]

    lu.assertEquals (res.status, 'PGRES_TUPLES_OK')
    lu.assertEquals (res.error_message, '')
    print (res)
    -- lu.assertEquals (tostring(res), '')
    
end

os.exit( lu.LuaUnit.run() )