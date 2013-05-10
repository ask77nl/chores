class Chore < ActiveRecord::Base
  attr_accessible :deadline, :email_id, :project_id, :title, :type
  has_many :emails
  belongs_to :project
end
