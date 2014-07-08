class Choretype < ActiveRecord::Base

  attr_accessible :name
  has_many :chores
  
  validates( :name, presence: true)
end
