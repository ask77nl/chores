class ChoresController < ApplicationController
include IceCube
before_filter :authenticate_user!
#load_and_authorize_resource 


  # GET /chores
  # GET /chores.json
  def index
    @contexts = Context.where("user_id = ?",current_user.id)
    @choretypes = Choretype.all


    if @contexts.empty?
      @active_context = nil
      @chores = nil
    else
      if params[:context] == nil
        @active_context = @contexts.first.id
      else
        @active_context = params[:context].to_s
      end
     
      if params[:choretype] == nil
        @active_choretype = @choretypes.first.id
      else
        @active_choretype = params[:choretype].to_s
      end

      @chores = Chore.all_chores_by_context_type_and_user(@active_context,@active_choretype, current_user.id)
      #also prepare active projects, because we use it to display project titles.
      #puts "chores controller calling projects with context "+@active_context.to_s+" and user_id "+current_user.id.to_s
      @projects = Project.all_active_projects(@active_context,current_user.id )
    end
    
        respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chores }
    end
  end
  
  # GET /status_quo
  # GET /status_quo.json
  def status_quo
    @contexts = Context.where("user_id = ?",current_user.id)
    @choretypes = Choretype.all


    if @contexts.empty?
      @active_context = nil
      @chores = nil
    else
      if params[:context] == nil
        @active_context = @contexts.first.id
      else
        @active_context = params[:context].to_s
      end
     
      choretype_todo = 1 #always todo only in the status quo. Warning: using undeclared constant!
      choretype_appointment = 3
            
      @chores = Chore.all_active_chores(@active_context,choretype_todo, current_user.id)
    
      @appointments = Chore.all_today_and_missed_appointments(@active_context,choretype_appointment, current_user.id)
      @projects = Project.all_active_projects(@active_context,current_user.id )
      @empty_projects = Project.empty_active_projects(@active_context,current_user.id )
    end
    
        respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chores }
    end
  end
  
  # GET /occurrences.json only!
  def occurrences
    @contexts = Context.where("user_id = ?",current_user.id)


    if @contexts.empty?
      @active_context = nil
      @occurrences = nil
    else
      if params[:context] == nil
        @active_context = @contexts.first.id
      else
        @active_context = params[:context].to_s
      end
     
    #puts "got params  "+params.to_s
    
    begin
         start_date = Date.parse(params[:start])
      rescue ArgumentError
         return nil
    end
    begin
         end_date = Date.parse(params[:end])
      rescue ArgumentError
         return nil
    end
      
      @occurrences = Chore.appointment_occurrences(@active_context,start_date,end_date, current_user.id)
    end
    
    #occurrences need to be formated in json with options http://fullcalendar.io/docs/event_data/Event_Object/
    
    respond_to do |format|
      format.json { render json: @occurrences }
    end
  end
  

  # GET /chores/1
  # GET /chores/1.json
  def show
    
    @chore = Chore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chore }
    end
  end

  # GET /chores/new
  # GET /chores/new.json
  def new
    @chore = Chore.new
    @chore.user_id = current_user.id

    # we use list of projects and emails on the view, need to prepare them
   
   @projects = Project.all_active_projects(params[:context],current_user.id )
   @emails = Email.where("user_id = ?",current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chore }
    end
  end

  # GET /chores/1/edit
  def edit
   
    #@projects = Project.where({user_id: current_user.id, someday: false})
    @projects = Project.all_active_projects(params[:context_id],current_user.id )
    @emails = Email.where("user_id = ?",current_user.id)

    @chore = Chore.find(params[:id])
  end

  # POST /chores
  # POST /chores.json
  def create
    if(params[:chore][:deadline] != '' and params[:chore][:deadline] != nil and params[:chore][:deadline] != "not set")
     params[:chore][:deadline]=  DateTime.strptime(params[:chore][:deadline], "%m/%d/%Y").strftime("%Y-%m-%d %z")
      end
    if(params[:chore][:startdate] != "" and params[:chore][:startdate] != nil and params[:chore][:startdate] != "not set")
      params[:chore][:startdate]=  DateTime.strptime(params[:chore][:startdate], "%m/%d/%Y").strftime("%Y-%m-%d %z")
      end 
   # print "create chores controller launched with ", params,"\n"

    @chore = Chore.new(params[:chore])
    @chore.user_id = current_user.id

    #attempt to serialize schedule correctly
    #@chore.schedule = IceCube::Schedule.from_yaml(params[:chore][:schedule])
    
    respond_to do |format|
      if @chore.save
        format.html { redirect_to @chore, notice: 'Chore was successfully created.' }
        format.json { render json: @chore, status: :created, location: @chore }
      else
        format.html { render action: "new" }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chores/1
  # PUT /chores/1.json
  def update
    @chore = Chore.find(params[:id])
    @chore.user_id = current_user.id

  #  print "chore update controller received params: ", params,"\n"

    respond_to do |format|
     if(params[:chore][:deadline] != "" and params[:chore][:deadline] != nil and params[:chore][:deadline] != "not set")
      params[:chore][:deadline]=  DateTime.strptime(params[:chore][:deadline], "%m/%d/%Y").strftime("%Y-%m-%d %z")
      end
    if(params[:chore][:startdate] != "" and params[:chore][:startdate] != nil and params[:chore][:startdate] != "not set")
      params[:chore][:startdate]=  DateTime.strptime(params[:chore][:startdate], "%m/%d/%Y").strftime("%Y-%m-%d %z")
      end  
       
      #attempt to serialize schedule correctly
      #@chore.schedule = IceCube::Schedule.from_yaml(params[:chore][:schedule])
      
      if @chore.update_attributes(params[:chore])
        format.html { redirect_to @chore, notice: 'Chore was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1
  # DELETE /chores/1.json
  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy

    respond_to do |format|
      format.html { redirect_to chores_url }
      format.json { head :no_content }
    end
  end
end
