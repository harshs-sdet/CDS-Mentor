*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SkillManagement/Skill.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource

Suite Setup     Run Keywords     Login With Personas For Suite Setup
...              AND             Switch Browser    Author
...              AND             User Navigates To Skill Management Page
...              AND             Create Training For Skills
...              AND             Save Skill Validation Data
...              AND             Load Skill Validation Data

Test Setup      Run Keywords    Reset Personas State
...             AND             Switch Browser    Author
...             AND             User Navigates To Skill Management Page

Test Teardown    Teardown For Skills Page
Suite Teardown    Close All Browsers
*** Test Cases ***

Verify That User Is Able To Create a New Skill with Elementary Training Only
    [Tags]   CZ-7324    sanity
    [Teardown]    Delete The Skill From The List Page
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Verify The Empty Skill Can't Be Assigned
    And Click On The Edit Button On Skill Details Page
    And User Adds Trainings    Elementary



Verify That User Is Able To Create a New Skill with Beginner Training Only
    [Tags]   CZ-7325
    When User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Beginner
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    Then Verify That A New Skill Is Created

Verify That User Is Able To Create a New Skill with Intermediate Training Only
    [Tags]   CZ-7326
    When User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    Then Verify That A New Skill Is Created

Verify that No Training is Created Upon Clicking the Cancel Button
    [Tags]   CZ-H
    When Save The Records Count Before Actions On Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance
    And User Clicks on Cancel Skill/Profile Button
    Then Verify that no Skill is created after clicking on the cancel button
    And Verify The Records Count Is Changed By

Verify That User Is Able To Create Empty Training
    [Setup]    Create Training For Skill Completion
    [Tags]   CZ-7176
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    #And Verify that an Empty Skill is Created
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Advanced,1,Not Started,0/1


Verify That User Is Able To Create a New Skill with Advance Training Only
    [Tags]   CZ-7182
    When User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance
    And User Adds Trainings    Expert
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    Then Verify That A New Skill Is Created
    And Verify Invalid Search On Skills Page

Verify That User Is Able To Create a New Skill with Expert Training Only
    [Tags]   CZ-7181
    When User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Expert
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    Then Verify That A New Skill Is Created

Verify That User Is Able To Create a New Skill
    [Tags]   CZ-7178      CZ-7177
    When Verify UI of Skills Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    Then Verify That A New Skill Is Created

Verify user is able to edit skill
    [Tags]    CZ-7179
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    Log    This testcase might fail due to UI issue -To be logged in seperate story
    When User Navigates To Skill Management Page
    And Verify UI of Skills Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On The Edit Button On Skill Details Page
    And User Adds Skills Details
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Verify The Skill Details

Verify functionality of 'Cancel' button while editing a skill
    [Tags]    CZ-7180
    Log    This testcase might fail due to UI issue -To be logged in seperate story
    When Verify UI of Skills Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Add Item To List    ITEM=${TD_SKILL_NAME}   VAR_NAME=RUNTIME_NEW_SKILLS_LIST
    And Navigate To Skill Details Page
    And Click On The Edit Button On Skill Details Page
    And User Adds Skills Details
    And User Clicks on Cancel Skill/Profile Button
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page    CUSTOM_SKILL_NAME=${RUNTIME_NEW_SKILLS_LIST[0]}
    Then Verify The Skill Details     DETAILS_UPDATED=False

Verify Pagination on skills page
    [Tags]    CZ-7183    sanity
    Then Verify The Pagination

Verify That User Is Able To Create a New Empty Skill Profile
    [Tags]   CZ-7194   CZ-7204
    When Navigate To Skill Profile List Page
    And Save The Records Count Before Actions On Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Click On Cancel Button On Skill Profile Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Click On Create Button On Skill Profile Details Page
    And Verify The Records Count Is Changed By    +1
    Then Verify The New Created Skill Profile

Verify that count and name of selected skills are visible on select skills page
    [Tags]    CZ-7247   CZ-7197    CZ-7216    sanity
    When Navigate To Skill Profile List Page
    And Save The Records Count Before Actions On Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Add Skills To Skill Profile
    And Click On Create Button On Skill Profile Details Page
    And Verify The Records Count Is Changed By    +1
    And Verify The New Created Skill Profile
    Then Check The Skills Added to New Skill Profile

