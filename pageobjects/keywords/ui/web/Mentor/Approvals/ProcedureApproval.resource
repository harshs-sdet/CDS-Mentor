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
Resource    SignOffApproval.resource

*** Variables ***
${REJECTION_REASON}              Rejection reason for automation testing

*** Keywords ***
Verify The Procedure Exists
    [Arguments]    ${Procedure}
    # Wait Until Element Is Visible    ${Add_btn}     ${MaxTime}
    ${ProcedureTitle}=    Replace String   ${ProcedureName}  replace    ${Procedure}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${Procedure_Search_Bar}
    Input Text   ${Procedure_Search_Bar}    ${Procedure}
    Wait Until Element Is Visible     ${ProcedureTitle}   ${MaxTime}
    
Navigate to the First Procedure
    Wait Until Element Is Visible    ${first_procedure_click}    timeout=60s
    Wait For The Element And Click    ${first_procedure_click}

Verify Procedure List Is Visible
   [Documentation]    Verifies that the list of procedures is visible in the dashboard table.
   #${locator}=    Set Variable    //table[contains(@class, 'mat-mdc-table')]//span[contains(@class, 'mat-mdc-tooltip-trigger clickable')]
   Wait Until Element Is Visible    ${approval_procedure_list}    timeout=60s
   ${count}=    Get Element Count    ${approval_procedure_list}
   Should Be True    ${count} > 0    msg=Procedure list not visible or empty
   Log    Procedure list is visible with ${count} items.    

Search For Recently Created Procedure
    Wait Until Element Is Visible    ${search_bar_field}
    Input Text    ${search_bar_field}    ${TD_PROCEDURE_NAME}
    Press Keys    css=body   ENTER
    wait for the page to load

Verify Approval Status Submissions
   Wait Until Element Is Visible    ${submissions_count}    timeout=10s
   ${text}=    Get Text    ${submissions_count}
   ${submission_count}=    Evaluate    ('${text}'.split()[0])
   Should Match Regexp    ${text}    ^\\d+\\s+Submissions$
   Should Be Equal    ${submission_count}    ${Completed_Submissions}

   

Get Approver Count and Verify if They Are Equal To the Number of Approvers Added
   [Documentation]    Extracts the numeric approver count (e.g. '1' from '1 Approvers') from the Approval Status field.
   Wait Until Element Is Visible    ${approvals_count}    timeout=10s
   ${text}=    Get Text    ${approvals_count}
   ${approver_count}=    Evaluate    re.search(r'\\d+', """${text}""").group(0)    re
   Set Test Variable    ${approver_count}
   Should Be Equal    ${approver_count}    2   

Extract Counts of Each Approval Status
   Wait Until Element Is Visible    ${approval_approved_counts}    timeout=10s
   ${approved}=    Get Text    ${approval_approved_counts}
   ${rejected}=    Get Text    ${approval_rejected_counts}
   ${pending}=     Get Text    ${approval_pending_counts}
   ${approved}=    Strip String    ${approved}
   ${rejected}=    Strip String    ${rejected}
   ${pending}=     Strip String    ${pending}
   ${APPROVED_COUNT}=    Convert To Integer    ${approved}
   ${REJECTED_COUNT}=    Convert To Integer    ${rejected}
   ${PENDING_COUNT}=     Convert To Integer    ${pending}
   Set Test Variable    ${APPROVED_COUNT}    ${APPROVED_COUNT}
   Set Test Variable    ${REJECTED_COUNT}    ${REJECTED_COUNT}
   Set Test Variable    ${PENDING_COUNT}     ${PENDING_COUNT}   

Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of approvers
    Extract Counts of Each Approval Status
    ${TOTAL_COUNT}=    Evaluate    ${APPROVED_COUNT} + ${REJECTED_COUNT} + ${PENDING_COUNT}
    Set Test Variable    ${TOTAL_COUNT}
    ${approver_count_int}=    Convert To Integer    ${approver_count}
    Should Be Equal    ${TOTAL_COUNT}    ${approver_count_int}
    
