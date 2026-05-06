*** Settings ***
Library    SeleniumLibrary
Library     String
Library    Collections
#Library     FakerLibrary
#Library     RandomLibrary
Library    OperatingSystem
Library    BuiltIn
Library    csvLibrary
Library    RequestsLibrary
Library    DateTime
Library   ../../../../../../src/utilities/Common-utils/csvLibrary.py
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
#Library   ../../../../../../src/ui/opcoUtils.py
Resource    ../Procedure/AuthorScreen.resource
Resource    ../Login/Login.resource
Variables   ../../../../../locators/ui/web/Mentor/AuthorScreen.yaml
Variables   ../../../../../locators/ui/web/Mentor/Common.yaml
Variables   ../../../../../locators/ui/web/Mentor/ApprovalSignOff.yaml
Variables   ../../../../../../config/Mentor/${env}_env.yaml

*** Variables ***
${csv_Path}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}ApplicationTestData${/}
${Report_path}     ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}
${Output_xml}     ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}Automation-Report.html
${TD_INVALID_EMAIL_ID}     hgigyfytikvyt@wrong.c

*** Keywords ***
Teardown For Procedure Library
    ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${Add_btn}    ${maxTime}
    IF    ${status} == True
        RETURN
        
    ELSE
        Run Keywords   Press Keys    None    ESC
    ...     AND            Click on breadcrumb link

    END

The User Login With Valid Credentials
    Login Resource  ParameterisedLogin

Get Test Data
    [Arguments]     ${testcase_ID}
    Get Test data For Execution      ${testcase_ID}
    Set Test Variable    ${testcase_ID}

Get Test data For Execution
    [Documentation]  To Get Test data For Execution.
    [Arguments]     ${page_scenario_key}
    #Read values from csv    ${csv_filePath}
    GetTestSuiteData   ${testSuite}     ${page_scenario_key}

GetTDVars
    [Documentation]  To Get TD Variables.
    [Arguments]     ${csv_filePath}     ${page_scenario_key}
    Read values from csv Application wise data      ${csv_filePath}
    ${td_var_row_dict}    GetTDVarRow    ${testdata_df}      ${page_scenario_key}
    ${td_var_row_dict}     Convert To Dictionary    ${td_var_row_dict}
    FOR   ${key}   IN   @{td_var_row_dict.keys()}
          ${value}=    Get From Dictionary    ${td_var_row_dict}    ${key}
          log   ${key} => ${value}
          ${value} =  Convert To String   ${value}
          ${tdvar}      Verify Runtime Var      ${value}
          IF       "${tdvar}"!="False"
                 Set Test Variable    ${${key}}     ${${tdvar}}
          ELSE
                 Set Test Variable    ${${key}}     ${value}
          END
    END

GetTDVarsDict
    [Documentation]  To Get TDVars Dictionary.
    [Arguments]     ${csv_filePath}     ${key}   ${page_scenario_key}
    Read values from csv Application wise data      ${csv_filePath}
    ${key_list}  Split String    ${page_scenario_key}  ,
    log  ${key_list}
    ${key_dict}    GetTDVarRowAsDict   ${testdata_df}    ${key_list}
    log  ${key_dict}
    Set Test Variable    ${${key}List}     ${key_list}
    Set Test Variable    ${${key}Dict}     ${key_dict}
    Set To Dictionary    ${TestSuiteDict}   ${key}Dict  ${key_dict}

GetTestDataVariables
    [Documentation]  To Get Test Data Variables.
    [Arguments]     ${csv_filePath}     ${page_scenario_key}
    Read values from Csv Page Controls      ${csv_filePath}
    ${td_var_row_dict}    GetTDVarRow    ${testdata_df}      ${page_scenario_key}
    ${td_var_row_dict}      Convert To Dictionary    ${td_var_row_dict}
    log  ${td_var_row_dict}
    FOR   ${key}   IN   @{td_var_row_dict.keys()}
          ${value}=    Get From Dictionary    ${td_var_row_dict}    ${key}
          log   ${key} => ${value}
          ${value} =  Convert To String   ${value}
          ${tdvar}      Verify Runtime Var      ${value}
          IF       "${tdvar}"!="False"
                 Set Test Variable    ${${key}}     ${${tdvar}}
          ELSE
                 Set Test Variable    ${${key}}     ${value}
          END
    END

