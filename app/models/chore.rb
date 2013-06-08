class Chore < ActiveRecord::Base
  attr_accessible :deadline, :email_id, :project_id, :title, :choretype_id
  belongs_to :email
  belongs_to :project
  belongs_to :choretype
end
