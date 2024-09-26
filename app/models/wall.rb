class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :buzz_term
end
