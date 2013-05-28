require 'spec_helper'
describe "StaticPages" do
  describe "Home" do
   it "should have the content 'Welcome to Chores'" do
      visit '/static_pages/home'
      page.should have_content('Welcome to Chores')
    end
  end
  describe "Contact page" do

    it "should have the h1 'Contact Chores team'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', text: 'Contact Chores team')
    end

  end
end

