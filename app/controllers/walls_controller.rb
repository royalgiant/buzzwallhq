class WallsController < ApplicationController
  before_action :set_wall, only: %i[ show edit update destroy ]
  before_action :set_buzz_terms, only: %i[ new edit ]

  def index
    @walls = Wall.includes(:buzz_term).all
  end

  def show
    @buzzes = @wall.buzzes
  end

  def new
    @wall = Wall.new
  end

  def edit
  end

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

  def update
    respond_to do |format|
      if @wall.update(wall_params)
        format.html { redirect_to walls_url(@wall), notice: "Wall was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wall.destroy

    respond_to do |format|
      format.html { redirect_to walls_url, notice: "Wall was successfully destroyed." }
    end
  end

  private
    def set_wall
      @wall = Wall.find(params[:id])
    end

    def set_buzz_terms
      @buzz_terms = current_user.buzz_terms
    end

    def wall_params
      params.require(:wall).permit(:name, :user_id, :buzz_term_id, :iframe_url, :published)
    end
end
