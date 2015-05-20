# /lib/inboxconverter.rb
 
module InboxConverter
  
  def inbox_threads(inbox)
   namespace = inbox.namespaces.first

    # Wait til the sync has successfully started
    thread = namespace.threads.first
    while thread == nil do
      puts "Sync not started yet. Checking again in 2 seconds."
      sleep 2
      thread = namespace.threads.first
    end
  
  namespace.threads.where(:tag => 'inbox')
 end

 def my_email(inbox)
   namespace = inbox.namespaces.first 
   
   namespace.email_address
 end
 
end