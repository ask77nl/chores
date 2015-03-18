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
     
     #alternative complex join
     @all_chores = Chore.joins(:project).where({chores: {user_id: user_id, choretype_id: choretype_id}, projects: {context_id: context_id, someday: false}})
     
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
   #in controller they need to be formated in json with options http://fullcalendar.io/docs/event_data/Event_Object/
   nil
  end
 
end
