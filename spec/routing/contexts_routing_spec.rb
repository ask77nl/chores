require "spec_helper"


describe ContextsController, :type => :controller do
  describe "routing" do

#     before(:each) { @routes =ContextsController::Engine.routes }
#    routes {ContextsController::Engine.routes}

    it "routes to #index" do
     expect(:get => 'contexts').to route_to("contexts#index")
#      get("/contexts").should route_to("contexts#index")
    end

    it "routes to #new" do
      expect(:get => 'contexts/new').to route_to("contexts#new")
#      get("/contexts/new").should route_to("contexts#new")
    end

    it "routes to #show" do
      expect( :get => "/contexts/1").to route_to("contexts#show", :id => "1")
    end

    it "routes to #edit" do
      expect( :get =>"/contexts/1/edit").to route_to("contexts#edit", :id => "1")
    end

    it "routes to #create" do
      expect( :post => "/contexts").to route_to("contexts#create")
    end

    it "routes to #update" do
      expect( :put => "/contexts/1").to route_to("contexts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect( :delete => "/contexts/1").to route_to("contexts#destroy", :id => "1")
    end

  end
end
