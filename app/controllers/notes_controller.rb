class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def delete
  end
end
