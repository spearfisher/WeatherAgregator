# Test app for forecasts data aggregation
 
This document describes how to launch this Ruby on Rails application.

There are several options for app launching: with docker or manual.

Application uses MongoDB, Redis and Sidekiq. So all those applications should be started before rails, or just use docker.

 ## Start application with docker
 
 * Check `docker-compose.yml` for MongoDB and Redis ports. Enter your free ports if needed.
 * Enter your `REDIS_URL` variable if you've changed Redis host in `docker-compose.yml`
 * Run `docker-compose up --build`
 * Open [localhost:3000](http://localhost:3000)
 * To shutdown hit `CTRL+C` and run `docker-compose stop`

 ## Manual application start:
 * Install and start MongoDB and Redis if needed
 * Enter custom MongoDB connection in `config/mongoid.yml` file. Check development section.
 * Enter custom Redis url in `.env` file. See `REDIS_URL` variable which is `redis://redis:6379/1` by default.
   Change it to `redis://localhost:6379/1` if you have redis enabled on `localhost:6379`
 * `bundle install`
 * Run application server `rails s`
 * Run worker in different tab `bundle exec sidekiq`
 * Open [localhost:3000](http://localhost:3000)
