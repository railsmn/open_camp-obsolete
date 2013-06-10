class Task < ActiveRecord::Base
  attr_accessible :due_date, :description, :name
  belongs_to :user

  validates :name, presence: true, length: {minimum: 5, maximum: 30}
  validates :description, presence: true, length: {within: 2..160}
end
