class BuzzTermsController < ApplicationController
  include RapidApiClient
  before_action :authenticate_user!, only: %i[ show new edit create update destroy ]
  before_action :set_buzz_term, only: %i[ show edit update destroy ]
  before_action -> { authorize_user!(@buzz_term) }, only: %i[ show edit update destroy]

  # GET /buzz_terms or /buzz_terms.json
  def index
    if current_user.nil?
      redirect_to home_index_path
    else
      @buzz_terms = current_user.buzz_terms
    end
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
    @buzz_term = BuzzTerm.new(buzz_term_params.merge({user_id: current_user.id, frequency_check: get_frequency_check}))

    respond_to do |format|
      if (!current_user&.role.present? && current_user.buzz_terms.count >= 2) || 
        (current_user&.role.present? && current_user&.role == User::LIFETIME_STARTER && current_user.buzz_terms.count >= 10) ||
        (current_user&.role.present? && current_user&.role == User::LIFETIME_LAUNCH && current_user.buzz_terms.count >= 50) ||
        (current_user&.role.present? && current_user&.role == User::LIFETIME_GROW && current_user.buzz_terms.count >= 100)
        format.html { redirect_to new_buzz_term_path, notice: "You have exceeded the number of keywords tracked. If you would like more, please subscribe or upgrade your plan!" }
      elsif @buzz_term.save
        get_initial_buzzes
        format.html { redirect_to edit_buzz_term_url(@buzz_term), notice: "Buzz term was successfully created. Please come back later to check for new buzzes!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buzz_terms/1 or /buzz_terms/1.json
  def update
    respond_to do |format|
      if @buzz_term.update(buzz_term_params)
        format.html { redirect_to buzz_terms_url, notice: "Buzz term was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzz_terms/1 or /buzz_terms/1.json
  def destroy
    @buzz_term.destroy

    respond_to do |format|
      format.html { redirect_to buzz_terms_url, notice: "Buzz term was successfully destroyed." }
    end
  end

  private

  def get_frequency_check
    case current_user&.role
    when User::LIFETIME_STARTER
      "monthly"
    when User::LIFETIME_LAUNCH
      "weekly"
    when User::LIFETIME_GROW, User::ADMIN
      "daily"
    else
      "monthly"
    end
  end

  def get_initial_buzzes
    case current_user&.role
    when User::LIFETIME_STARTER
      FindTiktokBuzzes.find_tiktok_buzzes_monthly
    when User::LIFETIME_LAUNCH
      FindTiktokBuzzes.find_tiktok_buzzes_weekly
    when User::LIFETIME_GROW, User::ADMIN
      FindTiktokBuzzes.find_tiktok_buzzes_daily
    else
      FindTiktokBuzzes.find_tiktok_buzzes_monthly
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_buzz_term
      @buzz_term = BuzzTerm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def buzz_term_params
      params.require(:buzz_term).permit(:term, :user_id, :frequency_check)
    end
end
