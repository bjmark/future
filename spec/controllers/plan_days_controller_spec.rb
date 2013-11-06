require 'spec_helper'

describe PlanDaysController do
  let(:plan_day) do
    plan_day = PlanDay.new do |t|
      t.task = "1,2,3,4"
    end
    plan_day.save!
    plan_day
  end

  specify "update1" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '1,2'}
    plan_day.reload.finish_task.should == '1,2'
  end
  
  specify "update2" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '1 2   3'}
    plan_day.reload.finish_task.should == '1,2,3'
  end
  
  specify "update3" do
    put "update", :id=> plan_day.id, :plan_day => {:finish_task => '1 2   3, 4'}
    plan_day.reload.finish_task.should == '1,2,3,4'
    plan_day.is_done.should == 'y'
  end
end
