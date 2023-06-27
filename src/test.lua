
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

    lu.assertEquals (pgconn:errorMessage (), '')
    lu.assertEquals (res:status (), pgsql.PGRES.TUPLES_OK)
    lu.assertEquals (res:errorMessage (), '')
    lu.assertEquals (res:cmdStatus (), 'SELECT 10')
    lu.assertEquals (res:cmdTuples (), 10)
    print (res)
    lu.assertEquals (res (), {})
    -- lu.assertEquals (tostring(res), '')
    
end


function Test_lua:test_exec_coord ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')

    local res = pgconn [[

        select * from pdm.ccnode limit 100;

    ]]

    
    lu.assertEquals (res:status (), pgsql.PGRES.TUPLES_OK)
    
    lu.assertEquals (res { row = 3, }, {})
    -- lu.assertEquals (tostring(res), '')
    
end

function Test_lua:test_exec_anonymous ()
    local pgconn = pgsql.setdbLogin ('localhost', '5436', 'pdmCC', 'pdm', 'devAdmin1')

    local flag, trace = pgconn:tracing (
        function ()
            local res = pgconn [[

                select 3 + 4, 8;

            ]]

            lu.assertEquals (res:status (), pgsql.PGRES.TUPLES_OK)
    
            local tuples = res { usenames = false } 

            lu.assertEquals (tuples [1][1], '7')
            lu.assertEquals (tuples [1][2], '8')
        end
    )
    
    lu.assertTrue (flag)
    print (trace)
    
end

os.exit( lu.LuaUnit.run() )