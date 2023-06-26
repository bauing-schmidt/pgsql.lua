
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <lua.h>
#include <lauxlib.h>
#include <libpq-fe.h>

int l_PQsetdbLogin(lua_State *L)
{
    const char *pghost = lua_tostring(L, 1);
    const char *pgport = lua_tostring(L, 2);
    const char *dbName = lua_tostring(L, 3);
    const char *login = lua_tostring(L, 4);
    const char *pwd = lua_tostring(L, 5);

    PGconn *conn = PQsetdbLogin(pghost, pgport, NULL, NULL, dbName, login, pwd);
    
    lua_pushlightuserdata(L, conn);

    return 1;
}

const struct luaL_Reg libpgsqllua[] = {
    {"setdbLogin", l_PQsetdbLogin},
    {NULL, NULL} /* sentinel */
};

extern int luaopen_libpgsqllua(lua_State *L)
{
    luaL_newlib(L, libpgsqllua);

    return 1;
}
