class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
  redirect_to root_path, :alert => exception.message
  
  before_filter :set_app_variables

 def set_app_variables
   Time.zone = 'Eastern Time (US & Canada)'
 end
    
  end
end
