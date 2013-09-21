class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string        :name
      t.date          :start_date   
      t.integer       :task_count
      t.string        :review_plan
      t.integer       :max_task_per_day
      t.integer       :max_new_task_per_day
      t.timestamps
    end
  end
end
