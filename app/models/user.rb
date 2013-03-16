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
    self.token_expired?(:reset_password_token, value)
  end

  def self.load_from_change_email_token(value)
    user = find_by_change_email_token(value)
    if user.present? && user.change_email_token_expires_at >
      Time.now.in_time_zone
      user
    else
      nil
    end
  end

  def self.change_email_token_expired?(value)
    self.token_expired?(:change_email_token, value)
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

  def change_email
    if change_email_new_value.present?
      self.email = change_email_new_value
      self.change_email_token = nil
      self.change_email_token_expires_at = nil
      self.change_email_new_value = nil
      save
    end
  end

  private

  def self.token_expired?(token, value)
    expires_at = expires_at_value(
      self.public_send("find_by_#{token}", value), token)
    if expires_at.present? && expires_at < Time.now.in_time_zone
      true
    else
      false
    end
  end

  def self.expires_at_value(user, token)
    user.present? ? user.public_send("#{token}_expires_at") : nil
  end
end
