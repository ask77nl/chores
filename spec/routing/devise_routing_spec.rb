require "spec_helper"

describe  Devise::SessionsController, :type => :routing do
  describe "routing" do

    it "sign in" do
      expect( :get => "/users/sign_in").to route_to("devise/sessions#new")
    end

   it "sign out" do
      expect( :delete => "/users/sign_out").to route_to("devise/sessions#destroy")
    end



  end
end
