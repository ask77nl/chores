Feature: Log out
Users must be able to log out

Scenario: registered users must be able to logout
Given  Visitor is logged it
When He clicks on log out button
Then He should see the home page
