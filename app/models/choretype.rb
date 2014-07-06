class Choretype < ActiveRecord::Base
  has_many :chores
  
  validates( :name, presence: true)
end
