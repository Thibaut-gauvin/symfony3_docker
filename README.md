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

Check that you can use docker commands without sudo ! **[LINUX USER ONLY]**
- To run docker command without sudo, you need to add your user (who has root privileges) to docker group & restart your sessions.
      
        $ sudo usermod -aG docker <user_name>

**-----------------------------------------------------**

## Installation:

A Makefile is used to provide some useful shortcuts for manipulating docker & docker-compose commands

- **1- Create .env file :**   

  First, you need to create a copy of `.env.example` and call it `.env`
  
        # Assume you are in project root, on Unix system
        $ cp .env.example .env
        
  This files contains sensible data that not be committed on GIT, you can modify it to you own needs !

- **1- Set the .env file :**   

  Update variables in `.env` file to fit your config 
  
        # Assume you are in project root, on Unix system
        $ vi .env
        
  Because we use [grumphp](https://github.com/phpro/grumphp), we need to configure git inside the container to be able to commit properly

- **2- Make the :coffee: :**

    Run following command :
    
        $ make init
        
	This command will create & build Docker images, also start & configures required Containers, and run provisioning script.
	A lot of stuff is downloaded from Internet, so it can take a lot of time, depending on your Internet speed. 
        
- **3- Your done !**

You can now access to following services on your host machine:

- **Symfony app [http://localhost](http://localhost)**
- **Mailhog [http://localhost:1080](http://localhost:1080)**
- **PhpMyAdmin [http://localhost:8080](http://localhost:8080)**

**When you reboot your computer :**  
- Just simply run following command to start your Containers (docker Images already created):

        $ make start

**-----------------------------------------------------**
        
## Makefile "tasks" :

You can read Makefile located at project root, it contain some comments on what "recipes" do.
Feel free to add more extra recipes depending on your needs.

	# List available make commands:
	$ make help


| Recipes         | Utility                                                            |
|-----------------|--------------------------------------------------------------------|
| start           | Start containers (Also builds & pull images, if there not exists)  |
| stop            | Stop containers & remove docker networks                           |
| list            | List current running containers                                    |
| ssh             | Start new bash terminal inside the Symfony Container               |
| init            | Execute "start" tasks and run provisioning scripts                 |
| tests           | Execute the entire Unitary & Functional PhpUnit tests suit         |
| code-coverage   | Run the entire tests with code coverage                            |
| logs            | Display current running containers logs (Press "Ctrl + c" to exit) |
| clean-sf-cache  | Clean symfony cache & logs files                                   |
| clean-container | Remove stopped useless containers                                  |
| help            | Display available make commands                                    |

**-----------------------------------------------------**

## Dev Tools :

You can use `make ssh` to connect inside the symfony container.

What is inside ?

- PHP 7.1-fpm with xdebug (dev) or OpCache & APCu (prod)
- Nodejs (6.x)
- [Yarn](https://yarnpkg.com/fr) 
- [Phpmetrics](http://www.phpmetrics.org)
- [Php-cs-fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)
- [Grumphp](https://github.com/phpro/grumphp)
- Git (with user config)
- [Tig](https://github.com/jonas/tig)

Other service 
- [Mailhog](https://github.com/mailhog/MailHog) for email testing during development
- [PhpMyAdmin](https://www.phpmyadmin.net/) a simply mysql administrator

**-----------------------------------------------------**

## Deploy in Production :

If you want to use in production, you need to : 
- Get SSL certificates, [Let's Encrypt](https://letsencrypt.org) provide them for free
- You also need to generate a `dhparam.pem` keys to enforce SSL encryption 

        # To generate your dhparam.pem file, run in the terminal
        openssl dhparam -out dhparam.pem 4096

- Copy your `fullchain.pem` & `privkey.pem` & `dhparam.pem` to `.data/web` directory
- Update `.env` file and set `ENV` to "prod"
- Update [nginx prod conf](.docker/prod/prod.conf) and set `server_name` at line 4 & line 39
- Run `make start`
- The first time, you need to build app yourself (like installing vendor & set parameter.yml ...)

Test your app, http redirect to https. [ssl labs](https://www.ssllabs.com/ssltest) analysis give you a A+ baby ! 
