class ChoretypesController < ApplicationController
  # GET /choretypes
  # GET /choretypes.json
  def index
    @choretypes = Choretype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @choretypes }
    end
  end

  # GET /choretypes/1
  # GET /choretypes/1.json
  def show
    @choretype = Choretype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @choretype }
    end
  end

  # GET /choretypes/new
  # GET /choretypes/new.json
  def new
    @choretype = Choretype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @choretype }
    end
  end

  # GET /choretypes/1/edit
  def edit
    @choretype = Choretype.find(params[:id])
  end

  # POST /choretypes
  # POST /choretypes.json
  def create
    @choretype = Choretype.new(params[:choretype])

    respond_to do |format|
      if @choretype.save
        format.html { redirect_to @choretype, notice: 'Choretype was successfully created.' }
        format.json { render json: @choretype, status: :created, location: @choretype }
      else
        format.html { render action: "new" }
        format.json { render json: @choretype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /choretypes/1
  # PUT /choretypes/1.json
  def update
    @choretype = Choretype.find(params[:id])

    respond_to do |format|
      if @choretype.update_attributes(params[:choretype])
        format.html { redirect_to @choretype, notice: 'Choretype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @choretype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choretypes/1
  # DELETE /choretypes/1.json
  def destroy
    @choretype = Choretype.find(params[:id])
    @choretype.destroy

    respond_to do |format|
      format.html { redirect_to choretypes_url }
      format.json { head :no_content }
    end
  end
end
