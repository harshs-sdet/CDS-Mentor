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
Variables   ../../../../../locators/ui/web/Mentor/ChangeLogs.yaml
Variables   ../../../../../locators/ui/web/Mentor/BOM_BOT.yaml
Variables   ../../../../../locators/ui/web/Mentor/ProcedureApproval.yaml 
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Resource    ../Common/Common.resource

*** Keywords ***
Navigate to Change Log page
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_change_log_option_VISIBLE}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${change_log_option}    5s
    IF    '${IF_change_log_option_VISIBLE}'=='True'
        Wait Until Element Is Visible    ${change_log_option}    ${Max_limit}
        Click Element    ${change_log_option}
    ELSE
        Wait Until Element Is Visible    ${ADMINISTRATION_OPTION}    ${Max_limit}
        Click Element    ${ADMINISTRATION_OPTION}
        Wait Until Element Is Visible    ${change_log_option}    ${Max_limit}
        Click Element    ${change_log_option}
    END
    wait for the page to load

Verify That Restore Button Is Not Visible
    [Documentation]    To Verify That Restore Button Is Not Visible
    Page Should Not Contain Element    ${change_logs_restore}

Click On Preview
    [Documentation]    To Click On Preview
    Wait For The Element And Click    ${Click On Preview}
    Wait For The Page To Load


Verify the UI of Change Log Page    
    Wait Until Element Is Visible    ${search_bar_field}
    Wait Until Element Is Visible    ${Procedure_Name_heading}
    Wait Until Element Is Visible    ${procedure_approval_heading}
    Wait Until Element Is Visible    ${change_logs_time}
    Wait Until Element Is Visible    ${change_logs_version}
    Wait Until Element Is Visible    ${change_logs_activity}
    Wait Until Element Is Visible    ${change_logs_author}

Get Current Date in Specific Format For Change Logs
    ${current_date} =    Get Current Date
    ${formatted_date} =    Convert Date    ${current_date}    result_format=%b %d, %Y
    RETURN    ${formatted_date}    

Verify the UI of Procedure Change Log Page
    Wait Until ELement Is Visible    ${change_logs_heading}    timeout=10s    
    Wait Until ELement Is Visible    ${change_logs_preview_icon}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_user_contribution}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_procedure_details}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_export}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_restore}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_dateandtime}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_activity_column}    timeout=10s
    Wait Until ELement Is Visible    ${change_logs_user_name}    timeout=10s

Navigate to the first Change Logs Procedure
    wait for the page to load
    Sleep    3s
    Wait Until Element Is Visible    ${change_logs_first_procedure}    timeout=5s
    Click Element    ${change_logs_first_procedure}
    wait for the page to load

Verify Restore Button is Disabled
    Element Should Be Disabled    ${change_logs_restore}

Create Procedure For Change Logs
    [Documentation]    To Create Procedure Records
    [Arguments]    ${COUNT}=1    ${SIGNOFF}=REQUIRED
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    Run Keyword If    '${SIGNOFF}'=='REQUIRED'  Select AN Approval Manager
    Add The Cycle Time To The Procedure
    User Add Step To Procedure    1
    User Publishes The Procedure
    User Adds Release Notes
    Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    wait for the page to load
    Sleep    2s
    Approve a Procedure for change logs

Approve a Procedure for change logs
    Logout from Mentor
    AND Login To Application     ${AUTHOR3_EMAIL}     ${AUTHOR3_PASS}
    Navigate To Procedure Approvals Page
    And Search For Recently Created Procedure
    Sleep    3s
    And Navigate to the First Procedure
    Sleep    3s
    Wait Until Element Is Visible    ${approve_procedure}    timeout=10s
    Click Element    ${approve_procedure}
    Wait Until Element Is Visible    ${confirm_button}    timeout=10s
    Click Element    ${confirm_button}
    wait for the page to load
    AND Logout from Mentor
    AND Login To Application     ${AUTHOR1_EMAIL}     ${AUTHOR1_PASS}

Click the Preview Button   
    wait for the page to load 
    Wait Until Element Is Visible    ${change_logs_preview_icon}    timeout=5s
    Click Element    ${change_logs_preview_icon}
    wait for the page to load
    

Navigate to Change Log Preview Page
    Wait Until Element Is Visible    ${preview_button_change_log}
    Click Element    ${preview_button_change_log}

