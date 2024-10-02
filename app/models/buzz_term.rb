class BuzzTerm < ApplicationRecord
  belongs_to :user
  has_many :walls, dependent: :destroy
  has_many :buzzs, dependent: :destroy

  FREQUENCY_OPTIONS = %w[daily weekly biweekly monthly never].freeze

  validates :term, presence: true
  validates :frequency_check, inclusion: { in: FREQUENCY_OPTIONS }
end
