
class UserMailer < ApplicationMailer
  # ...existing code...

  def captcha_failed_notification(user_email)
    @user_email = user_email
    mail(to: 'donaldlee50@gmail.com', subject: 'Captcha Verification Failed')
  end
end