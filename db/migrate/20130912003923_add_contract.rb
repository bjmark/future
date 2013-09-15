class AddContract < ActiveRecord::Migration
  def change
    add_column :trades, :contract, :string 
  end
end
