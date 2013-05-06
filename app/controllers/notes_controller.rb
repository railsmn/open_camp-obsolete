class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
  end

  def edit
    @note = Note.find(params[:id])
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render action: "new"
    end
  end

  def update
  end

  def delete
  end
end
