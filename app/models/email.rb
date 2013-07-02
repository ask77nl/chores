class Email < ActiveRecord::Base
  attr_accessible :body, :datetime, :from, :subject, :to
  has_many :chores
  validates(:subject, presence: true)
end
