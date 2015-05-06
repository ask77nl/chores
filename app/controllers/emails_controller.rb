class EmailsController < ApplicationController

 before_filter :authenticate_user!
# load_and_authorize_resource

 before_action :setup_inbox
  def setup_inbox
    config = Rails.configuration
    if config.inbox_app_id == 'YOUR_APP_ID'
        raise "error, you need to configure your app secrets in config/environments"
    end
    if config.inbox_api_server
        @inbox = Inbox::API.new(config.inbox_app_id, config.inbox_app_secret, session[:inbox_token], config.inbox_api_server, config.inbox_auth_domain)
    else
        @inbox = Inbox::API.new(config.inbox_app_id, config.inbox_app_secret, session[:inbox_token])
    end
  end

  def login
    # This URL must be registered with your application in the developer portal
    callback_url = url_for(:action => 'login_callback')
    redirect_to @inbox.url_for_authentication(callback_url, '')
  end

  def login_callback
    # Store the Inbox API token in the session
    session[:inbox_token] = @inbox.token_for_code(params[:code])
    redirect_to action: 'index'
  end
  
  # GET /emails
  # GET /emails.json
  def index
    return redirect_to action: 'login' unless @inbox.access_token
    namespace = @inbox.namespaces.first

    # Wait til the sync has successfully started
    thread = namespace.threads.first
    while thread == nil do
      puts "Sync not started yet. Checking again in 2 seconds."
      sleep 2
      thread = namespace.threads.first
    end

    # Print out the first five threads in the namespace
    @test_text = ""
    namespace.threads.range(0,4).each do |thread|
        @test_text += "#{thread.subject} - #{thread.id}<br>";
    end
    
    
    @emails = Email.where("user_id = ?",current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @emails }
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