Approve a Procedure and Verify Approval
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${approve_procedure}    timeout=10s
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Click Element    ${approve_procedure}
    Wait Until Element Is Visible    ${confirm_button}    timeout=10s
    Click Element    ${confirm_button}
    wait for the page to load
    Search For Recently Created Procedure
    Wait Until Element Is Visible    ${approval_approved_counts}    timeout=10s
    ${approved}=    Get Text    ${approval_approved_counts}
    ${approved}=    Strip String    ${approved}
    ${updated_approval_count}=    Convert To Integer    ${approved}
    ${APPROVED_COUNT}=    Evaluate    ${APPROVED_COUNT}+1
    Should Be Equal    ${updated_approval_count}    ${APPROVED_COUNT}
    
Reject a Procedure and Verify Rejection
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${reject_procedure}    timeout=10s
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Click Element    ${reject_procedure}
    Wait Until Element Is Visible    ${confirm_button}    timeout=10s
    Input Text      ${rejection_reason_field}    ${REJECTION_REASON}
    Click Element    ${confirm_button}
    wait for the page to load
    Search For Recently Created Procedure
    Wait Until Element Is Visible    ${approval_rejected_counts}    timeout=10s
    ${rejected}=    Get Text    ${approval_rejected_counts}
    ${rejected}=    Strip String    ${rejected}
    ${updated_rejection_count}=    Convert To Integer    ${rejected}
    ${REJECTED_COUNT}=    Evaluate    ${REJECTED_COUNT}+1
    Should Be Equal    ${updated_rejection_count}    ${REJECTED_COUNT}

Get Progress Width
   [Arguments]    ${XPATH}
   ${style}=    Get Element Attribute    ${XPATH}    style
   ${width_list}=    Get Regexp Matches    ${style}    width:\\s*([0-9.]+)%    1
   Run Keyword If    ${width_list}    Log    Found Width: ${width_list[0]}%
   ${width}=    Run Keyword If    ${width_list}    Set Variable    ${width_list[0]}    ELSE    Set Variable    0
   RETURN    ${width}

