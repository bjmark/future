#encoding=utf-8

require 'spec_helper'

describe TradesController do
  specify "#create 1" do
    post "create", :trade => {:parent_id=>'0', :kp=>'开仓'}
    expect(Trade.first.parent_id).to eq 0
  end
  
  specify "#create 2" do
    parent = Trade.new do |t|
      t.parent_id = 0
      t.kp = '开仓'
      t.op = '卖'
      t.contract = '螺纹1401'
      t.price = 3800
      t.hand = 4
    end
    parent.save

    post "create", :trade => {:parent_id=>parent.id, :kp=>'平仓', :price=>3600, :hand=>2}

    parent.reload
    expect(parent.profit).to eq 4000
  end
end
