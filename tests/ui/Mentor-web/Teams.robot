*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Workspace/Workspace.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${Env}_env.yaml

Suite Setup     Run Keywords     Login With Personas For Suite Setup
...              AND             Switch Browser    SiteAdmin
...            AND               Navigate To Teams Page



Test Teardown    Run Keywords    Reset Personas State
...             AND             Switch Browser    SiteAdmin
...             AND             Navigate To Teams Page
Suite Teardown    Close All Browsers
*** Test Cases ***



Verify User Group Breadcrumb Navigation
    [Tags]  CZ-6265
    When Click on User Group Hyperlink
    Then Verify that Breadcrumb links are visible
    And Click on the breadcrumb link
    Then Verify That User navigate to User Group screen

Verify Pagination Works Correctly
    [Tags]    CZ-6258
    When Verify The Pagination

Verify Multi-User group Selection Checkbox Functionality
    [Tags]    CZ-6261
    When Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2

Verify Adding a New User Group
    [Tags]    CZ-6252    CZ-6254    CZ-6264    CZ-6255    sanity
    When Save The Records Count Before Actions On Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Verify The User Is Not Able Create Empty Team
    And Enter The Teams Details    CUSTOM_TEAM_SITE=Automation Site
    And Add The Users In The Teams List    VERIFY_EMPTY_NAME_TEAM=True
    And Verify The Records Count Is Changed By    +1
    And Save The Records Count Before Actions On Page
    And Navigate To Teams Details Page
    And Verify The Team Details
    And Navigate To Teams Page
    And Search The Team On List Page
    And Delete The Team From The List Page
    And Reload Page
    Then Verify The Records Count Is Changed By    -1


Verify that Admin is able to restore the access of removed workspaces to user group
    Log    Bug: CZ-8092 
    [Tags]    CZ-6305    CZ-6253    CZ-6247    CZ-6257    sanity
    When Get The Workspace Data From List page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details    CUSTOM_TEAM_SITE=Automation Site
    And Add The Users In The Teams List
    And Navigate To Teams Details Page
    And Click On Next Button On Teams Details Page
    And Verify That A Workspace Is Automatically Added Based On The Selected Site
    And Delete The Workspace From The Teams
    And Click On The Save Button On The Team Details Page
    And Navigate To Teams Details Page
    And Click On Next Button On Teams Details Page
    And Verify The Workspace In Teams Details Page    Deleted
    And Add The Deleted Workspace To The Team
    And Click On The Save Button On The Team Details Page
    And Navigate To Teams Details Page
    And Click On Next Button On Teams Details Page
    Then Verify The Workspace In Teams Details Page   Added

Verify User Count Display on User Group Page
    [Tags]    CZ-6248    CZ-6249
    When Verify The Count Displayed On The User Group Page
    Then Verify The Invalid Search Functionality On Teams List Page


Verify the functionality of filter button
    [Tags]  CZ-6251  CZ-6250
    When Verify The Status Filter Functionality    ALL_ACTIVE_RECORDS=True


Verify that User group can see the Procedures of a workspace
    [Setup]    Get Procedure To Associate With Workspace
    [Tags]    CZ-6256    CZ-6266    sanity
    When Navigate To Workspace List Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Select Custom Site On Workspace Details Page    SITE_NAME=Automation Site
    And Add The Procedures To Workspace
    And Click On Create Button On Enter New Workspace Details Page
    And Navigate To Teams Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details    CUSTOM_TEAM_SITE=Automation Site
    And Add The Users In The Teams List
    And Navigate To Teams Details Page
    And Click On Next Button On Teams Details Page
    Then Verify The Procedures Of The Workspace On Teams Details Page

Verify Status Toggle Button
    [Tags]    CZ-6259
    When Get The First Team Details
    And Navigate To Teams Details Page    
    And Toggle The Status In Teams Details
    And Click On Next Button On Teams Details Page
    And Click On The Save Button On The Team Details Page
    Then Verify The Teams Status Is Changed    


Verify 'Edit' Button Functionality in the view user group page
    [Tags]    CZ-6260    CZ-6262
    When Get The First Team Details
    And Navigate To Teams Details Page
    And Add Item To List    ITEM=${TD_TEAM_NAME}   VAR_NAME=PREVIOUS_TEAM_NAME_LIST
    And Enter The Teams Details    UPDATE_DETAILS=True
    And Click On Next Button On Teams Details Page
    And Click On Previous Button On Teams Details Page And Verify The User Navigation
    And Click On Next Button On Teams Details Page
    And Click On The Save Button On The Team Details Page
    And Search The Team On List Page    CUSTOM_TEAM_NAME=${PREVIOUS_TEAM_NAME_LIST[0]}    TEAM_DELETED=True
    And Navigate To Teams Details Page
    Then Verify The Team Details    DETAILS_EDITED=True


Verify that users from one organization cannot view user group from another organization
    [Tags]    CZ-6263
    When Get The First Team Details
    And Navigate To Teams Details Page
    And Login Again As Persona     ${SiteAdmin}
    And Navigate To Teams Page
    Then Search The Team On List Page    TEAM_DELETED=True


On user group screen, Site associated users are visible with the Org admins. User is able to create a user group having Org admins also.
    [Tags]    CZ-6267
    When Save The Records Count Before Actions On Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Add Item To List    ITEM=${ORG_ADMIN_NAME}   VAR_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details    CUSTOM_TEAM_SITE=Automation Site
    And Add The Users In The Teams List
    Then Verify The Records Count Is Changed By    +1


Verify Sorting Functionality in Teams list page
    [Tags]  CZ-7517
    And Validate Dates Are Sorted On User/Teams List Page
    Then Validate The Names Are Sorted On User /Teams List Page