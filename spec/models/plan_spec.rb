#encoding=utf-8

require 'spec_helper'

describe Plan do
  let(:plan) do
    Plan.new do |t|
      t.name = "english700"
      t.start_date = '2013-9-16'
      t.task_count = 10
      t.review_plan = '1,2,4,8'
      t.max_task_per_day = 3
      t.max_new_task_per_day = 1
    end
  end

  specify "#h_delete" do
    plan.instance_eval do
      @h = {
        0 => {:task=>[1,2],:new_task=>[1]},
        1 => {:task=>[2],:new_task=>[2]},
        2 => {:task=>[2,3],:new_task=>[2]}
      }
    end
    res = {
      0 => {:task=>[1],:new_task=>[1]},
      2 => {:task=>[3],:new_task=>[]}
    }
    plan.h_delete(2)
    expect(plan.h).to eq res
  end

  specify "#review_plan_array" do
    expect(plan.review_plan_array).to eq [1,2,4,8]
  end
  
  specify "#task_start_date" do
    plan.instance_eval do
      @h = {}
    end
    expect(plan.task_start_date(1)).to eq 0
  end


  specify "#task_start_date 2" do
    plan.instance_eval do
      @h = {
        0 => {:task=>[1], :new_task=>[1]}
      }
    end
    
    expect(plan.max_new_task_per_day).to eq 1
    expect(plan.task_start_date(2)).to eq 1
  end

  specify "#task_start_date 3" do
    plan.instance_eval do
      @h = {
        0 => {:task=>[1], :new_task=>[1]},
        1 => {:task=>[1], :new_task=>[]}
      }
    end
    expect(plan.task_start_date(2)).to eq 1
  end
  
  specify "#task_start_date 4" do
    plan.instance_eval do
      @h = {
        0 => {:task=>[1], :new_task=>[1]},
        2 => {:task=>[1], :new_task=>[]}
      }
    end
    expect(plan.task_start_date(2)).to eq 1
  end

  specify "#try_plan" do
    plan.instance_eval do
      @h = {}
    end

    expect(plan.h).to eq({})
    expect(plan.try_plan(1, 0)).to eq true

    expect(plan.try_plan(2, 1)).to eq true
=begin
    h = plan.h.collect{|k,v| [k,v] }
    h = h.sort{|x,y| x[0] <=> y[0]}
    expect(h).to eq([])
=end
    expect(plan.h[1][:new_task]).to eq([2])
    expect(plan.h[1][:task]).to eq([1,2])
  end

  specify "#build" do
    plan.build
    h = plan.h

    h.each do |k,v|
      expect(v[:task].size <= 3).to eq true
      expect(v[:new_task].size <= 3).to eq true
    end

    plan_day = []
    d = 0
    plan.review_plan_array.each do |e|
      d += e
      plan_day << d
    end
    plan_day = [0] + plan_day
    expect(plan_day).to eq([0,1,3,7,15])
    
    (1..plan.task_count).each do |task_i|
      my_plan = h.find_all{|k,v| v[:task].include?(task_i)}
      expect(my_plan.size).to eq plan.review_plan_array.size + 1

      my_plan = my_plan.collect{|e| e[0]}
      start_date = my_plan.min
      my_plan = my_plan.collect{|e| e - start_date}
      expect(my_plan.sort).to eq plan_day
    end
  end

  specify "#new 1" do
    p = Plan.new
    expect(p.errors.empty?).to eq true 
  end

  specify "#new 2" do
    p = Plan.new
    p.my_validate
    expect(p.errors.empty?).to eq false
    expect(p.errors[:name]).to eq(['名称不能为空'])
  end

  specify "#delete2" do
    p = Plan.create!
    p.plan_days << PlanDay.new()
    expect(p.plan_days.count).to eq(1)
    expect(PlanDay.count).to eq(1)

    p.delete2
    expect(PlanDay.count).to eq(0)
  end
end
