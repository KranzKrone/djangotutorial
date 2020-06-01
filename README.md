# Django Tutorials

My Django learner repro


## Docker

Docker enables isolation of duties, and capsulates processes from each other. Finally, it does not make it necesarry to install localy anymore, you just run docker images; like 

    $ docker run --name some-redis -d redis

If you have your own Dockerfile, with your required content for the image to run follow these simple steps, build, run, stop/kill. 

Be aware that docker images are one-time storage images, and once gone the content is gone. If you need to keep things use a seperate storage/file system/database for this.

### Build

    $ docker build .  --file Dockerfile -t your_tag:your_version 

### Run

Use the image, with your portnumber for the access from the internet, and your local port

    $ docker run (-d) -p 8000:8000 your_tag:your_version 

### Check

    $ docker ps

### Stop

    $ docker [stop,kill] container_name
