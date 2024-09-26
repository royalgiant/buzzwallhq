class BuzzTerm < ApplicationRecord
  belongs_to :user

  FREQUENCY_OPTIONS = %w[daily weekly biweekly monthly never].freeze

  validates :term, presence: true
  validates :frequency_check, inclusion: { in: FREQUENCY_OPTIONS }
end
