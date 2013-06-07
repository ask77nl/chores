Feature: Sign up
Having clear sign up link on the very first page of the site is very important for every SaaS application

Scenario: Sign up page must be availalbe for new visitors 
Given  Visitor visits the home page 
When He is not logged in
Then He should see the sign up button
And he should see the log in button

Scenario: User must sign-up without confirmation
Given Visitor visits the sign-up page
And He is not logged in
When he enters email address and password
Then Site must sign him up

