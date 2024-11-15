class BuzzesController < ApplicationController
  before_action :authenticate_user!, only: %i[ update destroy ]
  before_action :set_buzz, only: %i[ update destroy ]
  before_action -> { authorize_user!(@buzz) }, only: %i[ update destroy]

  def index
    if current_user.nil?
      redirect_to home_index_path
    else
      @view_count = params[:views].to_i || 0
      @reviewed = params[:reviewed] == 'true'
      if @reviewed
        @buzz_terms = current_user.buzz_terms.includes(buzzes: :walls).where.not(buzzes: { walls: { id: nil } }).where(play_count_condition)
      else
        @buzz_terms = current_user.buzz_terms.includes(buzzes: :walls).where(buzzes: { walls: { id: nil } }).where(play_count_condition)
      end
      @walls = current_user.walls
    end
  end

  def load_more
    @buzz_term = BuzzTerm.find(params[:term_id])
    @reviewed = params[:reviewed] == 'true'
    @buzzes = if @reviewed
                @buzz_term.buzzes.where(approved: true).order(create_time: :desc).offset(params[:offset]).limit(8)
              else
                @buzz_term.buzzes.where(approved: false).order(create_time: :desc).offset(params[:offset]).limit(8)
              end
    @walls = current_user.walls
    render partial: 'buzzes/more_buzzes', locals: { buzzes: @buzzes, walls: @walls }
  end

  # PATCH/PUT /buzzs/1 or /buzzs/1.json
  def update
    respond_to do |format|
      if @buzz.update(buzz_params.merge(approved: true))
        format.turbo_stream { render turbo_stream: turbo_stream.remove("buzz-#{@buzz.id}") }
      else
        format.turbo_stream { render json: @buzz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzzs/1 or /buzzs/1.json
  def destroy
    @buzz = Buzz.find(params[:id])
    @buzz.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("buzz-#{@buzz.id}") }
      format.html { redirect_to buzzes_url, notice: 'Buzz was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buzz
      @buzz = Buzz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def buzz_params
      params.require(:buzz).permit(:url, :wall_id, :thumbnail_url, :user_id, :approved, :buzz_term_id, wall_ids: [])
    end

    def play_count_condition
      case @view_count
      when 10000
        ['buzzes.play_count >= ? AND buzzes.play_count < ?', 10000, 100001]
      when 100000
        ['buzzes.play_count >= ? AND buzzes.play_count < ?', 100000, 1000001]
      when 1000000
        ['buzzes.play_count >= ?', 1000000]
      else
        ['buzzes.play_count >= ?', 0]
      end
    end
end
