# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Chores::Application.initialize!


Time::DATE_FORMATS[:due_date] = "%m/%d/%Y "


