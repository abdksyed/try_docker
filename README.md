# DOCKER

## Docker Commands

### run

`docker run <image-name>` -> Runs the image, if not there pulls it from docker hub and run. (Create container and run in attach mode.)

`docker run -d <image-name>` -> Runs the container, but get's detached from the container and gives access back to the terminal.

`docker run <image-name>:<tag>` -> Runs the image of particular version/tag.

`docker run -i <image-name>` -> Runs the image in the interactive mode, but the container terminal is  not attached.

`docker -it <image-name>` -> Runs the image with pseudo-terminal which is attached to our terminal.

#### port mapping

`docker run -p <external-port>:<internal-port> <image-name>` -> Runs the image which is running on port <internal-port> of the docker container, and maps it to the <external-port> of the docker host, to be used outside.  

#### volume mapping

`docker run -v /<path-to-external-folder>:/<path-to-container-folder> <image-name>` -> Assume MySQL is running on `/var/lib/mysql` inside the container and to map the database to outside folder `/opt/datadir`. 

### attach

`docker attach <container-id>/<container-name>` -> Attach the terminal back to running the container. 

### ps

`docker ps` -> List all the **running** containers, gives the details like container-id(random), image, command, created, status, ports and name(random or given)

`docker ps -a` -> List all the containers (running or not)

### stop

`docker stop <contatiner-id>/<container-name>` -> Stops the provided container.

##### Stopping all running containers

`docker stop $(docker ps -q)` -> We can pass the list of the container ids by giving the `docker ps -q` which list the container ids.

### rm

 `docker rm <container-name>/<container-id>` -> Remove the container. 

> The container to be removed must be closed

`docker container prune` -> Removes all the closed containers.

`docker rm $(docker ps -a -q)` -> Removes all the closed containers.



`docker rmi <iamge-name>` -> Removes the mentioned image

>  There must be no containers present of the image which is to be removed.

### pull

`docker pull <image-name>`  -> Pulls the image from the docker hub. (Download it to local and NOT run it)

### <appending command>

Containers only lives as long as the process inside it is alive. Since images like ubuntu or any other OS are not doing any process, when they are run they exit immediately after running, as there is no process to be done.

So we can append a command while running the image to be executed after the container is up. As soon as the command is executed the container stops again.

`docker run ubuntu sleep 200` This  will run the ubuntu image and run a container, and runs the `sleep 200` command which will sleep the container for 200 seconds. After the end of the command, the container stops.

### exec

`docker exec <container-name>/<container-id> <command>` -> Run the given command on the running container.

 ### inspect

`docker inspect <container-naem>/<continaer-id>` -> Returns a JSON with all the details of the container.

### logs

`docker logs <container-name>/<container-id>`-> Shows all the logs which was written to the standard out of the container.

### e

`docker run -e <ENV_VAR>=<env_value> <iamge-name>` -> Runs the image with the provided environment variable.

### build

`docker build . -t <application-name>:<tag>` -> In the root folder, where there is Dockerfile present, the `build` command will build the image with the <application-name> as the name of the image.

## CMD vs ENTRYPOINT

```dockerfile
FROM Ubuntu

CMD sleep 5 # CMD command param
# or
CMD ["sleep", "5"] # CMD ["command", "param"]
```

Now building this new Image, will build on top of ubuntu and automatically run the `sleep 5` command.

But what if we want to sleep for 10 seconds instead of 10, for that we will have to pass the command while running the app

`docker run <application-name> sleep 10` -> This will overwrite the CMD command when running.

But what if we only want to pass the argument for sleep, which is 5 or 10 seconds, and not the entire command, here we can used `ENTRYPOINT`

```dockerfile
FROM Ubuntu

ENTRYPOINT ["sleep"]
```

`docker run <application-name> 10` -> When the container start it will take the `entry point` value of sleep and append  the passed argument during docker run, and run the command.

But running the image without any argument will through error as `sleep` won't get any argument.

Hence to have default argument to sleep, we can not use CMD along with ENTRYPOINT

```dockerfile
FROM Ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```

This will run `sleep 5` when not given any argument while docker run, but if given any argument of 10 or 15, will replace 5 with that.

> CMD gets replaced if given any command during docker run. Whereas ENTRYPOINT gets append to the command passed.

If we want to modify entrypoint during runtime:

`docker run --entrypoint <some-other-command> <application-name> <command-arg>`

<some-other-command> will replace the `sleep` command in the ENTRYPOINT while running the image.

## Storage

Docker create the file system in the following format

```
/var/lib/docker
	- aufs
	- containers
	- image
	- volumes
```

##### Creating folder to map to container

`docker volume create <volume-name>` -> Creates a folder inside the volumes folder.

`docker run -v <volume-name> : /var/lib/mysql mysql`-> Creates `mysql` container and the `/var/lib/mysql` is the default location where mysql stores the data, mapping that to our created folder.

We can directly do the run command with `-v` with the `volume-name` without explicitly creating folder, since if docker doesn't find the folder it automatically creates folder for us.  

