*** Settings ***
Library    SeleniumLibrary
Library     String
Library    Collections
Library    OperatingSystem
Library    BuiltIn
Library    csvLibrary
Library    RequestsLibrary
Library    DateTime
Library   ../../../../../../src/utilities/Common-utils/csvLibrary.py
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../locators/ui/web/Mentor/Common.yaml
Variables   ../../../../../locators/ui/web/Mentor/ApprovalSignOff.yaml
Variables   ../../../../../locators/ui/web/Mentor/ProcedureApproval.yaml
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Resource    ../Common/Common.resource
Resource    ../Trainings/Training.resource
Resource    ../JobManagement/JobManagement.resource
Resource    ProcedureApproval.resource

*** Keywords ***


Verify Sign Off Approvals Page
    Wait Until Element Is Visible    ${procedures_heading}    timeout=5s
    Wait Until Element Is Visible    ${search_bar_field}    timeout=5s
    Wait Until Element Is Visible    ${dashboard_headings}    timeout=5s
    Verify Procedure List Is Visible
    Wait Until Element Is Visible    ${search_icon}    timeout=5s
    Wait Until Element Is Visible    ${pagination_container}    timeout=5s
    #Verify The Pagination On Custom Page    ${Sign_off_approvals_pages_select}    False    ${PAGINATION_NEXT_PAGE}


Verify the View Procedure Page
    Wait Until Element Is Visible    ${Sign_off_procedures_breadcrumb_link}    timeout=10s
    Wait Until Element Is Visible    ${filter_icon}    timeout=5s
    Wait Until Element Is Visible    ${search_icon}    timeout=5s
    Wait Until Element Is Visible    ${search_bar_field}    timeout=5s
    Wait Until Element Is Visible    ${dashboard_headings}
    Wait Until Element Is Visible    ${pagination_container}


Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions   
    Extract Counts of Each Approval Status
    ${TOTAL_COUNT}=    Evaluate    ${APPROVED_COUNT} + ${REJECTED_COUNT} + ${PENDING_COUNT}
    Set Test Variable    ${TOTAL_COUNT}
    ${submissions}=    Get Text    ${submissions_count}
    ${submissions_no}=    Evaluate    int(''.join([c for c in """${submissions}""" if c.isdigit()]))
    Should Be Equal    ${TOTAL_COUNT}    ${submissions_no}

Approve a Training and Verify Approval
    Wait Until Element Is Visible    ${approve_button}    timeout=10s
    ${status}=    Get Text    ${first_training_entry_status}
    Click Element    ${approve_button}
    Wait Until Element Is Visible    ${confirm_button}    timeout=10s
    Click Element    ${confirm_button}
    wait for the page to load
    Click Element    ${Sign_off_procedures_breadcrumb_link}
    wait for the page to load
    Search For A Particular Procedure    PROCEDURE_NUMBER=0
    Wait Until Element Is Visible    ${approval_approved_counts}    timeout=10s
    ${approved}=    Get Text    ${approval_approved_counts}
    ${approved}=    Strip String    ${approved}
    ${updated_approval_count}=    Convert To Integer    ${approved}
    IF    '${status}' != 'Approved'
        ${APPROVED_COUNT}=    Evaluate    ${APPROVED_COUNT}+1
        IF    '${status}' == 'Rejected'
            ${REJECTED_COUNT}=    Evaluate    ${REJECTED_COUNT}-1
        END    
    END
    Should Be Equal    ${updated_approval_count}    ${APPROVED_COUNT}
    
Reject a Training and Verify Rejection
    Wait Until Element Is Visible    ${reject_button}    timeout=10s
    ${status}=    Get Text    ${first_training_entry_status}
    Click Element    ${reject_button}
    ${comment}=    Set Variable    'trial'
    Set Test Variable    ${comment}
    Input Text    ${reason_input}    ${comment}
    Wait Until Element Is Visible    ${confirm_button}    timeout=10s
    Click Element    ${confirm_button}
    wait for the page to load
    Click Element    ${Sign_off_procedures_breadcrumb_link}
    wait for the page to load
    Search For A Particular Procedure    PROCEDURE_NUMBER=0
    Wait Until Element Is Visible    ${approval_rejected_counts}    timeout=10s
    ${rejected}=    Get Text    ${approval_rejected_counts}
    ${rejected}=    Strip String    ${rejected}
    ${updated_rejection_count}=    Convert To Integer    ${rejected}
    IF    '${status}' != 'Rejected'
        ${REJECTED_COUNT}=    Evaluate    ${REJECTED_COUNT}+1 
        Log    ${REJECTED_COUNT}
        IF    '${status}' == 'Approved'
            ${APPROVED_COUNT}=    Evaluate    ${APPROVED_COUNT}-1
        END       
    END    
    Should Be Equal    ${updated_rejection_count}    ${REJECTED_COUNT}    

