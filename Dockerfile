FROM python:3.8-slim-buster
ENV PYTHONUNBUFFERED=1

# Tell our django app it's running inside docker container
ENV DOCKER=1
RUN apt update
RUN apt -y upgrade
RUN apt install -y python-pillow 
RUN apt install -y python3-psycopg2 gcc
RUN apt autoremove

# Application directory
RUN mkdir /app

# Copy requirements and install those
COPY ["requirements.txt", "/app/"]
WORKDIR /app
RUN pip3 install --trusted-host pypi.python.org --no-cache-dir -r requirements.txt
RUN rm /app/requirements.txt

# Generate directories for different types of static content in seperate directories
RUN mkdir media logs static

# Generate seperate Volumes (with the directories) for static files, media and logs
VOLUME ["$WORKDIR/media/", "$WORKDIR/logs/", "$WORKDIR/static/"]

# Copy application sources into django, this should be the same for all FinNerd projects
COPY [".", "$WORKDIR"]

# Now collect static files and move them into "/django/static"
ENV STATIC_ROOT .
RUN python3 manage.py collectstatic --noinput

# Copy runtime script (with setup config)
COPY ["docker-entrypoint.sh", "/usr/local/bin/"]

# Run applciation setup and service at exposed "default port"
EXPOSE 8000
HEALTHCHECK  --interval=5m --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:8000/ || exit 1
RUN adduser --quiet -system django
RUN chown -R django /app
USER django

# Use "Entrypoint" if user does not hand over a different CMD
ENTRYPOINT ["docker-entrypoint.sh"]

# Allow user to overwrite the default command
CMD ["gunicorn --bind 0.0.0.0:8000 main.wsgi"]
