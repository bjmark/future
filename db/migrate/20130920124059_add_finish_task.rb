class AddFinishTask < ActiveRecord::Migration
  def change
    add_column :plan_days, :finish_task, :string
    add_column :plan_days, :is_done, :string, :limit=>1
  end
end
