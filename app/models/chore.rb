class Chore < ActiveRecord::Base

  #IceCube stuff
  include IceCube
  #serialize :schedule, IceCube::Schedule
  
  #recurring model stuff
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  
  attr_accessible :startdate, :deadline, :email_id, :project_id, :title, :choretype_id, :user_id, :schedule
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
     #we return only active projects for the current context
     @all_projects = Project.where(:context_id => context_id, :someday => false)
     return nil if @all_projects == nil

     @all_chores = nil
     @all_projects.each do |project|
      
      if @all_chores == nil
       @all_chores = Chore.where(:project_id => project.id, :user_id =>user_id, :choretype_id => choretype_id)
      else
       @all_chores += Chore.where(:project_id => project.id, :user_id =>user_id, :choretype_id => choretype_id)
      end
     end
    #return nil if no chores found
     if @all_chores.blank? 
	return nil
      else 
	return @all_chores
      end
   else
    nil
   end
  end

 def self.appointment_occurrences(context_id,start_time, end_time,user_id)
   #will use http://www.rubydoc.info/github/seejohnrun/ice_cube/IceCube/Schedule#occurrences_between-instance_method to return events
    nil
  end
 
end
