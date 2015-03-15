class ProjectsController < ApplicationController
  
  include TheSortableTreeController::Rebuild  


before_filter :authenticate_user!
load_and_authorize_resource

 #stuff for sorted tree 
  def manage
    @pages = Project.nested_set.select('project_id, title, context, parent_project_id').all
  end

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where("user_id = ?",current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @project.user_id = current_user.id

    # we use list of projects and contexts on the view, need to prepare them
    @projects = Project.where("user_id = ?",current_user.id)
    @contexts = Context.where("user_id = ?",current_user.id)


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit

     # we use list of projects and contexts on the view, need to prepare them
    @projects = Project.where("user_id = ?",current_user.id)
    @contexts = Context.where("user_id = ?",current_user.id)

    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
#    if(params[:project].parent_project_id = '')
    @project = Project.new(params[:project])
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
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
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
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
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
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
