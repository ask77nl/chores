require 'spec_helper'
describe "StaticPages", :type => :feature do
  describe "Home" do
   it "should have the content 'Welcome to Chores'" do
      visit '/'
      expect(page).to have_content('Welcome to Chores')
    end
  end
  describe "Contact page" do

    it "should have the h1 'Contact Chores team'" do
      visit '/contact'
      expect(page).to have_selector('h1', text: 'Contact Chores team')
    end

  end

   describe "About page" do

    it "should have the content 'a personal version of Chores'" do
      visit '/about'
      expect(page).to have_content('a personal version of Chores')
    end

  end

end

