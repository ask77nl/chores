class Emailaccount < ActiveRecord::Base

  attr_accessible :email_address, :authentication_token, :user_id
  belongs_to :user
  
   def self.all_accounts(current_user_id)
     accounts = Emailaccount.where("user_id = ?",current_user_id)
     if accounts.blank?
       #in case of new users, assume their nylas email account is the same as chores email
       user = User.find(current_user_id)
       emailaccount = Emailaccount.create(user_id: user.id, email_address: user.email)
       accounts.push emailaccount
     end
    accounts
   end
   
    def self.save_token(current_user_id, email_address, authentication_token)
     Emailaccount.where({user_id: current_user_id, email_address: email_address}).take.update_attribute("authentication_token", authentication_token)
   end
  
end