Change Version using Dropdown
    Wait Until Element Is Visible    ${change_version_dropdown}    timeout=10s
    Click Element    ${change_version_dropdown}
    Wait Until Element Is Visible    ${second_version_option}    timeout=10s
    Click Element    ${second_version_option}
    wait for the page to load


Export the Change Logs
    Wait Until Element Is Visible    ${change_logs_export}    timeout=5s
    Click Element    ${change_logs_export}    
    Sleep    5s    


Append Release Number
   [Documentation]    Appends the release type to a global list variable.
   ${status}    ${value}=    Run Keyword And Ignore Error    Get Variable Value    ${RELEASE_NUMBERS}
   IF    $status == 'FAIL' or $value is None
       Log    RELEASE_NUMBERS not found. Initializing it.
       Set Test Variable    @{RELEASE_NUMBERS}    ${EMPTY}
   END
   Append To List    ${RELEASE_NUMBERS}    ${TD_VERSION}
   Log    RELEASE_NUMBERS updated: ${RELEASE_NUMBERS}


Compare Release Numbers With Versions
   [Documentation]    Compare @{RELEASE_NUMBERS} with versions shown in the version dropdown.
   Wait Until Element Is Visible    ${change_version_dropdown}    timeout=10s
   ${options}=    Get WebElements    xpath=${all_version_options_dropdown}
   ${available_versions}=    Create List
   FOR    ${opt}    IN    @{options}
       ${text}=    Get Text    ${opt}
       ${text}=    Strip String    ${text}
       Run Keyword If    '${text}' != ''    Append To List    ${available_versions}    ${text}
   END
   Log   Available versions: ${available_versions}
   FOR    ${release}    IN    @{RELEASE_NUMBERS}
       ${release}=    Convert To String    ${release}
       ${release}=    Strip String    ${release}
       IF    '${release}' == '' or '${release}' == '${None}'
           Log    Skipping empty release entry
           CONTINUE
       END
       Run Keyword And Continue On Failure    List Should Contain Value    ${available_versions}    Ver ${release}
   END

Verify Release Numbers Are Present
   [Documentation]    Verify that each release number in @{RELEASE_NUMBERS} appears in the UI.
   FOR    ${release}    IN    @{RELEASE_NUMBERS}
       ${release}=    Convert To String    ${release}
       ${release}=    Strip String    ${release}
       IF    '${release}' == '' or '${release}' == '${None}'
           CONTINUE
       END
       ${xpath}=    Replace String   ${left_panel_version_numbers}  xy    ${release}
       ${exists}=    Run Keyword And Return Status    Element Should Be Visible    ${xpath}
   END

Navigate to Show Detailed View Tab and Verify Tabs
    Wait Until Element Is Visible    ${preview_back_button}    timeout=5s
    Click Element    ${preview_back_button}
    wait for the page to load
    Wait Until Element Is Visible    ${change_logs_show_detailed_view}    timeout=5s
    Click Element    ${change_logs_show_detailed_view}
    wait for the page to load
    Wait Until Element Is Visible    ${show_detailed_view_content}    timeout=5s
    Wait Until Element Is Visible    ${show_detailed_view_activities}    timeout=5s
    Click Element    ${show_detailed_view_activities}

Verify Activity Column Texts
   [Documentation]    Verify that specific texts exist in the activity column.
   ${activity_cells_xpath}=    Set Variable    ${activity_column_cells}
   ${activity_cells}=    Get WebElements    xpath=${activity_cells_xpath}
   ${texts_found}=    Create List
   FOR    ${cell}    IN    @{activity_cells}
       ${text}=    Get Text    ${cell}
       ${text}=    Strip String    ${text}
       Run Keyword If    '${text}' != ''    Append To List    ${texts_found}    ${text}
   END
   Log    Activity column contains: ${texts_found}
   ${expected_texts}=    Create List    Steps Edited    Version Created
   FOR    ${expected}    IN    @{expected_texts}
       Run Keyword And Continue On Failure    List Should Contain Value    ${texts_found}    ${expected}
   END    

