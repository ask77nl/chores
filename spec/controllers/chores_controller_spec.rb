require 'spec_helper'

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

describe ChoresController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Choretype. As you add validations to Choretype, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {"title" => "test chore",
    "user_id" => 1,
    "email_id" => 1,
    "choretype_id" => 1,
    "project_id" => 1
 }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChoretypesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all chores as @chores" do
       @user = FactoryGirl.create(:user)
       sign_in @user

      context = Context.create!({ "name" => "work" , "user_id" => @user.id})
      choretype = Choretype.create!( { "name" => "to do", "context_id" => context.id })
      project = Project.create!({"title"=> "read email", "user_id" => @user.id, "context_id" => context.id })
      chore = Chore.create! valid_attributes
      get :index, {}, valid_session
      expect(:chores).to eq([chore])

    end
  end

  describe "GET show" do
    it "assigns the requested chore as @chore" do
      chore = Chore.create! valid_attributes
      get :show, {:id => chore.to_param}, valid_session
      assigns(:chore).should eq(chore)
    end
  end

  describe "GET new" do
    it "assigns a new chore as @chore" do
      get :new, {}, valid_session
      assigns(:chore).should be_a_new(Chore)
    end
  end

  describe "GET edit" do
    it "assigns the requested chore as @chore" do
      chore = Chore.create! valid_attributes
      get :edit, {:id => chore.to_param}, valid_session
      assigns(:chore).should eq(chore)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Chore" do
        expect {
          post :create, {:chore => valid_attributes}, valid_session
        }.to change(Chore, :count).by(1)
      end

      it "assigns a newly created chore as @chore" do
        post :create, {:chore => valid_attributes}, valid_session
        assigns(:chore).should be_a(Chore)
        assigns(:chore).should be_persisted
      end

      it "redirects to the created chore" do
        post :create, {:chore => valid_attributes}, valid_session
        response.should redirect_to(Chore.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved chore as @chore" do
        # Trigger the behavior that occurs when invalid params are submitted
        Chore.any_instance.stub(:save).and_return(false)
        post :create, {:chore => { "title" => "invalid value" }}, valid_session
        assigns(:chore).should be_a_new(Chore)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Chore.any_instance.stub(:save).and_return(false)
        post :create, {:chore => { "title" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested chore" do
        choretype = Chore.create! valid_attributes
        # Assuming there are no other chores in the database, this
        # specifies that the Chore created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
#        Chore.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        expect_any_instance_of(Chore).to receive(:update_attributes).with({ "title" => "test chore" })
 
       put :update, {:id => chore.to_param, :chore => { "type" => "test chore" }}, valid_session
      end

      it "assigns the requested chore as @chore" do
        chore = Chore.create! valid_attributes
        put :update, {:id => chore.to_param, :chore => valid_attributes}, valid_session
        assigns(:chore).should eq(chore)
      end

      it "redirects to the choretype" do
        chore = Chore.create! valid_attributes
        put :update, {:id => chore.to_param, :chore => valid_attributes}, valid_session
        response.should redirect_to(chore)
      end
    end

    describe "with invalid params" do
      it "assigns the chore as @chore" do
        chore = Chore.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chore.any_instance.stub(:save).and_return(false)
        put :update, {:id => chore.to_param, :chore => { "title" => "wrong title" }}, valid_session
        assigns(:chore).should eq(chore)
      end

      it "re-renders the 'edit' template" do
        chore = Chore.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chore.any_instance.stub(:save).and_return(false)
        put :update, {:id => chore.to_param, :chore => { "title" => "wrong title" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested choretype" do
      chore = Chore.create! valid_attributes
      expect {
        delete :destroy, {:id => chore.to_param}, valid_session
      }.to change(Chore, :count).by(-1)
    end

    it "redirects to the choretypes list" do
      chore = Chore.create! valid_attributes
      delete :destroy, {:id => chore.to_param}, valid_session
      response.should redirect_to(chores_url)
    end
  end

end
