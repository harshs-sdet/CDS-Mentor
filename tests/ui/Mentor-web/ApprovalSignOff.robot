*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
# Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Approvals/SignOffApproval.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Approvals/ProcedureApproval.resource

Suite Setup     Run Keywords       Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
...             AND             Wait For The Page To Load

Test Teardown    Delete A Procedure For Sign Off
Test Setup    Login Again As Author
Suite Teardown      Close All Browsers
*** Test Cases ***

Verify that Sign-off Manager can see the procedures requiring his sign-off in his approvals list.
    [Tags]    CZ-7093   CZ-7094    CZ-7095    CZ-7096    sanity
    # Sleep    5s
    When Create Procedure Records For Approval SignOff
    And Add Training Flow
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Navigate To Approval Sign Off Page
    And Verify Sign Off Approvals Page
    And Search For A Particular Procedure    PROCEDURE_NUMBER=0
    And Click On Searched Procedure
    And Login Again As Author  #Changed

Verify that Sign-Off Manager receives the entry for sign-off as soon as the procedure is completed by Operator.
    [Tags]    CZ-7100    CZ-7097    CZ-7101    CZ-7106
    When Create Procedure Records For Approval SignOff
    And Add Training Flow
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Navigate To Approval Sign Off Page
    AND Verify The Pagination
    AND Verify Approval Status Submissions
    And Search For A Particular Procedure    PROCEDURE_NUMBER=0
    And Verify The Procedure Data On Procedure SignOff List Page    PROCEDURE_NUMBER=0    PROCEDURE_STATUS=1,GREEN,0,0,1
    And Click On Searched Procedure
    AND Verify The Procedure Data On Procedure SignOff Details Page     EXECUTION_SEQUENCE=0    PROCEDURE_STATUS=Pending
    THEN Verify Search Functionality in Signoff
 
Verify that breadcrumb link on View Porcedure page is functional.
    [Tags]    CZ-7107    CZ-7126    sanity
    When Create Procedure Records For Approval SignOff
    And Add Training Flow
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Navigate To Approval Sign Off Page
    And Search For A Particular Procedure    PROCEDURE_NUMBER=0
    And Click On Searched Procedure
    AND Verify Cycle Time
    THEN Verify that user will navigate to Approval Sign off dashboard upon clicking the Breadcrumb link    
    

Verify that Author can select any number of Sign-Off Managers
    [Tags]    CZ-7099
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details Without Co-Author
    Then Verify User Can Add Multiple Sign-off Managers

Verify that user can see how many submission get their approval, rejection or are still in Pending
    [Tags]    CZ-7102    CZ-7103    CZ-7112    CZ-7104    sanity
    When Create Procedure Records For Approval SignOff
    AND Add Training Flow
    AND Logout from Mentor
    AND Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Approval Training Flow
    AND Validate Approval Progress Bar

Verify that user is able to download the signoff report.
    [Tags]    CZ-7132    CZ-7113    CZ-7121    CZ-7135
    When Create Procedure Records For Approval SignOff
    AND Add Training Flow
    AND Logout from Mentor
    AND Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Approval Training Flow
    AND Validate Approval Progress Bar
    AND Add Training Flow
    AND Logout From Mentor
    AND Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    AND Rejection Training Flow
    AND Navigate to the First Procedure
    AND View the Comments and Verify it exists
    AND Close Comments Screen
    THEN Verify The Procedure Report Download    

Verify visibility of multiple Entries for a single procedure across different users
    [Tags]    CZ-7108    CZ-7117    CZ-7119    sanity
    When Create Procedure Records For Approval SignOff    1
    AND Add Training Flow With Multiple Operators
    AND Logout From Mentor
    AND Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    AND Navigate To Approval Sign Off Page
    AND Search For A Particular Procedure    PROCEDURE_NUMBER=0
    AND Navigate to the First Procedure
    Sleep    5s
    ${No_of_rows}=    Get Element Count    //table//tr
    ${String_no_of_rows}=    Convert To String    ${No_of_rows-1}
    AND Should Be Equal    2    ${String_no_of_rows}
    THEN Verify The Pagination

#  Verify that User cannot modify the Approval status if sign-off is already given by first Sign-Off Manager
#      [Tags]    CZ-7122
#      @{signoff_managers}=    Create List    ${AUTHOR1_NAME}    ${AUTHOR2_NAME}
#      When Create Procedure Records With Multiple SignOff Managers    ${signoff_managers}    1
#      AND Add Training Flow
#      AND Logout From Mentor
#      AND Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
#      AND Approval Training Flow
#      AND Logout From Mentor
#      AND Login To Application    ${AUTHOR2_EMAIL}    ${AUTHOR1_PASS}
#      AND Navigate To Approval Sign Off Page
#      AND Search For A Particular Procedure    PROCEDURE_NUMBER=0
#      And Navigate to the First Procedure
#      Then Verify The Approve Button Is Disabled

Verify that User is able to scroll on Comments window
     [Tags]     CZ-7142
     When Create Procedure Records For Approval SignOff   1
     And Add Training Flow
     And Logout from Mentor
     And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
     And Navigate To Approval Sign Off Page
     And Search For a Particular Procedure    0
     Then Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions
     And Navigate to the First Procedure
     And Reject a Training and Verify Rejection
     And Navigate to the First Procedure
     And Open Comments Window
     And Scroll Up and Down in comments window
     And Close Comments Screen

# Verify approvers are visible in the General Details section with a More option to open the approvers pane
#     [Tags]    CZ-8217
    # when Create new Procedure Records For Approval SignOff