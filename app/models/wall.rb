class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :buzz_term
  has_and_belongs_to_many :buzzes, join_table: :buzzes_walls
  validates :embed_token, uniqueness: true, allow_blank: true
  before_save :generate_embed_token

  def generate_embed_token
    self.embed_token = SecureRandom.hex(10) if self.embed_token.blank?
  end
end
