class WallsController < ApplicationController
  before_action :set_wall, only: %i[ show edit update destroy ]

  # GET /walls or /walls.json
  def index
    @walls = Wall.all
  end

  # GET /walls/1 or /walls/1.json
  def show
  end

  # GET /walls/new
  def new
    @wall = Wall.new
  end

  # GET /walls/1/edit
  def edit
  end

  # POST /walls or /walls.json
  def create
    @wall = Wall.new(wall_params)

    respond_to do |format|
      if @wall.save
        format.html { redirect_to wall_url(@wall), notice: "Wall was successfully created." }
        format.json { render :show, status: :created, location: @wall }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /walls/1 or /walls/1.json
  def update
    respond_to do |format|
      if @wall.update(wall_params)
        format.html { redirect_to wall_url(@wall), notice: "Wall was successfully updated." }
        format.json { render :show, status: :ok, location: @wall }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walls/1 or /walls/1.json
  def destroy
    @wall.destroy

    respond_to do |format|
      format.html { redirect_to walls_url, notice: "Wall was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wall
      @wall = Wall.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wall_params
      params.require(:wall).permit(:name, :user_id, :buzz_term_id, :iframe_url, :published)
    end
end
