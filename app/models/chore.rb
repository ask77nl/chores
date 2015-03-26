class Chore < ActiveRecord::Base

  #IceCube stuff
  include IceCube
  serialize :schedule, Hash
  
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
  validates( :user_id, presence: true)



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
   if context_id != nil
      #uses http://www.rubydoc.info/github/seejohnrun/ice_cube/IceCube/Schedule#occurrences_between-instance_method to return events
      
      @all_occurrences = []
      all_chores = Chore.joins(:project).where({chores: {user_id: user_id, choretype_id: 3}, projects: {context_id: context_id, someday: false}})
      
      
     for chore in all_chores do 
       #schedule = IceCube::Schedule.from_yaml(chore[:schedule])
       if (chore[:schedule] != {} and chore[:schedule] != nil)
        schedule = IceCube::Schedule.new(start_time)
        schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(chore[:schedule]))
        for occurence_date in schedule.occurrences_between(start_time, end_time) do
           occurrence_hash = {id: chore.id, title: chore.title, start: occurence_date.start_time , end: occurence_date.end_time, url: "/chores/"+chore.id.to_s+"/edit", allDay: true}
          @all_occurrences << occurrence_hash
        end
       end
       
         
     end
     
     return @all_occurrences
  else
    nil
  end
 
 end
 
 def schedule=(new_schedule)
   
     if new_schedule == nil or new_schedule == 'null'
     
      write_attribute(:schedule, {})
     else
      write_attribute(:schedule, RecurringSelect.dirty_hash_to_rule(new_schedule).to_hash)
     end
  end
 
 def converted_schedule
  the_schedule = Schedule.new(self.start_date)
  the_schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(self.schedule))
  the_schedule
end

 def self.project
  if self.project_id
    return Project.find(self.project_id)
  else
    nil
  end
 
 end
 
end

