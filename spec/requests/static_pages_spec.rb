require 'spec_helper'

describe "StaticPages" do
  describe "Home" do
   it "should have the content 'Welcome to Chores'" do
      visit '/static_pages/home'
      page.should have_content('Welcome to Chores')
    end
  end
end
