*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource


Suite Setup     Run Keywords     Login With Personas For Suite Setup
...              AND             Switch Browser    Author
...             AND             Create Procedure For Job Execution    SAVE_DATA=True
...             AND             Navigate to Job Management Page
...             AND             AuthorScreen.Generate Unique Number
...             AND             Load Validation Data

Test Teardown    Run Keywords    Reset Personas State
...             AND             Switch Browser    Author

Suite Teardown    Close All Browsers

*** Test Cases ***
Verify Author receives notification when he is assigned as a signoff manager on publish
    Log    Bug: CZ-8088
    [Tags]    CZ-6716    CZ-5312    CZ-6717    sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Select The SignOff Manager
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    Then Verify The Newly Created Procedure
    And Verify The Notification Received    NOTIFICATION_CONTEXT=Assigned As Sign Off Manager,${TD_PROCEDURE_NAME},Sign Off Assigned    NOTIFICATION_INDEX=2
    And Click On The Notification Received    NOTIFICATION_INDEX=2
    And Verify Sign Off Approvals Page

Verify that Operator navigates to Job Execution screen from clicking on the Job Assigned notification
    [Tags]    CZ-6727    CZ-6447   CZ-6453   CZ-7259   CZ-7260   CZ-7260   CZ-6728   CZ-6729   CZ-6731   CZ-6713   CZ-6744   CZ-6742   CZ-6726
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Validate The Email Triggered To The User    Email=${OPERATOR1_EMAIL}    EMAIL_CONTENT=Job Assigned,Hello ,A new job “TESTJOB” has been assigned to you.,Please review the job details and proceed accordingly.    PARTICULAR_EMAIL=Job Assigned
    And Navigate To Job Details Page
    And Switch Browser    Author
    And Verify The Notification Received    NOTIFICATION_CONTEXT=New Job: TESTJOB Assigned,TESTJOB,Job Assigned
    And Click On The Notification Received
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Add Comments To Procedure In Job Execution
    Then Validate The Added Comments
    And Close Popup
    And Complete Job/Training Execution
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page
#    And Validate The Added Comments
    And Switch Browser    Author
    And Verify The Notification Received    NOTIFICATION_CONTEXT=Job: TESTJOB Completed,TESTJOB,Job Completed
    And Validate The Email Triggered To The User    Email=${AUTHOR1_EMAIL}    EMAIL_CONTENT=Job Completed,Hello ,successfully completed the job “TESTJOB”,You can review the job completion details below.    PARTICULAR_EMAIL=Job Completed

Verify Author receives email when he is assigned as a signoff manager on publish
    [Tags]    CZ-6738    CZ-6873    CZ-6874    CZ-6875    CZ-6876    CZ-6881    CZ-6882    CZ-6730    CZ-6715    CZ-6721    CZ-6739    CZ-6741    CZ-6743     sanity
    [Setup]    Run Keywords    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    ...        AND             Create Procedure Records
    Log    This testcase might fail due to CZ-7687
    When User Navigate to the Trainings Page
    And Validate The Email Triggered To The User    Email=${AUTHOR1_EMAIL}    EMAIL_CONTENT=Assigned Sign-Off Manager,Hello ${AUTHOR1_NAME},You have been assigned as the Sign-Off Manager for the procedure,Please review and complete the required sign-off actions.    PARTICULAR_EMAIL=Assigned as Sign-Off Manager
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
    And Switch Browser    Operator
#    And Verify The Notification Received    NOTIFICATION_CONTEXT=Training Assigned,You have been assigned a new training
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    And Start The Training    PROCEDURE_NUMBER=1
    And Complete Job/Training execution
    And Switch Browser    Author
    And Navigate To Procedure SignOff Page
    And Verify The Procedure Data On Procedure SignOff List Page    PROCEDURE_NUMBER=0    PROCEDURE_STATUS=1,GREEN,0,0,1
    And Click On Searched Procedure
    And Verify The Procedure Data On Procedure SignOff Details Page     EXECUTION_SEQUENCE=0    PROCEDURE_STATUS=Pending
    And Verify The Notification Received    NOTIFICATION_CONTEXT=The Trainee Has Successfully Completed The Procedure: ${ADD_PROCEDURE_TO_TRAINING_LIST[0]}; Sign-Off Is Pending.,${ADD_PROCEDURE_TO_TRAINING_LIST[0]},Sign Off Pending
    And Provide The Procedure SignOff
    And Verify The Procedure Data On Procedure SignOff Details Page    EXECUTION_SEQUENCE=0    PROCEDURE_STATUS=Approved
    And Switch Browser    Operator
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Click On Searched Training
    Then Verify The Training Data On My Training Flyout Screen    PROCEDURE_SEQUENCE=0    PROCEDURE_STATUS=Approved
    And Switch Browser    Author
    And Verify The Notification Received    NOTIFICATION_CONTEXT=Training Completed,${TRAINING_NAME},Training Completed
    And Validate The Email Triggered To The User    Email=${AUTHOR1_EMAIL}    EMAIL_CONTENT=Training Completed,Hello ,successfully completed the training,You may review the training details below.    PARTICULAR_EMAIL=Training Completed
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page    ${ADD_PROCEDURE_TO_TRAINING_LIST[-1]}
    And Click On Edit Button On Procedure Details Page
    And User Add Step To Procedure
    And User Publishes The Procedure    IGNORE_VERSION=True
    And User Adds Release Notes
    And Switch Browser    Operator
    And Verify The Notification Received    NOTIFICATION_CONTEXT=New Version,Is Published,${TD_PROCEDURE_NAME},Procedure Published
    And Validate The Email Triggered To The User    Email=${OPERATOR1_EMAIL}    EMAIL_CONTENT=New Procedure Version Published,Hello ${OPERATOR1_NAME},Procedure Details,${ADD_PROCEDURE_TO_TRAINING_LIST[-1]}    PARTICULAR_EMAIL=New Version

Verify that user receives an Email when NCR Report is submitted.
    [Tags]    CZ-6747    CZ-7544    CZ-6456    CZ-6457    CZ-6410    CZ-6571    CZ-6736    sanity
    When Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Select The User Input
    And Click on Fail button
    And Fill the NCR report
    And Click on done button in NCR
    And Validate The Email Triggered To The User    Email=${AUTHOR1_EMAIL}    EMAIL_CONTENT=NCR Reported    PARTICULAR_EMAIL=NCR Submited
    And Run Keyword And Ignore Error     Complete Job/Training execution
    And Finish The Job/Training
    And Verify The Job Status    Failed
    Then Delete The Job Created
    And Verify The Notification Received    NOTIFICATION_CONTEXT=Job: ${TestJobName} Failed,${TestJobName},Job Failed    NOTIFICATION_INDEX=1
    And Verify The Notification Received    NOTIFICATION_CONTEXT=New Ncr Form Submitted,${TD_PROCEDURE_NAME},NCR Reported   NOTIFICATION_INDEX=2
    And Expand The Notification Window
    And Verify The Pagination    PARTICULAR_PAGE_SIZE=4

