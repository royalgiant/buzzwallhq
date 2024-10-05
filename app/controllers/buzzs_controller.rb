class BuzzsController < ApplicationController
  before_action :set_buzz, only: %i[ show edit update destroy ]

  def index
    if current_user.nil?
      redirect_to home_index_path
    else
      @buzz_terms = current_user.buzz_terms.includes(:buzzs)
      @walls = current_user.walls
    end
  end

  # PATCH/PUT /buzzs/1 or /buzzs/1.json
  def update
    respond_to do |format|
      if @buzz.update(buzz_params)
        format.json { render :show, status: :ok, location: @buzz }
      else
        format.json { render json: @buzz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzzs/1 or /buzzs/1.json
  def destroy
    @buzz = Buzz.find(params[:id])
    # @buzz.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("buzz-#{@buzz.id}") }
      format.html { redirect_to buzzs_url, notice: 'Buzz was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buzz
      @buzz = Buzz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def buzz_params
      params.require(:buzz).permit(:url, :wall_id, :thumbnail_url, :user_id, :approved, :buzz_term_id)
    end
end
