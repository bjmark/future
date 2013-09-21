class CreatePlanDays < ActiveRecord::Migration
  def change
    create_table :plan_days do |t|
      t.date       "task_date"
      t.integer    "task_id"
      t.string     "is_done", :limit => 1
      t.integer    "plan_id"
      t.timestamps
    end
  end
end
