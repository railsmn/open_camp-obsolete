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
</div>
<%end%>  
```

This code creates a section that uses some Bootstrap HTML/CSS to space our Task information out nicely. You'll note, however, that when you reload the page you'll get an error referring to the ```tasks.days_til_due``` method call. To fix that, let's update our Task model.

###### Step 1. Modify ```app/models/task.rb```
Within our ```task.rb``` file we need to define the ```days_til_due``` function so we can use it in our view. The code is as follows (put it beneath the other methods in the file):

``` ruby
  def days_til_due
    (Date.today - due_date).to_i
  end
```

This function calculates the distance between the Task's saved due date and the current date by using Ruby's 'Date' class. In Ruby, you can subtract Date objects and then convert them to a number (via the ```.to_i``` call) to get the difference in days.

###### Step 1. Lets sort!
It would make sense if our new table would be sorted by the tasks closest to being due (the lowest 'days_til_due' value). Luckily, Ruby makes this easy to do via sorting ```@project.tasks```.

Open up ```app/views/projects/show.html.erb``` again and change the line 

```ruby
  <% @project.tasks.each do |task| %>
```

To:

```ruby
  <% @project.tasks.sort_by{|task| task.days_til_due}.each do |task| %>
```

The code should read pretty easily but is using Rails 'sort_by' method on arrays in combination with Ruby's 'block' syntax. [Here is a good introduction to Ruby blocks for more information](http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/)