GetTestSuiteData
    [Documentation]  To Get Test Suite Data
    [Arguments]     ${csv_filePath}     ${page_scenario_key}
    Read values from csv     ${csv_filePath}
    ${TestSuiteDict}  Create Dictionary
    Set Test Variable    ${TestSuiteDict}
    ${td_var_row_dict}    GetTDVarRow    ${testdata_df}      ${page_scenario_key}
    ${td_var_row_dict}      Convert To Dictionary       ${td_var_row_dict}
    FOR   ${key}   IN   @{td_var_row_dict.keys()}
          ${value}=    Get From Dictionary    ${td_var_row_dict}    ${key}
          log   ${key} => ${value}
          #${testdata_df} =  Check if TestcaseId is Unique    ${td_var_row_dict}
          ${csvfile}   Catenate    SEPARATOR=   ${csv_Path}     ${key}.csv
          Run Keyword And Ignore Error      GetTDVars    ${csvfile}   ${value}
          Run Keyword And Ignore Error      GetTDVarsDict    ${csvfile}   ${key}  ${value}
          ${value} =  Convert To String   ${value}
          ${tdvar}      Verify Runtime Var      ${value}
          IF       "${tdvar}"!="False"
                 Set Test Variable    ${${key}}     ${${tdvar}}
          ELSE
                 Set Test Variable    ${${key}}     ${value}
          END
    END

Read values from csv Application wise data
    [Documentation]  To Extract Data from CSV sheet
    [Arguments]  ${FilePath}
    ${testdata_df} =  Read Csv ID    ${FilePath}
    Set Test Variable    ${testdata_df}

Read values from Csv Page Controls
    [Documentation]   To Extract Data from CSV sheet
    [Arguments]  ${FilePath}
    ${testdata_df} =  Read Csv ScenarioName    ${FilePath}
    Set Test Variable    ${testdata_df}

Read values
  [Arguments]  ${FilePath}
  ${Data} =  Get User Credentials  ${FilePath}
  Set Test Variable   ${username}     ${Data}[0]
  Set Test Variable    ${password}    ${Data}[1]



Read values from csv
    [Documentation]  To Read values from csv.
    [Arguments]  ${FilePath}
    ${testdata_df} =  Read Csv TestID    ${FilePath}
    Set Test Variable    ${testdata_df}
    

Wait For The Element And Click
    [Documentation]  To Wait For The Element And Click
    [Arguments]    ${locator}    
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${locator}    ${Max_limit}
    Wait Until Keyword Succeeds     10x     2s      Click Element    ${locator}


Scroll Element And Enter Value
    [Documentation]  To Scroll Element And Enter Value
    [Arguments]    ${locator}    ${value}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${locator}    ${Max_limit}
    Scroll Element Into View    ${locator}
    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    5x    1s    Input Text    ${locator}    ${value}    clear=True
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}


wait for the page to load
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LoadingBar}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    120s
#    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
#    Wait Until Page Does Not Contain Element     ${LoadingBar}    ${Max_limit}


Scroll and Click
    [Documentation]     To scroll completely down to the required element and click on the element
    [Arguments]     ${locator}
    Scroll Element Into View    ${locator}
    Click Element    ${locator}

Retry Until Element Clickable
    [Arguments]  ${locator}
    Wait Until Element Is Visible  ${locator}   ${Max_limit}
    ${status}=  Run Keyword And Return Status  Click Element  ${locator}
    FOR    ${i}    IN RANGE    5
        ${status}=    Run Keyword And Return Status    Click Element  ${locator}
        Exit For Loop If    ${status}
    END

