class Chore < ActiveRecord::Base
  include IceCube

  serialize :schedule, IceCube::Schedule
  
  attr_accessible :deadline, :email_id, :project_id, :title, :choretype_id, :user_id, :schedule
  belongs_to :email
  belongs_to :user
  belongs_to :project
  belongs_to :choretype

  validates( :title, presence: true)
  validates( :project_id, presence: true)
  validates( :choretype_id, presence: true)
  validates(:user_id, presence: true)



 def self.all_chores_by_context_type_and_user(context_id,choretype_id,user_id)
   if context_id != nil
     @all_projects = Project.where(:context_id => context_id)
     return nil if @all_projects == nil

     @all_chores = nil
     @all_projects.each do |project|
      conditions = {:project_id => project.id, :user_id =>user_id}
      if @all_chores == nil
       @all_chores = Chore.where(:project_id => project.id, :user_id =>user_id, :choretype_id => choretype_id)
      else
       @all_chores += Chore.where(:project_id => project.id, :user_id =>user_id, :choretype_id => choretype_id)
      end
     end
     @all_chores
   else
    nil
   end
  end

end
