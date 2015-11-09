class Emailaccount < ActiveRecord::Base

  attr_accessible :email_address, :authentication_token
  belongs_to :user
  
   def self.all_accounts(cuser_id)
     accounts = Emailaccount.where("user_id = ?",current_user.id)
     if accounts.length = 0 
       #in case of new users, assume their nylas email account is the same as chores email
       user = User.where("user_id = ?",current_user.id)
       emailaccount = Emailaccount.create(user_id: current_user.id, email_address: user.email)
       accounts.push emailaccount
     end
    accounts
   end
  
end
