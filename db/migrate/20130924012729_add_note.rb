class AddNote < ActiveRecord::Migration
  def change
    add_column :plan_days, :note, :string
  end
end