Verify That User Is Able To Delete a New Skill Profile
    [Tags]   CZ-7206
    When Navigate To Skill Profile List Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Add Skills To Skill Profile
    And Click On Create Button On Skill Profile Details Page
    And Save The Records Count Before Actions On Page
    And Verify The New Created Skill Profile
    And Delete The Skill Profile
    Then Verify The Records Count Is Changed By    -1

Verify That User Is Able To Edit The Skill Profile
    [Tags]   CZ-7195
    When Navigate To Skill Profile List Page
    And Get The First Skill Profile Details
    And Navigate To Skill Profile Details Page
    And Click On Edit Skill Profile Button
    And Enter The Skill Profile Detail
    And Click On Create Button On Skill Profile Details Page
    And Navigate To Skill Profile Details Page
    Then Validate The Updated Skill Profile Details

Verify Pagination Functionality in Skill Profile page
    [Tags]  CZ-7199  CZ-7193
    When Navigate To Skill Profile List Page
    And Verify The Table Column Labels On Skill Profile List Page
    Then Verify The Pagination

Verify user is able to Assign skills to users
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    [Tags]    CZ-7187
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
#    And User Navigates To Skill Management Page
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Select The Difficulty Level    Intermediate
    And Assign The Skill To User
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page

Verify functionality of Cancel button on 'Assign Users' popup
    [Tags]    CZ-7188
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Assign The Skill To User    ACTION=CANCEL_ASSIGNMENT
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page    ACTION=NO_SKILLS


Verify user is able To Assign skills to team
    [Setup]    Run Keyword    Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    [Tags]    CZ-7189
    When Switch Browser    SiteAdmin
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details
    And Add The Users In The Teams List
    And Verify New Team Is Created
    And Switch Browser    Author
    And User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level
    Then Assign The Skill To Team

Verify user is able to delete Skills from skills listing page
    [Tags]    CZ-7190
    When Get The First Skill Details
    And Search The Skill On List Page
    And Delete The Skill From The List Page
    Then Verify The Skill Is Deleted

Verify user is able to select and delete multiple skills from skills listing page
    [Tags]    CZ-7191    sanity
    When Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2

Verify user is able to delete Skills from skills details page
    [Tags]    CZ-7192
    When User Navigates To Skill Management Page
    And Get The First Skill Details
    And Navigate To Skill Details Page
    And Delete The Skill From Skill Details Page
    Then Verify The Skill Is Deleted

Verify user is able to select and delete multiple skill profile from skill profile listing page
    [Tags]    CZ-7207
    When Navigate To Skill Profile List Page
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2

Verify user is able to delete Skill profile from skill profile details page
    [Tags]    CZ-7208    CZ-7198
    When Navigate To Skill Profile List Page
    And Get The First Skill Profile Details
    And Navigate To Skill Profile Details Page
    And Delete The Skill Profile From Details Page
    Then Verify The Skill Profile Is Deleted
    And Verify The Invalid Search On Skill Profile Page

Verify user is able to view the users to whom skills are assigned from Skills detail page
    [Tags]    CZ-7209    CZ-7211    CZ-7212
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Select The Difficulty Level
    And Assign The Skill To User    MULTIPLE_USERS=False
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    Then Verify All The Users Assigned To Skill Are Visible On Assign Window
    And Verify Search Functionality In Users Popup Of Assigned Skills
    And Verify Close Icon Functionality In Users Popup Of Assigned Skills

Verify user is able to view the teams to whom skills are assigned from Skills detail page
    [Tags]    CZ-7210    CZ-7213    CZ-7214
    Log    This testcase might fail due to CZ-7689
    When Switch Browser    SiteAdmin
    And Click On Administration
    And Navigate To Teams Page
    And Get The Teams Data
    And Switch Browser    Author
    And User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level
    And Assign The Skill To Team    EXISTING_TEAMS=True
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Click On The Teams Tab On The Skill User Assign Window
    Then Verify All The Teams Assigned To Skill Are Visible On Assign Window
    And Verify Search Functionality In Teams Popup Of Assigned Skills
    And Verify Close Icon Functionality In Users Popup Of Assigned Skills


