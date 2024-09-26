class BuzzsController < ApplicationController
  before_action :set_buzz, only: %i[ show edit update destroy ]

  # GET /buzzs or /buzzs.json
  def index
    @buzzs = Buzz.all
  end

  # GET /buzzs/1 or /buzzs/1.json
  def show
  end

  # GET /buzzs/new
  def new
    @buzz = Buzz.new
  end

  # GET /buzzs/1/edit
  def edit
  end

  # POST /buzzs or /buzzs.json
  def create
    @buzz = Buzz.new(buzz_params)

    respond_to do |format|
      if @buzz.save
        format.html { redirect_to buzz_url(@buzz), notice: "Buzz was successfully created." }
        format.json { render :show, status: :created, location: @buzz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @buzz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buzzs/1 or /buzzs/1.json
  def update
    respond_to do |format|
      if @buzz.update(buzz_params)
        format.html { redirect_to buzz_url(@buzz), notice: "Buzz was successfully updated." }
        format.json { render :show, status: :ok, location: @buzz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @buzz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzzs/1 or /buzzs/1.json
  def destroy
    @buzz.destroy

    respond_to do |format|
      format.html { redirect_to buzzs_url, notice: "Buzz was successfully destroyed." }
      format.json { head :no_content }
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
