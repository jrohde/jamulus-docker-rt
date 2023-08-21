# jamulus-headless-docker
Docker build with Jamulus Headless from source. \
If you want it to run it with real time priority capabilities you have to make sure that:

1. Your host has a realtime kernel with the PREEMPT_RT flag on (like Ubuntu RT, Xanmod RT or compile it yourself ;-)).
2. Give your container RT permissions when you start it. See: https://github.com/2b-t/docker-realtime.

The container will run jamulus-headless with some default CMD (see Dockerfile). \
To provide your own parameters - recommended or the jamulus directory will get bloated!! - you can start the container like this:

`docker run -i -t --rm smartlabel/jamulus /usr/bin/nice -n -20 /usr/bin/ionice -c 1 /usr/local/bin/jamulus-headless --version`

or with real-time capability like this:

`docker run -i -t --rm smartlabel/jamulus /usr/local/bin/jamulus-headless --version`

Of course you have to replace `--version` with your own server parameters if you really want to run a live Jamulus server. 
See https://jamulus.io/wiki/Running-a-Server for all the options you must/can provide.\

If you use the docker in a docker-compose.yml something like this should work:

CMD [/usr/bin/nice","-n","-20","/usr/bin/ionice","-c","1","/usr/local/bin/jamulus-headless","--version"]  

Happy Jammin!
