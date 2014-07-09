require 'spec_helper'

describe StaticPagesController, :type => :controller do

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

  describe "sign out" do
    it "redirects to home page" do
      get :sign_out
      expect(current_user).should be_nil
      expect(response).to render_template("index")
    end
  end


end
