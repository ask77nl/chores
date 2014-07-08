require 'spec_helper'

describe "Choretypes", :type => :request do
  describe "GET /choretypes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/choretypes'
      response.status.should be(200)
    end
  end
end
