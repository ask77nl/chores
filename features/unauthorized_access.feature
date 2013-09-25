Feature: Unauthorized access 
If user is not logged in he should not see any of the classes

Scenario Outline: access to different information by unauthorized user 
Given He visits the <Page>
And He is not logged in
Then He should be redirected to sign-in page

Examples:
|Page|
|chores|
|projects|
|emails|
|contexts|


Scenario: access to chores by wrong user
Given user1 created chore "user1 chore"
And user2 logged in
And user2 visits the chores
Then He should not see "user1 chore"
