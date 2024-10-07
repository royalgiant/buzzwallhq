# app/models/buzz_wall.rb
class BuzzWall < ApplicationRecord
  self.table_name = 'buzzes_walls'
  
  belongs_to :buzz
  belongs_to :wall
end