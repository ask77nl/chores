class EmailsController < ApplicationController
  
 include InboxConverter

 before_filter :authenticate_user!
# load_and_authorize_resource

 before_action :setup_inbox
  def setup_inbox
    @inboxes = {}
    email_accounts = Emailaccount.all_accounts(current_user.id)
    for email_account in email_accounts do
      @inboxes[email_account.email_address]=Inbox::API.new(Rails.configuration.inbox_app_id, Rails.configuration.inbox_app_secret, email_account.authentication_token)
    end
  end

  def login
    # This URL must be registered with your application in the developer portal
    callback_url = url_for(:action => 'login_callback')
    inbox = @inboxes[params["inbox_email_address"]]
    puts "inbox is ", inbox
    redirect_to inbox.url_for_authentication(callback_url+"&state="+params["inbox_email_address"], params["inbox_email_address"])
  end

  def login_callback
    authentication_token = @inboxes[params["state"]].token_for_code(params[:code])
    Emailaccount.save_token(current_user.id, params["state"], authentication_token)
    redirect_to action: 'index'
  end
  
  # GET /emails
  # GET /emails.json
  def index
    @email_threads = {}
    @my_provider = {}
    @inboxes.each do |email_address, inbox|
      return redirect_to action: 'login', inbox_email_address: email_address unless inbox.access_token != nil
      @email_threads[email_address] = EmailsController.new.inbox_threads(inbox)

      #try to figure out what to do with different my_emails and my_providers, probably display threads in groups
      @my_provider[email_address] = EmailsController.new.my_provider(inbox) 
    end

    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @emails }
    end
  end
  
  def delete_thread
    @inboxes.each do |email_address, inbox|
      return redirect_to action: 'login', inbox_email_address: email_address unless inbox.access_token != nil
    end
    
    if params['thread_id'] then
      EmailsController.new.archive_thread(@inboxes[params['email_address']],params['thread_id'])
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer}
      format.json { head :no_content }
    end
  end
  
  def convert_to_project
    session[:return_to] ||= Rails.application.routes.url_helpers.projects_path
    
    @inboxes.each do |email_address, inbox|
      return redirect_to action: 'login', inbox_email_address: email_address unless inbox.access_token != nil
    end
    
    return redirect_to action: 'show_messages' unless params['thread_id']
    
    @thread = EmailsController.new.get_thread(@inboxes[params['email_address']],params['thread_id'])
    @email_address = params['email_address']
    return redirect_to action: 'show_messages' unless  @threads != []
    
    @project = Project.new
    @project.user_id = current_user.id
    @project.title = @thread.subject
    # we use list of projects and contexts on the view, need to prepare them
    
    @projects = Project.all_active_projects(params[:context_id],current_user.id )
    @contexts = Context.where("user_id = ?",current_user.id)
    
    respond_to do |format|
      format.html 
      format.json { render json: @thread }
    end
  end
  
  
  def show_messages
   
   @inboxes.each do |email_address, inbox|
      return redirect_to action: 'login', inbox_email_address: email_address unless inbox.access_token != nil
    end
    
   @messages = []
   if params['thread_id'] then
     @messages = EmailsController.new.get_messages(@inboxes[params['email_address']],params['thread_id'])
     @thread_id = params['thread_id']
     @email_address = params['email_address']
   end
     
    respond_to do |format|
      format.html # show_messages.html.erb
      format.json { render json: @email }
    end
  end
  

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = Email.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email }
    end
  end

  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = Email.new
    @email.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email }
    end
  end

  # GET /emails/1/edit
  def edit
    @email = Email.find(params[:id])
  end

  # POST /emails
  # POST /emails.json

  def create
#    puts "Create email controller launched!"
    #fix convert date to what rails expect by default
    if(params[:email][:datetime] != "" and params[:email][:datetime] != nil )
    # print "create controller received date:",params[:email][:datetime],"\n"
     params[:email][:datetime]=  DateTime.strptime(params[:email][:datetime], "%m/%d/%Y").strftime("%Y-%m-%d %z")
   #   print "and converted it to:",params[:email][:datetime],"\n"
    else
   #   puts "got no date params in create email controller!"
    end

    @email = Email.new(params[:email])
    @email.user_id = current_user.id


    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render json: @email, status: :created, location: @email }
      else
        format.html { render action: "new" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = Email.find(params[:id])
    @email.user_id = current_user.id

    respond_to do |format|

      #fix convert date to what rails expect by default
      if(params[:email][:datetime] and params[:email][:datetime] != nil)
         #puts "update controller received date:",params[:email][:datetime],"\n"
         params[:email][:datetime]=  DateTime.strptime(params[:email][:datetime], "%m/%d/%Y").strftime("%Y-%m-%d %z")
         #puts "and converted it to:",params[:email][:datetime],"\n"
      end
      if @email.update_attributes(params[:email])
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = Email.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to emails_url }
      format.json { head :no_content }
    end
  end

#private
#    def email_params
#      params.require(:email).permit!
#    end
end
