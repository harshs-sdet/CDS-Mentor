*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Workspace/Workspace.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource


Suite Setup     Run Keywords    Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
...             AND             Navigate To Users List Page
...             AND             Wait For The Page To Load

Test Teardown    Ensure Users List Page Is Open
Suite Teardown      Close All Browsers

*** Test Cases ***

Verify User Count Display on User List Page
    [Tags]  CZ-6292   CZ-6298    sanity 
    When Verify The Same Total Users Count From Header And Pagination
    And Save User Count Before Updating Users List
    And Click On ADD New Button On Users List Page
    And Enter the User Email    Author
    And Update The Personal Detail      Author
    And Navigate To Professional Details
    And Update The Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Verify The User Count Is Updated After Adding New User
    And Verify The Same Total Users Count From Header And Pagination



Verify the correct personas are displayed in the dropdown while creating new user with site admin and Org admin
    [Tags]    CZ-7464    CZ-7465    sanity
    When Navigate To Users List Page
    And Click Add New Button On User List Page
    ${BASE}=    Generate Random String
    And Enter the User Email     ${BASE}
    And Navigate To Professional Details
    And Verify The User Can Create New Personas when Logged In As    Site Admin
    And Login Again As Org Admin
    And Navigate To Users List Page
    And Click Add New Button On User List Page
    And Enter the User Email     ${BASE}
    And Update The Personal Detail   role=Mentor Site
    And Navigate To Professional Details
    And Verify The User Can Create New Personas when Logged In As    Org Admin
    And Update The Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Verify The New Created User
    Then Verify The Data Of Users On List Page    SITE_NAME=${TD_SITE_NAME}    USER_ROLE=Mentor Site Admin

Verify Status Toggle functionality in the view user page
    [Tags]  CZ-6268   
    When Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Toggle The Status
    And Save The User Changes
    And Validate The User Status

Verify 'Edit' Button Functionality in the view user page
    [Tags]  CZ-6269   CZ-6274   CZ-6301    
    When Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Update The Personal Detail    Author
    And Save The User Changes
    And Navigate To User Details Page
    And Validate The Updated User Details

Verify user is able to create a new user
    [Tags]  CZ-6285   CZ-6281   CZ-6310   CZ-6278    sanity  
    When Navigate To Users List Page
    Then Verify User Is Able To Create New Users Persona

Verify Navigation to the "User " Page
    [Tags]  CZ-6276    CZ-6270   CZ-6290   CZ-6297    
    When Click On ADD New Button On Users List Page
    And Enter the User Email    Author
    And Update The Personal Detail    Author
    And Navigate To Professional Details
    And Update The Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Verify The New Created User
    And Delete The New Created User

Verify Navigation Between Tabs (Personal Details, Professional Details, Workspaces)
    [Tags]  CZ-6271      
    When Click On ADD New Button On Users List Page
    And Click On Professional Details Tab And Verify Navigation
    And Click On Personal Details Tab And Verify Navigation
    And Click On Workspace Tab And Verify Navigation

Verify invalid Email Format Validation in the view user page
    [Tags]  CZ-6272   
    When Click On ADD New Button On Users List Page
    And Enter Invalid Email
    And Verify Invalid Error Message
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Verify Invalid Error Message    
    
Verify Phone Number Format Validation
    [Tags]  CZ-6273   
    When Click On ADD New Button On Users List Page
    Then Input Number And Verify The Invalid Value Validations

Verify Read-Only Fields (if applicable) Like Site , Email
    [Tags]  CZ-6275      
    When Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Update The Personal Detail      Author
    And Verify The Read-Only Fields And Save Changes
    And Navigate To User Details Page
    And Validate The Updated User Details


Verify User List Table Columns
    [Tags]  CZ-6277   
    Then Verify The Table Column Labels On User List Page


Verify Sorting Functionality in user list page
    [Tags]  CZ-6282   
    And Validate Dates Are Sorted On User/Teams List Page
    Then Validate The Names Are Sorted On User /Teams List Page


Verify Pagination Functionality in user list page
    [Tags]  CZ-6283      
    Then Verify The Pagination


Verify the filter icon Functionality in user list page
    [Tags]  CZ-6284   
    When Click On Filter Button
    And Select The Filters On Users List Page
    And Apply The Filters
    And Verify The Filters Are Applied
    And Validate The Correct Filtered Results Shown
    And Click On Filter Button
    And Clear All Filters And Apply Changes
    Then Verify All The Filters Removed


Verify the Functionality of the Professional details tab in the add new user page
    [Tags]  CZ-6287  CZ-6286    CZ-6288    sanity
    When Click On ADD New Button On Users List Page
    And Navigate To Professional Details
    And Update The Professional Details
    And Verify The Correct Persona Selected
    And Navigate To Workspace Tab In New User Window

