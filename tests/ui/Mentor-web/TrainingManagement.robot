*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Trainings/Training.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SkillManagement/Skill.resource

Suite Setup     Run Keywords     Login With Personas For Suite Setup
...             AND             Switch Browser    Author
...             AND              User Navigate to the Trainings Page
#...             AND              Empty The List Page Via All Records Checkbox

Test Setup      Run Keywords    Reset Personas State
...             AND             Switch Browser    Author
...             AND             User Navigate to the Trainings Page

Test Teardown    Teardown For Training Page
Suite Teardown    Close All Browsers

*** Test Cases ***

Verify that user is able to view the Training Matrix
    [Tags]   CZ-6887    CZ-6899    CZ-6900    CZ-6892    CZ-6888    CZ-6891    CZ-6894    CZ-6896    CZ-6903    CZ-6904    CZ-6890    CZ-6893    sanity
    Log    This testcase might fail due to CZ-7755
    When User Navigate to the Trainings Page
    And Empty The List Page
    And User Navigate To The Trainings Matrix Page
    And Create Users List
    And Select The User On Matrix Page
    And Verify The UI Of Training Matrix
    Then Validate The Correct Users Training Matrix data
#    And Verify The User Name Hyperlink Is Functional On Training Matrix Page


Verify that user is able to assign training to Teams by clicking on Assign button.
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    [Tags]    CZ-6844     CZ-6889    CZ-6911    CZ-7479     CZ-6901    sanity
    Log    This testcase might fail due to CZ-7755
    When User Navigate To The Trainings Page
    And Empty The List Page
    And Switch Browser    SiteAdmin
    And Create Users List    VAR_LIST_NAME=ASSIGNED_USERS_TO_TEAM_LIST
    And Click On Administration
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Enter The Teams Details
    And Add The Users In The Teams List
    And Verify New Team Is Created
    And Switch Browser    Author
    And User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And User Assign Training To Team
    And Click On Select Procedure Done Button
    And User Navigate To The Trainings Matrix Page
    And Select The Team In Training Matrix
    And Verify The UI Of Training Matrix
    Then Validate The Correct Users Training Matrix data

Verify the UI of the Training Page
    [Tags]    CZ-6830
    When User Navigate to the Trainings Page
    Then Verify The UI Of Training Page

Verify user is able to Add a new training with Only Name field
    [Tags]    TR-02
    When Click On Add New Training Button
    And Fill The Form And Submit It
    Then Verify New Training Is Present In The Listing Page

Verify user is able to Add a new training with Name field and Description
    [Tags]    CZ-7328
    When Click On Add New Training Button
    And Fill The Form With Description And Submit It
    Then Verify New Training Is Present In The Listing Page

Verify that user is able to create a new training
    [Tags]    CZ-6813    CZ-6814    CZ-6817     CZ-7327
    When Get Default Training Count
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Cancel It
    Then Verify Canceled Training Is Not Present In The Listing Page
    And Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    Then Verify New Training Is Present In The Listing Page

Verify user is able to assign the created training
    [Tags]    CZ-6831
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Assign An Operator To The Training
    And Click Assign User Done Button
    And Verify Operator Assignment To Training Is Success
    And Verify The UI Of The Assigned Procedure Details Page

Verify that breadcrumb link is functional on "Create New Training" Page
    [Tags]    CZ-6815    CZ-6828     CZ-6834    CZ-6819
    When Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Add Procedures To Existing Training Via Edit
    And Navigate To Training Details Page
    And Assign An Operator To The Training
    And Click Assign User Done Button
    And Navigate To Training Details Page
    Then Verify that All Procedures In A Training Are Visible In Flyout Procedure Dropdown

Verify User is able to assign training with deadline
    [Tags]    CZ-6829    CZ-6855   
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Assign An Operator To The Training With Deadline
    And Navigate To Training Details Page
    Then Verify Deadline Date Is Visible In The Flyout Page


#Verify that user is not able to create a training with invalid name(space, empty, special character)
#    [Tags]    CZ-6821    CZ-6822
#    When Click On Add New Training Button
#    And Verify The Name Field Validations In New Training Page



Verify the pagination functionality on Training's page.
    [Tags]    CZ-6845    CZ-6846
    When Verify The Pagination

Verify that user can see the list of users whom training was assigned by clicking on users icon from flyout window
    [Tags]    CZ-6838    CZ-6840    CZ-6842    CZ-6848
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Assign An Operator To The Training With Deadline
    And Navigate To Training Details Page
    And Open Flyout
    And Verify The UI Of Flyout Window On Training Details Page After Assigning Users
