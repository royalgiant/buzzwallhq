class BuzzesController < ApplicationController
  before_action :authenticate_user!, only: %i[ update destroy ]
  before_action :set_buzz, only: %i[ update destroy ]
  before_action -> { authorize_user!(@buzz) }, only: %i[ update destroy]

  def index
    if current_user.nil?
      redirect_to home_index_path
    else
      @view_count = params[:views] || 0
      @reviewed = params[:reviewed] == 'true'
      if @reviewed
        @buzz_terms = current_user.buzz_terms.includes(buzzes: :walls).where.not(buzzes: { walls: { id: nil } }).where('buzzes.play_count >= ?', @view_count)
      else
        @buzz_terms = current_user.buzz_terms.includes(buzzes: :walls).where(buzzes: { walls: { id: nil } }).where('buzzes.play_count >= ?', @view_count)
      end
      @walls = current_user.walls
    end
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
end
