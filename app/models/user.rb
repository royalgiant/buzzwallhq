class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  attr_accessor :skip_validation

  validates_presence_of :first_name, unless: :skip_validation
  validates_presence_of :last_name, unless: :skip_validation

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.full_name = auth.info.name.titleize
      user.avatar_url = auth.info.image
      user.skip_confirmation!
      user.skip_validation = true
    end
  end
         
end