Reject a Training without comments
    Wait Until Element Is Visible    ${reject_button}    timeout=10s
    ${status}=    Get Text    ${first_training_entry_status}    
    Click Element    ${reject_button}
    Wait Until Element Is Visible    ${confirm_reject_button}    timeout=10s
    Element Should Be Disabled    ${confirm_reject_button}
    Wait Until Element Is Visible    ${reason_input}    timeout=10s
    ${comment}=    Set Variable    'trial'
    Set Test Variable    ${comment}
    Input Text    ${reason_input}    ${comment}
    Wait Until Element Is Visible    ${confirm_reject_button}    timeout=10s
    Click Element    ${confirm_reject_button}
    wait for the page to load
    Click Element    ${Sign_off_procedures_breadcrumb_link}
    wait for the page to load
    Search For A Particular Procedure    0
    Wait Until Element Is Visible    ${approval_rejected_counts}    timeout=10s
    ${rejected}=    Get Text    ${approval_rejected_counts}
    ${rejected}=    Strip String    ${rejected}
    ${updated_rejection_count}=    Convert To Integer    ${rejected}
    IF    '${status}' != 'Rejected'
        ${REJECTED_COUNT}=    Evaluate    ${REJECTED_COUNT}+1 
        Log    ${REJECTED_COUNT}
        IF    '${status}' == 'Approved'
            ${APPROVED_COUNT}=    Evaluate    ${APPROVED_COUNT}-1
        END       
    END   
    Should Be Equal    ${updated_rejection_count}    ${REJECTED_COUNT}

Approval Training Flow
    Navigate To Approval Sign Off Page
    And Search For A Particular Procedure    PROCEDURE_NUMBER=0
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions  
    And Navigate to the First Procedure
    And Approve a Training and Verify Approval
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions    

Rejection Training Flow
    Navigate To Approval Sign Off Page
    And Search For A Particular Procedure    PROCEDURE_NUMBER=0
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions  
    And Navigate to the First Procedure
    And Reject a Training without comments
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of Submissions    

Verify Search Functionality in Signoff
    Wait Until Element Is Visible    ${search_bar_field}    
    Input Text    ${search_bar_field}    ${TRAINING_NAME}
    Sleep    2s
    Press Keys    css=body   ENTER
    wait for the page to load
    ${training_name}=    Get Text    ${first_search_training}
    Should Be Equal As Strings    ${TRAINING_NAME}    ${training_name}
    Clear Element Text    ${search_bar_field}
    Input Text    ${search_bar_field}    ${OPERATOR1_NAME}
    wait for the page to load
    Press Keys    css=body   ENTER
    wait for the page to load
    ${user_name}=    Get Text    ${first_search_updatedby}
    Should Be Equal As Strings    ${user_name}    ${OPERATOR1_NAME}

Verify that user will navigate to Approval Sign off dashboard upon clicking the Breadcrumb link
    Wait Until Element Is Visible    ${Sign_off_procedures_breadcrumb_link}    timeout=10s
    Click Element    ${Sign_off_procedures_breadcrumb_link}
    wait for the page to load
    Verify Sign Off Approvals Page

View the Comments and Verify it exists
    Wait Until Element Is Visible    ${comments_icon}    timeout=10s
    Click Element    ${comments_icon}
    Page Should Contain    ${comment}

Close Comments Screen
    Wait Until Element Is Visible    ${close_comments}    timeout=5s
    Click Element    ${close_comments}
    Sleep    2s    

Verify The Procedure Report Download
    Wait Until Element Is Visible    ${Download_button}
    Click Element    ${Download_button}

Open Comments Window
    Wait Until Element Is Visible    ${comments_icon}    timeout=10s
    Click Element    ${comments_icon}

