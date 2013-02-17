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
    !!(value =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)
  end

  def self.reset_password_token_expired?(value)
    user = find_by_reset_password_token(value)
    if user.present? && !user.reset_password_token_expires_at.nil?
      user.reset_password_token_expires_at < Time.now.in_time_zone
    else
      false
    end
  end

  def admin?
    role == 'admin'
  end

  def needs_to_be_admin?
    !admin? && new_record? && User.count == 0
  end

  def set_to_be_admin
    self.role = 'admin' unless admin?
  end
end
