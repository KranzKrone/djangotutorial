#!/bin/sh
prefix="[docker-entrypoint.sh]"
project_name="main"
​
echo "${prefix} collect statics"
if [ ! -d "static/" ]
then
    echo "${prefix} created static directory"
    mkdir "static"
fi
python manage.py collectstatic --noinput
​
echo "${prefix} create db migrations"
python manage.py makemigrations --noinput
python manage.py makemigrations app_secrets connectors finnerds --noinput
​
if [ -z "${SKIPMIGRATIONS+x}" ]; then
	echo "${prefix} apply db migrations"
	python manage.py migrate --noinput
else
	echo "${prefix} faking migrations"
	python manage.py migrate --noinput --fake
​
fi
​
if [ ! -z $DOCKER ]; 
then 
	DEFAULTSITE=localhost
fi
​
echo "${prefix} set default domain name"
DEFAULTSITE=${DEFAULTSITE:-"localhost"}
DEFAULTSITENAME=${DEFAULTSITENAME:-$DEFAULTSITE}
python manage.py set_default_site --name "$DEFAULTSITENAME" --domain "$DEFAULTSITE"
​
python manage.py runserver 0:8000
