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
