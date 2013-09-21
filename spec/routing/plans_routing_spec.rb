require "spec_helper"

describe PlansController do
  describe "routing" do
    specify "routes to #build" do
      expect(post("/plans/1/build")).to route_to("plans#build", :id=>'1')
    end
  end
end