#    And Open Flyout
#    And Validate All The User Are Visible In Flyout Window
#    And Switch Browser    Operator
#    And Navigate To My Trainings Page
#    Then Search Training In My Trainings

Verify that correct version and updated by displayed against every procedure
    [Tags]    CZ-6820    CZ-6818    CZ-6843
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Click On Add Procedure Button On Training Details Page
    And Verify The UI Of Add Procedure To Training Screen
    Then Select Procedure From List

Verify that progress bar shows how many users has completed/started/not started the training for a single training.
    [Tags]    CZ-6850    CZ-6851    CZ-6852    CZ-6853    CZ-6854    CZ-6833    sanity
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records With With One Procedure Having Multiple Steps
    Log    This testcase might fail due to CZ-7687
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Select Procedure Done Button
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=Not Started,0/2,RGB_GRAY    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Navigate To Training Details Page
    And Verify The UI Of Added Procedure Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,OPERATOR1_NAME,Not Started    PROCEDURE_NUMBER=0
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,AUTHOR1_NAME,Not Started    PROCEDURE_NUMBER=1
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=0
    And Mark The Step As Completed
    And Verify The Pause Training Functionality
    And User Navigate To The Trainings Page
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=In Progress,0/2,RGB_GRAY    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Not Started,0 / 2,GRAY,0,0,2
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=In Progress,1 / 2,ORANGE,0,0,1
    And Start The Training   PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Switch Browser    Author
    And User Navigate to the Trainings Page
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=In Progress,1/2,RGB_ORANGE    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Navigate To Training Details Page
    Then Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,1/2,OPERATOR1_NAME,Completed    PROCEDURE_NUMBER=1




Verify the pagination functionality on Training's page at Operator 's end
    [Tags]    CZ-6880
    When Switch Browser    Operator
    And Navigate To My Trainings Page
    Then Verify The Pagination


Verify the functionality of Start Again button on flyout window
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    [Tags]    CZ-6878    sanity
    Log    This testcase might fail due to CZ-7687
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search User And Select
    And Click On Select Procedure Done Button
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Search Training In My Trainings
    And Click On Searched Training
    And Verify The Training Data On My Training Flyout Screen    PROCEDURE_SEQUENCE=0    APPROVAL=NOT REQUIRED
    And Restart The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Search Training In My Trainings
    And Click On Searched Training
    Then Verify The Training Data On My Training Flyout Screen    PROCEDURE_SEQUENCE=0    EXECUTION_SEQUENCE=1    APPROVAL=NOT REQUIRED
    And Switch Browser    Author
    And User Navigate To The Trainings Page
    And Delete The Training Created
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Click On Searched Training    TRAINING_DELETED=True    #Validate user not able to restart




Verify that user can delete multiple procedures from the training by clicking on delete button.
    [Tags]    CZ-6826    CZ-6825    CZ-6816    CZ-6837
    When Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Add Procedures To Existing Training Via Edit
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Verify User Is Able To Delete Single Procedure Added In Training Page
    Then Verify User Is Able To Delete Multiple Procedure Added In Training Page


Verify that if a new training is selected from dropdown, then it is reflected in matrix and data for same is reflected.
    [Tags]    CZ-6897    CZ-6909    CZ-6910    CZ-6895    sanity
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=3    SIGNOFF=NOT REQUIRED
    Log    This testcase might fail due to CZ-7687
    When User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search User And Select
    And Click On Select Procedure Done Button
    And User Navigate To The Trainings Matrix Page
    And Select The Training In Training Matrix
    And Verify The UI Of Training Matrix
    And Verify The Training Data In Training Matrix    PROCEDURE_STATUS=0,
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Switch Browser    Author
    And User Navigate To The Trainings Matrix Page
    And Select The Training In Training Matrix
    And Verify The Training Data In Training Matrix    PROCEDURE_STATUS=1,
    And User Navigate To The Trainings Page
    And Navigate To Training Details Page
    And Edit The Training Name
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Search Training In My Trainings
    And Restart The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Start The Training    PROCEDURE_NUMBER=2
    And Complete Job/Training execution
    And Switch Browser    Author
    And Reload Page
    And Select The Training In Training Matrix
    And Verify The Training Data In Training Matrix    PROCEDURE_STATUS=3,
    And User Navigate To The Trainings Page
    Then Verify The Data Of Training On List Page    PROGRESS_STATUS=Completed,1/1,RGB_GREEN    TRAINING_ASSIGNED_USER=1    TRAINING_ASSIGNED_PROCEDURE=3

