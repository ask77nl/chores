class ChoresController < ApplicationController
before_filter :authenticate_user!
load_and_authorize_resource 


  # GET /chores
  # GET /chores.json
  def index
    @contexts = Context.find_all_by_user_id(current_user.id)
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
