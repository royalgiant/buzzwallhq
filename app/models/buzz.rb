class Buzz < ApplicationRecord
  belongs_to :wall
  belongs_to :user
  belongs_to :buzz_term
end
