require 'spec_helper'

describe PlanDaysController do
  let(:plan_day) do
    plan_day = PlanDay.new do |t|
      t.task = "19,20,3,4"
    end
    plan_day.save!
    plan_day
  end

  specify "update1" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '19,20'}
    plan_day.reload.finish_task.should == '19,20'
  end
  
  specify "update2" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '19 20   3'}
    plan_day.reload.finish_task.should == '19,20,3'
  end
  
  specify "update3" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '19 20   3, 4'}
    plan_day.reload.finish_task.should == '19,20,3,4'
    plan_day.is_done.should == 'y'
  end
end
