class Plan < ActiveRecord::Base
  attr_reader :h

  def build
    @h = {}
    
    (1..task_count).each do |task_i|
      100.times do
        d = task_start_date(task_i)
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
    return 0 if @h.empty?

    d = @h.find do |k,v|
      v[:new_task].size < max_new_task_per_day && v[:task].size < max_task_per_day
    end

    return d[0] if d
    @h.keys.max + 1
  end
end
