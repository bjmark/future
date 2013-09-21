#encoding=utf-8

class TradesController < ApplicationController
  before_filter :set_title

  def index
    @trades = Trade.where(:parent_id=>0).order("id DESC")
  end

  def new
    @trade = Trade.new
    @trade.kp = params[:kp]
    @trade.parent_id = (params[:parent_id] or 0) 
    @trade.op_time = Time.now.to_s(:db)[0..-4]
    
    if @trade.kp == '平仓'
      parent = Trade.find(params[:parent_id])
      @trade.contract = parent.contract
      @trade.op = (parent.op == '买' ? '卖' : '买')
    end
  end

  def create
    @trade = Trade.new
    fill_attr(@trade)
    
    if !@trade.my_validate
      render :new  and  return
    end

    create_update_comm
    redirect_to '/trades'
  end

  def edit
    @trade = Trade.find(params[:id])
    @trade.op_time = @trade.op_time.to_s(:db)[0..-4]
  end

  def update
    @trade = Trade.find(params[:id])
    fill_attr(@trade)

    if !@trade.my_validate
      render :edit  and  return
    end

    create_update_comm
    redirect_to '/trades'
  end

  def destroy
    trade = Trade.find(params[:id])
    trade.destroy
    
    if trade.kp == '平仓'
      parent = trade.parent
      parent.cal_profit
      parent.save
    else
      trade.close_trades.each{|e| e.destroy}
    end

    redirect_to '/trades'
  end

  private 

  def fill_attr(obj)
    [:contract, :op, :price, :hand, :op_time, :kp, :parent_id].each do |name|
      obj.send("#{name}=",params[:trade][name])
    end
  end

  def create_update_comm
    if @trade.kp == '平仓'
      parent = @trade.parent

      @trade.parent_id = parent.id
      @trade.contract = parent.contract
      @trade.op = (parent.op == '买' ? '卖' : '买')

      @trade.cal_profit
      @trade.save

      parent.cal_profit
      parent.save
    else
      @trade.save
    end
  end

  def set_title
    @bread_crumbs = [['首页', '/']]
    @title = '期货交易记录'
  end
end
