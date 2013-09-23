#encoding=utf-8

class Plan < ActiveRecord::Base
  attr_reader :h
  has_many :plan_days

  def build
    @h = {}
    
    (1..task_count).each do |task_i|
      d = task_start_date(task_i)
      while true
        break if try_plan(task_i, d)
        h_delete(task_i)
        d += 1
      end
    end
  end

  def review_plan_array
    @review_plan_array ||= review_plan.split(',').collect{|e| e.to_i}
  end

  def h_delete(task_i)
    @h.values.each do |v|
      v[:task].delete_if{|e| e == task_i}
      v[:new_task].delete_if{|e| e == task_i}
    end
    
    @h.delete_if do |k,v|
      v[:task].empty? && v[:new_task].empty?
    end
  end

  def try_plan(task_i,d)
    res = true
    ([0] + review_plan_array).each do |e|
      d += e
      v = (@h[d] ||= {})
      v[:task] ||= []
      v[:new_task] ||= []

      if v[:task].size < max_task_per_day
        v[:task] << task_i
      else
        res = false and break
      end

      if e == 0
        if v[:new_task].size < max_new_task_per_day
          v[:new_task] << task_i 
        else
          res = false and break
        end
      end
    end
    res
  end

  def task_start_date(task_i)
    res = 0
    while true
      if (@h[res].nil? or (@h[res][:new_task].size < max_new_task_per_day and @h[res][:task].size < max_task_per_day))
        break
      end
      res += 1
    end
    res
  end

  def my_validate
    if self.name.blank?
      errors.add(:name, "名称不能为空")
    end
    
    if self.start_date.blank?
      errors.add(:start_date, "开始日期不能为空")
    end

    if self.task_count.blank?
      errors.add(:task_count, "任务数不能为空")
    end
=begin 
    if self.review_plan.blank?
      errors.add(:review_plan, "复习计划不能为空")
    end
=end
    if self.max_task_per_day.blank?
      errors.add(:max_task_per_day, "每日最多任务数不能为空")
    end
    
    if self.max_new_task_per_day.blank?
      errors.add(:max_new_task_per_day, "每日最多新任务数不能为空")
    end
  end

  def delete2
    PlanDay.delete_all(:plan_id=>id)
    destroy
  end
end
