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
   inbox.threads.where(:tag => 'unread').count
 end

 def my_email(inbox)
   inbox.account.email_address
 end
 
  def my_provider(inbox)
   inbox.account.provider
 end
 
 def archive_thread(inbox, thread_id)
   thread = inbox.threads.find(thread_id)
   thread.archive!
 end
 
 def get_messages(inbox, thread_id)
   inbox.messages.where(:thread_id => thread_id).all
 end
 
  def get_thread(inbox, thread_id)
   inbox.threads.find(thread_id)
 end

end