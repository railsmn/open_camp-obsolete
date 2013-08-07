Session 5 - August 12, 2013
===========================

## Introduction (30 minutes)
#### 1. Welcome and logistics
#### 2. [Session 4](https://github.com/railsmn/schedule/blob/master/open_camp/session3.md) - Recap
#### 3. No updates to your Virtual Machine!
#### 4. Session 5 Overview

- Gem Maintenance
- Organize notes and tasks under a Project

## Hack Time (90 minutes)

#### 1. Gem Maintenance
  
  1. Making ```rake spec``` work
  
  ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/68cf0d818a781f0e9c424fd2312c8ef8b69a9fcc))
  
  We introduced RSpec as our testing framework in session 2. We relied on the command ```rake spec``` to run our test suite. Somewhere since session 2, we changed the Rails Environment or Rake tasks to no longer start and run the RSpec test suite.
  
  The change that cause this is that the ```rspec-rails``` gem is listed under the ```test``` environment, and not under the development environment. Since you use the development environment by default when you run ```rake spec```, you don't have access to the ```rspec-rails``` Rake tasks.
  
  We can fix this by grouping all the development and test environment gems under one group ([link to git diff with changes](#)).
  
  ```ruby
  # Gemfile
  
  group :development, :test do 
      gem 'rspec-rails'
      gem 'shoulda'
      gem 'better_errors'
      gem 'binding_of_caller'
      gem 'meta_request'
      gem 'pry-rails'
      gem 'awesome_print'
  end
  ```
  
  2. Move ```quiet_assets``` to development/test group
  
  ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/748b6f9cfbba88924c646e1058a4bb49b86259e2))
  
  We should move the quiet_assets within the development/test 'block' since the [quiet_assets README](https://github.com/evrone/quiet_assets/blob/master/README.md) file suggests it.
  
  3. Bundle Update
  
  ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/edb13788917b6801951b665f3e61dc2d76dfcb6a))
  
  Recently, a couple of our major gems released new versions. Most notably, Rails release 3.2.14. Let's update the ```Gemfile```'s reference to rails an run a bundle udpate, 
  
  ```ruby
  # Gemfile
  
  gem 'rails', '3.2.14'
  ```
  
  then run, 
  
  ```shell
  # /vagrant/open_camp
  
  bundle update
  ```
  
  Before we keep going, you should take a brief look through of the changes whenever you run a bundle update. It's good to note which gems changed, and which one's had major/minor/maintenance. For large production Rails apps, it's recommended to investigate potential gem update impacts before updating gems. But since there's few gem changes and it's a smaller app, we're fine rolling with a gem update.
  
  4. Remove TestUnit
  
  ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/16d77f9e45913f34142a6e7837218e51d3aafd57))
  
  We're going to be working with RSpec in future sessions, and we'd like to remove TestUnit, the other testing framework that came by default when we created the rails app.
  
  ```shell
  # /vagrant/open_camp
  
  rm -rf test
  ```
  
  5. Setup RSpec Generators
  
  ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/511794e1ed63ff53ca2edf286415b75e58ec9d76))
  
  Since we've committed to RSpec, let's tell rails to automatically generate RSpec test files for us as we create new model and controller files. We don't care about view or routing  specs at the moment, but we do want model, controller, helper, and request RSpec files to be generated each time we create a file that will be covered by one of those test types.
  
  ```ruby
  # application.rb
  
    module OpenCamp
      class Application < Rails::Application
        ....
        config.generators do |g|
          g.test_framework    :rspec, fixture: false
          g.model_specs       true
          g.controller_specs  true
          g.helper_specs      true
          g.request_specs     true
          g.view_specs        false
          g.routing_specs     false
        end
        
      end
    end
  ```
  
#### 2. Organize notes and tasks under a Project

