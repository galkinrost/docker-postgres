docker-postgres
===============
```sh
docker run galkinrost/docker-postgres -p 5432:5432 \
                                      -v /path/to/local/data:/var/lib/postgresql/data \
                                      -e TIMEZONE=Europe/Moscow \
                                      -e LOCALE=ru_RU \
                                      -e POSTGRES_DB=database_name \
                                      -e POSTGRES_TEMPLATE=template0 \
                                      -e POSTGRES_USER=user_name \
                                      -e POSTGRES_PASSWORD=password
```
