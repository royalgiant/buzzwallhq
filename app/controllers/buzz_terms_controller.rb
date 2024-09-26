class BuzzTermsController < ApplicationController
  before_action :set_buzz_term, only: %i[ show edit update destroy ]

  # GET /buzz_terms or /buzz_terms.json
  def index
    @buzz_terms = BuzzTerm.all
  end

  # GET /buzz_terms/1 or /buzz_terms/1.json
  def show
  end

  # GET /buzz_terms/new
  def new
    @buzz_term = BuzzTerm.new
  end

  # GET /buzz_terms/1/edit
  def edit
  end

  # POST /buzz_terms or /buzz_terms.json
  def create
    @buzz_term = BuzzTerm.new(buzz_term_params)

    respond_to do |format|
      if @buzz_term.save
        format.html { redirect_to buzz_term_url(@buzz_term), notice: "Buzz term was successfully created." }
        format.json { render :show, status: :created, location: @buzz_term }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @buzz_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buzz_terms/1 or /buzz_terms/1.json
  def update
    respond_to do |format|
      if @buzz_term.update(buzz_term_params)
        format.html { redirect_to buzz_term_url(@buzz_term), notice: "Buzz term was successfully updated." }
        format.json { render :show, status: :ok, location: @buzz_term }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @buzz_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzz_terms/1 or /buzz_terms/1.json
  def destroy
    @buzz_term.destroy

    respond_to do |format|
      format.html { redirect_to buzz_terms_url, notice: "Buzz term was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buzz_term
      @buzz_term = BuzzTerm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def buzz_term_params
      params.require(:buzz_term).permit(:term, :user_id, :frequency_check)
    end
end
