#encoding=utf-8

class Trade < ActiveRecord::Base
  def my_validate
    true
  end

  def close_trades
    Trade.where(:parent_id=>id).order("id DESC")
  end

  def parent
    @parent ||= Trade.find(parent_id)
  end

  def kind
    contract.strip[0..-5] 
  end

  def unit_count
    ConfigFile.new[kind].to_i
  end
  
  def cal_profit 
    if parent_id > 0
      self.profit = (price - parent.price) * hand * unit_count
      self.profit = -profit if parent.op == '卖'
    else
      self.profit = 0
      close_trades.each do |e|
        self.profit += e.profit
      end
    end
  end
end
