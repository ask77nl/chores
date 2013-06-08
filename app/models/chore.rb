class Chore < ActiveRecord::Base
  attr_accessible :deadline, :email_id, :project_id, :title, :choretype_id
  has_many :emails
  belongs_to :project
  belongs_to :choretype
end
