class Household < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, uniqueness: true
  validates :head, presence: true

  belongs_to :head, class_name: 'User',
    foreign_key: 'head_id'
end
