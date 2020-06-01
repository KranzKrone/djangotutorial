# djangotutorial
My learning Django repro

## Docker

### Build

    $ docker build .  --file Dockerfile -t your_tag:your_version 

### Run

Use the image, with your portnumber for the access from the internet, and your local port

    $ docker run (-d) -p 8000:8000 your_tag:your_version 

### Check

    $ docker ps

### Stop

    $ docker [stop,kill] container_name
