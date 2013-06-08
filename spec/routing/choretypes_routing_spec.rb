require "spec_helper"

describe ChoretypesController do
  describe "routing" do

    it "routes to #index" do
      get("/choretypes").should route_to("choretypes#index")
    end

    it "routes to #new" do
      get("/choretypes/new").should route_to("choretypes#new")
    end

    it "routes to #show" do
      get("/choretypes/1").should route_to("choretypes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/choretypes/1/edit").should route_to("choretypes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/choretypes").should route_to("choretypes#create")
    end

    it "routes to #update" do
      put("/choretypes/1").should route_to("choretypes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/choretypes/1").should route_to("choretypes#destroy", :id => "1")
    end

  end
end
