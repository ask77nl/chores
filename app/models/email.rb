class Email < ActiveRecord::Base
  attr_accessible :body, :datetime, :from, :subject, :to
  has_many :chores
  belongs_to :user
  validates(:subject, presence: true)
  validates(:user_id, presence: true)

end
