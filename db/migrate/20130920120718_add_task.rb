class AddTask < ActiveRecord::Migration
  def change
    add_column :plan_days, :task, :string
    add_column :plan_days, :new_task, :string
    remove_column :plan_days, :task_id
    remove_column :plan_days, :is_done
  end
end
