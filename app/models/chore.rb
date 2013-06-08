class Chore < ActiveRecord::Base
  attr_accessible :deadline, :email_id, :project_id, :title, :choretype_id
  belongs_to :email
  belongs_to :project
  belongs_to :choretype


 def all_chores_by_context(id)
   if id != nil
     @all_projects = Project.where(:context_id => params[:id])

     @all_projects.each do |project|
      @all_chores += Chore.where(:project_id => project.id)
     end
     return @all_chores
   else
    return nil
   end
  end

end