Verify that user can check,how many Operators have completed by a particular procedure by clicking on "Completed by users"
    [Tags]   CZ-6839    CZ-6841    CZ-6865    CZ-6868    CZ-6832    sanity
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    SIGNOFF=NOT_REQUIRED
    Log    This testcase might fail due to CZ-7687
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Select Procedure Done Button
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=Not Started,0/2,RGB_GRAY    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Navigate To Training Details Page
    And Verify The UI Of Added Procedure Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,AUTHOR1_NAME,Not Started    PROCEDURE_NUMBER=0
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,OPERATOR1_NAME,Not Started    PROCEDURE_NUMBER=1
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Not Started,0 / 2,GRAY,0,0,2
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Start The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Completed,2 / 2,PROCEDURE_COMPLETION_GREEN,0,0,0
    And Switch Browser    Author
    And User Navigate to the Trainings Page
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=In Progress,1/2,RGB_ORANGE    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Navigate To Training Details Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,1/2,OPERATOR1_NAME,Completed    PROCEDURE_NUMBER=1
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=In Progress,1 / 2,ORANGE,0,0,1
    And User Navigate To The Trainings Page
    And Navigate To Training Details Page
    Then Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=PROCEDURE_COMPLETION_GREEN,2/2,AUTHOR1_NAME,Completed    PROCEDURE_NUMBER=1

Verify that user can delete multiple trainings at a single time.
    [Tags]    CZ-6847
    When User Navigate To The Trainings Page
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Click On Cancel Button On Job Order/Training Page
    Then Verify The Records Count Is Changed By


Verify the functionality of Cancel button on Select Procedure's page.
    [Tags]    CZ-6823
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    When User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form With Description And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Click On Add Procedure Button On Training Details Page
    And Click On Cancel Button And Verify The Training Details page
    And User Navigate To The Trainings Page
    Then Verify The Procedures Added In Training On List Page    PROCEDURE_COUNT=0


Verify the sort functionality on Operator end.
    [Tags]    CZ-6872    CZ-6835
    Log    This testcase might fail due to CZ-6673
    Then Verify The Sorting Functionality On The Training List Page



Verify the functionality of cross icon on Assign Team and Members screen
    [Tags]    CZ-6857    CZ-6859    CZ-6867
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    Log    This testcase might fail due to CZ-7712
    When User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form With Description And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Verify The Selected User Records On Assign Window
    And Click On Cross Button On The Assign Users To Training Window
    And User Navigate To The Trainings Page
    And Search The Training On Training List Page
    And Verify The Users Added Count In Training On List Page    USERS_COUNT=0
    And Navigate To Training Details Page
    And Click On Assign Button
    And Verify The Selected User Records On Assign Window
    And Click On Cancel Button On The Assign Users To Training Window
    And User Navigate To The Trainings Page
    And Search The Training On Training List Page
    Then Verify The Users Added Count In Training On List Page    USERS_COUNT=0

User can select all rows by clicking on All checkbox on dashboard
    [Tags]    CZ-6860    CZ-6861    CZ-6869
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    When User Navigate To The Trainings Page
    And Verify The UI Of Training Page
    And Verify The User Can Select All Records On Training List page
    And Click On Add New Training Button
    And Fill The Form With Description And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Click On Add Procedure Button On Training Details Page
    And Verify User Can Select All Procedures And Add To Training
    And Click Create/Update Training Submit Button
    And User Navigate To The Trainings Page
    And Search The Training On Training List Page
    And Verify The Procedures Added In Training On List Page    PROCEDURE_COUNT=10
    And Navigate To Training Details Page
    And Validate The Added Procedures Count In The Flyout Window On Training Details Page
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    Then Verify The UI Of My Training's Page

Verify that comments are mandatory with rejected projects
    [Tags]    CZ-6877
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    Log    This testcase might fail due to CZ-7687
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Assign Training Done Button
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Switch Browser    Author
    And Navigate To Procedure SignOff Page
    And Verify The Procedure Data On Procedure SignOff List Page    PROCEDURE_NUMBER=0    PROCEDURE_STATUS=1,GREEN,0,0,1
    And Click On Searched Procedure
    And Verify The Procedure Data On Procedure SignOff Details Page     EXECUTION_SEQUENCE=0    PROCEDURE_STATUS=Pending
    And Reject The Procedure Approval
    And Verify The Approval Comment Data
    And Verify The Procedure Data On Procedure SignOff Details Page    EXECUTION_SEQUENCE=0    PROCEDURE_STATUS=Rejected
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Click On Searched Training
    Then Verify The Training Data On My Training Flyout Screen    PROCEDURE_SEQUENCE=0    PROCEDURE_STATUS=Rejected

