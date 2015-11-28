# /lib/inboxconverter.rb
 
module InboxConverter
  
 def inbox_threads(inbox)
    # Wait til the sync has successfully started
    thread = inbox.threads.first
    while thread == nil do
      puts "Sync not started yet. Checking again in 2 seconds."
      sleep 2
      thread = inbox.threads.first
    end
    threads_array = inbox.threads.where(:tag => 'inbox').all

    #turn off again if there are trash treads in the inbox
    #threads_array.each do |thread|
    #  thread.tags.each do |tag|
    #    if tag['name'] == 'trash'
    #      threads_array.delete(thread)
    #    end
    #  end
    #end
   threads_array
 end
 
 def unread_count(inbox)
   unread_count =0
   inbox.threads.where(:tag => 'inbox').each do |thread|
     if thread.raw_json['unread'] == true
       unread_count=unread_count+1
     end
   end
   unread_count
 end

 def my_email(inbox)
   inbox.account.email_address
 end
 
  def my_provider(inbox)
   inbox.account.provider
 end
 
 def archive_thread(inbox, thread_id)
   thread = inbox.threads.find(thread_id)
   chores_archive_label = nil
   inbox_label = nil
   chores_label = nil
   inbox.labels.each do |label|
     if label.display_name == 'Chores'
       chores_label = label
     end
     if label.display_name == 'Chores/Archived'
       chores_archive_label = label
     end
     if label.display_name == 'Inbox'
       inbox_label = label
     end
   end
   thread.labels.push(chores_archive_label)
   thread.labels.delete(inbox_label)
   thread.labels.delete(chores_label)
   thread.save!
 end

 def move_thread_to_chores(inbox, thread_id)
   thread = inbox.threads.find(thread_id)

   chores_label = nil
   inbox_label = nil
   inbox.labels.each do |label|
     if label.display_name == 'Chores'
       chores_label = label
     end
     if label.display_name == 'Inbox'
       inbox_label = label
     end
   end
   thread.labels.push(chores_label)
   thread.labels.delete(inbox_label)
   thread.save!


 end
 
 def mark_thread_as_read(inbox, thread_id)
   thread = inbox.threads.find(thread_id)
   thread.mark_as_read!
 end
 
 def get_messages(inbox, thread_id)
   inbox.messages.where(:thread_id => thread_id).all
 end
 
  def get_thread(inbox, thread_id)
   begin
    inbox.threads.find(thread_id)
   rescue Inbox::ResourceNotFound
    nil
   end
 end

end