Verify The Pagination
    [Documentation]    To Verify Pagination
    ...    This keyword is failing due to the bug, list pages are not currently scrollable
    [Arguments]    ${PARTICULAR_PAGE_SIZE}=False
    Select The Page Size    PARTICULAR_PAGE_SIZE=${PARTICULAR_PAGE_SIZE}
    ${count}=   Get Current Record Count On Page
    IF    ${count} < ${PAGE_SIZE}
        Element Should Be Disabled    ${PAGINATION_NEXT_PAGE}
    ELSE
         ${NO_OF_PAGES}=    Evaluate     math.ceil(${count} / int(${PAGE_SIZE}))    math
        FOR    ${i}    IN RANGE    1    ${NO_OF_PAGES}+1
            Exit For Loop If    ${i}==${NO_OF_PAGES}
            Wait Until Element Is Enabled    ${PAGINATION_NEXT_PAGE}    ${Max_limit}
            Click Element       ${PAGINATION_NEXT_PAGE}
            Wait For The Page To Load
        END
        Element Should Be Disabled    ${PAGINATION_NEXT_PAGE}
    END

Click Element By JS
    [Arguments]    ${xpath}
    ${js}=    Catenate
    ...    let xpath = "${xpath}";
    ...    let el = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    ...    if (el) el.click();
    Execute Javascript    ${js}

Select The Page Size
    [Documentation]    To Select The Page Size
    [Arguments]    ${PAGE_SELECT_LOCATOR}=False    ${PARTICULAR_PAGE_SIZE}=False
#    Wait Until Keyword Succeeds    3x    1s    Click Element    ${PAGE_SIZE_DROPDOWN}
    IF    "${PAGE_SELECT_LOCATOR}"!="False"
        Wait Until Keyword Succeeds    5x    1s    Click Element By JS    ${PAGE_SELECT_LOCATOR}
    ELSE
       Execute Javascript    document.evaluate("(//div[contains(@class,'mat-mdc-paginator-touch-target')])", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    IF    ${PARTICULAR_PAGE_SIZE}
        ${index}=    Set Variable    3
    ELSE    
        ${index}=    Generate Random Number Between Range As String    1    4
    END    
    ${locator}=    Replace String    ${SELECT_PAGE_SIZE}    INDEX    ${index}
    ${PAGE_SIZE}=    Get Text    ${locator}
    ${PAGE_SIZE}=    Strip The String    ${PAGE_SIZE}
    Set Test Variable   ${PAGE_SIZE}
    Wait For The Element And Click    ${locator}

Set Page Zoom Level
    [Arguments]    ${scale}
#    Execute Javascript    document.body.style.transform = "scale(${scale})";
#    Execute Javascript    document.body.style.transformOrigin = "0 0";
    Repeat Keyword    2x    Press Keys    None    CTRL+-

Get Current Record Count On Page
    [Documentation]    To Get Current Record Count On Page
    ...    Zoom in should be removed once the bug is Fixed
    Log To Console    Zoom in should be removed once the bug is Fixed
    [Arguments]    ${LOCATOR}=False
    IF    '${LOCATOR}'!='False'
        Wait Until Element Is Visible    ${LOCATOR}    ${Max_limit}
        ${count}=    Get Text    ${LOCATOR}
    ELSE
        Wait For The Page To Load
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${RECORD_COUNT}    ${Max_limit}
        ${count}=    Get Text    ${RECORD_COUNT}
    END
    ${count}=    Split String    ${count}    of
    ${count}=    Strip String    ${count}[1]
    RETURN    ${count}


Get Record Count In Pop-up Window
    [Documentation]    To Get Record Count In Pop-up Window
    [Arguments]    ${POP_UP_WINDOW_RECORDS_COUNT_LOCATOR}
    Wait Until Element Is Visible    ${POP_UP_WINDOW_RECORDS_COUNT_LOCATOR}    ${Max_limit}
    ${count}=    Get Text    ${POP_UP_WINDOW_RECORDS_COUNT_LOCATOR}
    ${count}=    Split String    ${count}    of
    ${count}=    Strip String    ${count}[1]
    RETURN    ${count}

Verify User Is Able To Navigate To Home Page
    [Documentation]    To Verify User Is Able To Navigate To Home Page
    ${status}=   Run Keyword And Return Status       Wait Until Keyword Succeeds    5x    2s    Location Should Be    ${Url}/procedure
    IF  ${status} == False
        Location Should Be    ${Url}/users
    END


Save The Records Count Before Actions On Page
    [Documentation]    To Save The Records Count Before Actions On Page
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible   ${ZERO_RECORDS}    ${Max_limit}
    ${PREV_RECORD_COUNT}=   Get Current Record Count On Page
    Set Test Variable    ${PREV_RECORD_COUNT}


Verify The Records Count Is Changed By
    [Arguments]    ${CHANGE_FACTOR}=0
    [Documentation]    To Verify The Records Count Is Changed By given argument
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LoadingBar}   ${MaxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}  #Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}
    Wait For The Page To Load
    ${CURRENT_COUNT}=   Get Current Record Count On Page
    Check The Count Is Changed    ${PREV_RECORD_COUNT}   ${CURRENT_COUNT}    ${CHANGE_FACTOR}