Verify that if a Training is updated, the updated data is visible to Operator at its end.
    [Tags]    CZ-6883    CZ-6884    CZ-6885    CZ-6862
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It    CHECK_DEFAULT_IMAGE=True
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search User And Select
    And Click On Select Procedure Done Button
    And Navigate To Training Details Page
    And Verify The UI Of Added Procedure Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/1,OPERATOR1_NAME,Not Started    PROCEDURE_NUMBER=0
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page    CUSTOM_PROCEDURE_NAME=${ADD_PROCEDURE_TO_TRAINING_LIST[0]}
    And Click On Edit Button On Procedure Details Page
    And User Adds General Details
    And User Publishes The Procedure    EXISTING_PROCEDURE=True
    And User Adds Release Notes
    And Empty List    LIST_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And User Navigate To The Trainings Page
    And Navigate To Training Details Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/1,OPERATOR1_NAME,Not Started    PROCEDURE_NUMBER=0
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Not Started,0 / 1,GRAY,0,0,1
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    Then Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Completed,1 / 1,MY_TRAINING_GREEN,0,0,0


Verify that if a trainig is deleted, but was assigned to someone then it is removed from the matrix.
    [Tags]    CZ-6908    CZ-6905
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    Log    This testcase might fail due to CZ-7687
    When User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search User And Select
    And Click On Select Procedure Done Button
    And User Navigate To The Trainings Matrix Page
    And Select The User In Training Matrix
    And Verify The UI Of Training Matrix
    And Verify The Training Visibility To The User On The Matrix Page    ACTION=Created
    And User Navigate To The Trainings Page
    And Delete The Training Created
    And Wait Until Keyword Succeeds    2s    1s    User Navigate To The Trainings Matrix Page
    And Select The Training In Training Matrix    DELETED_TRAINING=True
    And Select The User In Training Matrix
    Then Verify The Training Visibility To The User On The Matrix Page    ACTION=Deleted


Verify user is able to zoom/in-zoom/out images in preview mode
    [Setup]    Create Procedure With Attachments
    [Tags]    CZ-7225    CZ-7270
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    And Add Item To List    VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Select Procedure Done Button
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Expand The Attachments Window
    And Verify Image Zoom In -Zoom Out
    And Close Popup
    Then Verify that Arrow icons should be visible on Attachment Preview screen


Verify No error is appearing when user open any training whose associated procedure has been deleted.
    [Tags]    CZ-7424
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    Log    This testcase might fail due to CZ-7392
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It    CHECK_DEFAULT_IMAGE=True
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search User And Select
    And Click On Select Procedure Done Button
    And Navigate To Procedures List Page
    And Search The Procedure On Procedure List Page    ${TD_PROCEDURE_NAME}
    And Delete The Procedure/Folder From The List Page
    And User Navigate To The Trainings Page
    And Navigate To Training Details Page
    Then Verify The UI Of Added Procedure Page
    And Capture Page Screenshot


Verify Updated By data is visible for the procedures on view training page whose current version is in draft state
    [Tags]    CZ-7425
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=2    SIGNOFF=NOT REQUIRED
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Select Procedure Done Button
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And User Saves Procedure As Draft
    And User Navigate To The Trainings Page
    And Verify The Data Of Training On List Page    PROGRESS_STATUS=Not Started,0/2,RGB_GRAY    TRAINING_ASSIGNED_USER=2    TRAINING_ASSIGNED_PROCEDURE=2
    And Navigate To Training Details Page
    And Verify The UI Of Added Procedure Page
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,OPERATOR1_NAME,Not Started    PROCEDURE_NUMBER=0
    And Capture Page Screenshot
    And Verify The Data Of Added Procedure To Training Screen    PROCEDURE_STATUS=RED,0/2,AUTHOR1_NAME,Not Started    PROCEDURE_NUMBER=1


