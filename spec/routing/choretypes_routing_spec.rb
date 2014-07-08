require "spec_helper"

describe ChoretypesController, :type => :controller do
  describe "routing" do

    it "routes to #index" do
      expect( :get => "/choretypes").to route_to("choretypes#index")
    end

    it "routes to #new" do
      expect( :get => "/choretypes/new").to route_to("choretypes#new")
    end

    it "routes to #show" do
      expect(:get => "/choretypes/1").to route_to("choretypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/choretypes/1/edit").to route_to("choretypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect( :post => "/choretypes").to route_to("choretypes#create")
    end

    it "routes to #update" do
      expect( :put => "/choretypes/1").to route_to("choretypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect( :delete =>"/choretypes/1").to route_to("choretypes#destroy", :id => "1")
    end

  end
end