Verify functionality of 'Cancel' button while editing a skill profile
    [Tags]    CZ-7196
    When Navigate To Skill Profile List Page
    And Get The First Skill Profile Details
    And Navigate To Skill Profile Details Page
    And Click On Edit Skill Profile Button
    And Add Item To List    ITEM=${TD_SKILL_PROFILE_NAME}   VAR_NAME=RUNTIME_NEW_SKILL_PROFILE_LIST
    And Enter The Skill Profile Detail
    And User Clicks on Cancel Skill/Profile Button
    And Verify User Lands On The Skill Profile Page
    And Navigate To Skill Profile Details Page    ${RUNTIME_NEW_SKILL_PROFILE_LIST[0]}
    Then Validate The Updated Skill Profile Details    DETAILS_UPDATED=False

Verify when Operator clicks on any skill, all the trainings part of the skill are displayed
    [Setup]    Create Training For Skills
    [Tags]    CZ-7222    CZ-7221    sanity
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[2]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[3]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    Then Verify All The Trainings Of The Skills Are Displayed

Verify that count of Skills on Skills page is correct.
    [Tags]    CZ-7233    CZ-7232
    When Create Training For Skills
    And User Navigates To Skill Management Page
    Then Verify The Count Of Skills On Skills Page Is Correct


Verify that breadcrumb link is functional on 'Create New Skill' Page.
    [Tags]    CZ-7234    CZ-7235
    When Get The First Skill Details
    And Navigate To Skill Details Page
    And Click On The Skills/Skill Profile Link From The Breadcrumbs
    And User Navigates To Skill Management Page
    Then Navigate To Skill Details Page

Verify that breadcrumb link is functional on 'Create New Skill Profile' Page.
    [Tags]    CZ-7245    CZ-7246
    When Navigate To Skill Profile List Page
    And Get The First Skill Profile Details
    And Navigate To Skill Profile Details Page
    And Click On The Skills/Skill Profile Link From The Breadcrumbs
    And Verify User Lands On The Skill Profile Page
    Then Navigate To Skill Profile Details Page

User can select all rows by clicking on All checkbox on dashboard
    [Setup]    Load Skill Validation Data
    [Tags]    CZ-7241    CZ-7242
    When User Navigates To Skill Management Page
    And Verify The User Can Select All Rows On The Skill List Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    Then Verify That User Can Select All Trainings By Clicking On All Checkbox On Select Training Page

Verify that user can select different trainings for different levels(Elementary, Beginner, Intermediate, Advanced and Expert)
    [Setup]    Create Training For Skills
    [Tags]    CZ-7240
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Beginner    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[2]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[3]}
    And User Adds Trainings    Expert    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[4]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    Then Verify The Trainings Are Added For Different levels

Verify that count and name of selected trainings are visible on select training page.
    [Setup]    Create Training For Skills
    [Tags]    CZ-7236
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[2]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[3]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[4]}
    Then Verify The Count And Name Of Selected Trainings Are Visible On Select Training Page

Verify that user receives a field validation message upon skipping mandatory feild.
    [Tags]    CZ-7237    CZ-7238
    When User Clicks on Add New Skill
    And Verify The Input Field Validation On New Skill Page
    Then Verify That User Is Not Able To Create A Skill With Invalid Name(Space, Empty, Special Character)

Verify that user is able to execute the right job with right skill
    [Setup]    Create Training For Skill Completion
    [Tags]    CZ-7268    CZ-7262    CZ-7263   sanity
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page    ${ADD_PROCEDURE_TO_TRAINING_LIST[0]}
    And Click On Edit Button On Procedure Details Page
    And Add Skill To The Procedure
    And User Publishes The Procedure    IGNORE_VERSION=True
    And User Adds Release Notes
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Get Last Two Records From List    LIST_NAME=ADD_PROCEDURE_TO_TRAINING_LIST    RETURN_LIST=UPDATED_PROCEDURE_LIST
    And Select Procedure To Job    MULTIPLE_PROCEDURES=True    LIST_VAR_NAME=UPDATED_PROCEDURE_LIST
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Edit Button On Job Details Page
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME    JUST_ASSIGN=False
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The Operator Is Not Able To Complete Job Without Getting Training
    And Close Popup
    And Navigate To My Skills Page
    And Wait For The Page To Load
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    START_AGAIN_BUTTON_VISIBLE=True    APPROVED/CONFIRMED=True
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[1]}
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=Advanced,Advanced,0,Completed,2/2
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    Then Complete Job/Training Execution

