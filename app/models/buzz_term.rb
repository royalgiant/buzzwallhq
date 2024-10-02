class BuzzTerm < ApplicationRecord
  belongs_to :user
  has_many :walls, dependent: :destroy
  has_many :buzzs, dependent: :destroy

  FREQUENCY_OPTIONS = %w[daily weekly biweekly monthly never].freeze

  validates :term, presence: true
  validates :frequency_check, inclusion: { in: FREQUENCY_OPTIONS }

  def self.run_daily_jobs
    where(frequency_check: 'daily').find_each do |buzz_term|
      FindTiktokVideoJob.perform_later(buzz_term)
    end
  end

  def self.run_weekly_jobs
    where(frequency_check: 'weekly').find_each do |buzz_term|
      FindTiktokVideoJob.perform_later(buzz_term)
    end
  end

  def self.run_biweekly_jobs
    where(frequency_check: 'biweekly').find_each do |buzz_term|
      FindTiktokVideoJob.perform_later(buzz_term)
    end
  end
end