Verify User Contributions In Change Logs
    Wait Until Element Is Visible    ${change_logs_user_contribution}    timeout=5s
    Click Element    ${change_logs_user_contribution}
    ${contributors}=    Get WebElements    xpath=${change_logs_contributor_name}
   ${visible_names}=    Create List
   FOR    ${contributor}    IN    @{contributors}
       ${name}=    Get Text    ${contributor}
       ${name}=    Strip String    ${name}
       Run Keyword If    '${name}' != ''    Append To List    ${visible_names}    ${name}
   END
   Run Keyword And Continue On Failure    List Should Contain Value    ${visible_names}    ${AUTHOR1_NAME}
   Run Keyword And Continue On Failure    List Should Contain Value    ${visible_names}    ${AUTHOR2_NAME}

Navigate To Procedures List Page from changeLogs page
    [Documentation]    To Navigate To Procedures List Page from chnage Logs Page
    wait for the page to load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_procedure_option_VISIBLE}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${PROCEDURE_LIBRARY_OPTION}    5s
    IF    '${IF_procedure_option_VISIBLE}'=='True'
        Wait Until Element Is Visible    ${PROCEDURE_LIBRARY_OPTION}    ${Max_limit}
        Click Element    ${PROCEDURE_LIBRARY_OPTION}
    ELSE
        Wait Until Element Is Visible    ${DASHBOARD_OPTION}    ${Max_limit}
        Click Element    ${DASHBOARD_OPTION}
        Wait Until Element Is Visible    ${PROCEDURE_LIBRARY_OPTION}    ${Max_limit}
        Click Element    ${PROCEDURE_LIBRARY_OPTION}
    END      
    wait for the page to load

Complete the details of a Procedure for Change Logs    
    Search For A Particular Procedure    0
    And Navigate to the First Procedure    
    And Click On Edit Button On Procedure Details Page
    User adds PPE to the procedure
    User Add Step To Procedure    5
    Click On The Step    2
    User adds Image attachments to the procedure
    User adds Video attachments to the procedure
    User adds PDF attachments to the procedure
    Sleep    3s
    Verify that user is able to see icons of attachments
    Click On The Step    3
    User adds Preventive Troubleshooting to Step
    Click On The Step    4
    User Adds User Input to Step
    User Is Able To Save And Preview The User Input
    User add Options to Step
    Add Parts&Tools To Step   BOM
    Sleep    2s
    Add Parts&Tools To Step   BOT
    Sleep    2s
    Add COM To Step
    User Publishes The Procedure    True
    User Adds Release Notes

Verify the Existence In Detailed View Page 
    Press Keys    //body    ESC
    Wait Until Element Is Visible    ${preview_back_button}    ${Max_limit}
    Click Element    ${preview_back_button}
    Sleep    5s
    wait for the page to load
    Wait Until Element Is Visible    ${change_logs_show_detailed_view}    ${Max_limit}
    Click Element    ${change_logs_show_detailed_view}
    wait for the page to load
    Sleep    5s
    Wait Until Element Is Visible    ${preview_details_bom}           ${Max_limit}
    Wait Until Element Is Visible    ${preview_details_bot}           ${Max_limit}
    Wait Until Element Is Visible    ${preview_details_options}       ${Max_limit}
    Wait Until Element Is Visible    ${preview_details_preventive}    ${Max_limit}
    Wait Until Element Is Visible    ${preview_details_image}         ${Max_limit}
    Wait Until Element Is Visible    ${preview_details_video}         10s
    Wait Until Element Is Visible    ${preview_details_general}       10s
    Wait Until Element Is Visible    ${preview_details_ppe}           10s
    Wait Until Element Is Visible    ${preview_details_com}           10s
    Wait Until Element Is Visible    ${preview_details_pdf}           10s
    Wait Until Element Is Visible    ${preview_details_user_input}    10s  

Change Version to latest version using Dropdown
    Wait Until Element Is Visible    ${change_version_dropdown}    timeout=10s
    Click Element    ${change_version_dropdown}
    Wait Until Element Is Visible    ${first_version_option}    timeout=10s
    Click Element    ${first_version_option}
    wait for the page to load
    Verify headers of the preview page

Update the details of a Procedure for Change Logs    
#    Navigate to Procedures page
    And Search For A Particular Procedure    0
    And Navigate to the First Procedure    
    And Click On Edit Button On Procedure Details Page
    And User Add Step To Procedure
    And User Publishes the Updated Procedure    True
    And User Adds Release Notes    

