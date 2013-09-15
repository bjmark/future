#encoding=utf-8

require 'spec_helper'

describe Trade do
  specify "#close_trades" do
    parent = Trade.create
    trade1 = Trade.create(:parent_id=>parent.id)
    trade2 = Trade.create(:parent_id=>parent.id)

    expect(parent.close_trades.count).to eq 2
    expect(parent.close_trades.first).to eq trade2
  end

  specify "#parent" do
    parent = Trade.create
    trade1 = Trade.create(:parent_id=>parent.id)

    expect(trade1.parent).to eq parent
  end

  specify "#kind" do
    trade1 = Trade.new(:contract=>"螺纹1401")
    expect(trade1.kind).to eq "螺纹"
  end

  specify "#cal_profit" do
    parent = Trade.create(:op=>"卖", :contract=>"螺纹1401", :hand=>4, :price=>3800,:parent_id=>0)
    trade1 = Trade.new(:parent_id=>parent.id,:hand=>2, :price=>3600, :contract=>"螺纹1401")
    trade2 = Trade.new(:parent_id=>parent.id,:hand=>1, :price=>3900, :contract=>"螺纹1401")
    
    trade1.cal_profit
    expect(trade1.profit).to eq 4000

    trade2.cal_profit
    expect(trade2.profit).to eq -1000

    trade1.save
    trade2.save

    parent.cal_profit
    expect(parent.profit).to eq 3000
  end
end
