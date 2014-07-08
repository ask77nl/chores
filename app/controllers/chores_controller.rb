class ChoresController < ApplicationController
include IceCube
before_filter :authenticate_user!
load_and_authorize_resource 


  # GET /chores
  # GET /chores.json
  def index
    @contexts = Context.where("id = ?",current_user.id)
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
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chores }
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
    @projects = Project.find_all_by_user_id(current_user.id)
    @emails = Email.find_all_by_user_id(current_user.id)


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chore }
    end
  end

  # GET /chores/1/edit
  def edit
     # we use list of projects and emails on the view, need to prepare them
    @projects = Project.find_all_by_user_id(current_user.id)
    @emails = Email.find_all_by_user_id(current_user.id)

    @chore = Chore.find(params[:id])
  end

  # POST /chores
  # POST /chores.json
  def create
    @chore = Chore.new(params[:chore])
    @chore.user_id = current_user.id


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

    respond_to do |format|
     #form correct schedule based on the filled form
      schedule = Schedule.new(Time.now)
    
      case params[:frequencyRadios]
        when "never"
	when "every_n_days"
	 schedule.add_recurrence_rule Rule.daily(params[:daily_day])
        when "every_weekday"
         schedule.add_recurrence_rule Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
        when "every_week"
         schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:monday) if(params[:weekly_monday])=="weekly_monday"
	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:tuesday) if(params[:weekly_tuesday])=="weekly_tuesday"
	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:wednesday) if(params[:weekly_wednesday])=="weekly_wednesday"
 	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:thursday) if(params[:weekly_thursday])=="weekly_thursday"
	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:friday) if(params[:weekly_friday])=="weekly_friday"
	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:saturday) if(params[:weekly_saturday])=="weekly_saturday"
	 schedule.add_recurrence_rule Rule.weekly(params[:weekly_week]).day(:sunday) if(params[:weekly_sunday])=="weekly_sunday"
        when "every_day_n_of_n_month"
         schedule.add_recurrence_rule Rule.monthly(params[:monthly_month].to_i).day_of_month(params[:monthly_day].to_i)
	when "every_month_day"
         schedule.add_recurrence_rule Rule.yearly.month_of_year(params[:yearly_month].underscore.to_sym).day_of_month(params[:yearly_day].to_i)
      end

      case params[:endRadios]
        when "no_end_date"
        when "end_after_n_repeats"
        when "end_by"
      end
      @chore.schedule = schedule
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
