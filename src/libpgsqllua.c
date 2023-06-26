
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

int l_PQstatus(lua_State *L)
{
    PGconn *conn = (PGconn *)lua_touserdata(L, 1);

    ConnStatusType status = PQstatus(conn);

    lua_pushinteger(L, status);

    return 1;
}

int l_PQserverVersion(lua_State *L)
{
    PGconn *conn = (PGconn *)lua_touserdata(L, 1);

    int v = PQserverVersion(conn);

    lua_pushinteger(L, v);

    return 1;
}

int l_PQexec(lua_State *L)
{
    PGconn *conn = (PGconn *)lua_touserdata(L, 1);
    const char *command = lua_tostring(L, 2);

    PGresult *res = PQexec(conn, command);

    ExecStatusType status = PQresultStatus(res);

    lua_pushlightuserdata(L, res);
    lua_pushstring(L, PQresStatus(status));
    lua_pushstring(L, PQresultErrorMessage(res));

    return 3;
}

int l_PQprint(lua_State *L)
{

    PGresult *res = (PGresult *)lua_touserdata(L, 1);

    PQprintOpt opt;

    opt.header = lua_toboolean(L, 2);
    opt.align = lua_toboolean(L, 3);
    opt.standard = lua_toboolean(L, 4);
    opt.html3 = lua_toboolean(L, 5);
    opt.expanded = lua_toboolean(L, 6);
    opt.pager = lua_toboolean(L, 7);
    opt.fieldSep = lua_tostring(L, 8);
    opt.tableOpt = lua_tostring(L, 9);
    opt.caption = lua_tostring(L, 10);
    opt.fieldName = NULL;

    FILE *fout = tmpfile();

    PQprint(fout, res, &opt);

    fseek(fout, 0L, SEEK_END);
    size_t sz = ftell(fout);
    rewind(fout);

    luaL_Buffer b;

    luaL_buffinit(L, &b);

    for (int i = 0; i < sz; i++)
        luaL_addchar(&b, fgetc(fout));

    luaL_pushresult(&b);

    fclose(fout);

    return 1;
}

int l_PQclear(lua_State *L)
{

    PGresult *res = (PGresult *)lua_touserdata(L, 1);

    PQclear(res);

    return 0;
}

void PQclear(PGresult *res);

const struct luaL_Reg libpgsqllua[] = {
    {"setdbLogin", l_PQsetdbLogin},
    {"connectdb", l_PQconnectdb},
    {"conninfo", l_PQconninfo},
    {"finish", l_PQfinish},
    {"status", l_PQstatus},
    {"serverVersion", l_PQserverVersion},
    {"exec", l_PQexec},
    {"print", l_PQprint},
    {"clear", l_PQclear},
    {NULL, NULL} /* sentinel */
};

extern int luaopen_libpgsqllua(lua_State *L)
{
    luaL_newlib(L, libpgsqllua);

    return 1;
}