Verify that the color of tiles is auto upgraded when user attains the required level
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    [Tags]    CZ-7266    CZ-7265    CZ-7264     CZ-7501
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details    CHECK_DEFAULT_IMAGE=True
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Intermediate
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Matrix Page
    And Select The Skill In Skill Matrix Page
    And Verify The Skill Data In Skill Matrix Page    SKILL_DATA=3,COLOR,1,0,COLOR
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}
    And Switch Browser    Author
    And Reload Page
    And Select The Skill In Skill Matrix Page
    Then Verify The Skill Data In Skill Matrix Page    SKILL_DATA=3,COLOR,1,0,COLOR

Verify that only Site Admin has the authority to set the current level of skill for the user
    [Tags]    CZ-7261    CZ-7243    CZ-7481
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details    CHECK_DEFAULT_IMAGE=True
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Capture Page Screenshot
    And Assign The Skill To User
    And Switch Browser    SiteAdmin
    And Navigate To Users List Page
    And Navigate To User Details Page    USER_EMAIL=${OPERATOR1_EMAIL}
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Search The Skill In User Details Skill Tab
    And Capture Page Screenshot
    And Select The Current Level In User Details    2
    And Click On The Done Button On New User Window
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Beginner,Advanced,1,Not Started,0/1


Verify that deleted assigned skills from site admin side should also not appear at assigned user in My skill section.
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    [Tags]    CZ-7330    CZ-7482    CZ-7512
    Log    This testcases might fail due to CZ-7690
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details    CHECK_DEFAULT_IMAGE=True
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Switch Browser    SiteAdmin
    And Navigate To Users List Page
    And Navigate To User Details Page    USER_EMAIL=${OPERATOR1_EMAIL}
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    And Search The Skill In User Details Skill Tab
    And Delete The Skill From The User Details Page
    And Click On The Done Button On New User Window
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page    ACTION=NO_SKILLS


Verify user is able to zoom/in-zoom/out images in preview mode
    [Setup]    Create Procedure With Attachments
    [Tags]    CZ-7225
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    And Add Item To List   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And Empty List    NEW_TRAINING_CREATED_LIST
    And Add Item To List    ITEM=${TRAINING_NAME}    VAR_NAME=NEW_TRAINING_CREATED_LIST
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To My Skills Page
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    DO_NOT_COMPLETE_EXECUTION=True
    And Expand The Attachments Window
    And Verify Image Zoom In -Zoom Out
    And Close Popup
    Then Verify that Arrow icons should be visible on Attachment Preview screen


Verify that the assigned skill is no longer visible in the My Skill section at the assigned users end when the user is unassigned from the Assign User flyout on the Skill Details page.
    [Setup]    Create Training For Skill Completion
    [Tags]    CZ-7421    CZ-7271    CZ-7335    CZ-7411    CZ-7215
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Elementary
    And Assign The Skill To User
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Elementary,1,Not Started,0/1
    And Switch Browser    Author
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Unassign The User From The Skill    USER_NAME=${OPERATOR1_NAME}    SKILL_ASSIGNED_AT_LEVEL=Elementary    VERIFY_FLYOUT=True
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page    ACTION=NO_SKILLS


