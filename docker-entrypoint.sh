#!/bin/sh
prefix="[docker-entrypoint.sh]"
project_name="main"
echo "${prefix} collect statics"
if [ ! -d "static/" ]
then
    echo "${prefix} created static directory"
    mkdir "static"
fi
python manage.py collectstatic --noinput
echo "${prefix} create db migrations"
python manage.py makemigrations --noinput
python manage.py makemigrations chat --noinput
if [ -z "${SKIPMIGRATIONS+x}" ]; then
	echo "${prefix} apply db migrations"
	python manage.py migrate --noinput
else
	echo "${prefix} faking migrations"
	python manage.py migrate --noinput --fake
fi
python manage.py runserver 0.0.0.0:8000
