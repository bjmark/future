class AddProfit < ActiveRecord::Migration
  def change
    add_column :trades, :profit, :integer
  end
end
