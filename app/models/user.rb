class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_accessible :username, :email, :password, :password_confirmation

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
    format: { with: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i }
  validates :password, presence: true,
    on: :create
  validates :password, confirmation: true, length: { minimum: 6 },
    if: :password

  def self.valid_email?(value)
    value =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  end
end
