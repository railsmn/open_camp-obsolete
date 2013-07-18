class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name

      t.timestamps
    end

    add_column :tasks, :project_id, :integer
    add_column :notes, :project_id, :integer
  end
end
