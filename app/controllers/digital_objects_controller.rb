class DigitalObjectsController < ApplicationController
  before_action :set_digital_object, only: [:show, :edit, :update, :destroy]

  # GET /digital_objects
  # GET /digital_objects.json
  def index
    @digital_objects = DigitalObject.all
  end

  # GET /digital_objects/1
  # GET /digital_objects/1.json
  def show
  end

  # GET /digital_objects/new
  def new
    @digital_object = DigitalObject.new
  end

  # GET /digital_objects/1/edit
  def edit
  end

  # POST /digital_objects
  # POST /digital_objects.json
  def create
    @digital_object = DigitalObject.new(digital_object_params)

    respond_to do |format|
      if @digital_object.save
        format.html { redirect_to @digital_object, notice: 'Digital object was successfully created.' }
        format.json { render action: 'show', status: :created, location: @digital_object }
      else
        format.html { render action: 'new' }
        format.json { render json: @digital_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /digital_objects/1
  # PATCH/PUT /digital_objects/1.json
  def update
    respond_to do |format|
      if @digital_object.update(digital_object_params)
        format.html { redirect_to @digital_object, notice: 'Digital object was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @digital_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /digital_objects/1
  # DELETE /digital_objects/1.json
  def destroy
    @digital_object.destroy
    respond_to do |format|
      format.html { redirect_to digital_objects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_digital_object
      @digital_object = DigitalObject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def digital_object_params
      params.require(:digital_object).permit(:home_repository)
    end
end
