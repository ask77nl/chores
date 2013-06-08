Feature: Log in
Users must be able to log in

Scenario: registered users must be able to login 
Given  Visitor visits the login  page 
And He is a registered user
When He is not logged in
And He enters correct email address and passowrd
Then He should be logged in
