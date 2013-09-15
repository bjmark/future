class AddParentId < ActiveRecord::Migration
  def change
    add_column :trades, :parent_id, :integer
  end
end
