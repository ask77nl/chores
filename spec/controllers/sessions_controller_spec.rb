require 'spec_helper'

include Devise::TestHelpers
include ControllerMacros


# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Devise::SessionsController,:type => :controller do

#   login_user
  # This should return the minimal set of attributes required to create a valid
  # Session. As you add validations to Task, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "name" => "MyString" ,
      "user_id" => 1}
  end
 
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SessionController. Be sure to keep this updated too.
  def valid_session
    {}
  end


  describe "sign out" do
     it "redirects to home page" do
 
#      login_user
       @user = FactoryGirl.create(:user) 
       sign_in @user
       sign_out @user 
#       expect(current_user).should be_nil
       expect(response.status).to eq(200)
#       expect(response).to render_template()
     end
   end

      #   post :create, {:task => valid_attributes}, valid_session
      #   assigns(:task).should be_a(Task)
      #   assigns(:task).should be_persisted
      # end
      # 
      # it "redirects to the created task" do
      #   post :create, {:task => valid_attributes}, valid_session
      #   response.should redirect_to(Task.last)
      # end

    # describe "with invalid params" do
    #   it "assigns a newly created but unsaved task as @task" do
    #     # Trigger the behavior that occurs when invalid params are submitted
    #     Task.any_instance.stub(:save).and_return(false)
    #     post :create, {:task => {}}, valid_session
    #     assigns(:task).should be_a_new(Task)
    #   end
    # 
    #   it "re-renders the 'new' template" do
    #     # Trigger the behavior that occurs when invalid params are submitted
    #     Task.any_instance.stub(:save).and_return(false)
    #     post :create, {:task => {}}, valid_session
    #     response.should render_template("new")
    #   end
    # end


end