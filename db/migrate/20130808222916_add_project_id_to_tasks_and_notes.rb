class AddProjectIdToTasksAndNotes < ActiveRecord::Migration
  def change
    add_column :tasks, :project_id, :integer
    add_column :notes, :project_id, :integer
  end
end
