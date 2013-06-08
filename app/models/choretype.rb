class Choretype < ActiveRecord::Base
  attr_accessible :name
  has_many :chores
end
