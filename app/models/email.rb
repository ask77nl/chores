class Email < ActiveRecord::Base
  attr_accessible :body, :datetime, :from, :subject, :to
  belongs_to :chore
end