Get Values In List For Validation
    [Documentation]    Get Values In List For Validation
    [Arguments]    ${elements_locator}    ${start_index}    ${end_index}=False
    ${start_index}=    Evaluate    int(${start_index})
    ${end_index}=    Evaluate    int(${end_index})+1
    @{return_list}=    Create List
    FOR    ${i}    IN RANGE    ${start_index}    ${end_index}
        ${i}=    Evaluate    str(${i})
        ${locator}=    Replace String    ${elements_locator}  INDEX    ${i}
        ${text}=    Wait Until Keyword Succeeds    3x    1s    Get Text    ${locator}
        ${status}=     Check If Not Empty    ${text}
        IF    '${status}'=='True'
            ${text}=    Strip String    ${text}
            ${text}=    Remove Trailing Dots    ${text}
            Append To List    ${return_list}    ${text}
        END
    END
    RETURN    ${return_list}

Validate The Extracted List Data
    [Documentation]    To Validate The Extracted List Data
    #VALIDATION_VALUE is Scaler type only
    [Arguments]    ${INPUT_LIST}    ${VALIDATION_VALUE}
    FOR    ${ELE}    IN    @{INPUT_LIST}
        Should Contain    ${VALIDATION_VALUE}    ${ELE}
    END



Get Text Should Not Be Empty
    [Arguments]    ${locator}
    ${text}=    Get Text    ${locator}
    Should Not Be Equal As Strings    ${text}    None

Select The Multiple Records
    [Documentation]    To Select The Multiple Records
    [Arguments]    ${END_RECORD}=5