Verify that user can change the level of training for a particular user Assigned Users flyout window,
    [Setup]    Create Training For Skill Completion
    [Tags]    CZ-7338    CZ-7336    CZ-7417    CZ-7418    CZ-7420    sanity
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Elementary
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Verify The Skill Assigned To User At Level    USER_NAME=${OPERATOR1_NAME}    CURRENT_LEVEL=Elementary
    And Change The Level Of Skill Assigned To User To    USER_NAME=${OPERATOR1_NAME}    TARGET_LEVEL=4    CANCEL_LEVEL_CHANGE=True
    And Verify The Skill Assigned To User At Level    USER_NAME=${OPERATOR1_NAME}    CURRENT_LEVEL=Elementary
    And Change The Level Of Skill Assigned To User To    USER_NAME=${OPERATOR1_NAME}    TARGET_LEVEL=4
    And Verify The Skill Assigned To User At Level    USER_NAME=${OPERATOR1_NAME}    CURRENT_LEVEL=Advanced
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Advanced,1,Not Started,0/1

Verify the delete icon functionality against Assigned user names.
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    [Tags]    CZ-7337    CZ-7339    CZ-7412    CZ-7413    CZ-7414    CZ-7415    CZ-7416    CZ-7422    CZ-7423
    When Switch Browser    SiteAdmin
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST    MULTIPLE_USERS=True
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details
    And Add The Users In The Teams List
    And Verify New Team Is Created
    And Switch Browser    Author
    And User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Intermediate
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Intermediate
    And Assign The Skill To Team
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Verify The Skill Is Assigned To All The Members Of The Team
    And Unassign The User From The Skill    USER_NAME=${OPERATOR1_NAME}    SKILL_ASSIGNED_AT_LEVEL=Intermediate
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page    ACTION=NO_SKILLS
    And Switch Browser    Author
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Intermediate,1,Not Started,0/1
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Delete All Team Members From The Skill
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page    ACTION=NO_SKILLS
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    Then Verify The Skill Is Unassigned From    Team

Verify the user is displayed the correct upgraded level upcoming completing the trainings for the skill
    [Setup]    Create Training For Skill Completion With Multiple Procedures
    [Tags]    CZ-7476    sanity
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Intermediate    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Intermediate
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Intermediate,2,Not Started,0/2
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Intermediate,2 Procedures,Not Started
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    PROCEDURE_COUNT=1
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Intermediate,2 Procedures,In Progress (1/2)
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    PROCEDURE_COUNT=2
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Intermediate,2 Procedures,Completed    APPROVED/CONFIRMED=True
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Intermediate,1,In Progress,1/2
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[1]}    PROCEDURE_COUNT=1
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[1]}    TRAINING_STATUS=Intermediate,Intermediate,1 Procedures,Completed    APPROVED/CONFIRMED=True
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Intermediate,Intermediate,0,Completed,2/2


Verify the training completion count of the skill is updated once the procedure signoff is approved
    [Setup]    Create Training For Skill Completion With Multiple Procedures    SIGNOFF_REQUIRED=REQUIRED
    [Tags]    CZ-7475    CZ-7267    sanity
    Log    This testcase might fail due to CZ-7784
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Expert    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Adds Trainings    Expert    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Clicks on Create Button On Skill Details Page
    And Verify The User Lands On The Skill list Page After Creating Or Updating The Skill
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Expert
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Expert,2,Not Started,0/2
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Expert,2 Procedures,Not Started
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    START_SIGNOFF_PROCEDURE=True
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Expert,2 Procedures,Not Started
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    PROCEDURE_COUNT=2
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[0]}    TRAINING_STATUS=No level,Expert,2 Procedures,In Progress (1/2)
    And Switch Browser    Author
    And Navigate To Procedure SignOff Page
    And Verify The Procedure Data On Procedure SignOff List Page    PROCEDURE_NUMBER=0    PROCEDURE_STATUS=1,GREEN,0,0,1
    And Click On Searched Procedure
    And Provide The Procedure SignOff
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Expert,1,In Progress,1/2
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[1]}    PROCEDURE_COUNT=1
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[1]}    TRAINING_STATUS=Expert,Expert,1 Procedures,Completed    APPROVED/CONFIRMED=True
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Expert,Expert,0,Completed,2/2
    And Verify The Skill Training Completion Details


