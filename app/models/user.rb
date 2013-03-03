class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_accessible :username, :email, :password,
    :password_confirmation, :full_name

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
    format: { with: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i }
  validates :password, presence: true,
    on: :create
  validates :password, confirmation: true, length: { minimum: 6 },
    if: :password

  belongs_to :household

  has_many :co_members, through: :household, source: :members,
    conditions: proc { ['users.id != ?', self.id] }

  def self.valid_email?(value)
    !!(value =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)
  end

  def self.available_email?(value)
    !find_by_email(value)
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

  def update_personal_attributes(params)
    update_attributes(params.slice(:username, :full_name))
  end

  def deliver_change_email_instructions!(new_email)
    return false if !self.class.available_email?(new_email)

    self.change_email_token = TemporaryToken.generate_random_token
    self.change_email_token_expires_at = Time.now.in_time_zone + 172800
    self.change_email_new_value = new_email
    if save
      UserMailer.change_email_address_email(self).deliver
      true
    else
      self.change_email_token = nil
      self.change_email_token_expires_at = nil
      self.change_email_new_value = nil
      false
    end
  end

  def change_email(email)
    self.email = email
    save
  end
end
