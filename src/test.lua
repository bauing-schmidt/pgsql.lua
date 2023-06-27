
local lu = require 'luaunit'
local pgsql = require 'pgsql'
local lambda = require 'operator'

Test_lua = {}


function Test_lua:test_gc ()


    local mt = {
        __gc = function (t) print 'garbage from tests' end,
    }

    local o = { }

    setmetatable (o, mt)
    
end


function Test_lua:test_connection_status ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')
    lu.assertEquals (pgconn:status (), pgsql.CONNECTION.OK)
    
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

        select * from pdm.ccnode limit 10;

    ]]

    lu.assertEquals (res:status (), pgsql.PGRES.TUPLES_OK)
    lu.assertEquals (res:resultErrorMessage (), '')
    print (res)
    -- lu.assertEquals (tostring(res), '')
    
end

os.exit( lu.LuaUnit.run() )