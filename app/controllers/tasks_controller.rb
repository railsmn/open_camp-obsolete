class TasksController < ApplicationController
  before_filter :authenticate_user!
  # GET /tasks
  # GET /tasks.json
  def index

    # @project current_user.projects.find(params[:project_id])
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @project = Project.find(params[:project_id])
    @task = Task.where(id: params[:id], project_id: @project.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @project = Project.find(params[:project_id])
    # @task = @project.tasks.build
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @task = Task.where(id: params[:id], project_id: @project.id).first
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @project = Project.find(params[:project_id])
    
    # NOTE rails automaticall sets Task.proejct_id = Project.id since we are building
    # the Task object with respect from the project.
    @task = @project.tasks.build(params[:task])

    @task.user = current_user
    
    respond_to do |format|

      # NOTE notice that saving parent also saves dependent child objects
      if @project.save
        format.html { redirect_to project_task_path(@project, @task), notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: project_task_path(@project, @task) }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @project = Project.find(params[:project_id])
    @task = Task.where(id: params[:id], project_id: @project.id).first

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to project_task_path(@project, @task), notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @task = Task.where(id: params[:id], project_id: @project.id).first

    @task.destroy

    respond_to do |format|
      format.html { redirect_to project_tasks_url(@project) }
      format.json { head :no_content }
    end
  end
end
