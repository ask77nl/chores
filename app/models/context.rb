class Context < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :projects
  belongs_to :user
  validates( :name, presence: true)
  validates(:user_id, presence: true)

end