Verify User Breadcrumb Navigation
    [Tags]  CZ-6291      
    When Get The First User Details
    And Navigate To User Details Page
    And Verify The User Name is Displayed In The Breadcrumbs
    Then Click On Users Link And Verify User Lands On The Users List Page

Workspaces of mapped site are visible in the workspace tab in user screen
    [Setup]    Get The Existing Site And Workspace Data
    [Tags]  CZ-6302    CZ-6295   CZ-6296    sanity 
    When Navigate To Users List Page
    And Click On ADD New Button On Users List Page
    And Enter the User Email    Author
    And Update The Personal Detail      Author
    And Navigate To Professional Details
    And Update The Professional Details
    And Select The Site With Correct Workspaces
    And Navigate To Workspace Tab In New User Window
    Then Verify The Workspaces Displayed Corresponding To The Site
    And Navigate To Skills Tab In New User Window
    Then Click On The Done Button On New User Window


Verify the Multiselect 'Delete and cancel' Button Functionality
    [Tags]  CZ-6280    CZ-6279
    When Select The Multiple Records
    And Delete Selected Users
    And Verify The Users Count After Deleting The Users
    And Select The Multiple Records
    And Cancel User Record Deletion
    Then Verify The Users Count Should Not Change
    

Verify that users from one organization cannot view users from another organization
    [Tags]  CZ-6289      
    When Verify User Is not Visible     ${SiteAdmin}
    And Logout From Mentor
    And OrgAdmin Login        ${OrgAdmin}    ${OrgAdminPass}
    And Navigate To Users List Page
    Then Verify User Is not Visible     ${SITE_ADMIN_EMAIL}
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify that users from one Site cannot view users from another Site
    [Tags]  CZ-7350    sanity       
    When Verify User Is not Visible     ${SiteAdminNew}
    And Logout From Mentor
    And Login To Application        ${SiteAdminNew}    ${SiteAdminNewPass}
    And Navigate To Users List Page
    Then Verify User Is not Visible     ${SITE_ADMIN_EMAIL}
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify that Admin is able to restore the access of removed workspaces to user
    [Tags]  CZ-6304
    [Documentation]     Bug: CZ-6655
    When Get The Workspace Data From List page
    And Navigate To Users List Page
    And Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details    
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Delete The Workspace From The User Details Page
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    Then Search The Removed Workspace And Add Again

Verify that Admin is able to Remove the access of workspaces to user
    [Tags]   CZ-6300    sanity
    [Documentation]
    When Navigate To Users List Page
    And Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Observe the Count Of Workspaces Before Deletion
    And Delete The Workspace From The User Details Page
    And Navigate To Skills Tab In New User Window
#    And Switch to Workspace Tab
#    And Observe the Count Of Workspaces After Deletion
#    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Observe the Count Of Workspaces After Deletion

Verify that On deleting one user, User is getting deleted from User Group
    [Tags]  CZ-6303
    Log    Bug : CZ-8091
    When Save The Records Count Before Actions On Page
    And Click On ADD New Button On Users List Page
    And Enter the User Email    Author
    And Update The Personal Detail      Author
    And Navigate To Professional Details
    And Update The Professional Details
    And Select The Site With Correct Workspaces
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Click On The Done Button On New User Window
    And Verify The Records Count Is Changed By    +1
    And Verify The New Created User
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Create A Team With New User And Save Added Users Count
    And Verify New Team Is Created
    And Navigate To Users List Page
    And Delete The New Created User
    And Navigate To Teams Page
    Then Verify The User Is Deleted From The Team

Verify that User can see the WI/Procedures of a workspace
    [Tags]      CZ-6299    sanity
    When Get The First User Details
    And Navigate To User Details Page
    And Click On Edit Button In User Details
    And Switch to Workspace Tab
    Then Verify User can access the Procedures Of The Workspace

Verify the system displays 'User is inactive' when attempting to log in with a deleted user
    [Tags]    CZ-7463
    When Run Keyword And Ignore Error    Login To Mentor Application    ${DELETED_USER_EMAIL}    ${GENERIC_PASSWORD}
    Then Verify The 'User is inactive' Is Displayed When Attempting To Login
    And Capture Page Screenshot

Verify that User is able to Activate the account and update the password
    [Tags]  CZ-A
    When Verify User Is Able To Create New Users Persona     Mentor Site Admin
    And Navigate To Inbox To Get The Data    ${TD_USER_EMAIL}
    And Get The Temporary Creds Emailed
    And Enter the Temporary Password
    And Reset The Password      ${NewPassword}
    Then Verify User Is Able To Navigate To Home Page