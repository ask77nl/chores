class ProjectsController < ApplicationController
  
  include TheSortableTreeController::Rebuild  
  include InboxConverter


before_filter :authenticate_user!
load_and_authorize_resource

 #stuff for sorted tree 
 # def manage
 #   @pages = Project.nested_set.select('project_id, title, context, parent_project_id').all
 # end

  # GET /projects
  # GET /projects.json
  def index
    #by default show only active projects, not someday projects
    @projects = Project.all_active_projects(params[:context],current_user.id )
    @chores = Chore.where("user_id = ?",current_user.id)
    @choretypes = Choretype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
  
  def someday
    #similar to main index, but show only someday projects
    @projects = Project.all_someday_projects(params[:context_id],current_user.id )
    @chores = Chore.where("user_id = ?",current_user.id)
    @choretypes = Choretype.all

    respond_to do |format|
      format.html # someday.html.erb
      format.json { render json: @projects }
    end
  end
  
   def show_archived
    @projects = Project.all_archived_projects(current_user.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chore }
    end
  end
  

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    #we need to unit test the email part
    if(@project.thread_id)
      email_account = Emailaccount.where(email_address: @project.email_address).first
      inbox = Inbox::API.new(Rails.configuration.inbox_app_id, Rails.configuration.inbox_app_secret, email_account.authentication_token)
      @messages = EmailsController.new.get_messages(inbox,@project.thread_id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    session[:return_to] ||= request.referer
    @project = Project.new
    @project.user_id = current_user.id

    # we use list of projects and contexts on the view, need to prepare them
    @projects = Project.all_active_projects(params[:context_id],current_user.id )
    @contexts = Context.where("user_id = ?",current_user.id)


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    session[:return_to] ||= request.referer
     # we use list of projects and contexts on the view, need to prepare them
    @projects = Project.all_active_projects(params[:context_id],current_user.id )
    gon.projects = @projects
    @contexts = Context.where("user_id = ?",current_user.id)

    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
#    if(params[:project].parent_project_id = '')
    @project = Project.new(params[:project])
    @project.user_id = current_user.id

#if the project was created with a thread id, archive the thread
    if params[:project][:thread_id] then
      config = Rails.configuration
      #search for the email account is probably shitty here
      email_account = Emailaccount.where(email_address: params[:project][:email_address]).first
      inbox = Inbox::API.new(Rails.configuration.inbox_app_id, Rails.configuration.inbox_app_secret, email_account.authentication_token)
      EmailsController.new.archive_thread(inbox,params[:project][:thread_id])
    end

    respond_to do |format|
      if @project.save
        format.html { redirect_to session.delete(:return_to), notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    @project.user_id = current_user.id


    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to session.delete(:return_to), notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.delete

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end
  
  # PUT archive/project/1
  # PUT archive/project/1.json
  def archive
    @project = Project.find(params[:id])
    @project.archive

    respond_to do |format|
      format.html { redirect_to request.referer}
      format.json { head :no_content }
    end
  end
  
  
 protected

  def sortable_model
    Project
  end

  def sortable_collection
    "projects"
  end
  
end
