class CreateTaskLists < ActiveRecord::Migration
  def change

    create_table :task_lists do |t|
      t.string :name

      t.timestamps
    end

    add_column :tasks, :task_list_id, :integer
  end
end
