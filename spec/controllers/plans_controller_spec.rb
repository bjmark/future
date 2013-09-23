require 'spec_helper'

describe PlansController do
  specify "#index_by_day" do
    plan1 = Plan.create
    plan2 = Plan.create
    plan3 = Plan.create
    
    task_date = '2013-9-23'
    
    plan1.plan_days << PlanDay.new(:task_date=>task_date)
    plan2.plan_days << PlanDay.new(:task_date=>task_date)

    get "index_by_day", :task_date=>task_date
    expect(assigns(:plans).size).to eq 2
    expect(assigns(:plans)[0][0]).to eq plan1
  end
end