Restore the procedure to previous version
    Navigate to Change Log Preview Page
    Change Version using Dropdown
    Wait Until Element Is Visible    ${change_logs_restore}
    Element Should Be Enabled    ${change_logs_restore}
    Click Element    ${change_logs_restore}
    Wait Until Element Is Visible    ${change_logs_restore_confirm}
    Click Element    ${change_logs_restore_confirm}
    Wait Until Element Is Visible    ${preview_back_button}
    Click Element    ${preview_back_button}

Restore the procedure to latest version
    Navigate to Change Log Preview Page
    Change Version to latest version using Dropdown
    Wait Until Element Is Visible    ${change_logs_restore}
    Element Should Be Enabled    ${change_logs_restore}
    Click Element    ${change_logs_restore}
    Wait Until Element Is Visible    ${change_logs_restore_confirm}
    Click Element    ${change_logs_restore_confirm}
    Wait Until Element Is Visible    ${preview_back_button}
    Click Element    ${preview_back_button}

Cancel the restore procedure
    Navigate to Change Log Preview Page
    Change Version using Dropdown
    Wait Until Element Is Visible    ${change_logs_restore}
    Element Should Be Enabled    ${change_logs_restore}
    Click Element    ${change_logs_restore}
    Wait Until Element Is Visible    ${change_logs_restore_cancel}
    Click Element    ${change_logs_restore_cancel}
    Wait Until Element Is Visible    ${preview_back_button}
    Click Element    ${preview_back_button}


Get Current Version
    ${versions}=    Get WebElements    ${VERSION_LOCATOR}
    FOR    ${ver}    IN    @{versions}
        ${text}=    Get Text    ${ver}
        Run Keyword If    '(Current)' in '${text}'    Return From Keyword    ${text}
    END
    Fail    No version marked as (Current)

Verify Current Version
    [Arguments]    ${expected_version}
    ${current_version}=    Get Current Version
    Should Contain    ${current_version}    ${expected_version}


Verify the restore procedure for different versions
    wait for the page to load
    Verify Current Version    ${updated_version_in_string}
    Restore the procedure to previous version
    wait for the page to load
    Verify Current Version    ${original_version_in_string}

Verify the cancel button in restore
    wait for the page to load
    Verify Current Version    ${updated_version_in_string}
    Cancel the restore procedure
    wait for the page to load
    Verify Current Version    ${updated_version_in_string}

Close the preview screen
    wait for the page to load
    Navigate to Change Log Preview Page
    wait for the page to load
    Wait Until Element Is Visible    ${preview_close_button}    timeout=10s
    Click Element    ${preview_close_button}

Verify headers of the preview page
    ${text}=    Get Text    ${preview_header_message}
    Should Be Equal    ${text}    This is the preview of an old version.
    Element Should Be Visible    ${preview_close_button}
    Element Should Be Enabled    ${preview_close_button}
    Element Should Be Visible    ${change_version_dropdown}

Verify the procedure version and contents for restored version
    [Arguments]    ${expected_version}    ${steps_count}
    Search For A Particular Procedure    0
    ${type}=    Get Text    ${FIRST_PROCEDURE_VERSION}
    Should Contain    ${type}    ${expected_version}
    Navigate to the First Procedure
    wait for the page to load
    Validate The Correct Steps Count (Change Logs)    ${steps_count}

Validate The Correct Steps Count (Change Logs)
    [Arguments]    ${steps_count}
    [Documentation]    To Validate The Correct Steps Count
    ${STEPS_COUNT}=    Get Text    ${STEPS_IN_PROCEDURES_PREVIEW}
    Check The Strings Are Equal    ${STEPS_COUNT}    ${steps_count}

Set details of initial version procedure details
    ${original_version}=    Set Variable    ${TD_VERSION}
    ${original_version_in_string}=    Convert To String    ${original_version}
    ${steps_count}=    Get Length    ${STEP_INSTRUCTIONS_LIST}
    ${steps_count_in_string}=    Convert To String    ${steps_count}
    Set Test Variable    ${original_version_in_string}
    Set Test Variable    ${steps_count_in_string}

Set details of initial latest procedure details
    ${updated_version}=    Set Variable    ${TD_VERSION}
    ${updated_version_in_string}=    Convert To String    ${updated_version}
    ${updated_steps_count}=    Get Length    ${STEP_INSTRUCTIONS_LIST}
    ${updated_steps_count_in_string}=    Convert To String    ${updated_steps_count}    
    Set Test Variable    ${updated_version_in_string}
    Set Test Variable    ${updated_steps_count_in_string}
