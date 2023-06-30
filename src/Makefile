
linux:
	cc -O2 -fPIC -Wall -shared -o libpgsqllua.so libpgsqllua.c \
		-I/usr/local/pgsql/include -L/usr/local/pgsql/lib \
		-llua -lpq

mingw:
	cc -O2 -fPIC -Wall -shared -o libpgsqllua.dll libpgsqllua.c \
		-I/c/Program\ Files/PostgreSQL/15/include -I/usr/local/include -L/c/Program\ Files/PostgreSQL/15/lib -L/usr/local/lib \
		-llua54 -lpq

macos:
	cc -O2 -fPIC -Wall -shared -o libpgsqllua.dylib libpgsqllua.c -llua -lpg

install:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libpgsqllua.so /usr/local/lib/lua/5.4/
	cp pgsql.lua /usr/local/share/lua/5.4/
	
install-mingw:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libpgsqllua.dll /usr/local/lib/lua/5.4/
	cp pgsql.lua /usr/local/share/lua/5.4/

install-macos:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libpgsqllua.dylib /usr/local/lib/lua/5.4/
	cp pgsql.lua /usr/local/share/lua/5.4/

test:
	cd ../test && lua test-liblualua.lua -v #> README