#    Capture Page Screenshot
    ${END_RECORD_COUNT}=  Get Element Count   (//input[@type="checkbox"])
    IF  ${END_RECORD_COUNT} < ${END_RECORD}
        ${END_RECORD}=      Set Variable     ${END_RECORD_COUNT}
    END
#    ${END_RECORD}=  Evaluate    ${END_RECORD}-1
    FOR    ${i}    IN RANGE    2    ${END_RECORD}
        ${i}=    Evaluate    str(${i})
        ${locator}=    Replace String    ${SELECT_MULTIPLE_RECORD}    INDEX    ${i}
        Scroll Element Into View    ${locator}
        Scroll And Click    ${locator}
    END

    # Deselect one record
    Run Keyword And Ignore Error    Scroll And Click    ${locator}

Cancel the Delete Process
    Wait Until Element Is Visible    ${SELECTED_RECORD}    ${Max_limit}
    Wait For The Element And Click    ${DELETE_MULTIPLE_RECORD}

Delete Selected Records
    [Documentation]    To Delete Selected Records
    [Arguments]    ${VALIDATE_UI_KEYWORD}=False
#    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SELECTED_RECORD}    ${Max_limit}
    Wait For The Element And Click    ${DELETE_MULTIPLE_RECORD}
    Run Keyword If    '${VALIDATE_UI_KEYWORD}'!='False'    ${VALIDATE_UI_KEYWORD}
    Wait For The Element And Click    ${DELETE_MULTIPLE_POPUP}
    Wait For The Page To Load


Click On Previous Button
    [Documentation]    To Click On Previous Button
    Wait For The Element And Click    ${PREVIOUS_BUTTON}

Navigate To Workspace Page
    [Documentation]    To Navigate To Workspace Page
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Wait For The Element And Click    ${LEFT_NAV_WORKSPACE_TAB}
    Wait Until Element Is Visible    ${WORKS_MAGANEMENT_HEADER}

Click On The Dashboard In Left Navigation
    [Documentation]    To Click On The Dashboard In Left Navigation
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${DASHBOARD_LINK}

Enter Invalid Email
    [Documentation]    To Enter Invalid Email And Verify Error Message
    Scroll Element And Enter Value   ${INPUT_EMAIL}    ${TD_INVALID_EMAIL_ID}


Verify Invalid Error Message
    [Documentation]    To Verify Error Message
    Scroll Element Into View    ${INVALID_EMAIL_ENTERED}
    Page Should Contain Element    ${INVALID_EMAIL_ENTERED}    ${Max_limit}


Navigate To Users List Page
    [Documentation]    To Navigate To Users List Page
#    Wait For The Page To Load
#    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
#    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Mouse Over    ${DASHBOARD_LINK}
    ${if_users_tab_open}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${USERS_TAB}    15s
    ${if_user_management_tab_open}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${left_Navigation_user_management}    5s
    IF    '${if_users_tab_open}'=='True'
        Navigate Back To Users Page
    ELSE IF    '${if_user_management_tab_open}'=='True'
        Wait For The Element And Click    ${left_Navigation_user_management}
        Wait For The Element And Click    ${USERS_TAB}
        Wait For The Page To Load
    ELSE
        Wait For The Element And Click    ${ADMINISTRATION_LINK}
        Wait For The Element And Click    ${left_Navigation_user_management}
        Click Element    ${USERS_TAB}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}    ${Max_limit}
    Mouse Over    ${ADD_NEW_BUTTON}

Navigate Back To Users Page
    [Documentation]    To Navigate Back To Users Page
    Wait For The Element And Click    ${USERS_TAB}



Close The Pop-up Window
    [Documentation]    To Close The Pop-up Window
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${CLOSE_POPUP}


#Verify The User Is Not Able to Delete Default Record
#    [Documentation]    To Verify The User Is Not Able to Delete Default Workspace
#    Verify The Pagination
#    Mouse Over    ${PAGE_DOWN_ELEMENT}
#
#    ${CURRENT_PAGE_RECORDS}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
#    ${CURRENT_PAGE_RECORDS}=    Evaluate    ${CURRENT_PAGE_RECORDS}%${PAGE_SIZE}
#    FOR    ${i}    IN RANGE    ${CURRENT_PAGE_RECORDS}
#        Press Keys    ${PAGE_DOWN_ELEMENT}    ARROW_DOWN
#    END
#    ${CURRENT_PAGE_RECORDS}=    Evaluate    str(${CURRENT_PAGE_RECORDS})
#    ${LAST_RECORD}=    Replace String    ${DEFAULT_RECORD}    INDEX    ${CURRENT_PAGE_RECORDS}
#    Wait Until Page Contains Element    ${LAST_RECORD}
#
#    #Should not be visible
#    Element Should Not Be Visible    ${LAST_RECORD}
#    Scroll Element Into View    ${LAST_RECORD}
#    Click Element    ${LAST_RECORD}

Verify The User Is Not Able to Delete Default Record
    [Documentation]    To Verify The User Is Not Able to Delete Default Workspace
     ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${DELETE_ICON}    ${Max_limit}
     WHILE    '${status}'=='True'
         Wait For The Element And Click    ${DELETE_ICON}
         Wait For The Element And Click    ${DELETE_POPUP}
         Wait For The Page To Load
         ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${DELETE_ICON}    ${Max_limit}
     END
     Element Should Not Be Visible    ${DELETE_ICON}


