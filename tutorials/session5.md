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
  
  2. Move `quiet_assets` to development/test group
  
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

  So far, users are able to create Tasks and Notes within the Rails app. This is great, but we want them to create these Tasks and Notes in the content of a Project. Therefore, we'll need to create Project model, controller, view, and asset files (javascript, css). We'll also need to "nest" the Task and Note objects to exist within the context of a Project.

  1. Create the Project Model
    
    ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/6c3a506c323a3e6e5c4e5420a460236c97c1869a) - __NOTE:__ schema.rb file changed because we ran `rake db:migrate`)
      
    Let's go ahead and create the project.

    ```shell
    # /vagrant/open_camp
    
    rails g model Project name:string
    
    ### OUPUT
    
    vagrant@rails-dev-box:/vagrant/open_camp$ rails g model Project name:string
        invoke  active_record
        create    db/migrate/20130807201045_create_projects.rb
        create    app/models/project.rb
        invoke    rspec
        create      spec/models/project_spec.rb
    ```
    
    Let's also run the migration to create the `projects` table in the database.
    
    ```shell
    rake db:migrate
    ```
    
  2. Relate a Project to Tasks and Notes
    
      We can relate a Project with Notes and Tasks through the Rails::AcitveRecord ```belongs_to``` and ```has_many``` declarations. And here's where it gets really fun. Rather than merely typing in the relationships, we can practice a little TDD action by:
    
        1. write the RSpec tests for the relations
        2. run the tests and see the tests fail
        3. implement the relations and see the tests pass
      
      1. RSpec Tests
      
        ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/f2913e38a78cebb3e76714823e813fd3c45c3b92))
        
        We'll use the ```shoulda``` gem's rspec expectation matchers to test the ActiveRecord inter model relationships. Make the following changes,
        
        ```ruby
        # spec/models/project_spec.rb
        
        require 'spec_helper'
        describe Project do 
          it { should have_many :tasks } 
          it { should have_many :notes } 
        end
        ```
        
        
        ```ruby
        # spec/models/note_spec.rb
        
        require 'spec_helper'
        describe Note do 
          it { should belong_to :project }
        end
        ```
        
        
        ```ruby 
        # spec/models/task_spec.rb
        
        require 'spec_helper'
        describe Task do 
          it { should belong_to :project } 
        end
        ```
        
      2. Run tests and see tests fail
    
        (no code changes)
      
        ```shell
        # /vagrant/open_camp
        
        rake spec
        
        ### OUTPUT
        
        Failures:

          1) Project should have many notes
             Failure/Error: it { should have_many :notes }
               Expected Project to have a has_many association called notes (no association called notes)
             # ./spec/models/project_spec.rb:5:in `block (2 levels) in <top (required)>'

          2) Project should have many tasks
             Failure/Error: it { should have_many :tasks }
               Expected Project to have a has_many association called tasks (no association called tasks)
             # ./spec/models/project_spec.rb:4:in `block (2 levels) in <top (required)>'

          3) Note should belong to project
             Failure/Error: it { should belong_to :project }
               Expected Note to have a belongs_to association called project (no association called project)
             # ./spec/models/note_spec.rb:4:in `block (2 levels) in <top (required)>'

          4) Task should belong to project
             Failure/Error: it { should belong_to :project }
               Expected Task to have a belongs_to association called project (no association called project)
             # ./spec/models/task_spec.rb:4:in `block (2 levels) in <top (required)>'

        Finished in 0.09836 seconds
        5 examples, 4 failures

        Failed examples:

        rspec ./spec/models/project_spec.rb:5 # Project should have many notes
        rspec ./spec/models/project_spec.rb:4 # Project should have many tasks
        rspec ./spec/models/note_spec.rb:4 # Note should belong to project
        rspec ./spec/models/task_spec.rb:4 # Task should belong to project

        Randomized with seed 43519
        ```
        
      3. Implement the relations and see the tests pass
          
        ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/f4578dc26e6f63221fa6f305b7ee1e8ec4e27ec8))
          
        So let's go back and implement the ActiveRecord relationhips in the models. 
        
        We'll need to write a migration to add the `project_id` to the Tasks and Note tables. Create the migration using the `rails generate migration` command.
        
        ```shell
        # /vagrant/open_camp
        
        rails generate migration AddProjectIdToTasksAndNotes
            invoke  active_record
            create    db/migrate/20130807211028_add_project_id_to_tasks_and_notes.rb
        ```
        
        Use the `add_column` to tell Rails to create a new column `project_id` in for the `tasks` and `notes` tables.
        
        ```ruby
        # db/migrate/20130807211028_add_project_id_to_tasks_and_notes.rb
        
        class AddProjectIdToTasksAndNotes < ActiveRecord::Migration
            def change
              add_column :tasks, :project_id, :integer
              add_column :notes, :project_id, :integer
            end
        end
        ```
        
        Run the migration.
        
        ```shell
        # /vagrant/open_camp
        
        rake db:migrate
        
        ### OUTPUT
        
        ==  AddProjectIdToTasksAndNotes: migrating ====================================
        -- add_column(:tasks, :project_id, :integer)
           -> 0.0030s
        -- add_column(:notes, :project_id, :integer)
           -> 0.0009s
        ==  AddProjectIdToTasksAndNotes: migrated (0.0055s) ===========================
        ```

        Update the models,
        
        ```ruby
        # app/models/project.rb
        
        class Project < ActiveRecord::Base
            has_many :notes
            has_many :projects
        end
        ```
        
        
        ```ruby
        # app/models/note.rb
        
        class Note < ActiveRecord::Base
            belongs_to :project
        end
        ```
        
        
        ```ruby
        # app/models/task.rb
        
        class Task < ActiveRecord::Base
            belongs_to :project
        end
        ```
        
        And with those changes, run the tests again to see the tests pass.
        
        ```shell
        # /vagrant/open_camp
        
        rake spec
        
        ### OUTPUT
        /home/vagrant/.rvm/rubies/ruby-2.0.0-p247/bin/ruby -S rspec ./spec/models/note_spec.rb ./spec/models/project_spec.rb ./spec/models/task_spec.rb ./spec/models/user_spec.rb
        .....

        Finished in 0.10059 seconds
        5 examples, 0 failures

        Randomized with seed 54209
        ```
    
  3. Create the Project Controller, View, and Asset files
  
    ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/c16d6a63b97bcf223f580fd81a3dae0ca3d80703))
    
    Since we'll want to create and interact projects, we'll need to create Project routes and a controller to receive RESTful HTTP requests. We can create the Controller and Views via Rails' `scaffold_controller` generator rather than having to manually create all mentioned files.
    
    ```shell
    # /vagrant/open_camp
    
    rails generate scaffold_controller Project name:string
    
    ### OUTPUT

    create  app/controllers/projects_controller.rb
    invoke  erb
    create    app/views/projects
    create    app/views/projects/index.html.erb
    create    app/views/projects/edit.html.erb
    create    app/views/projects/show.html.erb
    create    app/views/projects/new.html.erb
    create    app/views/projects/_form.html.erb
    invoke  rspec
    create    spec/controllers/projects_controller_spec.rb
    invoke    rspec
    create      spec/requests/projects_spec.rb
    invoke  helper
    create    app/helpers/projects_helper.rb
    invoke    rspec
    create      spec/helpers/projects_helper_spec.rb
    
    ```
    
    And we want to create the Javascript and Stylesheet files too. Rails has a niffy generator for that too.
    
    ```shell
    # /vagrant/open_camp
    
    rails generate assets Projects
    
    ### OUTPUT
    
    invoke  coffee
      create    app/assets/javascripts/projects.js.coffee
      invoke  scss
      create    app/assets/stylesheets/projects.css.scss
    ```
    
    Lastly, add projects' route to your OpenCamp's `routes.rb` file.
     
    ```
    # config/routes.rb
    
    OpenCamp::Application.routes.draw do
      resources :projects
    end
    ```
    
    And notice that tests are still passing,
    
    ```shell
    # /vagrant/open_camp
    
    rake spec
    
    ### OUTPUT
    
    /home/vagrant/.rvm/rubies/ruby-2.0.0-p247/bin/ruby -S rspec ./spec/controllers/projects_controller_spec.rb ./spec/helpers/projects_helper_spec.rb ./spec/models/note_spec.rb ./spec/models/project_spec.rb ./spec/models/task_spec.rb ./spec/models/user_spec.rb ./spec/requests/projects_spec.rb
    ................*......

    Pending:
      ProjectsHelper add some examples to (or delete) /vagrant/open_camp/spec/helpers/projects_helper_spec.rb
        # No reason given
        # ./spec/helpers/projects_helper_spec.rb:14

    Finished in 0.48086 seconds
    23 examples, 0 failures, 1 pending

    Randomized with seed 53916
    ```
    
  4. Nest Notes and Task under a Project
  
    Now comes the real Ruby on Rails 'magick'. Hold onto your seats folks, we're about to jump to lightspeed. We want to nest Tasks and Notes within a project. Or, in other words, we want to interact with Tasks and Notes always within the context of a Project. 
    
    We've already related the Projec model with the Task and Note models, AND written specs to prove this works (woot!). Now we'll nest the Task and Note controllers within the Project controller, and modify the Taks and Note view files to refernce the Project they're related to.
    
    Let's begin!
    
    1. Nest the Task and Note Controllers
    
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/e37c6a037201996bacec9f4600ca5272e102119f))
      
      Rails allows (and encourages) us to nest URL routes in order to more explicitly describe object relationships. By placing `resources :tasks` and `resources :notes` inside the `resources :proects` block, we're telling rails that each project has many tasks and notes.
      
      ```ruby
      OpenCamp::Application.routes.draw do
          resources :projects do 
              resources :tasks
              resources :notes
          end
          
          root to: 'projects#index'
      end
      ```
      
      To better understand the impact of this, run `rake routes` to see the resulting URLs that are available to us, 
      
      ```shell 
      # /vagrant/open_camp
      
      rake routes
      
      ### OUTPUT
      
           project_notes GET    /projects/:project_id/notes(.:format)          notes#index
                         POST   /projects/:project_id/notes(.:format)          notes#create
        new_project_note GET    /projects/:project_id/notes/new(.:format)      notes#new
       edit_project_note GET   /projects/:project_id/notes/:id/edit(.:format) notes#edit
            project_note GET    /projects/:project_id/notes/:id(.:format)      notes#show
                         PUT    /projects/:project_id/notes/:id(.:format)      notes#update
                         DELETE /projects/:project_id/notes/:id(.:format)      notes#destroy
           project_tasks GET    /projects/:project_id/tasks(.:format)          tasks#index
                         POST   /projects/:project_id/tasks(.:format)          tasks#create
        new_project_task GET    /projects/:project_id/tasks/new(.:format)      tasks#new
       edit_project_task GET   /projects/:project_id/tasks/:id/edit(.:format) tasks#edit
            project_task GET    /projects/:project_id/tasks/:id(.:format)      tasks#show
                         PUT    /projects/:project_id/tasks/:id(.:format)      tasks#update
                         DELETE /projects/:project_id/tasks/:id(.:format)      tasks#destroy
                projects GET    /projects(.:format)                            projects#index
                         POST   /projects(.:format)                            projects#create
             new_project GET    /projects/new(.:format)                        projects#new
            edit_project GET    /projects/:id/edit(.:format)                   projects#edit
                 project GET    /projects/:id(.:format)                        projects#show
                         PUT    /projects/:id(.:format)                        projects#update
                         DELETE /projects/:id(.:format)                        projects#destroy
      
      ```
      
      Notice that we can now have an all the original `resource` routes, but we now have them inside the specific context of a project.
      
    2. Remove Task and Note links on Header
    
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/4b073e1585c7c7a9da10c5733612a773e08e434b))
    
      Let's remove the Task and Note links on the header since we redefined the routing logic. We can replace those links with a "Projects" link,
      
      ```ruby
      # views/layouts/_header
      <%= link_to 'OpenCamp', '/projects', class: 'brand' %>
      <% if user_signed_in? %>
        <ul class='nav'>
          <li>
            <%= link_to 'Projects', projects_path %>
          </li>
        </ul>
        <%# ... other code ... %>
      <% else %>
      ```
      
    3. Create link for user to create a project task and note
      
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/9e69038f36806ec6a1cf485176590817f7f21ee1))
    
      Let's go a project page, and drop a link for the user to create a Project specific Note and Task,
    
      
      ```ruby
      # views/projects/show.htm.erb
      
      <%= link_to 'New Project Task', new_project_task_path(@project) %> |
      <%= link_to 'New Project Note', new_project_note_path(@project) %> |
      <%= link_to 'Edit', edit_project_path(@project) %> |
      <%= link_to 'Back', projects_path %>
      ```
      
      __NOTE:__ If you click on the these links, you'll see that the Task and Note pages are broken because of the nested URL changes.  We'll fix the Task and Note pages in the next step.
      
      
    4. Redo Task index/_form/show view files to reflect the being nested under Project
    
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/bcfb4df987f70fd4716b6ec33595754ca58bcc44))
      
      Next we want the Task HTML views to reflect the project to which the task is related. Or, more technically correct, we want the links in the HTML to reflect the nested URL structure, EG, `/projects/1/tasks/4`. We saw the beginning of this in the previous changes when we created the "New Task" and "New Note" links.
      
      Let's start by changing the links on the `index` page.
      
      ```ruby
      # app/views/tasks/index.html.erb
      
      <td><%= link_to 'Show', project_task_path(@project, task) %></td>
      <td><%= link_to 'Edit', edit_project_task_path(@project, task) %></td>
      <td><%= link_to 'Destroy', project_task_path(@project, task.id), method: :delete, data: { confirm: 'Are you sure?' } %></td>
            
      ....
      
      <%= link_to 'New Task', new_project_task_path(@project) %>
      ```
      
      As you can see, the `_path` helper method allows us to input multiple objects. This allows us to describe the nested URL route structure we defined the in the `routes.rb` file.
      
      Also notice that `_path` is intaking a full Ruby object, EG `@project`. The dynamic path helpers can take a full Ruby object, or a single key-value pair inputs, which are translated to HTTP params like this, `?key1=value1&key2=value2`.
      
      Update the `new` links, 
      
      ```ruby
      # app/views/tasks/new.html.erb
      
      <%= link_to 'Back', project_tasks_path(@project) %>
      ```
      
      Update the `_form` links.
      
      All we need to do is add the `project` to the form's url, which we can do thorugh a small tweak,
      
      ```ruby
      # app/views/tasks/index.html.erb
      <%= form_for([@project, @task]) do |f| %>
      ```
      
      Update the `show` page.
     
      ```ruby
      # app/views/tasks/new.html.erb
      
      <%= link_to 'Edit', edit_project_task_path(@project, @task) %> |
      <%= link_to 'Back', project_tasks_path(@project) %>
      ```
      
      Update the `edit` page.
      
      ```ruby
      # app/views/tasks/edit.html.erb
      
      <%= link_to 'Show', project_task_path(@project, @task) %> |
      <%= link_to 'Back', project_tasks_path(@project) %>
      ```
      
    5. Change the mailer url for a task
    
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/b5ea7048922c5891fce4c1e1312657112f678167))
      
      We need to update the mailer's link for a created task, 
      
      ```ruby
      # app/mailers/task_mailer.rb
      
      def task_creation(task)
          @task = task
          @project  = @task.project
          mail to: task.user.email, subject: "New Task Created: #{task.name}"
      end
      ```
      
      
      ```ruby
      # app/views/tasks_mailer.rb
      
      You may access this Task at <%= project_task_url(@project, @task) %>.
      ```
      
    6. Update the Task Controller to handle nested tasks
    
      ([link to git diff with changes](https://github.com/railsmn/open_camp/commit/00e7d7222712774c0b2cba5b91090bef6d56ac4c))
      
      Now we need to change the `tasks_controller.rb` to be aware of and supply the `@project` instance variable we defined in the HTML views.
      
      Starting with the `index` action. Only get the tasks for the project.
      
      ```ruby
      # app/controllers/tasks_controller.rb
      
      def index
          @project = Project.find(params[:project_id])
          @tasks = @project.tasks

          respond_to do |format|
              format.html # index.html.erb
              format.json { render json: @tasks }
          end
      end
      ```
        
      `new` action. Supply a `@project` instance variable.
      
      ```ruby
      # app/controllers/tasks_controller.rb
      def new
          @project = Project.find(params[:project_id])
          @task = Task.new

          respond_to do |format|
              format.html # new.html.erb
              format.json { render json: @task }
          end
      end
      ```
      
      For the rest of controller actions, we'll implement the same pattern. Since we only want give the user tasks within a specific project, we'll only search for tasks that are related to the project. Therefore, for 
      
      - show
      - edit
      - update
      - destroy
      
      get the `@project` and `@task` variables like this,
      
      ```ruby
      @project = Project.find(params[:project_id])
      @task = @project.tasks.find(params[:id])
      ```
      
      You'll also need to update the redirect logic. EG, 
      
      ```ruby
      respond_to do |format|
          if @task.save
            format.html { redirect_to project_task_path(@project, @task), notice: 'Task was successfully created.' }
            format.json { render json: @task, status: :created, location: project_task_path(@project, @task) }
          else
            format.html { render action: "new" }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
      end
      ```
      
      See the git diff with changes](https://github.com/railsmn/open_camp/commit/00e7d7222712774c0b2cba5b91090bef6d56ac4c) for all the details.
