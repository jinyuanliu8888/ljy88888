# README #

### Abstract ###
Campus Flora maps the locations of more than 2000 individual plants from over 70 families on campus grounds and provides a botanical description of each plant and information on its distribution. Campus Flora not only extends the teaching of botany from the classroom into the University of Sydney campus grounds but it enables us to share our learning resources with the broader community.

“Trails” highlight the important aspects of select plant groups and we have initially developed these to align with the current botanical curriculum. We encourage those using Campus Flora to provide us with feedback: each species page allows users to offer feedback, and we will use this to shape future versions and develop additional trails.
 
The project team acknowledges the support of the School of Biological Sciences and University grounds staff.
 
Project team:  Rosanne Quinnell, Lachlan Pettit, Matthew Pye, Angela Pursey, Xiaolong Wang, Nic Barker (bitbucket / github username nicbarker), Caroline Cheung, Grant Zeng.
  
This web repository was built and maintained by Nic Barker and as a result all tech related questions should be directed to him.

This README aims to document the design process behind the app, as well provide instructions on branching and installing your own copy of the app for your institution or just for personal interest.  

## Stack
### Backend ###
* ruby 2.2.0
* Rails 4
* MySQL via mysql2 gem

### Frontend ###
* CoffeeScript
* SCSS
* Backbone.js
* Google maps Javascript API

### Deployment ###
* Capistrano 3

## Install Requirements ##
Campus Flora runs on Ruby On Rails - and while you can certainly run this on a simplified service provider like Heroku, it's recommended that you run this on a plain old Linux VPS.  
The University of Sydney is using Digital Ocean for this project, but there are many others such as Linode or Amazon AWS that are all great.

## Install Guide ##

### Environment Setup ###
This project has been configured for local development using Docker, and of course you can also use docker to deploy the app in production if you like.

* Download and configure Docker for your platform (strongly recommend native installation on Mac, see ([https://docs.docker.com/docker-for-mac/](https://docs.docker.com/docker-for-mac/))
* If you're on Linux or Windows download [docker-compose](https://docs.docker.com/compose/) (it's automatically installed as part of Docker for mac)
* Clone the repository with `git clone git@bitbucket.org:bio_eru/campusfloraweb.git`
* Run `docker-compose up` inside the campusfloraweb directory. Docker will take care of the rest, be warned this involves some quite large downloads and may take some time.
* Run the rails migrations to get the database up to date with `docker-compose run rails rake db:migrate`
* Navigate to [http://localhost:3000](http://localhost:3000) and you should see the campus flora app.  
* You should be able to login at localhost:3000/admin with the username 'admin@example.com' and password 'password'. **Please** change this!  
  
If you have any issues, please don't hesitate to [refer to the wiki.](https://bitbucket.org/bio_eru/campusfloraweb/wiki)