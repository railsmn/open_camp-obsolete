class Note < ActiveRecord::Base
  belongs_to :project
  
  attr_accessible :body, :title
end