Extract Values In List From All Pages
    [Documentation]    To Extract Values In List From All Pages
    [Arguments]    ${GIVEN_KEYWORD}    @{ARGS}
    @{RESULTANT_LIST}=    Create List
    Select The Page Size
    ${TOTAL_COUNT}=   Get Current Record Count On Page
#    ${END_INDEX}=    Evaluate    int(${PAGE_SIZE})+1
    ${LAST_PAGE_RECORDS}=    Evaluate    ${TOTAL_COUNT}%int(${PAGE_SIZE})
    IF    ${TOTAL_COUNT} < ${PAGE_SIZE}
        Element Should Be Disabled    ${PAGINATION_NEXT_PAGE}
        ${RESULTANT_LIST}=    Run Keyword    ${GIVEN_KEYWORD}    ${ARGS[0]}    ${ARGS[1]}    ${LAST_PAGE_RECORDS}
    ELSE
         ${NO_OF_PAGES}=    Evaluate     math.ceil(${TOTAL_COUNT} / int(${PAGE_SIZE}))    math
         @{TEMP_LIST}=    Create List
        FOR    ${i}    IN RANGE    1    ${NO_OF_PAGES}+1
            IF    ${i}!=${NO_OF_PAGES}
                ${TEMP_LIST}=    Run Keyword    ${GIVEN_KEYWORD}    ${ARGS[0]}    ${ARGS[1]}    ${PAGE_SIZE}
                Append To List    ${RESULTANT_LIST}    ${TEMP_LIST}
                Wait Until Element Is Enabled    ${PAGINATION_NEXT_PAGE}    ${Max_limit}
                Click Element       ${PAGINATION_NEXT_PAGE}
                Wait For The Page To Load
            ELSE
                ${TEMP_LIST}=    Run Keyword    ${GIVEN_KEYWORD}    ${ARGS[0]}    ${ARGS[1]}    ${LAST_PAGE_RECORDS}
                ${RESULTANT_LIST}    Combine Lists    ${TEMP_LIST}    ${RESULTANT_LIST}
                Exit For Loop If    ${i}==${NO_OF_PAGES}
            END
        END
        Element Should Be Disabled    ${PAGINATION_NEXT_PAGE}
    END
    RETURN    ${RESULTANT_LIST}

Get CSS Property
    [Arguments]    ${locator}    ${css_property}
    ${element}=    Get WebElement    ${locator}
    ${css_value}=    Wait Until Keyword Succeeds    3x    1s    Call Method    ${element}    value_of_css_property    ${css_property}
    RETURN    ${css_value}

Verify The Pagination On Custom Page
    [Documentation]    To Verify The Pagination On Custom Page
    [Arguments]    @{PAGINATION_ARGUMENTS}
    Select The Page Size    ${PAGINATION_ARGUMENTS[0]}
    ${count}=   Get Current Record Count On Page    ${PAGINATION_ARGUMENTS[1]}
    IF    ${count} < ${PAGE_SIZE}
        Element Should Be Disabled    ${PAGINATION_ARGUMENTS[2]}
    ELSE
         ${NO_OF_PAGES}=    Evaluate     math.ceil(${count} / int(${PAGE_SIZE}))    math
        FOR    ${i}    IN RANGE    1    ${NO_OF_PAGES}+1
            Exit For Loop If    ${i}==${NO_OF_PAGES}
            Wait Until Element Is Enabled    ${PAGINATION_ARGUMENTS[2]}    ${Max_limit}
            Click Element       ${PAGINATION_ARGUMENTS[2]}
            Wait For The Page To Load
        END
        Element Should Be Disabled    ${PAGINATION_ARGUMENTS[2]}
    END


Click On Filter Button
    [Documentation]    To Click On Filter Button
    Wait For The Element And Click   ${filter_button}


Apply The Filters
    [Documentation]    To Apply The Filters
    Scroll And Click     ${apply_filter}
    Wait For The Page To Load

Verify The Filters Are Applied
    [Documentation]    To   Verify The Filters Are Applied
    Wait Until Element Is Visible    ${APPLIED_FILTERS}    ${Max_limit}

