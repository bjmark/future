#encoding=utf-8

class PlansController < ApplicationController
  before_filter :set_title

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new
    fill_attr(@plan)
    @plan.save

    redirect_to plans_path
  end

  private
  
  def fill_attr(obj)
    [:name, :start_date, :task_count, :review_plan, :max_task_per_day, :max_new_task_per_day].each do |name|
      obj.send("#{name}=",params[:plan][name])
    end
  end

  def set_title
    @title = '学习计划'
  end
end
