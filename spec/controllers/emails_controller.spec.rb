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

describe EmailsController, :type => :controller do
   include IceCube

   before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    $user = FactoryGirl.create(:user)
    sign_in $user

  end

  # This should return the minimal set of attributes required to create a valid
  # Email. As you add validations to Email, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {"subject" => "test subject",
    "user_id" => 1,
   }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EmailtypesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns emails with correct context, type and user as @emails" do
      email = Email.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:emails)).to eq([email])
    end
  end

  describe "GET show" do
    it "assigns the requested email as @email" do
      email = Email.create! valid_attributes
      get :show, {:id => email.to_param}, valid_session
      expect(assigns(:email)).to eq(email)
    end
  end

  describe "GET new" do
    it "assigns a new email as @email" do
      get :new, {}, valid_session
      expect(assigns(:email)).to  be_a_new(Email)
    end
  end

  describe "GET edit" do
    it "assigns the requested email as @email" do
      email = Email.create! valid_attributes
      get :edit, {:id => email.to_param}, valid_session
      expect(assigns(:email)).to  eq(email)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Email" do
        expect {
          post :create, {:email => valid_attributes}, valid_session
        }.to change(Email, :count).by(1)
      end

      it "assigns a newly created email as @email" do
        post :create, {:email => valid_attributes}, valid_session
        expect(assigns(:email)).to  be_a(Email)
        expect(assigns(:email)).to  be_persisted
      end

      it "redirects to the created email" do
        post :create, {:email => valid_attributes}, valid_session
        expect(response).to redirect_to(Email.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email as @email" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Email).to receive(:save).and_return(false)
        post :create, {:email => { "title" => "invalid value" }}, valid_session
        expect(assigns(:email)).to be_a_new(Email)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Email).to receive(:save).and_return(false)
        post :create, {:email => { "title" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested email" do
        email = Email.create! valid_attributes
 
       put :update, {:id => email.to_param, :email => { "subject" => "new email"}}, valid_session 
      expect(assigns(:email)).to eq(email)
      end

      it "assigns the requested email as @email" do
        email = Email.create! valid_attributes
        put :update, {:id => email.to_param, :email => valid_attributes}, valid_session
        expect(assigns(:email)).to eq(email)
      end

      it "redirects to the email" do
        email = Email.create! valid_attributes
        put :update, {:id => email.to_param, :email => valid_attributes}, valid_session
        expect(response).to redirect_to(email)
      end
    end

    describe "with invalid params" do
      it "assigns the email as @email" do
        email = Email.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Email).to receive(:save).and_return(false)
        put :update, {:id => email.to_param, :email => { "title" => "wrong title" }}, valid_session
        expect(assigns(:email)).to  eq(email)
      end

      it "re-renders the 'edit' template" do
        email = Email.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Email).to receive(:save).and_return(false)
        put :update, {:id => email.to_param, :email => { "title" => "wrong title" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested emailtype" do
      email = Email.create! valid_attributes
      expect {
        delete :destroy, {:id => email.to_param}, valid_session
      }.to change(Email, :count).by(-1)
    end

    it "redirects to the emailtypes list" do
      email = Email.create! valid_attributes
      delete :destroy, {:id => email.to_param}, valid_session
      expect(response).to redirect_to(emails_url)
    end
  end

end