Verify user is able to Assign skill profiles to users
    [Setup]    Create Skill Records
    [Tags]   CZ-7203
    When Navigate To Skill Profile List Page
    And Save The Records Count Before Actions On Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Add Skills To Skill Profile    CUSTOM_SKILLS=True    CUSTOM_SKILLS_LIST=${ADDED_SKILLS_LIST}
    And Click On Create Button On Skill Profile Details Page
    And Verify The Records Count Is Changed By    +1
    And Verify The New Created Skill Profile
    And Navigate To Skill Profile Details Page
    And Click On Assign Button On Skill Details Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILL_PROFILE_TO_USERS_LIST
    And Assign The Skill Profile To User
    And Navigate To My Skills Page
    Then Search The Skill Of Skill Profile In My Skills Page
    And Navigate To Skill Profile List Page
    And Navigate To Skill Profile Details Page
    And Click On Edit Skill Profile Button
    And Remove The Skills From The Skill Profile
    And Search The Skill Of Skill Profile In My Skills Page    SKILLS_DELETED=True
    And User Navigates To Skill Management Page
    And Delete The Skills From Listing Page Added In The Skill Profile
    And Navigate To Skill Profile List Page
    And Verify The Added Skill And Its Training Count For A Skill Profile Is Reset



Verify user is able to Assign skill profile to team
    [Setup]    Create Skill Records
    [Tags]    CZ-7205
    When Switch Browser    SiteAdmin
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details
    And Add The Users In The Teams List
    And Verify New Team Is Created
    And Switch Browser    Author
    And Navigate To Skill Profile List Page
    And Save The Records Count Before Actions On Page
    And Click On ADD New Button On Skill Profile Page
    And Enter The Skill Profile Detail
    And Add Skills To Skill Profile    CUSTOM_SKILLS=True    CUSTOM_SKILLS_LIST=${ADDED_SKILLS_LIST}
    And Click On Create Button On Skill Profile Details Page
    And Verify The Records Count Is Changed By    +1
    And Verify The New Created Skill Profile
    And Navigate To Skill Profile Details Page
    And Click On Assign Button On Skill Details Page
    And Assign The Skill Profile To Team
    And Navigate To My Skills Page
    Then Search The Skill Of Skill Profile In My Skills Page


Verify only the trainings of assigned level is assigned to the user
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=2
    [Tags]    CZ-7426
    Log    This testcase might fail due to CZ-7784
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Expert    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Expert
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On The Edit Button On Skill Details Page
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And Capture Page Screenshot
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Verify The Trainings Data On My Skill Flyout Page    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[1]}    OTHER_LEVEL_TRAINING=True
    And Capture Page Screenshot

Verify the removed skill doesn't appear in skill section of user under User management when login via Site admin
    [Tags]    CZ-7427    CZ-7485
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Delete The Skill From Skill Details Page
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page    ACTION=NO_SKILLS
    And Switch Browser    SiteAdmin
    And Navigate To Users List Page
    And Navigate To User Details Page    USER_EMAIL=${OPERATOR1_EMAIL}
    And Click On Edit Button In User Details
    And Navigate To Professional Details
    And Navigate To Workspace Tab In New User Window
    And Navigate To Skills Tab In New User Window
    Then Search The Skill In User Details Skill Tab    SKILL_DELETED=True
    And Capture Page Screenshot

Verify that if a particular training is already completed by user and same is added in skill then that training is visible as completed on My Skills page.
    [Tags]    CZ-7480    CZ-7486
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=2    SIGNOFF=NOT_REQUIRED
    Log    This testcase might fail
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List    SINGLE_USER=True
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Assign Training Done Button
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Start The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Empty List    NEW_TRAINING_CREATED_LIST
    And Add Item To List    ITEM=${TRAINING_NAME}   VAR_NAME=NEW_TRAINING_CREATED_LIST
    And Switch Browser    Author
    And User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To Skill Details Page
    And Verify The Skill Is Assigned To The User
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Advanced,Advanced,0,Completed,1/1


Verify that the completed skill goes to In Progress state if the procedure added in training gets updated
    [Tags]    CZ-7483
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    PROCEDURE_COUNT=1
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=Advanced,Advanced,0,Completed,1/1
    And Switch Browser    Author
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And User Add Step To Procedure
    And User Publishes The Procedure    IGNORE_VERSION=True
    And User Adds Release Notes
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
#    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Elementary,Advanced,1,In Progress,0/1

