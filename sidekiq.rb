### Active job with Redis and Sidekiq

## Normal request

1. Browser--->HTTP request---> webserver--->middelware--->routes.rb--->controller.rb--->model.rb--->database--->model.rb---->controller.rb--->middleware--->webserver--->http response--->browser.

## With active job

2. Browser--->HTTP request---> webserver--->middelware--->routes.rb--->controller.rb--->Queue--->Worker.rb--->Http request--->destination.

## Redis

1. Redis is a datbase, that we will use as queue for our application to write to.

## Sidekiq

1. Sidekiq is a ruby library for managing worker processes for rails appliaction. it reads the queue to perform the jobs.

2. edit config/application.rb file
   config.active_job.queue_adapter = :sidekiq

3. edit config/initializers/sidekiq.rb
   Sidekiq.configure_server do |config|
   config.redis = { url: 'redis://localhost:6379' }
   end
   Sidekiq.configure_client do |config|
   config.redis = { url: 'redis://localhost:6379' }
   end

## ways of performing jobs

# In rails console

1. try JobName.perform_now or JobName.perfrom_later

# With rails controllers

1. User JobName.perfrom now directly or put it inside a instance method to access from CRUD controller.

## Steps to use Sidekiq in project

1. gem 'sidekiq', aslo sinatra as sidekiq is written in sinatara.
2. Sidekiq comes with Web User Interface, to access it.
3. require 'sidekiq/web' in routes.rb and mount it.
4. mount Sidekiq::Web => "/sidekiq "
5. Go to localhost:3000/sidekiq to access the sidekiq web ui.

## Steps to put a job on the queue, and build a worker that can actuallly process the job and monitor from the UI.

# Build sidekiq worker

1. Into the job folder create the jobs or custom approach
2. class nameWorker
   include Sidekiq::Worker
   ...sidekiq_options retry: false
   ...def perform(args)
   .....#work
   ...end
3. To put the message on the queue, we have to use controller
   def jobmethod
   ...nameWorker.perform_async(args)
   render text: "Added the request to the queue"
   end

# Run the job

1. Go to the cmd and run sidekiq with or without threads.
2. sidekiq -c 1

### Simple and fast steps to implement Sidekiq

1. Add sidekiq to your Gemfile
2. Add a worker in app/workers to process jobs asynchronously: rails generate sidekiq:worker hard
3. class HardWorker
   include Sidekiq::Worker
   def perform(name, count)
   #do something
   end
   end
4. Create a job to be processed asynchronously: HardWorker.perform_async('bob', 5)
5. Start sidekiq from the root of your Rails application so the jobs will be processed: bundle exec sidekiq
