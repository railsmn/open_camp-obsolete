class NotesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @project = Project.find(params[:project_id])
    @notes = @project.notes
  end

  def show
    @project = Project.find(params[:project_id])
    @note = Note.where(id: params[:id], project_id: @project.id).first
  end

  def new
    @project = Project.find(params[:project_id])
    @note = Note.new
  end

  def edit
    @project = Project.find(params[:project_id])
    @note = Note.where(id: params[:id], project_id: @project.id).first
  end

  def create
    @project = Project.find(params[:project_id])
    @note = @project.notes.build(params[:note])

    if @note.save
      redirect_to project_note_path(@project, @note), notice: 'Note was successfully created.'
    else
      render action: "new"
    end
  end

  def update   
    @project = Project.find(params[:project_id]) 
    @note = Note.where(id: params[:id], project_id: @project.id).first

    if @note.update_attributes(params[:note])
      redirect_to project_note_url(@project, @note), notice: 'Note was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @note = Note.where(id: params[:id], project_id: @project.id).first

    @note.destroy

    redirect_to project_notes_url(@project)
  end
end
