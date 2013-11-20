#encoding=utf-8

class PlansController < ApplicationController
  before_filter :set_title

  def index
    @plans = Plan.all.order("id DESC")
  end

  def index_by_day
    task_date = params[:task_date]
    begin
      task_date = task_date.to_date
    rescue
      @plan = [] and return 
    end

    plan_days = PlanDay.where(:task_date=>task_date)

    plan_ids = plan_days.collect{|e| e.plan_id}
    plans = Plan.where(:id=>plan_ids).order("id")

    @plans = plans.collect{|e| [e, plan_days.find_all{|d| d.plan_id == e.id }]}
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new
    fill_attr(@plan)

    @plan.my_validate
    if @plan.errors.empty?
      @plan.save
      redirect_to plans_path
    else
      render "new"
    end
  end

  def clone
    plan = Plan.find(params[:id])
    new_plan = Plan.new
    fill_attr(new_plan,plan)
    new_plan.name << "(克隆)"
    new_plan.save!
    redirect_to plans_path
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    fill_attr(@plan)

    @plan.my_validate
    if @plan.errors.empty?
      @plan.save
      redirect_to (params[:return_to] or plans_path)
    else
      render "edit"
    end
  end

  def destroy
    plan = Plan.find(params[:id])
    plan.delete2
    redirect_to plans_path
  end

  def build
    plan = Plan.find(params[:id])
    PlanDay.delete_all(:plan_id=>plan.id)
    plan.build

    plan.h.keys.sort.each do |k|
      plan_day = PlanDay.new do |t|
        t.task_date = plan.start_date + k
        t.is_done = 'n'
        t.plan_id = plan.id
        t.task = plan.h[k][:task].join(',')
        t.new_task = plan.h[k][:new_task].join(',')
        t.finish_task = ''
      end
      plan_day.save
    end
    redirect_to plans_path
  end

  private

  def fill_attr(obj,attrs = params[:plan])
    [:name, :start_date, :task_count, :review_plan, :max_task_per_day, :max_new_task_per_day, :description].each do |name|
      #obj.send("#{name}=",params[:plan][name])
      obj.send("#{name}=", attrs[name])
    end
  end

  def set_title
    @bread_crumbs = [['首页', '/']]
    @title = '学习计划'
  end
end
