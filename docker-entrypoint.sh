#!/bin/bash
set -e

chown -R postgres "$PGDATA"

echo $TIMEZONE > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

localedef -i $LOCALE -c -f UTF-8 -A /usr/share/locale/locale.alias $LOCALE.UTF-8

if [ "$1" = 'postgres' ]; then

	if [ -z "$(ls -A "$PGDATA")" ]; then

		gosu postgres initdb

		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

		{ echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf
	fi

	SINGLE="gosu postgres $@ --single"

    $SINGLE <<< "CREATE USER $POSTGRES_USER WITH SUPERUSER;" > /dev/null
    $SINGLE <<< "ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';" > /dev/null
    $SINGLE <<< "CREATE DATABASE \"$POSTGRES_DB\" OWNER $POSTGRES_USER TEMPLATE $POSTGRES_TEMPLATE;" > /dev/null

    exec gosu postgres "$@"
else
    gosu postgres pg_ctl start -w
	exec "$@"
fi
