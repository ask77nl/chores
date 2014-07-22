require 'spec_helper'

describe "Unauthorized access", :type => :feature do
  context "user is not logged in" do

   describe "user is visiting chores page" do
    it "it should be redirected to sign in page" do
       visit chores_path 
       expect(page).to have_content('You need to sign in or sign up before continuing')
    end
   end

   describe "user is visiting projects page" do
    it "it should be redirected to sign in page" do
       visit projects_path
       expect(page).to have_content('You need to sign in or sign up before continuing')
    end
    end

    describe "user is visiting contexts page" do
    it "it should be redirected to sign in page" do
       visit contexts_path
       expect(page).to have_content('You need to sign in or sign up before continuing')
    end
    end

     describe "user is visiting emails page" do
    it "it should be redirected to sign in page" do
       visit emails_path
       expect(page).to have_content('You need to sign in or sign up before continuing')
    end
   end

 end
end

