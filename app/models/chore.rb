class Chore < ActiveRecord::Base
  attr_accessible :deadline, :email_id, :project_id, :title, :choretype_id
  belongs_to :email
  belongs_to :project
  belongs_to :choretype


 def self.all_chores_by_context(id)
   if id != nil
     @all_projects = Project.where(:context_id => id)
     return nil if @all_projects == nil

     @all_chores = nil
     @all_projects.each do |project|
      if @all_chores == nil
       @all_chores = Chore.where(:project_id => project.id)
      else
       @all_chores += Chore.where(:project_id => project.id)
      end
     end
     @all_chores
   else
    nil
   end
  end

end
