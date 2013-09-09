Session 6 - August 12, 2013
===========================

## Introduction (30 minutes)
#### 1. Welcome and logistics
#### 2. [Session 5](https://github.com/railsmn/schedule/blob/master/open_camp/session5.md) - Recap
#### 3. No updates to your Virtual Machine!
#### 4. Session 6 Overview

- Improving the Project 'show' page
  - Listing tasks
  - Searching tasks
  - Adding attachments

## Hack Time (90 minutes)

### 1. Listing tasks
###### Step 0. Updating the View
Our project dashboard page has a lot to be desired. On the top of missing features on the page is the ability to see what Tasks are associated to the project. To fix that, let's create a listing of tasks that features, showing for each task:
- The name
- The description
- The due date (with a number of days until it's due)
  
###### Step 1. Modify ```app/views/projects/show.html.erb```
At the end of ```show.html.erb``` put the following HTML/Ruby (ERB) code underneath the four 'link_to' lines:

``` HTML+ERB
<h3>
  Tasks
</h3>

<div class="row-fluid">
  <div class="span2">
    <b>Name</b>
  </div>
  <div class="span4">
    <b>Description</b>
  </div>
  <div class="span2">
    <b>Due Date</b>
  </div>
  <div class="span2">
    <b>Due In (days)</b>
  </div>
  <div class="span2">
    <b>Actions</b>
  </div>  
</div>
<% @project.tasks.each do |task| %>
<div class="row-fluid">
  <div class="span2">
    <%= task.name %>
  </div>
  <div class="span4">
    <%= task.description %>
  </div>
  <div class="span2">
    <%= task.due_date %>
  </div>
  <div class="span2">
    <%= task.days_til_due %>
  </div>  
  <div class="span2">
    <%= link_to 'Show', project_task_path(@project, task) %>
    <%= link_to 'Edit', edit_project_task_path(@project, task) %>
  </div>
</div>
<%end%>
```

This code creates a section that uses some Bootstrap HTML/CSS to space our Task information out nicely. You'll note, however, that when you reload the page you'll get an error referring to the ```tasks.days_til_due``` method call. To fix that, let's update our Task model.

###### Step 2. Modify ```app/models/task.rb```
Within our ```task.rb``` file we need to define the ```days_til_due``` function so we can use it in our view. The code is as follows (put it beneath the other methods in the file):

``` ruby
  def days_til_due
    (Date.today - due_date).to_i
  end
```

This function calculates the distance between the Task's saved due date and the current date by using Ruby's 'Date' class. In Ruby, you can subtract Date objects and then convert them to a number (via the ```.to_i``` call) to get the difference in days.

###### Step 3. Lets sort!
It would make sense if our new table would be sorted by the tasks closest to being due (the lowest 'days_til_due' value). Luckily, Ruby makes this easy to do via sorting ```@project.tasks```.

Open up ```app/views/projects/show.html.erb``` again and change the line 

``` HTML+ERB
  <% @project.tasks.each do |task| %>
```

To:

``` HTML+ERB
  <% @tasks.each do |task| %>
```

And in ```app/controllers/projects_controller.rb``` in the ```show``` method underneath the @project = ... line add:

``` ruby
  @tasks = @project.tasks.sort_by{|task| task.days_til_due}
```

The code should read pretty easily but is using Rails 'sort_by' method on arrays in combination with Ruby's 'block' syntax. [Here is a good introduction to Ruby blocks for more information](http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/)

### 1. Searching tasks via AJAX
At some point, our number of tasks per projects may require the ability to search in order to find them quickly. Let's make an initial implementation where we can search by name (we can improve our search functionality later once we establish a framework). 

This will be a great example of adding scopes to our models and 'non-CRUD' routes in our controllers.


###### Step 1. Refactor ```app/views/projects/show.html.erb```
In a previous step we explicitly looped through each task of the project in the show.html.erb file. This would be a perfect case to use partials (and it'll help us return our search results). Change: 

``` HTML+ERB
<% @tasks.each do |task| %>
<div class="row-fluid">
  <div class="span2">
    <%= task.name %>
  </div>
  <div class="span4">
    <%= task.description %>
  </div>
  <div class="span2">
    <%= task.due_date %>
  </div>
  <div class="span2">
    <%= task.days_til_due %>
  </div>  
  <div class="span2">
    <%= link_to 'Edit', edit_project_task_path(@project, task) %>
    <%= link_to 'Show', project_task_path(@project, task) %>
  </div>
</div>
<%end%>
```

By removing the HTML output with the following:

``` HTML+ERB
<div id="tasks">
  <%= render @tasks %>
</div>
```

Slick, right? This code will loop through each of our tasks and pass it to our 'partial' which will render it. So now we need to create that partial and update our Project controller.

Create the file ```app/views/tasks/_task.html.erb``` and put the following in:

```
<div class="row-fluid">
  <div class="span2">
    <%= task.name %>
  </div>
  <div class="span4">
    <%= task.description %>
  </div>
  <div class="span2">
    <%= task.due_date %>
  </div>
  <div class="span2">
    <%= task.days_til_due %>
  </div>  
  <div class="span2">
    <%= link_to 'Show', project_task_path(@project, task) %>
    <%= link_to 'Edit', edit_project_task_path(@project, task) %>
  </div>
</div>
```

Note it is identical to the code we removed prior. The 'task' variable is being passed by Rails to the partial from the call to render in our 'show' page.

###### Step 2. Add the search form 

In ```app/views/projects/show.html.erb```, add the following right above the ```<h3>``` and below the links:

``` HTML+ERB
<div class="row-fluid">
  <%= form_tag project_tasks_path(@project), remote: true, method: 'get', id: 'tasks_search' do %>
  <%= text_field_tag :search, '', class: 'input-medium search-query'%>
  <%= submit_tag "Search", :name => nil, class: 'btn' %>
  <%end%>
</div>
```

This is using Bootstrap to create a nice looking search form that sends a request to our Tasks controllers index method. A special thing to note here is the ``` remote: true ``` bit. This designates to Rails that it should send the request 'behind the scenes' to the controller. To accommodate this, we'll need to update ```app/controllers/tasks_controller.rb``` to accept AJAX JavaScript requests.

In ```app/controllers/tasks_controller.rb``` update the ```index``` method by updating the ```respond_to``` block as follows:

``` ruby
respond_to do |format|
  format.html # index.html.erb
  format.json { render json: @tasks }
  format.js {render :tasks}
end
```

You'll note the new ```format.js``` response which renders expects the ```app/views/tasks/tasks.js.erb``` file to exist (the .js is implied from the format.js line). Let's create that file and put this within:

``` HTML+ERB
$('#tasks').html("<%= escape_javascript(render @tasks) %>");
```

This line is doing quite a bit, but it is using JavaScript to change the content of the HTML we have already rendered, replacing it with our response results (via render @tasks, like we used in the original ```app/views/projects/show.html.erb``` file).

We're almost there!

###### Step 2. Search the tasks by name
Now that we have our form and AJAX responses set up, all we need to do now is filter our tasks by the queried search name. This will take place within our controller, which will request a method on the Task model to filter our results.

Within ```app/controllers/tasks_controller.rb``` update the ```index``` method to the following:

``` ruby
def index
  @project = Project.find(params[:project_id])
  @tasks = @project.tasks
  if params[:search].presence
    @tasks = @tasks.search(params[:search])
  end
  @tasks.sort_by!{|task| task.days_til_due}
  
  respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tasks }
    format.js {render :tasks}
  end
end
``` 

There is a new line here using ```@tasks.search```, which doesn't exist yet. This is referred to within Rails as a 'scope'. To create it, open up ```app/models/task.rb``` and add the following line after the ```after_save``` callback line:

``` ruby
scope :search, lambda {|search| where('name ILIKE ?', "%#{search}%")}
```

For more information on how this scope works, [check out the Ruby on Rails guide to scoping](http://guides.rubyonrails.org/active_record_querying.html#scopes).

Refresh the page and enter in some names and submit the form. You should notice that the page shows the filtered results without loading the page!

