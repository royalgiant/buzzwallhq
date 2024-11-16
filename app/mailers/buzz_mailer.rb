
class BuzzMailer < ApplicationMailer
  def viral_videos_found
    @user = User.find(params[:user_id])
    @play_count_over_1m = params[:play_count_over_1m]
    @play_count_over_100k = params[:play_count_over_100k]
    mail(to: @user.email, subject: "New Viral Videos Found at BuzzwallHQ!")
  end
end