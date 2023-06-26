
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

int l_PQconnectdb(lua_State *L)
{
    const char *conninfo = lua_tostring(L, 1);

    PGconn *conn = PQconnectdb(conninfo);

    lua_pushlightuserdata(L, conn);

    return 1;
}

int l_PQconninfo(lua_State *L)
{
    PGconn *conn = (PGconn *)lua_touserdata(L, 1);

    PQconninfoOption *info = PQconninfo(conn);

    lua_newtable(L);

    lua_pushstring(L, info->keyword);
    lua_setfield(L, -2, "keyword");

    lua_pushstring(L, info->val);
    lua_setfield(L, -2, "val");

    lua_pushstring(L, info->label);
    lua_setfield(L, -2, "label");

    lua_pushstring(L, info->dispchar);
    lua_setfield(L, -2, "dispchar");

    PQconninfoFree(info);

    return 1;
}

int l_PQfinish(lua_State *L)
{
    PGconn *conn = (PGconn *)lua_touserdata(L, 1);

    PQfinish(conn);

    return 0;
}

const struct luaL_Reg libpgsqllua[] = {
    {"setdbLogin", l_PQsetdbLogin},
    {"connectdb", l_PQconnectdb},
    {"conninfo", l_PQconninfo},
    {"finish", l_PQfinish},
    {NULL, NULL} /* sentinel */
};

extern int luaopen_libpgsqllua(lua_State *L)
{
    luaL_newlib(L, libpgsqllua);

    return 1;
}
