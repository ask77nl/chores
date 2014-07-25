require 'spec_helper'

describe "Header", :type => :feature do
  describe "checking footer at Home page" do
   it "when user is not logged in, it should contain some footer links" do
      visit '/'
      print page.body
      expect(page).to have_link('Chores', href: "http://chores.com/")
      expect(page).to have_link('About', href: about_page_path)
      expect(page).to have_link('Contact', href: contact_page_path)
      expect(page).to have_link('News', href: "http://news.chores.com")
    end
  end

end