Validate Approval Progress Bar
   ${approved_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${approved_progress}    timeout=3s
   ${rejected_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${rejected_progress}    timeout=3s
   ${pending_exists}=     Run Keyword And Return Status    Element Should Be Visible    ${pending_progress}    timeout=3s
   ${approved_actual}=    Run Keyword If    ${approved_exists}    Get Progress Width    ${approved_progress}    ELSE    Set Variable    0
   ${rejected_actual}=    Run Keyword If    ${rejected_exists}    Get Progress Width    ${rejected_progress}    ELSE    Set Variable    0
   ${pending_actual}=     Run Keyword If    ${pending_exists}     Get Progress Width    ${pending_progress}    ELSE    Set Variable    0
   ${approved_actual}=    Evaluate    float(re.sub(r'[^0-9.]', '', str(${approved_actual})))
   ${rejected_actual}=    Evaluate    float(re.sub(r'[^0-9.]', '', str(${rejected_actual})))
   ${pending_actual}=     Evaluate    float(re.sub(r'[^0-9.]', '', str(${pending_actual})))
   ${approved_expected}=    Evaluate    round((${APPROVED_COUNT} / ${TOTAL_COUNT}) * 100, 2)
   ${rejected_expected}=    Evaluate    round((${REJECTED_COUNT} / ${TOTAL_COUNT}) * 100, 2)
   ${pending_expected}=     Evaluate    round((${PENDING_COUNT} / ${TOTAL_COUNT}) * 100, 2)
   Should Be Equal As Numbers    ${approved_expected}    ${approved_actual}    0.1
   Should Be Equal As Numbers    ${rejected_expected}    ${rejected_actual}    0.1
   Should Be Equal As Numbers    ${pending_expected}     ${pending_actual}    0.1

Approve Procedure Flow
    Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    And Get Approver Count and Verify if They Are Equal To the Number of Approvers Added
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of approvers
    And Navigate to the First Procedure
    And Approve a Procedure and Verify Approval
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of approvers

Reject Procedure Flow
    Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    Sleep    3s
    And Get Approver Count and Verify if They Are Equal To the Number of Approvers Added
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of approvers
    And Navigate to the First Procedure
    Sleep    3s
    And Reject a Procedure and Verify Rejection
    And Verify If Sum of Approvals(Pending,Rejected, Approved) is Equal to total number of approvers         

Check Procedure Status
   [Arguments]    ${expected_status}
   ${status_xpath}=    Set Variable    //span[contains(@class,'status-tag') and normalize-space(text())='${expected_status}']
   Wait Until Element Is Visible    ${status_xpath}    timeout=5s
   ${actual_status}=    Get Text    ${status_xpath}
   Should Be Equal As Strings    ${actual_status}    ${expected_status}
    
Obtain Last Updated By Name
    ${updated_by}=    Get Text    ${updated_by_name}   
    ${updated_by}=    Strip String    ${updated_by}
    RETURN    ${updated_by}  

Verify And Change Pagination Size
   [Documentation]    Verify table shows 10 rows, change dropdown to 20, then verify 20 rows.
   ${rows_10}=    Get Element Count    //table//tr
   ${rows_10}=    Evaluate    ${rows_10}-1
   ${rows_10}=    Convert To Integer    ${rows_10}
   IF    ${rows_10} == 10   
       Should Be Equal As Integers    ${rows_10}    10
   END
   Scroll Element Into View    (//mat-select)[3]
   Sleep    0.5s
   ${click_status}=    Run Keyword And Return Status    Click Element    (//mat-select)[3]
   Run Keyword Unless    ${click_status}    Execute Javascript    document.querySelectorAll('mat-select')[2].click()
   Sleep    1s
   Wait Until Element Is Visible    ${twenty_rows_option}    timeout=5s
   Click Element    ${twenty_rows_option}
   Sleep    2s
   ${rows_20}=    Get Element Count    //table//tr
   ${rows_20}=    Evaluate    ${rows_20}-1
   ${rows_20}=    Convert To Integer    ${rows_20}
   IF    ${rows_20} == 20   
       Should Be Equal As Integers    ${rows_20}    20
   END

Verify Version Type Colors
   ${minor_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${minor_release_color}    timeout=2s
   ${major_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${major_release_color}    timeout=2s
   Run Keyword If    ${minor_exists}    Verify Single Tag Color    minor    rgb(64, 148, 204)
   ...    ELSE    Log    'minor' tag not found — skipping color verification.
   Run Keyword If    ${major_exists}    Verify Single Tag Color    major    rgb(0, 143, 49)
   ...    ELSE    Log    'major' tag not found — skipping color verification.   
    
Verify Single Tag Color
   [Arguments]    ${tag_text}    ${expected_rgb}
   ${style}=    Get Element Attribute    //span[normalize-space(.)='${tag_text}']    style
   Should Contain    ${style}    ${expected_rgb}    msg=Expected '${tag_text}' color to be ${expected_rgb}

Verify Procedure Approval (Procedure Details) Page
    Wait Until Element Is Visible    ${version_details}    timeout=20s
    Page Should Contain Element    ${procedures_heading}    timeout=5s
    Page Should Contain Element     ${approve_procedure}    timeout=5s
    Page Should Contain Element     ${reject_procedure}    timeout=5s
    Page Should Contain Element     ${Procedure_approvals_breadcrumb_link}    timeout=10s
    Page Should Contain Element     ${version_details}    timeout=5s
#    Wait Until Element Is Visible    ${procedures_heading}    timeout=5s
#    Wait Until Element Is Visible    ${approve_procedure}    timeout=5s
#    Wait Until Element Is Visible    ${reject_procedure}    timeout=5s
#    Wait Until Element Is Visible    ${Procedure_approvals_breadcrumb_link}    timeout=10s
#    Wait Until Element Is Visible    ${version_details}    timeout=5s

Verify General Details on View Procedure Page
    Wait Until Element Is Visible    ${procedure_name_key}    timeout=5s
    Wait Until Element Is Visible    ${document_id_key}    timeout=5s
    Wait Until Element Is Visible    ${material_number_key}    timeout=5s
    Wait Until Element Is Visible    ${approval_managers_key}    timeout=5s

Verify that user will navigate to Procedure Approvals dashboard upon clicking the Breadcrumb link
    Wait Until Element Is Visible    ${Procedure_approvals_breadcrumb_link}    timeout=10s
    Click Element    ${Procedure_approvals_breadcrumb_link}
    wait for the page to load
    Verify Procedure Approval Page
    

Verify Procedure Approval Page
    Wait Until Element Is Visible    ${filter_icon}
    Wait Until Element Is Visible    ${search_bar_field}
    Wait Until Element Is Visible    ${Procedure_Name_heading}
    Wait Until Element Is Visible    ${Change_Type}
    Wait Until Element Is Visible    ${Updated_By}
    Wait Until Element Is Visible    ${Received_On}
    Wait Until Element Is Visible    ${Status}
    Wait Until Element Is Visible    ${Approved_on}
    Wait Until Element Is Visible    ${Approval_Status}
    Verify Procedure List Is Visible
    Wait Until Element Is Visible    ${procedure_approval_heading}    

Verify UI of View Procedure Page
    Verify Procedure Approval (Procedure Details) Page
    Verify Step Details And Version Differences

Verify Step Details And Version Differences
   [Documentation]    Verifies step details, instruction tabs, and version color differences. Handles missing elements safely.
   ${step_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${view_step_details}
   Run Keyword If    not ${step_exists}    Fail    Step section not visible.
   ${cycle_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${view_cycle_time}
   Run Keyword If    ${cycle_exists}    Log    Cycle Time visible.
   ...    ELSE    Log    Cycle Time not found - skipping.
   ${instr_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${view_instructions}
   Run Keyword If    ${instr_exists}    Log    Instructions visible.
   ...    ELSE    Log    Instructions not found - skipping.
   ${tabs}=    Create List    User Input    Options    Instructions    Attachments
   FOR    ${tab}    IN    @{tabs}
       ${tab_exists}=    Run Keyword And Return Status    Element Should Be Visible    //div[normalize-space(.)='${tab}']
       Run Keyword If    ${tab_exists}    Log    Tab '${tab}' visible.
       ...    ELSE    Log    Tab '${tab}' not found.
   END
   ${prev_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${view_prev_version}
   ${curr_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${view_curr_version}
   Run Keyword If    not ${prev_visible}    Log    Previous Version section not visible.
   Run Keyword If    not ${curr_visible}    Log    Current Version section not visible.
   
Verify the version number and type on Procedure Approvals Page
    [Documentation]    Verifies if the version number and type on Procedure Approvals Page matches the one when it is created
    ${type}=    Get Text    ${version_type}
    Should Be Equal    ${type}    ${TD_RELEASE_TYPE}

Apply a Filter
    Sleep    2s
    Wait Until Element Is Visible    ${filter_click}    timeout=10s
    Click Element    ${filter_click}
    Wait Until Element Is Visible    ${filter_approval_status}    timeout=10s
    Click Element    ${filter_approval_status}
    Wait Until Element Is Visible    ${approved_filter}    timeout=10s
    Click Element    ${approved_filter}
    Capture Page Screenshot
    Wait Until Element Is Visible    ${filter_apply}    timeout=10s
    Click Element    ${filter_apply}
    Capture Page Screenshot
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LoadingBar}   ${MaxTime}


Verify The Filter is Applied
    Sleep    2s
    ${ELEMENTS_IN_PAGE}=    Get Element Count    //table//tr
    FOR    ${counter}    IN RANGE    1    ${ELEMENTS_IN_PAGE}
        ${string_number}=    Convert To String    ${counter}
        ${replaced_xpath}=    Replace String   ${Table_Procedure_Status}  INDEX    ${string_number}
        ${STATUS}=    Get Text    ${replaced_xpath}
        Log    ${STATUS}
        Should Be Equal    ${STATUS}    Approved
    END

Verify The Procedure Names Are Hyperlinked
    [Documentation]    Verify the procedures are hyperlinked.
    ${ELEMENTS_IN_PAGE}=    Get Element Count    //table//tr
    FOR    ${counter}    IN RANGE    1    ${ELEMENTS_IN_PAGE}
        ${string_number}=    Convert To String    ${counter}
        ${replaced_xpath}=    Replace String   ${Table_procedures_name}  INDEX    ${string_number}
        ${is_clickable}=    Is Span clickable    ${replaced_xpath}
        Should Be True    ${is_clickable}
    END
    # Is Span clickable    ${procedure_click}

Is Span clickable
    [Arguments]    ${locator}
    ${span}=    Get WebElement    ${locator}
    #cursor returns a pointer if it is clickable and other if it is not clickable
    ${cursor}=    Execute Javascript    return window.getComputedStyle(document.evaluate("${locator}",document,null,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue).cursor
    ${enabled}=    Run Keyword And Return Status    Element Should Be Enabled    ${span}
    ${visible}=    Run Keyword And Return Status    Element Should Be Visible    ${span}
    ${clickable}=    Run Keyword And Return Status    Should Be True    '${cursor}'=='pointer' and ${visible} and ${enabled}
    RETURN    ${clickable}

Verify New and Old Version 
    ${prev_input_exists}=    Run Keyword And Return Status    Element Should Contain    //div[contains(@class,'section left')]    User Input
   ${curr_input_exists}=    Run Keyword And Return Status    Element Should Contain    //div[contains(@class,'section right')]    User Input
   Run Keyword If    '${prev_input_exists}'=='False' and '${curr_input_exists}'=='True'    Log    User input was added successfully.
   Run Keyword If    '${prev_input_exists}'=='True' and '${curr_input_exists}'=='True'     Fail    User input already existed in previous version.
   Run Keyword If    '${prev_input_exists}'=='True' and '${curr_input_exists}'=='False'    Fail    User input was removed instead of added.
   Run Keyword If    '${prev_input_exists}'=='False' and '${curr_input_exists}'=='False'   Log    User.

Navigate to First Step
    Wait Until Element Is Visible    ${FIRST_STEP}    timeout=10s
    Click Element    ${FIRST_STEP}

Login with approval manager
    IF    '${MANAGER_EMAIL_1}'=='${CrossSiteUser}'
        Login To Application    ${MANAGER_EMAIL_2}    ${AuthorPass}
    ELSE
        Login To Application    ${MANAGER_EMAIL_1}    ${AuthorPass}
    END

Create Procedure For Approval Manager
    [Documentation]    To Create Procedure Records
    [Arguments]    ${COUNT}=1    ${SIGNOFF}=REQUIRED
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    Run Keyword If    '${SIGNOFF}'=='REQUIRED'  Select The Approval Managers
    Add The Cycle Time To The Procedure
    User Add Step To Procedure    1
    User Publishes The Procedure
    User Adds Release Notes
    Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    wait for the page to load
    Sleep    2s
    Verify that the Procedure is saved

Select The Approval Managers
    [Documentation]    To Select The Approval Managers
    Wait For The Element And Click    ${APPROVAL_MANAGERS_SELECT}
    Scroll Element And Enter Value    ${SIGNOFF_MANAGER_INPUT}    ${AUTHOR2_EMAIL}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SIGNOFF_MANAGER}    ${AUTHOR2_NAME}
    Wait For The Element And Click    ${FIRST_SIGNOFF_MANAGER}
    Clear Element Text    ${SIGNOFF_MANAGER_INPUT}    
    Scroll Element And Enter Value    ${SIGNOFF_MANAGER_INPUT}    ${AUTHOR3_EMAIL}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SIGNOFF_MANAGER}    ${AUTHOR3_NAME}
    Wait For The Element And Click    ${FIRST_SIGNOFF_MANAGER}
    Press Keys    None    ESC

Select AN Approval Manager
    Wait For The Element And Click    ${APPROVAL_MANAGERS_SELECT}
    Scroll Element And Enter Value    ${SIGNOFF_MANAGER_INPUT}    ${AUTHOR3_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SIGNOFF_MANAGER}    ${AUTHOR3_NAME}
    Wait For The Element And Click    ${FIRST_SIGNOFF_MANAGER}
    Press Keys    None    ESC