Scroll Up and Down in comments window
    ${comment_window}=    Get WebElement    //mat-dialog-content[@class='mat-mdc-dialog-content mdc-dialog__content ng-star-inserted']
    Execute JavaScript    arguments[0].scrollTop = arguments[0].scrollHeight    ARGUMENTS    ${comment_window}
    Sleep    1s 
    Execute JavaScript    arguments[0].scrollTop = 0    ARGUMENTS    ${comment_window}
    Sleep    1s

Add Training Flow
    User Navigate to the Trainings Page
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
    And Logout From Mentor
    And Login To Application    ${OPERATOR1_EMAIL}    ${OPERATOR1_PASS}
    And Navigate To My Trainings Page
    #And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    And Complete Job/Training execution
    AND Increment Training Submissions
    
    
Search For A Particular Procedure
    [Documentation]    To Verify The Procedure Data On Procedure SignOff List Page
    [Arguments]    ${PROCEDURE_NUMBER}
    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_NUMBER}
    Search Procedure In Procedures Page    ${PROCEDURE} 



Search Procedure In Procedures Page
    [Documentation]    To Search Procedure In SignOff Procedure Page
    [Arguments]    ${PROCEDURE}
    Wait Until Element Is Enabled    ${SIGNOFF_PROCEDURE_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${SIGNOFF_PROCEDURE_SEARCH}    ${PROCEDURE}
    # Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_NAME})[1]    ${PROCEDURE}   

Add Training Flow With Multiple Operators
    User Navigate to the Trainings Page
    And Click On Add New Training Button
    And Fill The Form And Submit It
    And Navigate To Training Details Page
    And Click Edit Procedure Button
    And Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}
    And Click Create/Update Training Submit Button
    And Navigate To Training Details Page
    And Click On Assign Button
    @{users_list}=    Create List    ${OPERATOR1_NAME}    ${OPERATOR2_NAME}
    And Search Multiple User And Select    ASSIGNEE_LIST=${users_list}
    And Click On Select Procedure Done Button
    AND Finish Training For Operator    ${OPERATOR1_EMAIL}    ${OPERATOR1_PASS}
    AND Finish Training For Operator    ${OPERATOR2_EMAIL}    ${OPERATOR2_PASS}

Finish Training For Operator
    [Arguments]    ${Mail}    ${Pass}
    And Logout From Mentor
    And Login To Application    ${Mail}    ${Pass}
    And Navigate To My Trainings Page
    And Search Training In My Trainings
    And Start The Training    PROCEDURE_NUMBER=0
    AND Complete Job/Training execution
    AND Increment Training Submissions


Increment Training Submissions
    [Documentation]    Increement submission as we complete a training to signoff approvals
    ${count}    Run Keyword And Return Status    Variable Should Exist    ${Completed_Submissions}
    IF    ${count}
        ${Completed_Submissions}    Evaluate    ${Completed_Submissions} + 1
    ELSE
        ${Completed_Submissions}    Set Variable    1
    END
    Set Test Variable    ${Completed_Submissions}
    
Verify Cycle Time
    Wait Until Element Is Visible    ${sign_cycle_time}    timeout=10s
    ${view_cycle_time}=    Get Text    ${sign_cycle_time}
    ${observed_cycle_time}=    Set Variable    ${TAKEN_TIME_IN_EXECUTION}[-1]
    Should Be Equal As Strings    ${view_cycle_time}    ${observed_cycle_time}
Verify The Approve Button Is Disabled
    [Documentation]    Verify The Approve Button Is Disabled: Bug is logged
    Wait Until Element Is Visible    ${approve_button}    timeout=10s
    Element Should Be Disabled    ${approve_button}

Verify Cancel Button Functionality
    Wait Until Element Is Visible    ${reject_button}    timeout=10s
    ${status}=    Get Text    ${first_training_entry_status}    
    Click Element    ${reject_button}
    Wait Until Element Is Visible    ${confirm_reject_button}    timeout=10s
    Element Should Be Disabled    ${confirm_reject_button}
    Wait Until Element Is Visible    ${reason_input}    timeout=10s
    ${comment}=    Set Variable    'trial'
    Set Test Variable    ${comment}
    Input Text    ${reason_input}    ${comment}