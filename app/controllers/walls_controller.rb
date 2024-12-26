class WallsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy ]
  before_action :set_wall, only: %i[ show edit update destroy load_more ]
  before_action :set_buzz_terms, only: %i[ new create edit update ]
  before_action -> { authorize_user!(@wall) }, only: %i[ update destroy]

  def index
    @walls = current_user.walls.includes(:buzz_term)
    @number_of_views = [["> 10,000 views", 10000], ["> 100,000 views", 100000], ["> 1M+ views", 1000000]]
  end

  def load_more
    @buzzes = @wall.buzzes.order(create_time: :desc).offset(params[:offset]).limit(8)
    @walls = current_user&.walls
    render partial: 'walls/more_buzzes', locals: { buzzes: @buzzes, walls: @walls }
  end


  def show
    if params[:embed_token].present? && params[:embed_token].match?("your_embed_token")
      render 'embed_token_notice', status: :not_found
      return
    end

    unless @wall
      render 'invalid_token', status: :not_found
      return
    end
    
    response.headers['Content-Security-Policy'] = "frame-ancestors 'self' *"
    @is_subscriber = @wall.user&.role.present?
    if !@wall.user&.role.present? && @wall.user.walls.count >= 1
      @buzzes = @wall.buzzes.order(created_at: :desc).limit(9)
    else
      @buzzes = @wall.buzzes
    end
    @walls = current_user&.walls
  end

  def new
    @wall = Wall.new
  end

  def edit
  end

  def create
    @wall = Wall.new(wall_params.merge({user_id: current_user.id}))

    respond_to do |format|
      if !current_user&.role.present? && current_user.walls.count >= 1
        format.html { redirect_to new_wall_path, notice: "Your plan only allows for one wall. If you would like more, please subscribe to a plan!" }
      elsif @wall.save
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
      @wall = if params[:id]
                Wall.find(params[:id])
              elsif params[:embed_token]
                Wall.find_by(embed_token: params[:embed_token].strip)
              end
    end

    def set_buzz_terms
      @buzz_terms = current_user.buzz_terms
    end

    def wall_params
      params.require(:wall).permit(:name, :user_id, :buzz_term_id, :iframe_url, :published)
    end
end
