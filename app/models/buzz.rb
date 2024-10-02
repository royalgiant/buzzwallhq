class Buzz < ApplicationRecord
  belongs_to :wall, optional: true
  belongs_to :user
  belongs_to :buzz_term
end
