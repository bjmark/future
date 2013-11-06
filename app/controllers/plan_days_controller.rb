#encoding=utf-8

class PlanDaysController < ApplicationController
  before_filter :set_title

  def edit
    @plan_day = PlanDay.find(params[:id])
  end
 
  def update
    @plan_day = PlanDay.find(params[:id])
    
    @plan_day.note = params[:plan_day][:note]

    finish_task = params[:plan_day][:finish_task]
    finish_task = finish_task.split(/\s*,\s*|\s+/).collect{|e| e.to_i}

    task = @plan_day.task.split(',').collect{|e| e.to_i}

    finish_task = finish_task - (finish_task - task)
    
    @plan_day.finish_task = finish_task.join(',')
    if finish_task.sort == task.sort
      @plan_day.is_done = 'y'
    else
      @plan_day.is_done = 'n'
    end
    @plan_day.save

    redirect_to (params[:return_to] or plan_path(@plan_day.plan))
  end

  private
  
  def set_title
    @bread_crumbs = [['首页', '/']]
    @title = '学习计划'
  end
end
