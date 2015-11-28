class Chore < ActiveRecord::Base

  #IceCube stuff
  include IceCube
  serialize :schedule, Hash
  
  #recurring model stuff
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  
  
  attr_accessible :startdate, :deadline, :email_id, :project_id, :title, :choretype_id, :user_id, :schedule, :all_day, :next_action, :archived
  belongs_to :email
  belongs_to :user
  belongs_to :project
  belongs_to :choretype

  validates( :title, presence: true)
  validates( :project_id, presence: true, :allow_nil => true)
  validates( :choretype_id, presence: true)
  validates( :user_id, presence: true)



 def self.all_chores_by_context_type_and_user(context_id,choretype_id,user_id)
   Chore.joins(:project).where({chores: {user_id: user_id, choretype_id: choretype_id, archived: false}, projects: {context_id: context_id, someday: false}}).order("projects.lft asc")
 end
 
  def self.all_archived_chores(user_id)
   return Chore.where({:user_id => user_id, :archived => true})
 end
  
 def self.all_active_chores(context_id,choretype_id,user_id)
   all_chores = self.all_chores_by_context_type_and_user(context_id,choretype_id,user_id)
   return all_chores.where("startdate < ? or startdate is null", Time.zone.now.midnight+ 1.day).where(:next_action => true)
 end

 def self.orphan_chores()
     return Chore.where({:project_id => nil, :archived => false})
 end

 
 def self.all_today_and_missed_appointments(context_id,choretype_id,user_id)
   
   all_chores = self.all_chores_by_context_type_and_user(context_id,choretype_id,user_id)
   appointments = []
   
   if all_chores
    #first get all simple appointments from today and past
     for chore in all_chores do
       if chore.startdate and chore.startdate < Time.zone.now.midnight+ 1.day and chore.schedule == {}
         appointments << chore
       end
     end

    #puts "now appointments length is "+ appointments.length.to_s
    #then get all active reoccurring events
   
    reoccurring_chores = all_chores.where("schedule is not null")
      
    for chore in reoccurring_chores do 
      if chore.startdate and chore.startdate < Time.zone.now.midnight+ 1.day
          schedule = IceCube::Schedule.new(Time.zone.parse('2015-01-01 00:00'))
          schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(chore[:schedule]))
          if schedule.occurring_between?(Time.zone.parse('2015-01-01 00:00'),Time.zone.now.midnight+ 1.day)
            appointments << chore
          end
      end
    end
   end
   return appointments
end

 def self.appointment_occurrences(context_id,start_time, end_time,user_id)
   if context_id != nil
      #uses http://www.rubydoc.info/github/seejohnrun/ice_cube/IceCube/Schedule#occurrences_between-instance_method to return events
      
      @all_occurrences = []
      #temporary ignore context on calendar
      all_chores = Chore.joins(:project).where({chores: {user_id: user_id, choretype_id: 3, archived: false}, projects: {someday: false}})
      #all_chores = Chore.joins(:project).where({chores: {user_id: user_id, choretype_id: 3}, projects: {context_id: context_id, someday: false}})
      
      #puts "got chores: "+all_chores.length.to_s
      
     for chore in all_chores do 
       #if a chore has dates but no schedule
       if (chore[:startdate]!= nil and chore[:deadline] != nil and (chore[:schedule] == nil or chore[:schedule] == {}) )
         appointment_hash = {id: chore.id, title: chore.title, start: chore.startdate , end: chore.deadline, url: "/chores/"+chore.id.to_s+"/edit", allDay: chore.all_day}
         @all_occurrences << appointment_hash
       end
       
       #if a chore has a schedule
       if (chore[:schedule] != {} and chore[:schedule] != nil)
        schedule = IceCube::Schedule.new(chore.startdate)
        schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(chore[:schedule]))
        #puts "analyzing schedule : "+schedule.to_s
        
        for occurrence_date in schedule.occurrences_between(start_time, end_time) do
           udjusted_start_time = DateTime.parse(occurrence_date.start_time.to_s)
           if(chore.startdate)
            udjusted_start_time= udjusted_start_time.change(hour:chore.startdate.strftime('%H').to_i , min: chore.startdate.strftime('%M').to_i )
           end
           udjusted_end_time = DateTime.parse(occurrence_date.end_time.to_s)
           if(chore.deadline)
            udjusted_end_time= udjusted_end_time.change(hour:chore.deadline.strftime('%H').to_i , min: chore.deadline.strftime('%M').to_i )
           end
           occurrence_hash = {id: chore.id, title: chore.title, start: udjusted_start_time , end: udjusted_end_time, url: "/chores/"+chore.id.to_s+"/edit", allDay: chore.all_day}
          @all_occurrences << occurrence_hash
        end
       end
     end
  end
  return @all_occurrences
 end
 

 
 def schedule=(new_schedule)
   
     
     if new_schedule == nil or new_schedule == 'null'
      write_attribute(:schedule, nil)
     else
      write_attribute(:schedule, RecurringSelect.dirty_hash_to_rule(new_schedule).to_hash)
     end
 end
 
 def move_start_date_to_next_occurrence
  if self.schedule != {} and self.startdate < Time.zone.now.midnight+ 1.day
    schedule = IceCube::Schedule.new()
    schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(self.schedule))
 
    new_startdate = schedule.next_occurrence(Time.zone.now.midnight+ 1.day)
    new_deadline = schedule.next_occurrence(Time.zone.now.midnight+ 1.day)
    
    if self.all_day == false
      new_startdate_string = new_startdate.strftime("%Y-%m-%d")
      new_deadline_string = new_deadline.strftime("%Y-%m-%d") 

      new_startdate_string += " "+self.startdate.strftime('%H')+":"+self.startdate.strftime('%M')+" -0400"
      new_deadline_string += " "+self.deadline.strftime('%H')+":"+self.deadline.strftime('%M')+" -0400"
      
      new_startdate = DateTime.strptime(new_startdate_string, "%Y-%m-%d %H:%M %z")
      new_deadline = DateTime.strptime(new_deadline_string, "%Y-%m-%d %H:%M %z")
    end

    self.update_attribute(:startdate, new_startdate)
    self.update_attribute(:deadline, new_deadline)
    
    return new_startdate
  else
    nil
  end
 end
 
# def converted_schedule
#  the_schedule = Schedule.new(self.start_date)
#  the_schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(self.schedule))
#  the_schedule
#end

def archive
   project_id = self.project_id
   if self.next_action
      all_chores = Chore.where(:project_id => project_id)
      if all_chores.where(:next_action => true).length == 1
        all_chores.update_all(:next_action => true)
      end
    end
   self.update_attribute(:archived, true)
   #self.save!
end



 def self.project
  if self.project_id
    return Project.find(self.project_id)
  else
    nil
  end
 
 end
 
end