Get The Filtered Record Results Shown
    [Documentation]    To Get The Filtered Record Results Shown
    [Arguments]    ${TARGET_FILTER_LOCATOR}    ${START_INDEX}=1
    ${RECORDS_COUNT}=    Get Current Record Count On Page
    ${RECORD_COUNT_WITH_FILTER}=    Set Variable    ${RECORDS_COUNT}
    Set Test Variable    ${RECORD_COUNT_WITH_FILTER}
    ${END_INDEX}=    Get Lower Bound    ${RECORDS_COUNT}
    ${FILTERED_RESULTS}=    Get Values In List For Validation    ${TARGET_FILTER_LOCATOR}    ${START_INDEX}    ${END_INDEX}
    RETURN    ${FILTERED_RESULTS}


Clear All Filters And Apply Changes
    [Documentation]    To Clear All Filters
    Wait For The Element And Click    ${filter_clear_all}
    Apply The Filters
    Wait For The Page To Load

Verify All The Filters Removed
    [Documentation]    To Verify All The Filters Removed
    Wait Until Element Is Not Visible    ${APPLIED_FILTERS}
    ${CURRENT_RECORD_COUNT}=    Get Current Record Count On Page
    Should Be True    ${CURRENT_RECORD_COUNT}>=${RECORD_COUNT_WITH_FILTER}

Select The Different Site
    [Documentation]    To Select The Different Site
    Wait For The Element And Click    ${DIFFERENT_SITE_DROPDOWN}
    ${locator}=    Replace String    ${DIFFERENT_SITE_OPTION}    SITE    ${TD_SITE_NAME}
    Wait For The Element And Click    ${locator}

Login With The Site Admin
    [Documentation]    To Login With The Site Admin
    Logout From Mentor
    Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Close The Custom popup
    [Documentation]    To Close The Custom popup
    Execute JavaScript
    ...    document.querySelectorAll('button, span, div').forEach(el => {
    ...        if (el.innerText.toLowerCase().includes('Block')) {
    ...            console.log('Trying to click:', el);
    ...            el.click();
    ...        }
    ...    });

Navigate To Approval Sign Off Page
    [Documentation]    To Navigate To Approval Sign Off Page
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${Approvals_view_more}    ${Max_limit}
    Click Element    ${Approvals_view_more}
    Wait Until Element Is Visible    ${Sign_off_procedures}    timeout=5s
    Click Element    ${Sign_off_procedures}
    wait for the page to load

Navigate To Procedure Approvals Page
    [Documentation]    To Navigate To Approval Sign Off Page
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Mouse Over    ${DASHBOARD_LINK}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${Approvals_view_more}    ${Max_limit}
    Click Element    ${Approvals_view_more}
    Wait Until Element Is Visible    ${Procedure_approvals}    timeout=5s
    Click Element    ${Procedure_approvals}
    wait for the page to load    


Delete One Record From List Page
    [Documentation]    To Delete One Record From List Page
    Wait Until Page Contains Element    ${DELETE_RECORD_ICON}
    Wait Until Element Is Enabled    ${DELETE_RECORD_ICON}
    Click Element By JS    ${DELETE_RECORD_ICON}
    Wait For The Element And Click    ${DELETE_RECORD_POPUP_BUTTON}
    Wait For The Page To Load

Empty The List Page
    [Documentation]    To Empty The List Page
    ...    This keyword is failing due to the bug, list pages are not currently scrollable
    ${COUNT}=    Get Current Record Count On Page
    Return From Keyword If    ${COUNT}<=12
    FOR    ${IT}    IN RANGE    ${COUNT}-8
        Wait Until Element Is Visible    ${DELETE_RECORD_ICON}
        Click Element By JS    ${DELETE_RECORD_ICON}
        Wait For The Element And Click    ${DELETE_RECORD_POPUP_BUTTON}
        Wait For The Page To Load
    END
    Wait Until Element Is Not Visible    ${ToasterMessage}    ${Max_limit}