Verify The user is able to change the training deadline from the flyout window
    [Tags]    CZ-7467    CZ-6856
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Assign An Operator To The Training
    And Click On Assign Training Done Button
    And Navigate To Training Details Page
    And Click On Flyout Profile Icon
    And Change The Training Deadline And Verify
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    Then Verify The Training Data On My Training Screen    PROCEDURE_STATUS=Not Started,0 / 1,GRAY,0,0,1    DUE_DATE=${EXPECTED_DATE}
    And Capture Page Screenshot


Verify The User is able to unassign the training from the flyout window
    [Tags]    CZ-7468
    Log    This testcase might fail due to
    When Click On Add New Training Button
    And Fill The Form With All Fields Including Procedure And Submit It
    And Navigate To Training Details Page
    And Assign An Operator To The Training
    And Click On Assign Training Done Button
    And Navigate To Training Details Page
    And Click On Flyout Profile Icon
    And Unassign The Training From The Operator
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    Then Search Training In My Trainings    NO_TRAINING=True
    And Capture Page Screenshot

Verify that user is able to reset the steps of a particular procedure added inside the Training.
    [Tags]    CZ-7472
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED    LIST_NAME=ADD_PROCEDURE_TO_TRAINING_LIST    NUMBER_OF_STEPS=4
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Assign Training Done Button
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=0
    And Get Procedures List In Training Execution Screen
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Click On The Reset Icon From Header
    And Reset The Training Execution Element    RESET_TYPE=STEP    STEP_NUMBER=2    PROCEDURE_NUMBER=1
    And Verify The Procedure Step Is Reset    STEP_NUMBER=2
    And Click On The Step In Job Execution    STEP_INDEX=2    IGNORE_STEP=True
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training

Verify that user is able to reset the steps added in Step Group of a particular procedure added inside the Training.
    [Tags]    CZ-7473    sanity
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure    2
    And Create Steps Group
    And Edit The Step Group Name
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List    ITEM=${TD_PROCEDURE_NAME}    VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Assign Training Done Button
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=0
    And Get Procedures List In Training Execution Screen
    And Mark The Step As Completed
    And Click On The Reset Icon From Header
    And Reset The Step Group Step In Training Execution    PROCEDURE_NUMBER=1
    And Verify The Step Group Procedure Step Is Reset In Training Execution
    And Click On The Step In Job Execution    STEP_INDEX=1    IGNORE_STEP=True
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training

Verify that user input added in the steps of a particular procedure gets reset upon resetting the procedure or steps added inside the Training.
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED    LIST_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure For Job Execution
    [Tags]    CZ-7474
    When User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Add Item To List    ITEM=${TD_PROCEDURE_NAME}    VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Create Users List
    And Navigate To Training Details Page
    And Click On Assign Button
    And Search Multiple User And Select    ASSIGNEE_LIST=${ASSIGNED_USERS_TO_TRAINING_LIST}
    And Click On Assign Training Done Button
    And Navigate To My Trainings Page
    And Start The Training    PROCEDURE_NUMBER=1
    And Wait For The Page To Load
    And Close Popup
    And Click On The Step In Job Execution    3
    And Verify The UI Of The User Input Pop-up
    And Select The User Input
    And Mark The Step As Completed
    And Click On The Step In Job Execution    3
    And Close Popup
    And Reset The Procedure Step
    And Click On The Step In Job Execution    1
    And Click On The Step In Job Execution    3
    Then Verify The User Input Value Is Reset


Verify The Filter Functionality On My Trainings Page
    [Tags]    CZ-7492
    When Navigate To My Trainings Page
    And Click On Filter Button
    And Select The Filters On Training List Page
    And Apply The Filters
    And Verify The Filters Are Applied
    And Validate The Correct Filtered Results Shown On Training List Page
    And Click On Filter Button
    And Clear All Filters And Apply Changes
    Then Verify All The Filters Removed

Verify user is able to view the teams to whom Training are assigned from Training detail page
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED    LIST_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    [Tags]    CZ-7499
    When Switch Browser    SiteAdmin
    And User Navigate To The Trainings Page
    And Verify The My Training Tab Is Not Visible At Site Admins Screen
    And Click On Administration
    And Navigate To Teams Page
    And Get The Teams Data
    And Switch Browser    Author
    And User Navigate To The Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    And Assign The Training To Team   EXISTING_TEAMS=True
    And Navigate To Training Details Page
    And Click On Assign Button
    And Click On The Teams Tab On The Training User Assign Window
    Then Verify All The Teams Assigned To Training Are Visible On Assign Window