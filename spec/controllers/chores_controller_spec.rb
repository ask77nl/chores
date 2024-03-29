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
   include IceCube

   before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    sign_in @user
 
    @context = FactoryGirl.create(:context, user_id: @user.id)
    @choretype = FactoryGirl.create(:choretype)
    @project = FactoryGirl.create(:project,user_id: @user.id,context_id: @context.id)
    @email = FactoryGirl.create(:email,user_id: @user.id)

#    request.env['HTTP_REFERER'] = "/"   
  end

  # This should return the minimal set of attributes required to create a valid
  # Chore. As you add validations to Chore, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {"title" => "test chore",
    "user_id" => 1,
    "email_id" => 1,
    "choretype_id" => 1,
    "context_id" => 1,
    "project_id" => 1
 }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChoretypesController. Be sure to keep this updated too.
  def valid_session
    {"return_to" => "/"}
  end

  describe "GET index" do
    it "assigns chores with correct context, type and user as @chores, also fills up all required global variables" do
      chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
      wrong_user_chore = Chore.create!({"title" => "test chore", "user_id" => 2,"email_id" => 1,"choretype_id" => 1,"project_id" => 1, "context_id" => 1})
      wrong_type_chore = Chore.create!({"title" => "test chore", "user_id" => 1,"email_id" => 1,"choretype_id" => 2,"project_id" => 1, "context_id" => 1})
      wrong_context_chore = Chore.create!({"title" => "test chore", "user_id" => 1,"email_id" => 1,"choretype_id" => 2,"project_id" => 1,"context_id" => 2})
      get :index, {"user_id" => 1,"choretype_id" => 1, "context_id" => 1}, valid_session
      expect(assigns(:chores)).to eq([chore])
      expect(assigns(:contexts)).to eq([@context])
      expect(assigns(:choretypes)).to eq([@choretype])
      expect(assigns(:projects)).to eq([@project])
      expect(assigns(:chores).length).to eq(1)
    end
  end
  
  describe "GET status_quo" do
    it "assigns correct chores and projects" do
      @choretype_todo = 1
      @choretype_appointment = 3
      @choretype_waiting = 2
      
      chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_todo, user_id: @user.id)
      todays_appointment = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date, schedule: nil)
      waiting_chore = FactoryGirl.create(:chore, choretype_id: @choretype_waiting, project_id: @project.id, user_id: @user.id, schedule: nil)
      archived_chore = FactoryGirl.create(:chore, choretype_id: @choretype_todo, project_id: @project.id, user_id: @user.id, schedule: nil, archived: true)
      empty_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
      get :status_quo, {"user_id" => 1,"context_id" => 1}, valid_session
      expect(assigns(:chores)).to eq([chore])
      expect(assigns(:appointments)).to eq([todays_appointment])
      expect(assigns(:waiting_chores)).to eq([waiting_chore])
      expect(assigns(:contexts)).to eq([@context])
      expect(assigns(:choretypes)).to eq([@choretype])
      expect(assigns(:projects)).to eq([@project, empty_project])
      expect(assigns(:empty_projects)).to eq([empty_project])
      expect(assigns(:chores).length).to eq(1)
    end
  end

   describe "GET show_archived_chores" do
     it "assigns correct chores" do
       @choretype_todo = 1
       @choretype_appointment = 3
       @choretype_waiting = 2

       chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_todo, user_id: @user.id)
       archived_chore = FactoryGirl.create(:chore, choretype_id: @choretype_todo, project_id: @project.id, user_id: @user.id, schedule: nil, archived: true)
       empty_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
       get :show_archived, {"user_id" => 1}, valid_session
       expect(assigns(:chores)).to eq([archived_chore])
       expect(assigns(:projects)).to eq([@project, empty_project])
       end
   end
  
  describe "GET occurrences" do
    it "assigns occurrences from the correct chores" do
      @choretype_appointment = 3
      daily_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id)
      todays_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id, startdate:Time.zone.now.to_date, deadline: Time.zone.now.to_date)
      #puts "created schedule "+daily_chore.schedule.to_s
      
      occurrences = Chore.appointment_occurrences(@context,Time.zone.now.to_date,Time.zone.now.to_date, @user.id)
      get :occurrences,  { :format => :json , "context" => @context.id , "start"=> Time.zone.now.strftime("%Y-%m-%d"), "end" => Time.zone.now.strftime("%Y-%m-%d")}, valid_session
      
      expect(assigns(:contexts)).to eq([@context])
      expect(assigns(:occurrences)).to eq(occurrences)
      
    end
  end

  describe "GET show" do
    it "assigns the requested chore as @chore" do
      chore = Chore.create! valid_attributes
      get :show, {:id => chore.to_param}, valid_session
      expect(assigns(:chore)).to eq(chore)
    end
  end

  describe "GET new" do
    it "assigns a new chore as @chore" do
      get :new, {}, valid_session
      expect(assigns(:chore)).to  be_a_new(Chore)
      #it also needs to prepare the list of emails and active project for the select boxes
      Project.create!("title" => "test title 2", "context_id" => 1,"user_id" => 1, "someday" => true)
      expect(assigns(:emails)).to eq([@email])
      expect(assigns(:projects)).to eq([@project])
    end
  end

  describe "GET edit" do
    it "assigns the requested chore as @chore" do
      chore = Chore.create! valid_attributes
      get :edit, {:id => chore.to_param}, valid_session
      expect(assigns(:chore)).to  eq(chore)
     #it also needs to prepare the list of emails and active projects for the select boxes
      Project.create!("title" => "test title 2", "context_id" => 1,"user_id" => 1, "someday" => true)
      expect(assigns(:emails)).to eq([@email])
      expect(assigns(:projects)).to eq([@project])

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
        #puts "referer is "+request.env['HTTP_REFERER']
        post :create, {:chore => valid_attributes}, valid_session
        expect(assigns(:chore)).to  be_a(Chore)
        expect(assigns(:chore)).to  be_persisted
      end

      it "redirects to the created chore" do
       #puts "referer is "+request.env['HTTP_REFERER']
        post :create, {:chore => valid_attributes}, valid_session
        expect(response).to redirect_to('/')
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved chore as @chore" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Chore).to receive(:save).and_return(false)
        post :create, {:chore => { "title" => "invalid value" }}, valid_session
        expect(assigns(:chore)).to be_a_new(Chore)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Chore).to receive(:save).and_return(false)
        post :create, {:chore => { "title" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      
      it "assigns the requested chore as @chore" do
        chore = Chore.create! valid_attributes
        put :update, {:id => chore.to_param, :chore => valid_attributes}, valid_session
        expect(assigns(:chore)).to eq(chore)
      end

      it "redirects to the chore" do
        chore = Chore.create! valid_attributes
        put :update, {:id => chore.to_param, :chore => valid_attributes}, valid_session
        expect(response).to redirect_to('/')
      end
    end

    describe "with invalid params" do
      it "assigns the chore as @chore" do
        chore = Chore.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Chore).to receive(:save).and_return(false)
        put :update, {:id => chore.to_param, :chore => { "title" => "wrong title" }}, valid_session
        expect(assigns(:chore)).to  eq(chore)
      end

      it "re-renders the 'edit' template" do
        chore = Chore.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Chore).to receive(:save).and_return(false)
        put :update, {:id => chore.to_param, :chore => { "title" => "wrong title" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested choretype" do
      chore = Chore.create! valid_attributes
      request.env['HTTP_REFERER'] = '/'
      expect {
        delete :destroy, {:id => chore.to_param}, valid_session
      }.to change(Chore, :count).by(-1)
    end

    it "redirects to the choretypes list" do
      chore = Chore.create! valid_attributes
      request.env['HTTP_REFERER'] = '/'
      delete :destroy, {:id => chore.to_param}, valid_session
      expect(response).to redirect_to('/')
    end
  end

   describe "archive" do
     it "redirects to the choretypes list" do
       chore = Chore.create! valid_attributes
       request.env['HTTP_REFERER'] = '/'
       put :archive, {:id => chore.to_param}, valid_session
       expect(response).to redirect_to('/')
     end
   end


  describe "PUT skip" do
    it "redirects to the choretypes list" do
      @choretype_appointment = 3
      chore = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now, deadline: Time.zone.now, schedule: IceCube::Rule.weekly.day(Time.zone.now.wday).to_json.to_s)
      request.env['HTTP_REFERER'] = '/'
      put :skip, {:id => chore.id}, valid_session
      expect(response).to redirect_to('/')
    end
  end

end