Verify that training deleted from Trainings page gets deleted from the created skill as well.
    [Tags]    CZ-7484    sanity
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}    PROCEDURE_COUNT=1
    And Verify The Skill Data On My Skill Page    SKILL_STATUS=Advanced,Advanced,0,Completed,1/1
    And Switch Browser    Author
    And User Navigate To The Trainings Page
    And Delete The Training Created
    And Switch Browser    Operator
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=Advanced,Advanced,0,Not Started,0/0


Verify the error is not appearing and the user is unassign from the skill when the training associated with that skill has been deleted..
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    Log    This testcase might fail due to CZ-7931
    [Tags]    CZ-7490
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    SINGLE_USER=True    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Elementary
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And User Navigate To The Trainings Page
    And Search The Training On Training List Page
    And Delete One Record From List Page
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Unassign The User From The Skill    USER_NAME=${OPERATOR1_NAME}    SKILL_ASSIGNED_AT_LEVEL=Elementary    VERIFY_FLYOUT=False
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page    ACTION=NO_SKILLS

Verify The Error is not appearing when unassign the user for upper level from the skill when there is no training associated for level 1 with that skill
    [Setup]    Create Training For Skill Completion    REQUIRED_PROCEDURE_COUNT=1
    Log    This testcase might fail due to CZ-7931
    [Tags]    CZ-7491
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Expert    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List     SINGLE_USER=True        VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Verify The Skill Can't Be Assigned To Org Admin And Site Admin Persona
    And Select The Difficulty Level    Expert
    And Assign The Skill To User
    And User Navigates To Skill Management Page
    And User Navigate To The Trainings Page
    And Search The Training On Training List Page
    And Delete One Record From List Page
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Unassign The User From The Skill    USER_NAME=${OPERATOR1_NAME}    SKILL_ASSIGNED_AT_LEVEL=Elementary    VERIFY_FLYOUT=False
    And Switch Browser    Operator
    And Navigate To My Skills Page
    Then Search The Skill In My Skills Page    ACTION=NO_SKILLS


Verify The assign button Should be Disabled While Assigning Skill To User At A Level With Empty Trainings
    [Tags]    CZ-7500    CZ-7219    CZ-7244    CZ-7503    CZ-7513    CZ-7514    CZ-7510    CZ-7511
    [Setup]    Create Training For Skill Completion
    When User Navigates To Skill Management Page
    And User Clicks on Add New Skill
    And Verify The User Navigates To Create New Skill Page
    And User Adds Skills Details
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[1]}
    And User Adds Trainings    Advance    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And User Navigates To Skill Management Page
    And Create Users List    VAR_LIST_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Verify The Empty Levels Of The Skill Are Disabled
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Elementary
    And Assign The Skill To User
    And Navigate To Skill Details Page
    And Verify The Empty Levels Of The Skill Are Disabled In The Unassign Skill Flyout
    And Remove the Previous Training From The Skill
    And Navigate To Skill Details Page
    And Open The Unassign Flyout Window
    And Capture Page Screenshot
    And Close The Unassign Flyout Window
    And Navigate To My Skills Page
    And Search The Skill In My Skills Page    ACTION=NO_SKILLS
    And Create Training For Skill Completion
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On The Edit Button On Skill Details Page
    And User Adds Trainings    Elementary    CUSTOM_TRAINING_NAME=${NEW_TRAINING_CREATED_LIST[0]}
    And User Clicks on Create Button On Skill Details Page
    And Navigate To My Skills Page
    And Complete The Trainings In My Skills    ${NEW_TRAINING_CREATED_LIST[0]}
    And Capture Page Screenshot
    And User Navigates To Skill Management Page
    And Navigate To Skill Details Page
    And Click On Assign Button On Skill Details Page
    And Select The Difficulty Level    Advance
    And Assign The Skill To User
    And Navigate To My Skills Page
    Then Verify The Skill Data On My Skill Page    SKILL_STATUS=No level,Advanced,0,Not Started,0/1

