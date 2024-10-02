# lib/find_tiktok_buzzes.rb
class FindTiktokBuzzes
  def self.find_tiktok_buzzes_daily
    BuzzTerm.where(frequency_check: 'daily').find_each do |buzz_term|
      Rails.logger.info("Buzz Term Daily Check ID: #{buzz_term.id}")
      FindTiktokBuzzesWorker.perform_async(buzz_term.id)
    end
  end

  def self.find_tiktok_buzzes_weekly
    BuzzTerm.where(frequency_check: 'weekly').find_each do |buzz_term|
      Rails.logger.info("Buzz Term Weekly Check ID: #{buzz_term.id}")
      FindTiktokBuzzesWorker.perform_async(buzz_term.id)
    end
  end

  def self.find_tiktok_buzzes_biweekly
    BuzzTerm.where(frequency_check: 'biweekly').find_each do |buzz_term|
      Rails.logger.info("Buzz Term Bi-Weekly Check ID: #{buzz_term.id}")
      FindTiktokBuzzesWorker.perform_async(buzz_term.id)
    end
  end
end
