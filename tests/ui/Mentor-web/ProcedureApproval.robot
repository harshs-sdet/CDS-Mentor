*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Approvals/ProcedureApproval.resource

Suite Setup     Run Keywords       Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
...             AND             Wait For The Page To Load
...             AND        Set Selenium Speed    0.1s

Test Teardown    Run Keyword    Login Again As Author
#...             AND             Delete A Procedure
#Test Teardown    Delete A Procedure
Suite Teardown    Close All Browsers
*** Test Cases ***
Verify that user is able to send procedure for approval
    [Tags]    CZ-7143    CZ-7144    CZ-7145    CZ-7146    CZ-7148    CZ-7150    CZ-6745    sanity
    [Documentation]    Verify that count of approvals (Approved, Rejected or Pending) is correctly calculated.
    # AND Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AuthorPass}
    When Create Procedure For Approval Manager
    AND Verify That Procedure In Approval Pending State
    AND Logout from Mentor
    AND Login To Application    ${AUTHOR2_EMAIL}    ${AUTHOR2_PASS}
    AND Navigate To Procedure Approvals Page
    AND Verify Procedure Approval Page
    AND Verify The Procedure Names Are Hyperlinked
    AND Verify The Procedure Exists    ${TD_PROCEDURE_NAME}
    AND Verify the version number and type on Procedure Approvals Page
    And Validate The Email Triggered To The User    Email=${AUTHOR2_EMAIL}    EMAIL_CONTENT=A new procedure, ${TD_PROCEDURE_NAME}, has been created in Mentor by ${AUTHOR1_NAME} and is awaiting your approval.    PARTICULAR_EMAIL=Requested Procedure
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}   

Verify that user is able to filter the procedures using filter icon
    [Tags]    CZ-7151   
    [Documentation]    Verify that user is able to filter the procedures using filter icon. This is Failing because of the issue #CZ-8514
    When Create Procedure For Approval Manager
    AND Logout from Mentor
    AND Login To Application    ${AUTHOR2_EMAIL}    ${AUTHOR2_PASS}
    AND Navigate To Procedure Approvals Page
    AND wait for the page to load
    AND Apply a Filter
    AND Verify The Filter is Applied

Verify the Pagination functionality on Procedure Approval Page
    [Tags]    CZ-7152    CZ-7160
    [Documentation]    Verify the Pagination functionality on Procedure Approval Page
    When Create Procedure For Approval Manager
    AND Logout from Mentor
    AND Login To Application     ${AUTHOR2_EMAIL}     ${AuthorPass}
    AND Navigate To Procedure Approvals Page
    AND Verify The Pagination
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}

Verify that user is able to Approve/Reject a procedure and count is reflected on dashboard in real time.
    [Tags]    CZ-7161    CZ-7154    CZ-7155    CZ-7156
    [Documentation]    Verify that count of approvals (Approved, Rejected or Pending) is correctly calculated
    When Create Procedure For Approval Manager
    And Logout from Mentor
    And Login To Application    ${AUTHOR2_EMAIL}    ${AuthorPass}
    And Approve Procedure Flow
    And Validate Approval Progress Bar
    And Logout from Mentor
    And Login To Application    ${AUTHOR3_EMAIL}    ${AuthorPass}
    And Reject Procedure Flow
    And Validate Approval Progress Bar
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}

Verify that a procedure is displayed as Approved only if all the approvers mark them as Approved.
    [Tags]    CZ-7157    CZ-7153    sanity
    [Documentation]    Verify that a procedure is displayed as Approved only if all the approvers mark them as Approved.
    When Create Procedure For Approval Manager
    And Logout from Mentor
    FOR    ${i}    IN RANGE    2    4    
        Login To Application    ${AUTHOR${i}_EMAIL}    ${AUTHOR${i}_PASS}
        And Approve Procedure Flow
        And Logout from Mentor        
    END
    And Login To Application    ${AUTHOR2_EMAIL}    ${AuthorPass}
    And Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    And Check Procedure Status    Approved
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}

Verify that the name in 'Updated By' correctly shows who has updated the procedure and sent for approval.
    [Tags]    CZ-7158    CZ-7162    CZ-7166    sanity
    [Documentation]    Verify that the name in 'Updated By' correctly shows who has updated the procedure and sent for approval.
    When Create Procedure For Approval Manager
    And Logout from Mentor
    FOR    ${i}    IN RANGE    2   4       
        And Login To Application    ${AUTHOR${i}_EMAIL}    ${AUTHOR${i}_PASS}
        And Approve Procedure Flow
        And Logout from Mentor        
    END
    And Login To Application    ${AUTHOR2_EMAIL}    ${AUTHOR2_PASS}
    And Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    ${initial_updated_by}=    Obtain Last Updated By Name
    And Navigate To Procedures List Page
    And Search For Recently Created Procedure
    And Navigate to the First Procedure    
    And Click On Edit Button On Procedure Details Page
    And User Add Step To Procedure
    And User Publishes the Updated Procedure
    And User Adds Release Notes    
    And wait for the page to load
    And wait for the page to load
    And Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    And Verify Version Type Colors
    ${new_updated_by}=    Obtain Last Updated By Name
    Then Should Not Be Equal As Strings    ${initial_updated_by}    ${new_updated_by}
    And Navigate to the First Procedure
    And Verify UI of View Procedure Page
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}

Verify the text displayed on View Procedure page.
    [Tags]    CZ-7163    CZ-7164    CZ-7165    CZ-7168    CZ-7172
    [Documentation]    Verify the text displayed on View Procedure page.
    When Create Procedure For Approval Manager
    And Logout from Mentor
    And Login To Application    ${AUTHOR2_EMAIL}    ${AuthorPass}
    And Navigate To Procedure Approvals Page
    And Verify Procedure List Is Visible
    And Search For Recently Created Procedure
    And Navigate to the First Procedure
    And Verify Procedure Approval (Procedure Details) Page
    And Verify General Details on View Procedure Page
    And Verify Step Details And Version Differences
    And Verify that user will navigate to Procedure Approvals dashboard upon clicking the Breadcrumb link
    And Logout from Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}

#  Verify that Appoval Manager can compare the current and previous version of the procedure.
#      [Tags]    CZ-7169    
#      [Documentation]    Verify that Appoval Manager can compare the current and previous version of the procedure.
#      When Navigate to Procedures page
#      And Publish A procedure With Approval Managers
#      And Logout from Mentor
#      FOR    ${i}    IN RANGE    1    3
#          ${manager_email}=    Get Variable Value    ${MANAGER_EMAIL_${i}}
#          IF    '${manager_email}' == '${AUTHOR1_EMAIL}'
#              CONTINUE
#          END
#          And Login To Application    ${MANAGER_EMAIL_${i}}    ${AuthorPass}
#          And Approve Procedure Flow
#          And Logout from Mentor
#      END
#      And Login To Application    ${AUTHOR1_EMAIL}    ${AuthorPass}
#      And Search For Recently Created Procedure
#      And Navigate to the First Procedure
#      And Click On Edit Button On Procedure Details Page
#      And Navigate to First Step
#      And User Adds User Input to Step
#      And User Publishes the Updated Procedure
#      And User Adds Release Notes
#      And Logout from Mentor
#      And Login with approval manager
#      And Navigate To Procedure Approvals Page
#      And Search For Recently Created Procedure
#      And Navigate to the First Procedure
#      And Verify New and Old Version