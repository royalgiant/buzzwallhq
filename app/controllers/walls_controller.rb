class WallsController < ApplicationController
  before_action :set_wall, only: %i[ show edit update destroy ]
  before_action :set_buzz_terms, only: %i[ new edit ]

  # GET /walls
  def index
    @walls = Wall.includes(:buzz_term).all
  end

  # GET /walls/new
  def new
    @wall = Wall.new
  end

  # GET /walls/1/edit
  def edit
  end

  # POST /walls
  def create
    @wall = Wall.new(wall_params.merge({user_id: current_user.id}))

    respond_to do |format|
      if @wall.save
        format.html { redirect_to edit_wall_url(@wall), notice: "Wall was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /walls/1
  def update
    respond_to do |format|
      if @wall.update(wall_params)
        format.html { redirect_to walls_url(@wall), notice: "Wall was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walls/1
  def destroy
    @wall.destroy

    respond_to do |format|
      format.html { redirect_to walls_url, notice: "Wall was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wall
      @wall = Wall.find(params[:id])
    end

    def set_buzz_terms
      @buzz_terms = current_user.buzz_terms
    end

    # Only allow a list of trusted parameters through.
    def wall_params
      params.require(:wall).permit(:name, :user_id, :buzz_term_id, :iframe_url, :published)
    end
end
