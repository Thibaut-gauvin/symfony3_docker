# GET STARTED WITH DOCKER :

More Infos :

[Docker Documentation](https://docs.docker.com/)

**-----------------------------------------------------**

## Prerequisites

Install [Docker](https://www.docker.com/) on your system.

- [Install instructions](https://docs.docker.com/installation/mac/) for Mac OS X
- [Install instructions](https://docs.docker.com/installation/ubuntulinux/) for Ubuntu
- [Install instructions](https://docs.docker.com/engine/installation/windows/) for Windows (prefer "Docker For Windows" than deprecated "Docker Toolbox")

Note that using "Docker Toolbox" on Windows OS can occur unexpected issues ... 

Install [Docker Compose](http://docs.docker.com/compose/) on your system.

- [Install instructions](https://docs.docker.com/installation/) for all supported systems

Check that you can use docker commands without sudo !
- To run docker command without sudo, you need to add your user (who has root privileges) to docker group & restart your sessions.
      
        $ sudo usermod -aG docker <user_name>

**-----------------------------------------------------**

## Installation:

A Makefile is used to provide some useful shortcuts for manipulating docker & docker-compose commands

- **1- Copying compose file :**   

  First, you need to create a copy of `.env.example` and call it `.env`
  
        # Assume you are in project root, on Unix system
        $ cp .env.example .env
        
  This files contains sensible data that not be committed on GIT, you can modify it to you own needs !
  
  Example: you can change Nginx listen port on your machine to avoid collision with other local apps

- **2- Make the :coffee: :**

    Run following command :
    
        $ make init
        
	This command will create & build Docker images, also start & configures required Containers, and run provisioning script.
	A lot of stuff is downloaded from Internet, so it can take a lot of time, depending on your Internet speed. 
        
- **3- Your done !**

You can now access to following services on your host machine:

- **[Application](http://symfony.dev/)**
- **[MailCatcher](http://localhost:1080)**
- **[PhpMyAdmin](http://localhost:8080)**

**When you reboot your computer :**  
- Just simply run following command to start your Containers (docker Images already created):

        $ make

**-----------------------------------------------------**
        
## Makefile "tasks" :

You can read Makefile located at project root, it contain some comments on what "recipes" do.
Feel free to add more extra recipes depending on your needs.

	# List available make commands:
	$ make help


Recipes List:

| Recipes         | Utility                                                            |
|-----------------|--------------------------------------------------------------------|
| start           | Start containers (Also builds images, if there not exists)         |
| stop            | Stop containers (And also remove it)                               |
| list            | List current running containers                                    |
| init            | Execute "start" tasks and run provisioning scripts                 |
| ssh             | Start new bash terminal inside the Symfony Container               |
| metrics         | Run the PhpMetrics analysis (output report.html)				   |
| logs            | Display current running containers logs (Press "Ctrl + c" to exit) |
| prod            | Execute "make" cmd & give environment variable "env" = prod        |
| clean-container | Remove stopped useless containers                                  |
| help            | Display available make commands                                    |
