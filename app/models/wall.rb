class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :buzz_term
  has_and_belongs_to_many :buzzes
end
