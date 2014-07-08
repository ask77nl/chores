class Email < ActiveRecord::Base
  attr_accessible :body, :datetime, :from, :subject, :to, :user_id
  has_many :chores
  belongs_to :user
  validates(:subject, presence: true)
  validates(:user_id, presence: true)

end
