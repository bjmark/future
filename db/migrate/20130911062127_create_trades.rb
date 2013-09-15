class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string   "kp"
      t.string   "op"
      t.integer  "price"
      t.integer  "hand"
      t.datetime "op_time"
      t.integer  "fee"
      t.timestamps
    end
  end
end
