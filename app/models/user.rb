class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids,
         :unread_inbox_emails, :total_inbox_emails, :unread_project_emails

  validates :password,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,uniqueness:  true, format: { with: VALID_EMAIL_REGEX }

  has_many :chores
  has_many :projects
  has_many :contexts
  has_many :emails
  has_many :emailaccounts

  # attr_accessible :title, :body
  
  def set_total_inbox_flag(total_inbox_emails)
   update_attribute(:total_inbox_emails, total_inbox_emails)
  end
  
  def set_unread_inbox_flag(unread_inbox_emails)
   update_attribute(:unread_inbox_emails, unread_inbox_emails)
  end
end
