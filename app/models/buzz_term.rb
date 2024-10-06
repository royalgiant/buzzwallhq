class BuzzTerm < ApplicationRecord
  belongs_to :user
  has_many :walls, dependent: :destroy
  has_many :buzzes, dependent: :destroy

  FREQUENCY_OPTIONS = %w[daily weekly biweekly monthly never].freeze

  validates :term, presence: true
  validates :frequency_check, inclusion: { in: FREQUENCY_OPTIONS }

  def get_tiktok_publish_time
    case frequency_check
    when 'daily'
      1
    when 'weekly'
      7
    when 'biweekly'
      14
    when 'monthly'
      30
    else
      0
    end
  end
end