Scroll Dialog Until Element Clickable
   [Arguments]    ${element_xpath}    ${dialog_xpath}=//mat-dialog-content[contains(@class,'mat-mdc-dialog-content')]    ${step}=200    ${max_scrolls}=30
   [Documentation]    Scrolls inside dialog until the given element becomes clickable, or fails after max scrolls.
   ${dialog}=    Get WebElement    ${dialog_xpath}
   FOR    ${index}    IN RANGE    ${max_scrolls}
       ${is_clickable}=    Run Keyword And Return Status       Element Should Be Clickable    ${element_xpath}
       IF    ${is_clickable}
           Log    Element became clickable after ${index} scrolls
           Exit For Loop
       END
       Execute Javascript    return arguments[0].scrollTop += ${step};    ARGUMENTS    ${dialog}
   END

Open Notification Panel
    [Documentation]    To Open Notification Panel
    Wait For The Element And Click    ${BELL_ICON_ON_LIST_PAGE}


Click On The Notification Received
    [Documentation]    To Click On The Notification Received
    [Arguments]    ${NOTIFICATION_INDEX}=1
    Open Notification Panel
    Wait For The Element And Click    (${FIRST_NOTIFICATION_CATEGORY})[${NOTIFICATION_INDEX}]
    Wait For The Page To Load

Close Notification Panel
    [Documentation]    To Close Notification Panel
    Wait For The Element And Click    ${NOTIFICATION_FLYOUT_CLOSE_BUTTON}

Expand The Notification Window
    [Documentation]    To Expand The Notification Window
    Open Notification Panel
    Wait For The Element And Click    ${NOTIFICATION_FLYOUT_EXPAND_BUTTON}
    Wait For The Page To Load

Verify The Notification Received
    [Documentation]    To Verify The Notification Received
    [Arguments]    ${NOTIFICATION_CONTEXT}    ${NOTIFICATION_INDEX}=1

    #Bug to be logged -notification not coming without hard refress
    Reload Page
    Wait For The Page To Load

    #logic
    Open Notification Panel
    @{NOTIFICATION_CONTEXT_LIST}=    Split String    ${NOTIFICATION_CONTEXT}    ,
    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    Log To Console    ${TODAY_DATE}

    Wait Until Element Is Visible    ${NOTIFICATION_FLYOUT_TITLE}    ${Max_limit}
    Wait Until Element Is Visible    ${FIRST_NOTIFICATION_TITLE_ICON}
    Wait Until Element Is Visible    ${FIRST_NOTIFICATION_SUB_TITLE_ICON}
    #Validate data
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${FIRST_NOTIFICATION_DATE})[${NOTIFICATION_INDEX}]    ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${FIRST_NOTIFICATION_TITLE_TEXT})[${NOTIFICATION_INDEX}]    ${NOTIFICATION_CONTEXT_LIST[0]}
    ${FIRST_NOTIFICATION_SUB_TITLE_TEXT}=    Replace String    ${FIRST_NOTIFICATION_SUB_TITLE_TEXT}    INDEX    ${NOTIFICATION_INDEX}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${FIRST_NOTIFICATION_SUB_TITLE_TEXT})   ${NOTIFICATION_CONTEXT_LIST[1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${FIRST_NOTIFICATION_CATEGORY})[${NOTIFICATION_INDEX}]    ${NOTIFICATION_CONTEXT_LIST[2]}

    Close Notification Panel


Generate Random Data For Plant Creation
    ${name}=            Name
    ${address1}=    Generate Random String    30    [LETTERS][NUMBERS]
#    ${address1}=        Street Address
    ${address2}=    Generate Random String    30    [LETTERS][NUMBERS]
#    ${address2}=        Secondary Address
    ${city}=            City
#    ${state}=           State
#    ${country}=         Country
    ${phone}=    Evaluate    str(__import__('random').randint(1000000000, 9999999999))
    ${postal_code}=    Generate Random String    6   [NUMBERS]
    ${email}=           Email
    ${random_data}=     Create Dictionary    name=${name}    address1=${address1}    address2=${address2}    city=${city}     postal_code=${postal_code}    phone=${phone}    email=${email}
    RETURN    ${random_data}