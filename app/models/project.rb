class Project < ActiveRecord::Base
  has_many :notes
  has_many :tasks
  
  attr_accessible :name
end
