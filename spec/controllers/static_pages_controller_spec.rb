require 'spec_helper'

describe StaticPagesController, :type => :controller do

  before :each do
   sign_out :user
  end

  render_views

  describe "GET 'home'" do
    it "contains welcome message" do
      get :home
      expect(response.body).to match /Welcome to Chores!/m
    end
  end

  describe "GET 'contact'" do
    it "contains contact info" do
      get :contact
      expect(response.body).to match /Contact Chores team/m
    end
  end
  
  describe "GET 'about'" do
    it "contains about info" do
      get :about
      expect(response.body).to match /About/m
    end
  end



end
