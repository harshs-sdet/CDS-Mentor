*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    OperatingSystem
Library    Collections
Library    String
Library    JSONLibrary
Library     ../../../../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../Login/Login.resource
Resource    ../Common/Common.resource
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/JobManagement.yaml

Variables    ../../../../../../testdata/ui/web/Mentor/testdata.yaml

*** Variables ***
${JOB_LIST_PAGE}    ${Url}/job

*** Keywords ***
Navigate to Job Management Page
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Wait Until Element Is Visible    ${JobMenu}    ${maxTime}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${JobMenu}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${JobHeading}    ${maxTime}
    Run Keyword And Ignore Error    Mouse Over    ${FPY_CHART_CARD}
    Run Keyword And Ignore Error    Mouse Over    ${AddJob}


Verify User Is On Job Management Page
    Element Should Be Visible    ${JobHeading}

Click On Add New Button
    [Arguments]    ${CHECK_AUTO_FOCUS}=False
    Wait Until Element Is Visible    ${AddJob}    ${maxTime}
    Wait Until Element Is Enabled    ${AddJob}    ${maxTime}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Double Click Element    ${AddJob}
    Wait For The Page To Load
    
    Wait Until Element Is Visible    ${INPUT_JOB_ID}
#    IF    '${CHECK_AUTO_FOCUS}'=='True'
#        Element Should Be Focused    (${INPUT_JOB_ID})[2]
#    END
    #Job listing page UI is distorted
    Set Page Zoom Level    1

User Is Able To Enter Serial Number
    Input Text    ${INPUT_JOB_ID}    SERNo-DUMMY



User Is Able To Enter Material Number
    Input Text    ${MaterialNo}    MATNo-DUMMY

Navigate To Enter Job Details
    Click Element    ${DoneButton}

Enter The Job Name
    Wait Until Element Is Visible    ${JobName}    ${maxTime}
    Input Text    ${JobName}    Job-DUMMY_NAME

Click On Next/Done Button
    Wait Until Element Is Visible    ${JobNext_Done}    ${maxTime}
    Click Element    ${JobNext_Done}


Click On Create Job Button
    [Documentation]    To Click On Create Job Button
    Wait Until Element Is Visible    ${btn_create}    ${maxTime}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${btn_create}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}


Add The Procedure To Job
    Click Element    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${Procedure_Search_Bar}    ${maxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element By JS    ${SelectProcedure}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Click On Add To Add Procedure

Click On Add To Add Procedure
    Click Element    ${AddProcedure}

Click On Change Button
    Click Element    ${changeBtn}

Verify User Navigates Back To First Screen of PopUp
    Element Should Not Be Visible    ${MaterialNumberField}

User Clicks On Cancel Button To End Job Creation Process
    Click Element    ${CANCEL_JOB_BUTTON_DETAILS_PAGE}

Verify That on Click Cancel, User Navigates Back to Job Listing Page
    Wait Until Element Is Visible    ${AddJob}    ${maxTime}

Search procedure in add procedure to job screen
    Click Element    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${Procedure_Search_Bar}    ${maxTime}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Click Element   ${Procedure_Search_Bar}
    Input Text   ${Procedure_Search_Bar}    Procedure-${UniqueNumbertest}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Click Element    ${SelectProcedure}

Click on Newly created job
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}    ${maxTime}
    Click Element    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}

Navigate to procedure tab and verify added procedure
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${txt_procedure}    ${maxTime}
    Click Element    ${txt_procedure}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    //td[contains(@class, 'cdk-column-name')]//span    ${maxTime}
    ${NameColumnText}=    Get Text    //td[contains(@class, 'cdk-column-name')]//span
    Log    ${NameColumnText}
    Should Contain    ${NameColumnText}    Procedure-${UniqueNumbertest}

Click On The Cancel Button On Welcome Screen
    [Documentation]    To Click On The Cancel Button On Welcome Screen
    Wait For The Element And Click    ${CANCEL_JOB_BUTTON_ON_WELCOME_SCREEN}

Click On Start Job On Job Details Page
    [Documentation]    To Click On Start Job On Job Details Page
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${START_BUTTON}    ${maxTime}
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${START_BUTTON}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}

Start Job execution
    Wait Until Element Is Visible    ${START_JOB_BUTTON_WELCOME_SCREEN}    ${maxTime}
    Click Element    ${START_JOB_BUTTON_WELCOME_SCREEN}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}

Complete Job/Training execution
    [Arguments]    ${SAVE_TAKEN_TIME}=True    ${SAVE_CYCLE_TIME}=False
    FOR    ${i}    IN RANGE    17
        ${dialog_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${FinishPopUp}
        Exit For Loop If    ${dialog_visible}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${Check}
    END

    IF    $SAVE_TAKEN_TIME
        Wait For The Element And Click    ${CLOSE_FINISH_POPUP}
        Wait Until Element Is Not Visible    ${CLOSE_FINISH_POPUP}
        ${TIME_TOOK}=    Get Text    ${JOB_TAKEN_TIME}
        Add Item To List     ITEM=${TIME_TOOK}   VAR_NAME=TAKEN_TIME_IN_EXECUTION
    END
    IF    $SAVE_CYCLE_TIME
        Wait For The Element And Click    ${JOB_EXECUTION_TIMER_CYCLE_TIME}
        Wait Until Element Is Not Visible    ${CLOSE_FINISH_POPUP}
        ${EXECUTION_COMPLETION_CYCLE_TIME}=    Get Text    ${JOB_EXECUTION_TIMER_CYCLE_TIME}
        Set Test Variable    ${EXECUTION_COMPLETION_CYCLE_TIME}
    END

    Wait For The Element And Click    ${FinishButton}
    Wait Until Element Is Visible    ${FinishPopUp}    10s
    Click Element                    ${FinishPopUp}
    Wait For The Page To Load


Finish The Job/Training
    [Documentation]    To Finish The Job/Training
    Run Keyword And Ignore Error    Wait For The Element And Click    ${FinishButton}
    Run Keyword And Ignore Error    Wait For The Element And Click    ${FinishPopUp}
    Wait For The Page To Load

Verify Job status after completion
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span    ${maxTime}
    ${NameColumnText}=    Get Text    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span
#    Wait Until Element Is Visible    ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span    ${maxTime}
#    ${NameColumnText}=    Get Text    ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span
    Log    ${NameColumnText}
    Should Contain    ${NameColumnText}    Completed

Verify That User Navigates Back To Serial Order Input Window Upon Clicking The 'Change' Hyperlink
    [Documentation]    To Verify That User Navigates Back To Serial Order Input Window Upon Clicking The 'Change' Hyperlink
    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Click Element    ${AddJob}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    ${TD_SERIAL_NUMBER}=    Generate Random String
    Set Test Variable    ${TD_SERIAL_NUMBER}
    Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    Wait For The Element And Click    ${CancelJob}

Click On Cancel Button On Job Order Page
    [Documentation]    To Click On Cancel Button On Job Order Page
    Wait For The Element And Click    ${DELETE_MULTIPLE_RECORD}
    Wait For The Element And Click    ${CancelJob}

Enter All Other Job Details
    [Documentation]    To Enter All Other Job Details

#    #Job Name
    ${TD_JOB_NAME}=    Generate Random String
    Set Test Variable    ${TD_JOB_NAME}
    Scroll Element And Enter Value    ${JOB_NAME_INPUT}    ${TD_JOB_NAME}
    #Product Plant
    ${TD_PRODUCT_PLANT}=    Generate Random String
    Set Test Variable    ${TD_PRODUCT_PLANT}
    Scroll Element And Enter Value    ${PRODUCT_PLANT_INPUT}    ${TD_PRODUCT_PLANT}

    #PO Number
    ${TD_PO_NUMBER}=    Generate Random String
    Set Test Variable    ${TD_PO_NUMBER}
    Scroll Element And Enter Value    ${PO_NUMBER_INPUT}    ${TD_PO_NUMBER}

    #Batch Number
    ${TD_BATCH_NUMBER}=    Generate Random String
    Set Test Variable    ${TD_BATCH_NUMBER}
    Scroll Element And Enter Value    ${BATCH_NUMBER_INPUT}    ${TD_BATCH_NUMBER}

    #Version
    ${TD_JOB_VERSION}=    Generate Random String
    Set Test Variable    ${TD_JOB_VERSION}
    Scroll Element And Enter Value    ${VERSION_JOB_INPUT}    ${TD_JOB_VERSION}

    #Sales Order Number
    ${TD_SALES_ORDER_NUMBER}=    Generate Random String
    Set Test Variable    ${TD_SALES_ORDER_NUMBER}
    Scroll Element And Enter Value    ${SALES_ORDER_NUMBER_INPUT}    ${TD_SALES_ORDER_NUMBER}

    #Order Type
    ${TD_ORDER_TYPE}=    Generate Random String
    Set Test Variable    ${TD_ORDER_TYPE}
    Scroll Element And Enter Value    ${ORDER_TYPE_INPUT}    ${TD_ORDER_TYPE}

    #MRP Controller
    ${TD_MRP_CONTROLLER}=    Generate Random String
    Set Test Variable    ${TD_MRP_CONTROLLER}
    Scroll Element And Enter Value    ${MRP_CONTROLLER_INPUT}    ${TD_MRP_CONTROLLER}

    #Storage Location
    ${TD_STORAGE_LOCATION}=    Generate Random String
    Set Test Variable    ${TD_STORAGE_LOCATION}
    Scroll Element And Enter Value    ${STORAGE_LOCATION_INPUT}    ${TD_STORAGE_LOCATION}

    #Quantity
#    ${TD_JOB_QUANTITY}=    Generate Random String
#    Set Test Variable    ${TD_JOB_QUANTITY}
#    Scroll Element And Enter Value    ${JOB_QUANTITY_INPUT}    ${TD_JOB_QUANTITY}
#    Capture Page Screenshot


Verify The Updated Job Details
    [Documentation]    To Verify The Updated Job Details

    #Job Name
    Element Attribute Value Should Be    ${JOB_NAME_INPUT}    value    ${TD_JOB_NAME}

    #Product Plant
    Element Attribute Value Should Be    ${PRODUCT_PLANT_INPUT}    value    ${TD_PRODUCT_PLANT}

    #PO Number
    Element Attribute Value Should Be    ${PO_NUMBER_INPUT}    value    ${TD_PO_NUMBER}

    #Batch Number
    Element Attribute Value Should Be    ${BATCH_NUMBER_INPUT}    value    ${TD_BATCH_NUMBER}

    #Version
    Element Attribute Value Should Be    ${VERSION_JOB_INPUT}    value    ${TD_JOB_VERSION}

    #Sales Order Number
    Element Attribute Value Should Be    ${SALES_ORDER_NUMBER_INPUT}    value    ${TD_SALES_ORDER_NUMBER}

    #Order Type
    Element Attribute Value Should Be    ${ORDER_TYPE_INPUT}    value    ${TD_ORDER_TYPE}

    #MRP Controller
    Element Attribute Value Should Be    ${MRP_CONTROLLER_INPUT}    value    ${TD_MRP_CONTROLLER}

    #Storage Location
    Element Attribute Value Should Be    ${STORAGE_LOCATION_INPUT}    value    ${TD_STORAGE_LOCATION}

    #Quantity
    Element Attribute Value Should Be    ${JOB_QUANTITY_INPUT}    value    ${TD_JOB_QUANTITY}


Create Sample Job With Mandatory Fields
    [Arguments]    ${CUSTOM_MATERIAL_NUMBER}=False    ${CUSTOM_SERIAL_NUMBER}=False
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${AddJob}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    IF    '${CUSTOM_SERIAL_NUMBER}'!='False'
        Input Text    ${INPUT_JOB_ID}    ${CUSTOM_SERIAL_NUMBER}
#        Input Text    (${INPUT_JOB_ID})[2]    ${CUSTOM_SERIAL_NUMBER}
    ELSE
        ${TD_SERIAL_NUMBER}=    Generate Random String
        Set Test Variable    ${TD_SERIAL_NUMBER}
        Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
#        Input Text    (${INPUT_JOB_ID})[2]    ${TD_SERIAL_NUMBER}
    END
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    IF    '${CUSTOM_MATERIAL_NUMBER}'!='False'
        Input Text    ${MaterialNo}    ${CUSTOM_MATERIAL_NUMBER}
    ELSE
        Input Text    ${MaterialNo}    ${TD_MATERIAL_NUMBER}
    END
    Wait Until Element Is Visible    ${JobName}    ${maxTime}
    Input Text    ${JobName}    ${TestJobName}



Delete The Job Created
    [Documentation]    To Delete The Job Created
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${FIRST_JOB}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_JOB}    ${TD_SERIAL_NUMBER}
    Delete One Record From Job List Page
    Wait For The Page To Load
    Clear Element Text    ${INPUT_SEARCH}
    Reload Page

Verify The UI Of Delete Popup-Message
    [Documentation]    To Verify The UI Of Delete Popup-Message
    Wait Until Element Is Visible    ${DELETE_POPUP_CONFIRMATION_MESSAGE}    ${Max_limit}
    Wait Until Element Is Visible    ${DELETE_POPUP_JOB_ID}    ${Max_limit}
    Wait Until Element Is Visible    ${DELETE_POPUP_WARNING_MESSAGE}    ${Max_limit}
    Wait Until Element Is Visible    ${DELETE_JOB_POPUP_BUTTON}    ${Max_limit}
    Wait Until Element Is Visible    ${CANCEL_DELETE_JOB_BUTTON}    ${Max_limit}


Search And Add Procedure To Job
    [Documentation]    To Search And Add Procedure To Job
    [Arguments]    ${VAR_NAME}
    Click Element    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    FOR    ${PROCEDURE}    IN    @{${VAR_NAME}}
        Wait Until Element Is Visible    ${Procedure_Search_Bar}    ${maxTime}
        Scroll Element And Enter Value    ${Procedure_Search_Bar}    ${PROCEDURE}
        Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
        Wait Until Keyword Succeeds    5x    1s    Click Element By JS    ${SelectProcedure}
        Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    END    

Get Last Two Records From List
    [Documentation]    To Get Last Two Records From List
    [Arguments]    ${LIST_NAME}    ${RETURN_LIST}
    ${${RETURN_LIST}}=    Get Last Two Elements From List    ${${LIST_NAME}}
    Set Test Variable    ${${RETURN_LIST}}

Verify The Procedures Associated With The Material Number Are Displayed At the Operators End In Job Creation
    [Documentation]    To Verify The Procedures Associated With The Material Number Are Displayed At the Operators End In Job Creation
    [Arguments]    ${VISIBILITY}=None
    Wait Until Element Is Visible    ${JobNext_Done}    ${maxTime}
    Click Element    ${JobNext_Done}
    
    #validation
    Wait Until Page Does Not Contain Element    ${AddProcedureToJob}
    
    Wait Until Element Is Visible    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}
    IF    '${VISIBILITY}'=='Hide'
        Element Should Not Contain    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}    ${TD_PROCEDURE_NAME}
        Page Should Contain    Procedure not found
    ELSE
        Element Should Contain    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}    ${TD_PROCEDURE_NAME}
        Page Should Not Contain    Procedure not found
    END            
    ${END_LIMIT}=    Get Element Count    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}
    ${ALL_LISTED_PROCEDURE}=    Get Values In List For Validation    ${ALL_PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}    1    ${END_LIMIT}
    
    Evaluate    len(${ALL_LISTED_PROCEDURE})==1
    Capture Page Screenshot
    
    
    
Remove Procedure From The Job
    [Documentation]    To Remove Procedure From The Job
    
    Wait For The Element And Click    ${REMOVE_PROCEDURE_FROM_JOB}
    Wait Until Page Contains    Are you sure you want to delete this procedure?
    Wait For The Element And Click    ${REMOVE_PROCEDURE_FROM_JOB_DELETE_BUTTON}
    Wait Until Element Is Not Visible    ${REMOVE_PROCEDURE_FROM_JOB}    ${maxTime}
      
Select Procedure To Job
    [Documentation]    To Select Procedure To Job
    [Arguments]     ${MULTIPLE_PROCEDURES}=False    ${LIST_VAR_NAME}=PROCEDURE_LIST
    Wait Until Element Is Visible    ${JobNext_Done}    ${maxTime}
    Click Element    ${JobNext_Done}
    IF    '${MULTIPLE_PROCEDURES}'!='True'
        ${PROCEDURE_LIST}=    Create List    ${TD_PROCEDURE_NAME}
        Set Test Variable    ${PROCEDURE_LIST}
    END
    
    Search And Add Procedure To Job    ${LIST_VAR_NAME}
    
    Click Element    ${AddProcedure}
    Wait Until Element Is Visible    ${btn_create}
    Wait Until Element Is Visible    ${btn_cancel}
    Wait Until Element Is Visible    ${btn_previous}



Select Procedure And Create Job As Operator
    [Documentation]    To Select Procedure And Create Job As Operator
    Wait Until Element Is Visible    ${JobNext_Done}    ${maxTime}
    Click Element    ${JobNext_Done}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}


    Wait Until Element Is Visible    ${btn_create}
    Wait Until Element Is Visible    ${btn_cancel}
    Wait Until Element Is Visible    ${btn_previous}


    Wait Until Element Is Visible    ${btn_create}    ${maxTime}
    Double Click Element    ${btn_create}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}


Delete the created Job
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-action')]//button    ${maxTime}
    Click Element    ${JobID_generic_start}${UniqueNumbertest}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-action')]//button
    Wait Until Element Is Visible    ${btn_delete_job}
    Click Element    ${btn_delete_job}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    WAIT UNTIL ELEMENT IS NOT VISIBLE    ${ToasterMessage}    ${MaxTime}

Search invalid Job and verify
    ${random_string}=    Generate Random String    5
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${Procedure_Search_Bar}
    Input Text   ${Procedure_Search_Bar}    ${random_string}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${NO_JOBS_FOUND}    ${MaxTime}
    Element Should Be Visible    ${NO_JOBS_FOUND}

Verify Invalid Serial number
    ${random_string}=    Generate Random String    4
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Click Element    ${AddJob}

    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    Input Text    ${INPUT_JOB_ID}    ${random_string} ${random_string}
    Page Should Contain    Spaces are not allowed.

    Clear Element Text    ${INPUT_JOB_ID}
    Input Text    ${INPUT_JOB_ID}   ${TD_SERIAL_NUMBER}


Verify Invalid Material number
    ${random_string}=    Generate Random String    4
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    Input Text    ${MaterialNo}    ${random_string} ${random_string}
    Page Should Contain    Spaces are not allowed.

    Clear Element Text    ${MaterialNo}
    Input Text    ${MaterialNo}    ${TD_MATERIAL_NUMBER}
    Page Should Not Contain    Spaces are not allowed.

Verify serial number and material number changes are not saved on clicking cancel
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Click Element    ${AddJob}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    Input Text    ${MaterialNo}    ${TD_MATERIAL_NUMBER}
    Click Element    ${CANCEL_JOB_BUTTON_DETAILS_PAGE}


    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Click Element    ${AddJob}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    ${value}=    Get Value    ${INPUT_JOB_ID}
    log    ${value}
    Should Be Empty    ${value}

    Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    ${value}=    Get Value    ${MaterialNo}
    log    ${value}
    Should Be Empty    ${value}

Click newly created sample job
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}    ${maxTime}
    Click Element By JS     ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}

Verify The Job Status
    [Documentation]    To Verify The Job Status
    [Arguments]    ${JOB_STATUS}=FALSE    ${VERIFY_CYCLE_TIME}=FALSE
    IF    '${JOB_STATUS}'=='Completed'
        Element Text Should Be    ${JOB_PROGRESS_STATUS}    Completed
        Wait Until Element Is Visible    ${JOB_PROGRESS_STATUS}
    ELSE IF    '${JOB_STATUS}'=='Not Started'
        Element Text Should Be    ${JOB_PROGRESS_STATUS}    Not Started
        Element Text Should Be    ${JOB_COMPLETION_STATUS}    0%
    ELSE IF    '${JOB_STATUS}'=='Failed'
        Element Text Should Be    ${JOB_PROGRESS_STATUS}    Failed
        Element Text Should Be    ${JOB_COMPLETION_STATUS}    99%
    END
    IF    '${VERIFY_CYCLE_TIME}'=='True'
        Element Should Contain    ${FIRST_JOB_TIME_TAKEN}    ${EXECUTION_COMPLETION_CYCLE_TIME}
    END
    Wait Until Element Is Visible    ${PROGRESS_BAR}
    ${ALL_PROGRESS_BAR}=    Get Element Count    ${PROGRESS_BAR}
    Should Be True    ${ALL_PROGRESS_BAR}>=1    Progress Bar Not Visible

Select due date and verify
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${DueDateCalendar}
    Click Element    ${DueDateCalendar}

    Wait Until Element Is Visible    //span[contains(@class,'mat-calendar-body-today')]/..
    ${before}=    Get Element Attribute    //span[contains(@class,'mat-calendar-body-today')]/..    aria-label
    Log    Current date shown: ${before}

    # Updated to match the format of the date string being received ('Oct 01, 2025')
    ${expected}=    Evaluate    (datetime.datetime.strptime('${before}', '%B %d, %Y') + datetime.timedelta(days=1)).strftime('%d-%m-%Y')    modules=datetime
    Log    Expected tomorrow: ${expected}


    # Get current time and process date values
    ${NOW}=           Get Time
    ${TODAY_MONTH}=   Evaluate    datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S').strftime('%m')    modules=datetime
    ${TOMORROW_DAY}=  Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') + datetime.timedelta(days=1)).strftime('%d')    modules=datetime
    ${TOMORROW_MONTH}=    Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') + datetime.timedelta(days=1)).strftime('%m')    modules=datetime

   # Convert to integer for proper comparison
    ${TODAY_MONTH}=    Convert To Integer    ${TODAY_MONTH}
    ${TOMORROW_DAY}=   Convert To Integer    ${TOMORROW_DAY}
    ${TOMORROW_MONTH}=    Convert To Integer    ${TOMORROW_MONTH}

    # If the month changes, click to go to the next month
    Run Keyword If    '${TOMORROW_MONTH}' != '${TODAY_MONTH}'    Click Element    ${btn_next_month}

    Wait Until Element Is Visible    ${DateGenericStart}${TOMORROW_DAY}${DateGenericEnd}   ${MaxTime}
    Double Click Element    ${DateGenericStart}${TOMORROW_DAY}${DateGenericEnd}

    # Ensure the due date is updated correctly
    Wait Until Keyword Succeeds    5x    1s    Element Text Should Be    ${dueDate}    ${expected}

Enter sample serial number and material number
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
#    Input Text    (${INPUT_JOB_ID})[2]    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    Input Text    ${MaterialNo}    ${TD_MATERIAL_NUMBER}
    Wait For The Element And Click    ${NextButton}
    Wait For The Element And Click    ${DoneButton}

Enter sample job name
    Wait Until Element Is Visible    ${JobName}   ${MaxTime}
    Input Text    ${JobName}    ${TestJobName}


Verify invalid due date
    ${NOW}=                Get Time
    ${YESTERDAY_DAY}=      Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') - datetime.timedelta(days=1)).strftime('%d')    modules=datetime
    ${YESTERDAY_DAY}=      Convert To Integer    ${YESTERDAY_DAY}

    Wait Until Element Is Visible    ${DueDateCalendar}
    Click Element    ${DueDateCalendar}

    Wait Until Element Is Visible    ${DateGenericStart}${YESTERDAY_DAY}${DateGenericEnd}    ${MaxTime}

    ${YESTERDAY_BUTTON}=    Set Variable    //button[contains(@class, 'mat-calendar-body-disabled')]//span[normalize-space(.)='${YESTERDAY_DAY}']/ancestor::button
    Element Attribute Value Should Be    ${YESTERDAY_BUTTON}    aria-disabled    true

Verify unsaved job data cleared on refresh
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobName}    ${MaxTime}
    Input Text                       ${JobName}    ${TestJobName}
    Element Attribute Value Should Be    ${JobName}    value    ${TestJobName}
    Reload Page
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobName}    ${MaxTime}
    Element Attribute Value Should Be    ${JobName}    value    ${EMPTY}

Verify warning message on clicking create without adding procedures
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${btn_create}    ${MaxTime}
    Click Element    ${btn_create}
    Wait Until Element Is Visible    ${ToasterMessage}    ${MaxTime}
    Element Text Should Be           ${ToasterMessage}    Please add at least one procedure

Verify on clicking cancel on procedure page, user lands on job orders page
    Wait Until Element Is Visible    ${btn_cancel}    ${MaxTime}
    Click Element    ${btn_cancel}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${JobHeading}    ${maxTime}
    Wait Until Element Is Visible    ${JobHeading}

Verify input fields are disabled after job creation
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Element Should Be Disabled    ${SerialNoDisabled}
    Element Should Be Disabled    ${SerialNoDisabled}
    Element Should Be Disabled    ${JobNameDisabled}
    Element Should Be Disabled    ${MateriaDisabled}
    Element Should Be Disabled    ${ProductionPlantDisabled}
    Element Should Be Disabled    ${PONoDisabled}
    Element Should Be Disabled    ${BatchNumberDisabled}
    Element Should Be Disabled    ${VersionDisabled}
    Element Should Be Disabled    ${SalesOrderNoDisabled}
    Element Should Be Disabled    ${OrderTypeDisabled}
    Element Should Be Disabled    ${MRPControllerDisabled}
    Element Should Be Disabled    ${StorageLocationDisabled}
    Element Should Be Disabled    ${QuantityDisabled}

Verify entered details are visible on Job Orders page
    Element Text Should Be    ${header_jobName}    ${TestJobName}
    ${serial_number}=    Get Value    ${SerialNoDisabled}
    Should Be Equal    ${serial_number}    ${TD_SERIAL_NUMBER}
    ${job_name}=    Get Value    ${JobNameDisabled}
    Should Be Equal    ${job_name}    ${TestJobName}
    ${material_number}=    Get Value    ${MateriaDisabled}
    Should Be Equal    ${material_number}    ${TD_MATERIAL_NUMBER}

Pause Job Execution
    [Documentation]    To Pause Job Execution
    Wait For The Element And Click    ${PAUSE_BUTTON}
    #Delay in pause
    Sleep    5s

Verify Pause job functionality
    sleep    3s
    ${before}=    Get Text    ${step_timer}

    Sleep    3s
    ${after}=    Get Text    ${step_timer}
    Should Be Equal    ${before}    ${after}

    ${paused_time_before}=    Get Text    ${paused_timer}
    Sleep    3s
    ${paused_time_after}=    Get Text    ${paused_timer}
    Should Not Be Equal    ${paused_time_before}    ${paused_time_after}

    Wait Until Element Is Visible    ${resume_button}
    Click Element By JS    ${resume_button}
    Sleep    3s
    ${after_resume}=    Get Text    ${step_timer}
    Should Not Be Equal    ${before}    ${after_resume}
    Wait Until Element Is Visible    ${total_cycle_time}    ${maxTime}
    Wait Until Element Is Visible    ${total_cycle_time}

Ensure Job Management Page Is Open
    ${status}=    Run Keyword And Return Status    Navigate to Job Management Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Run Keyword And Ignore Error    Click Element    ${closeIcon}
    ${status}=    Run Keyword And Return Status    Navigate to Job Management Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Reload Page
    ${status}=    Run Keyword And Return Status    Navigate to Job Management Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${SupervisorEmail}    ${SupervisorPass}
    Navigate to Job Management Page

Handle Failure With Recovery
    IF    '${TEST STATUS}' != 'PASS'
        Log    Test failed. Recovering browser session...
        Close Browser
        Login To Mentor Application    ${SupervisorEmail}    ${SupervisorPass}
        Navigate to Job Management Page
    ELSE
        Log    Test passed. No recovery needed.
        Ensure Job Management Page Is Open
    END

Click on Fail button
    Wait Until Page Does Not Contain Element    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible    ${btn_fail}    ${MaxTime}
    Click Element    ${btn_fail}
    Wait Until Element Is Visible    ${txt_ncr}    ${MaxTime}
    Wait Until Element Is Visible    ${txt_ncr}

Fill the NCR report
    Wait Until Element Is Visible    ${defective_Part_no}    ${MaxTime}
    Run Keyword And Ignore Error    Click Element    ${ncr_done_btn}
    Click Element                    ${defective_Part_no}
    Input Text                       ${defective_Part_no}    ${NCR_affected_partnamne}
    Wait Until Element Is Visible    ${affected_quantity}    ${MaxTime}
    Click Element                    ${affected_quantity}
    Input Text                       ${affected_quantity}    ${NCR_affected_quantity}
    Wait Until Element Is Visible    ${ncr_description}      ${MaxTime}
    Click Element                    ${ncr_description}
    Input Text                       ${ncr_description}      ${NCR_description_text}

Click on done button in NCR
    Wait Until Element Is Visible    ${ncr_done_btn}    ${MaxTime}
    Click Element                    ${ncr_done_btn}
    Wait Until Element Is Visible    ${ncr_submitted_msg}    ${MaxTime}

Verify Job status after completing Sample job
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span    ${maxTime}
    ${NameColumnText}=    Get Text    ${SampleJobStart}${TD_SERIAL_NUMBER}${JobID_generic_end}/../../..//td[contains(@class, 'cdk-column-status')]//span
    Log    ${NameColumnText}
    Should Contain    ${NameColumnText}    Completed

Load Validation Data
    ${VALIDATION_DATA}=    Load Json From File    validation_data.json
    Set Suite Variable    ${VALIDATION_DATA}
    Log    ${VALIDATION_DATA}
    FOR    ${key}    IN    @{VALIDATION_DATA.keys()}
        ${value}=    Get From Dictionary    ${VALIDATION_DATA}    ${key}
        Set Suite Variable    ${${key}}    ${value}
        Log    ${${key}}
    END


Verify The User Is Not Able To Select The Due Date From Back Date
    [Documentation]    To Verify The User Is Not Able To Select The Due Date From Back Date
    Click Element    ${DUE_DATE_SELECT}
    ${CURRENT_DAY}=    Get Text    ${SELECTED_DUE_DATE}
    ${CURRENT_DAY}=    Strip String    ${CURRENT_DAY}
    ${DATE_FORMAT}=    Get Element Attribute    ${CURRENT_DAY_DATE}    aria-label
    ${COUNT}=    Evaluate    int(${CURRENT_DAY})
    FOR    ${DAY}    IN RANGE    1    ${COUNT}
        ${DAY}=    Evaluate    str(${DAY})
        ${PREVIOUS_DATE}=    Replace String    ${DATE_FORMAT}    ${CURRENT_DAY},    ${DAY},
        ${LOCATOR}=    Replace String    ${PREVIOUS_DAY}    DATE    ${PREVIOUS_DATE}
        Element Attribute Value Should Be    ${LOCATOR}    aria-disabled    true
    END
    ${All_DAYS}=    Get Webelements    //button[contains(@class,"mat-calendar-body-cell")]
    Element Should Be Enabled    ${All_DAYS[-1]}
    Click Element    ${SELECTED_DUE_DATE}

Search The Job On Job List Page
    [Documentation]    To Search The Job On Job List Page
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${FIRST_JOB}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_JOB}    ${TD_SERIAL_NUMBER}


Navigate To Job Details Page
    [Documentation]    To Navigate To Job Details Page
    Search The Job On Job List Page
#    Wait For The Element And Click    ${FIRST_JOB}
    Wait Until Page Contains Element    ${FIRST_JOB}
    Click Element By JS    ${FIRST_JOB}
    Wait For The Page To Load

Click On Edit Button On Job Details page
    [Documentation]    To Click On Edit Button On Job Details page
    Wait For The Element And Click    ${EDIT_JOB_BUTTON}

Verify The Correct Count Is Displayed In The Header
    [Documentation]    To Verify The Correct Count Is Displayed In The Header
    ${CURRENT_COUNT}=   Get Current Record Count On Page
    Element Should Contain    ${HEADER_JOBS_COUNT}    (${CURRENT_COUNT})

Verify That The UI Displays Option Choices Correctly In The Selection Dropdown
    [Documentation]    To Verify That The UI Displays Option Choices Correctly In The Selection Dropdown
    [Arguments]    ${NO_OPTION_ADDED_TO_STEP}=False

    IF    '${NO_OPTION_ADDED_TO_STEP}'=='True'
        Wait For The Page To Load
        Wait Until Element Is Not Visible    ${USER_OPTION_POPUP_HEADER}
        Return From Keyword
    END

    Wait Until Element Is Visible    ${USER_OPTION_POPUP_HEADER}
    Element Text Should Be    ${USER_OPTION_POPUP_PROCEDURE_NAME}    ${TD_PROCEDURE_NAME}
    ${TD_OPTIONS_TITLE}    Evaluate    list(${OPTIONS_DICT}.keys())[0]
    Set Test Variable    ${TD_OPTIONS_TITLE}
    Element Should Contain    ${USER_OPTION_POPUP_OPTION_TITLE}    ${TD_OPTIONS_TITLE}
    Wait For The Element And Click    ${USER_OPTION_POPUP_OPTION_DROPDOWN}
    Wait Until Element Is Visible    ${FIRST_OPTION_IN_USER_OPTION_POPUP_DROPDOWN}
    ${END_INDEX}=    Get Element Count    ${OPTION_LIST_VALUES_IN_USER_OPTION_POPUP}
    ${OPTIONS_VALIDATION_LIST_FROM_JOB}=    Get Values In List For Validation    ${ALL_OPTION_IN_USER_OPTION_POPUP_DROPDOWN}    3    ${END_INDEX}
    ${OPTIONS_VALIDATION_LIST_FROM_PROCEDURE}=    Get From Dictionary    ${OPTIONS_DICT}    ${TD_OPTIONS_TITLE}
    Lists Should Be Equal    ${OPTIONS_VALIDATION_LIST_FROM_PROCEDURE}    ${OPTIONS_VALIDATION_LIST_FROM_JOB}
    Element Should Be Disabled    ${DONE_BUTTON_IN_USER_OPTION_POPUP}
    Click Element By JS    ${FIRST_OPTION_IN_USER_OPTION_POPUP_DROPDOWN}
    Element Should Be Visible    ${DONE_BUTTON_IN_USER_OPTION_POPUP}
    Element Should Be Enabled    ${DONE_BUTTON_IN_USER_OPTION_POPUP}
    Click Element    ${CHOOSE_LATER_BUTTON_IN_USER_OPTION_POPUP}

Select The User Option In Job
    [Documentation]    To Select The User Option In Job
    [Arguments]    ${CORRECTNESS}=False
    Click On Option Select Button From Header
    Wait For The Element And Click    ${USER_OPTION_POPUP_OPTION_DROPDOWN}

    IF    '${CORRECTNESS}'=='Correct'
        ${TD_OPTIONS_TITLE}    Evaluate    list(${OPTIONS_DICT}.keys())[0]
        Set Test Variable    ${TD_OPTIONS_TITLE}
        ${CORRECT_OPTION}=    Get From Dictionary    ${OPTIONS_VALIDATION_DICT}    ${TD_OPTIONS_TITLE}
        Set Test Variable     ${CORRECT_OPTION}
        Scroll Element And Enter Value    ${input_search}    ${CORRECT_OPTION}
        Wait For The Element And Click    ${FIRST_OPTION_IN_USER_OPTION_POPUP_DROPDOWN}
    ELSE
        ${LOCATOR}=    Replace String    ${INCORRECT_OPTION_IN_USER_OPTION_POPUP_DROPDOWN}    OPTION    ${CORRECT_OPTION}
        Scroll Element Into View    ${LOCATOR}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    END
    Click Element    ${DONE_BUTTON_IN_USER_OPTION_POPUP}


Verify The UI Of The User Input Pop-up
    [Documentation]    To Verify The UI Of The User Input Pop-up
    Wait Until Element Is Visible    ${HEADER_IN_USER_INPUT_POPUP}
    ${TD_BLOCK_NAME}=    Get From Dictionary    ${USER_INPUT_DATA}    Block_Name
    ${TD_BLOCK_TITLE}=    Get From Dictionary    ${USER_INPUT_DATA}    Block_Title
    Element Should Contain    ${BLOCK_NAME_IN_USER_INPUT_POPUP}    ${TD_BLOCK_NAME}
    Element Should Contain    ${BLOCK_TITLE_IN_USER_INPUT_POPUP}    ${TD_BLOCK_TITLE}
    Wait For The Element And Click    ${DROPDOWN_IN_USER_INPUT_POPUP}
    Wait Until Element Is Visible    ${FIRST_DROPDOWN_OPTION_IN_USER_INPUT_POPUP}
    ${END_INDEX}=    Get Element Count    ${DROPDOWN_OPTIONS_IN_USER_INPUT_POPUP}
    ${USERINPUT_VALIDATION_LIST_FROM_JOB}=    Get Values In List For Validation    ${All_DROPDOWN_OPTIONS_IN_USER_INPUT_POPUP}    3    ${END_INDEX}
    ${TD_OPTION1}=    Get From Dictionary    ${USER_INPUT_DATA}    OPTION1
    ${TD_OPTION2}=    Get From Dictionary    ${USER_INPUT_DATA}    OPTION2
    List Should Contain Value    ${USERINPUT_VALIDATION_LIST_FROM_JOB}    ${TD_OPTION1}
    List Should Contain Value    ${USERINPUT_VALIDATION_LIST_FROM_JOB}    ${TD_OPTION2}
    ${STATUS}=    Evaluate    len(${USERINPUT_VALIDATION_LIST_FROM_JOB})==2
    Should Be True    ${STATUS}
    Wait For The Element And Click    ${FIRST_DROPDOWN_OPTION_IN_USER_INPUT_POPUP}
    Element Should Be Visible    ${DONE_BUTTON_IN_USER_INPUT_POPUP}
    Wait Until Element Is Visible    ${CLOSE_BUTTON_IN_USER_INPUT_POPUP}

Select The User Input
    [Documentation]    To Select The User Input
    Wait For The Element And Click    ${DROPDOWN_IN_USER_INPUT_POPUP}
    Wait For The Element And Click    ${FIRST_DROPDOWN_OPTION_IN_USER_INPUT_POPUP}
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${DONE_BUTTON_IN_USER_INPUT_POPUP}
    Run Keyword And Ignore Error    Close User Input Popup


Verify The Steps Based On The Option Selected
    [Documentation]    To Verify The Steps Based On The Option Selected
    [Arguments]    ${OPTION_SELECTED}
    Wait Until Element Is Visible    ${STEPS_ADDED_IN_JOB}    ${Max_limit}
    ${STEPS_COUNT}=    Get Element Count    ${STEPS_ADDED_IN_JOB}
    IF    '${OPTION_SELECTED}'=='Correct Option'
        Check The Strings Are Equal    ${STEPS_COUNT}    16
        Element Should Be Visible    ${STEP_TO_BE_HIDDEN}
    ELSE IF  '${OPTION_SELECTED}'=='Incorrect Option'
        Check The Strings Are Equal    ${STEPS_COUNT}    15
        Wait Until Element Is Not Visible    ${STEP_TO_BE_HIDDEN}
    END


Click On Option Select Button From Header
    [Documentation]    To Click On Option Select Button From Header
    Run Keyword And Ignore Error    Click Element    ${CLOSE_OPTION_SELECT_POPUP}
    Wait For The Element And Click    ${OPTION_SELECT_BUTTON}


Close Popup
    [Documentation]    To Close Popup
    Run Keyword And Ignore Error    Click Element    ${CLOSE_OPTION_SELECT_POPUP}

Close User Option Popup
    [Documentation]    To Close User Option Popup
    Wait For The Element And Click    ${USER_OPTION_CHOOSE_LATER_BUTTON}

Close User Input Popup
    [Documentation]    To Close User Option Popup
    Wait For The Element And Click    ${USER_INPUT_CLOSE_BUTTON}

Click On The Step In Job Execution
    [Documentation]    To Click On The Step In Job Execution
    [Arguments]    ${STEP_INDEX}    ${IGNORE_STEP}=False
    ${STEP_INDEX}=    Evaluate    str(${STEP_INDEX})
    ${LOCATOR}=  Replace String    ${ADDED_PROCEDURE_STEP_IN_JOB}    INDEX    ${STEP_INDEX}
    Double Click Element    ${LOCATOR}
    Run Keyword If    '${IGNORE_STEP}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${VALIDATE_CORRECT_NUMBER}    ${STEP_INDEX}

Mark The Step As Completed
    [Documentation]    To Mark The Step As Completed
    Wait For The Element And Click     ${Check}

Verify Procedure Steps In Job Execution
    [Documentation]    To Verify Procedure Steps And Complete Job/Training execution
    [Arguments]    ${STEP_FROM}=1
    Click On The Step In Job Execution    ${STEP_FROM}
    ${STEP_INSTRUCTIONS_LIST}=    Evaluate    ${STEP_INSTRUCTIONS_LIST}\[${STEP_FROM}-1:]
    ${STEP_INSTRUCTIONS_LIST_ENUMERATED}=    ENUMERATE LIST    ${STEP_INSTRUCTIONS_LIST}
    FOR    ${STEP_INSTRUCTION}    IN    @{STEP_INSTRUCTIONS_LIST_ENUMERATED}
        #User input popup should appear when click on check button
        IF    '${STEP_INSTRUCTION[0]}'=='2'
            Run Keyword And Ignore Error    Close Popup
            Run Keyword And Ignore Error    Press Keys    None    ESC
        END
        IF    '${STEP_INSTRUCTION[0]}'=='3'
            Capture Page Screenshot
            Run Keyword And Ignore Error    Select The User Input
        END
        Verify The Procedure Step UI On The Job Execution Page    ${STEP_INSTRUCTION[1]}
        Mark The Step As Completed
    END
    Capture Page Screenshot

Verify The Procedure Step UI On The Job Execution Page
    [Documentation]    To  Verify The Procedure Step UI On The Job Execution Page
    [Arguments]    ${INSTRUCTION_TEXT}
    Wait Until Element Is Visible    ${Check}    ${Max_limit}
    Wait Until Element Is Visible    ${JOB_EXECUTION_STEP_FAIL_BUTTON}
    Wait Until Element Is Visible    ${STEP_NAME_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${STEP_BOOK_ICON_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${PROCEDURE_COMMENT_ICON_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${STEP_VIEW_SELECTOR_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${STEP_INSTRUCTION_EDITOR_IN_JOB_EXECUTION}
    Element Should Contain    ${STEP_INSTRUCTION_EDITOR_IN_JOB_EXECUTION}    ${INSTRUCTION_TEXT}
    Wait Until Element Is Visible    ${STEP_INSTRUCTION_EXPAND_ICON_IN_JOB_EXECUTION}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${STEP_INSTRUCTION_EXPAND_ICON_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${EXPANDED_STEP_INSTRUCTION_EDITOR_IN_JOB_EXECUTION}
    Element Should Contain    ${EXPANDED_STEP_INSTRUCTION_EDITOR_IN_JOB_EXECUTION}    ${INSTRUCTION_TEXT}
    Wait For The Element And Click    ${CLOSE_EXPANDED_STEP_INSTRUCTION_EDITOR}
    Wait Until Element Is Visible    ${STEP_INSTRUCTION_EDITOR_IN_JOB_EXECUTION}


Verify The UI Of Start Job Welcome Screen
    [Documentation]    To Verify The UI Of Start Job Welcome Screen
    Wait Until Element Is Visible    ${JOB_WELCOME_SCREEN_HEADER}
    Element Should Contain    ${JOB_NAME_IN_WELCOME_SCREEN}    ${TestJobName}
    Wait Until Element Is Visible    ${PROCEDURE_SECTION_TITLE_IN_WELCOME_SCREEN}
    Wait Until Element Is Visible    ${PROCEDURE_SECTION_DESC_IN_WELCOME_SCREEN}    ${Max_limit}
    Wait Until Element Is Visible    ${PROCEDURE_NAME_IN_WELCOME_SCREEN}    ${Max_limit}
    Wait Until Element Is Visible    ${PROCEDURE_PUBLISHED_BY_TEXT_IN_WELCOME_SCREEN}
    Wait Until Element Is Visible    ${PROCEDURE_VERSION_IN_WELCOME_SCREEN}
    Wait Until Element Is Visible    ${PROCEDURE_PUBLISHER_LOGO_IN_WELCOME_SCREEN}
    Wait Until Element Is Visible    ${PROCEDURE_NAME_IN_WELCOME_SCREEN}

    Wait Until Element Is Visible    ${WELCOME_SCREEN_PPE_SECTION_TITLE}
    Wait Until Element Is Visible    ${WELCOME_SCREEN_PPE_SECTION_DESC}
    Wait Until Element Is Visible    ${WELCOME_SCREEN_PPE_SECTION_CANCEL_BUTTON}

Verify The PPE's Of The Procedure Added In Job
    [Documentation]    To Verify The PPE's Of The Procedure Added In Job
    Wait Until Element Is Visible    ${FIRST_PPE_ADDED_IN_JOB}
    Wait Until Element Is Visible    ${SECOND_PPE_ADDED_IN_JOB}
    Wait Until Element Is Visible    ${THIRD_PPE_ADDED_IN_JOB}
    Wait Until Element Is Visible    ${FOURTH_PPE_ADDED_IN_JOB}

Verify No PPE Is Added To The Job
    [Documentation]    To Verify No PPE Is Added To The Job
    Wait Until Element Is Not Visible    ${FIRST_PPE_ADDED_IN_JOB}
    Wait Until Element Is Not Visible    ${NO_PPE_ADDED_IN_JOB}


Verify The Procedures Listed On Welcome Screen
    [Documentation]    To Verify The Procedures Listed On Welcome Screen
    FOR    ${PROCEDURE}    IN    @{PROCEDURE_LIST}
        ${LOCATOR}=    Replace String    ${PROCEDURE_ADDED_IN_JOB_WELCOME_SCREEN}    PROCEDURE_NAME    ${PROCEDURE}
        Wait Until Element Is Visible    ${LOCATOR}    ${Max_limit}
   END


Verify The PPE's Of Both The Procedure Added In Job
    [Documentation]    To Verify The PPE's Of Both The Procedure Added In Job
    ${PPE_ADDED_IN_JOB}=    Extend List    ${PPE_LIST}    ${PPE_ADDED_TO_PROCEDURE}
    ${PPE_ADDED_IN_JOB}=    Evaluate    [i.split(' ')[0][:10] for i in ${PPE_ADDED_IN_JOB}]
    FOR    ${PPE_ITEM}    IN    @{PPE_ADDED_IN_JOB}
        ${LOCATOR}=    Replace String    ${PPE_ITEM_ADDED_IN_JOB}    PPE    ${PPE_ITEM}
        Wait Until Page Contains Element    ${LOCATOR}
   END
   Click Element    ${WELCOME_SCREEN_PPE_SECTION_CANCEL_BUTTON}
   Wait Until Element Is Not Visible    ${WELCOME_SCREEN_PPE_SECTION_CANCEL_BUTTON}


Verify UI of Status Indicators in job order page
    [Documentation]    To Verify UI of Status Indicators in job order page
    Wait Until Element Is Visible    ${TOTAL_JOBS_PIE_CHART}    ${Max_limit}
    Element Should Be Visible    ${TOTAL_JOBS_HEADER}
    Element Should Be Visible    ${TOTAL_JOBS_PIE_CHART_COMPLETED_JOB}
    Element Should Be Visible    ${TOTAL_JOBS_PIE_CHART_INPROGRESS_JOBS}
    Element Should Be Visible    ${TOTAL_JOBS_PIE_CHART_NOT_STARTED}
    Element Should Be Visible    ${TOTAL_JOBS_PIE_CHART_PAUSED}
    Element Should Be Visible    ${TOTAL_JOBS_PIE_CHART_FAILED}


    Element Should Be Visible    ${COMPLETED_STATUS_PIE_CHART}
    Element Should Be Visible    ${COMPLETED_STATUS_PIE_ONTIME_JOBS}
    Element Should Be Visible    ${FPY_CHART_CARD}

Verify The Donut Chart Color Coding For Different Jobs
    [Documentation]    To Verify The Donut Chart Color Coding For Different Jobs
    Wait Until Element Is Visible    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_COMPLETED_JOB}    ${Max_limit}
    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_COMPLETED_JOB}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(0, 143, 49, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_INPROGRESS_JOBS}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(244, 125, 89, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_NOT_STARTED}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(207, 228, 242, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_PAUSED}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(244, 125, 89, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_FAILED}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(228, 0, 43, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_ON_TIME}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(0, 143, 49, 1)

    ${TEMP}=    Get CSS Property    ${TOTAL_JOBS_PIE_CHART_COLOR_FOR_LATE}    background-color
    Log    ${TEMP}
    Should Be Equal As Strings    ${TEMP}    rgba(228, 0, 43, 1)


Save The Status Indicators
    [Documentation]    To Save The Status Indicators
    ${COMPLETED_COUNT}=    Get Text    ${TOTAL_JOBS_PIE_CHART_COMPLETED_JOB}
    ${COMPLETED_COUNT}=    Extract Numbers    ${COMPLETED_COUNT}
    Set Test Variable    ${COMPLETED_COUNT}

    ${IN_PROGRESS_COUNT}=    Get Text    ${TOTAL_JOBS_PIE_CHART_INPROGRESS_JOBS}
    ${IN_PROGRESS_COUNT}=    Extract Numbers    ${IN_PROGRESS_COUNT}
    Set Test Variable    ${IN_PROGRESS_COUNT}

    ${NOT_STARTED_COUNT}=    Get Text    ${TOTAL_JOBS_PIE_CHART_NOT_STARTED}
    ${NOT_STARTED_COUNT}=    Extract Numbers    ${NOT_STARTED_COUNT}
    Set Test Variable    ${NOT_STARTED_COUNT}

    ${PAUSED_COUNT}=    Get Text    ${TOTAL_JOBS_PIE_CHART_PAUSED}
    ${PAUSED_COUNT}=    Extract Numbers    ${PAUSED_COUNT}
    Set Test Variable    ${PAUSED_COUNT}

    ${FAILED_COUNT}=    Get Text    ${TOTAL_JOBS_PIE_CHART_FAILED}
    ${FAILED_COUNT}=    Extract Numbers    ${FAILED_COUNT}
    Set Test Variable    ${FAILED_COUNT}

Verify The Job Count Changed By
    [Documentation]    To Verify The Job Count Changed By
    [Arguments]    ${STATUS_TYPE}    ${CHANGE_FACTOR}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}
    ${PREVIOUS_COUNT}=   Get Variable Value    ${${STATUS_TYPE}}
    Save The Status Indicators
    Check The Count Is Changed    ${PREVIOUS_COUNT}    ${${STATUS_TYPE}}    ${CHANGE_FACTOR}

Verify The Step Group Is Visible In Job Execution
    [Documentation]    To Verify The Step Group Is Visible In Job Execution
    Wait Until Element Is Visible    ${NEW_GROUP_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${NEW_GROUP_EXPAND_BUTTON_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${STEPS_ADDED_IN_JOB}
    Click Element     ${NEW_GROUP_EXPAND_BUTTON_IN_JOB_EXECUTION}
    Wait Until Element Is Not Visible    ${STEPS_ADDED_IN_JOB}
    Click Element     ${NEW_GROUP_EXPAND_BUTTON_IN_JOB_EXECUTION}
    Wait Until Element Is Visible    ${STEPS_ADDED_IN_JOB}

Verify User Lands On The Job Order Page
    [Documentation]    To Verify User Lands On The Job Order Page
    Wait Until Location Is    ${JOB_LIST_PAGE}    ${Max_limit}

Click On Cancel Button On Job Order/Training Page
    [Documentation]    To Click On Cancel Button On Job Order/Training Page
    Wait For The Element And Click    ${DELETE_MULTIPLE_RECORD}
    Wait For The Element And Click    ${CANCEL_DELETE_JOB_BUTTON}

Verify The Cumulative Cycle Time Of The Procedures In Job
    [Documentation]    To Verify The Cumulative Cycle Time Of The Procedures In Job
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${FIRST_JOB}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_JOB}    ${TD_SERIAL_NUMBER}
    Element Should Contain    ${CUMULATIVE_TIME}    4h 31m 0s



Verify The Updated Procedures, Versions, Author Listed On Welcome Screen
    [Documentation]    To Verify The Updated Procedures, Versions, Author Listed On Welcome Screen
    Reverse List    ${UPDATED_PROCEDURE_NAME_AND_VERSION}
    ${ENUMERATED_LIST}    ENUMERATE LIST    ${UPDATED_PROCEDURE_NAME_AND_VERSION}
    FOR    ${PROCEDURE_DATA}    IN    @{ENUMERATED_LIST}
        ${i}=    Evaluate    str(${PROCEDURE_DATA[0]})
        ${UPDATED_PROCEDURE_ADDED_IN_JOB_LOCATOR}=    Replace String    ${UPDATED_PROCEDURE_ADDED_IN_JOB}    VALUE    ${PROCEDURE_DATA[1][0]}
        Element Should Be Visible    ${UPDATED_PROCEDURE_ADDED_IN_JOB_LOCATOR}

        ${UPDATED_PROCEDURE_VERSION__ADDED_IN_JOB_LOCATOR}=    Replace String    ${UPDATED_PROCEDURE_VERSION__ADDED_IN_JOB}    VALUE    ${SPACE}${PROCEDURE_DATA[1][1]}
        Element Should Be Visible    ${UPDATED_PROCEDURE_VERSION__ADDED_IN_JOB_LOCATOR}

        ${UPDATED_PROCEDURE_AUTHOR__ADDED_IN_JOB_LOCATOR}=    Replace String    ${UPDATED_PROCEDURE_AUTHOR__ADDED_IN_JOB}    INDEX    ${i}
        Element Should Contain    ${UPDATED_PROCEDURE_AUTHOR__ADDED_IN_JOB_LOCATOR}   ${AUTHOR1_NAME}

   END

Complete Job/Training execution And Calculate Taken Time
    [Documentation]    To Complete Job/Training execution And Calculate Taken Time
    #To Calculate Some delay
    Close Popup
    Sleep    10s
    Mark The Step As Completed
    ${TEMP1}=    Get Text    ${FIRST_PROCEDURE_TAKEN_TIME}
    Sleep    15s
    Mark The Step As Completed
    Close Popup
    ${TEMP2}=    Get Text    ${SECOND_PROCEDURE_TAKEN_TIME}
    Wait For The Element And Click    ${FinishButton}
    Complete Job/Training execution
    ${TOTAL_TAKEN_TIME}=    Evaluate    int(${TEMP1[:-1]})+int(${TEMP2[:-1]})
    Set Test Variable    ${TOTAL_TAKEN_TIME}

Verify The Taken Time
    [Documentation]    To Verify The Taken Time
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${FIRST_JOB}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_JOB}    ${TD_SERIAL_NUMBER}
    Element Should Contain    ${TAKEN_TIME}    ${TOTAL_TAKEN_TIME}s

Verify The Total Jobs Count Is Displayed Properly
    [Documentation]    Verify The Total Jobs Count Is Displayed Properly
    ${ALL_JOBS_RECORDS}=    Get Current Record Count On Page
    ${TOTAL_JOBS}=    Evaluate    ${COMPLETED_COUNT}+${IN_PROGRESS_COUNT}+${NOT_STARTED_COUNT}+${PAUSED_COUNT}+${FAILED_COUNT}
    Should Be Equal As Integers    ${ALL_JOBS_RECORDS}    ${TOTAL_JOBS}
    Element Should Contain    ${ALL_JOBS_RECORDS}    (${TOTAL_JOBS})

Verify The User Is Able To Delete The Procedures From New Job Screen
    [Documentation]    To Verify The User Is Able To Delete The Procedures From New Job Screen
    Wait For The Element And Click    ${JobNext_Done}
    # Add Procedures to Job and verify no duplicate procedure can be added
    Wait For The Element And Click    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    FOR    ${PROCEDURE}    IN    @{PROCEDURE_LIST}
        Wait Until Element Is Visible    ${Procedure_Search_Bar}    ${maxTime}
        Scroll Element And Enter Value    ${Procedure_Search_Bar}    ${PROCEDURE}
        Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
        Wait Until Keyword Succeeds    5x    1s    Click Element By JS    ${SelectProcedure}
        Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    END
    Scroll Element And Enter Value    ${Procedure_Search_Bar}    ${PROCEDURE_LIST[0]}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SelectProcedure}    ${Max_limit}
    Checkbox Should Be Selected    ${SelectProcedure}
    Wait For The Element And Click    ${AddProcedure}

    #Verify The procedures added in job
    Wait Until Element Is Visible    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}
    ${PROCEDURES_COUNT}=    Get Element Count    ${PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}
    ${ADDED_PROCEDURES_IN_JOB}=    Get Values In List For Validation  ${ALL_PROCEDURE_LISTED_IN_NEW_JOB_ADD_PROCEDURE_SCREEN}    1    ${PROCEDURES_COUNT}
    Lists Should Be Equal    ${ADDED_PROCEDURES_IN_JOB}    ${PROCEDURE_LIST}

    Click Element    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait For The Element And Click    ${NEW_JOB_ADD_PROCEDURE_SCREEN_CROSS_ICON}

    Wait For The Element And Click    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait For The Element And Click    ${NEW_JOB_ADD_PROCEDURE_SCREEN_CANCEL_BUTTON}

    #Delete the Added Procedures
    FOR    ${i}    IN RANGE    1    ${PROCEDURES_COUNT}
        Wait For The Element And Click    ${NEW_JOB_ADD_PROCEDURE_SCREEN_DELETE_ICON}
        Wait For The Element And Click    ${NEW_JOB_ADD_PROCEDURE_SCREEN_POPUP_DELETE_BUTTON}
    END

    #Validate one procedure
    Element Should Be Disabled    ${NEW_JOB_ADD_PROCEDURE_SCREEN_DELETE_ICON}

Verify Pagination On The Add Procedures To Job Screen
    [Documentation]    To Verify Pagination On The Add Procedures To Job Screen
    Click Element    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait For The Element And Click    //mat-dialog-content//th//div/div[normalize-space()='Name']
    Repeat Keyword    15x    Press Keys    None    ARROW_DOWN
    Verify The Pagination On Custom Page    ${NEW_JOB_ADD_PROCEDURE_SCREEN_PAGE_SIZE_SELECT}    False    ${PAGINATION_NEXT_PAGE}


Get The First Job Details
    [Documentation]    To Get The First Procedure Details
    Wait Until Element Is Visible    ${FIRST_JOB}    ${Max_limit}
    ${TD_SERIAL_NUMBER}=    Get Text    ${FIRST_JOB}
    Set Test Variable    ${TD_SERIAL_NUMBER}

Verify The Job Having Duplicate Serial Number
    [Documentation]    To Verify The Job Having Duplicate Serial Number
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SERIAL_NUMBER}
    Wait Until Element Is Visible    ${FIRST_JOB}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_JOB}    ${TD_SERIAL_NUMBER}
    ${JOB_RECORDS}=    Get Current Record Count On Page
    Should Be True    ${JOB_RECORDS}==2

Verify Invalid Input Fields Validation For New Job Form
    [Documentation]    To Verify Invalid Input Fields Validation For New Job Form
    #verify validation for name field
    VAR    ${TEMP}    @,#,$,%,^,*,)a
    ${INVALID_CHARACTERS}=    Split String    ${TEMP}    ,
    FOR    ${CHAR}    IN    @{INVALID_CHARACTERS[:-1]}
        Wait Until Keyword Succeeds    5x    1s    Input Text    ${JOB_NAME_INPUT}    ${CHAR}
        Wait Until Element Is Visible    ${ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}
        Wait Until Element Is Visible    ${ERROR_MESSAGE_MINIMUM_TWO_CHAR_ALLOWED}
    END
    Scroll Element And Enter Value    ${JOB_NAME_INPUT}    ${INVALID_CHARACTERS[-1]}
    Wait Until Element Is Visible    ${ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}
    Scroll Element And Enter Value    ${JOB_NAME_INPUT}    The Job-Name
    Wait Until Element Is Not Visible    ${ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}
    Wait Until Element Is Not Visible    ${ERROR_MESSAGE_MINIMUM_TWO_CHAR_ALLOWED}

    #Quantity validation
    Repeat Keyword    3    Press Keys    ${SerialNoDisabled}    ARROW_DOWN
    Scroll Element And Enter Value    ${JOB_QUANTITY_INPUT}    -1
    Press Keys    ${JOB_QUANTITY_INPUT}    TAB
    Repeat Keyword    3    Press Keys    ${SerialNoDisabled}    ARROW_DOWN
    Wait Until Keyword Succeeds    10x    2s    Wait Until Element Is Not Visible    ${ERROR_MESSAGE_MINIMUM_VALUE}


    Scroll Element And Enter Value    ${JOB_QUANTITY_INPUT}    0
    Wait Until Element Is Not Visible    ${ERROR_MESSAGE_MINIMUM_VALUE}

#    Scroll Element And Enter Value    ${JOB_QUANTITY_INPUT}    0
#    Wait Until Element Is Not Visible    ${ERROR_MESSAGE_MINIMUM_VALUE}

    #Mandatory Field validation
    Repeat Keyword    14x    Press Keys    ${JOB_NAME_INPUT}    BACKSPACE



Verify the UI Layout of the Procedures Page
    [Documentation]    To Verify the UI Layout of the Procedures Page
    Wait Until Element Is Visible    ${NEW_JOB_ADD_PROCEDURE_SCREEN_LABEL_NAME}
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_LABEL_NAME}    Name
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_LABEL_VERSION}    Version
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_LABEL_EMT_TIME}    Estimated Time
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_LABEL_MATERIAL}    Material


Verify Estimated Time Display In Add Procedure Page
    [Documentation]    To Verify Estimated Time Display In Add Procedure Page
    Wait For The Element And Click    ${AddProcedureToJob}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}

    #Estimated Time format valdation
    ${END_LIMIT}=    Get Element Count    ${NEW_JOB_ADD_PROCEDURE_SCREEN_ALL_PROCEDURE_EMT_TIME}
    ${ALL_LISTED_PROCEDURE_ESTIMATED_TIME}=    Get Values In List For Validation    ${NEW_JOB_ADD_PROCEDURE_SCREEN_ALL_RECORDS_PROCEDURE_EMT_TIME}    1    ${END_LIMIT}
    Validate Time Format    ${ALL_LISTED_PROCEDURE_ESTIMATED_TIME}

    #Validate Procedure Record Data
    Scroll Element And Enter Value    ${Procedure_Search_Bar}    ${TD_PROCEDURE_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_NAME}    ${TD_PROCEDURE_NAME}
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_VERSION}    ${TD_VERSION}
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_EMT_TIME}    2h 15m 30s
#    Mouse Over    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_MAT_NUMBER}
#    Wait Until Element Is Visible    ${NEW_JOB_ADD_PROCEDURE_SCREEN_MATERIAL_NUMBER_TOOLTIP}    ${Max_limit}
    Element Should Contain    ${NEW_JOB_ADD_PROCEDURE_SCREEN_FIRST_RECORD_MAT_NUMBER}    ${TD_MATERIAL_NUMBER[:11]}

    Wait For The Element And Click    ${NEW_JOB_ADD_PROCEDURE_SCREEN_CANCEL_BUTTON}

Verify The Mandatory Fields Validation In Job Creation
    [Documentation]    To Verify The Mandatory Fields Validation In Job Creation
    Wait Until Element Is Visible    ${ERROR_MESSAGE_JOB_NAME_REQUIRED}

Lists Should Be Equal With Items
    [Documentation]    To Verify Lists Should Be Equal With Items
    [Arguments]    ${List1}    ${List2}
    
    FOR    ${ITEM}    IN    @{List1}
        List Should Contain Value    ${List2}    ${ITEM}
    END    

Validate Parts&Tools Added In Job
      [Documentation]    To Validate Parts&Tools Added In Job
      [Arguments]    ${BILL_OF_ITEM}
      IF    '${BILL_OF_ITEM}'=='BOM'
          Wait For The Element And Click    ${JOB_BOM_TAB}
          Wait Until Element Is Visible    ${ALL_BOM_ADDED_IN_JOB}    ${Max_limit}
          ${MAX_LIMIT}=    Get Element Count    ${ALL_BOM_ADDED_IN_JOB}
          @{BILL_OF_MATERIAL_IN_JOB}=    Get Values In List For Validation    ${BOM_ADDED_IN_JOB}    1    ${MAX_LIMIT}
          ${BILL_OF_MATERIAL_IN_JOB}=    Evaluate    [val[:15] for val in @{BILL_OF_MATERIAL_IN_JOB} ]
          Lists Should Be Equal With Items    ${BOM_ADDED_TO_STEP}    ${BILL_OF_MATERIAL_IN_JOB}
          Get First BOM Item Data
          Validate The BOM Details In Modal
      ELSE IF    '${BILL_OF_ITEM}'=='BOT'
          Wait For The Element And Click    ${JOB_BOT_TAB}
          Wait Until Element Is Visible    ${ALL_BOT_ADDED_IN_JOB}
          ${MAX_LIMIT}=    Get Element Count    ${ALL_BOT_ADDED_IN_JOB}
          @{BILL_OF_TOOLS_IN_JOB}=    Get Values In List For Validation    ${BOT_ADDED_IN_JOB}    1    ${MAX_LIMIT}
          ${BILL_OF_TOOLS_IN_JOB}=    Evaluate    [val[:15] for val in @{BILL_OF_TOOLS_IN_JOB} ]
          Lists Should Be Equal With Items    ${BOT_ADDED_TO_STEP}    ${BILL_OF_TOOLS_IN_JOB}
          Get First BOT Item Data
          Validate The BOT Details In Modal
      ELSE IF    '${BILL_OF_ITEM}'=='COM'
          Wait For The Element And Click    ${JOB_BOT_TAB}
          Wait Until Element Is Visible    ${ALL_BOT_ADDED_IN_JOB}
          ${MAX_LIMIT}=    Get Element Count    ${ALL_BOT_ADDED_IN_JOB}
          @{BILL_OF_TOOLS_IN_JOB}=    Get Values In List For Validation    ${BOT_ADDED_IN_JOB}    1    ${MAX_LIMIT}
          ${BILL_OF_TOOLS_IN_JOB}=    Evaluate    [val[:15] for val in @{BILL_OF_TOOLS_IN_JOB} ]
          Lists Should Be Equal With Items    ${BOT_ADDED_TO_STEP}    ${BILL_OF_TOOLS_IN_JOB}
          Get First BOT Item Data
          Validate The BOT Details In Modal
      END

Verify The UI of The Job Order Page
    [Documentation]    To Verify The UI of The Job Order Page
    Verify The Donut Chart Color Coding For Different Jobs
    Element Should Contain    ${JOB_ORDER_HEADER_JOB_ID}    Job Id
    Element Should Contain    ${JOB_ORDER_HEADER_JOB_NAME}    Job Name
    Element Should Contain    ${JOB_ORDER_HEADER_ASSIGNED_TO}    Assigned to
    Element Should Contain    ${JOB_ORDER_HEADER_MATERIAL}    Material
    Element Should Contain    ${JOB_ORDER_HEADER_DUE_DATE}    Due Date
    Element Should Contain    ${JOB_ORDER_HEADER_CYCLE_TIME}    Cycle Time
    Element Should Contain    ${JOB_ORDER_HEADER_TIME_TAKEN}    Time Taken
    Element Should Contain    ${JOB_ORDER_HEADER_COMPLETED_ON}    Completed On
    Element Should Contain    ${JOB_ORDER_HEADER_STATUS}    Status
    Element Should Contain    ${JOB_ORDER_HEADER_ACTIONS}    Actions

Verify The UI Of Job Execution Page
    [Documentation]    To Verify The UI Of Job Execution Page
    Wait Until Element Is Visible    ${JOB_ORDER_PAGE_LINK}
    Wait Until Element Is Visible    ${JOB_EXECUTION_PAGE_JOB_NAME}
    Wait Until Element Is Visible    ${JOB_EXECUTION_EXPAND_PROCEDURE}
    Wait Until Element Is Visible    ${JOB_EXECUTION_EXPAND_SECOND_PROCEDURE}
    Wait Until Element Is Visible    ${JOB_EXECUTION_RESET_STEP_BUTTON}
    Wait Until Element Is Visible    ${JOB_EXECUTION_CYCLE_TIME}
    Wait Until Element Is Visible    ${PAUSE_BUTTON}
    Wait Until Element Is Visible    ${FINISH_BUTTON_HEADER}

Verify Step Status Update In Side Panel
    [Documentation]    To Verify Step Status Update In Side Panel

    Wait For The Element And Click    ${JOB_EXECUTION_EXPAND_SECOND_PROCEDURE}
    Click On The Step In Job Execution    3    IGNORE_STEP=True

    Click on Fail button
    Fill the NCR report
    Click on done button in NCR

#    Wait For The Element And Click    ${JOB_EXECUTION_EXPAND_PROCEDURE}
    ${STEPS_IN_JOB_EXECUTION}=    Get Element Count    ${ALL_STEPS_IN_JOB}
    Should Be True    ${STEPS_IN_JOB_EXECUTION}==4

    Click On The Step In Job Execution    1
    Mark The Step As Completed
    Mark The Step As Completed

    Wait For The Element And Click    ${STEP_VIEWER_COLLAPSE_BUTTON}
    ${COMPLETED_STEPS}=    Get Element Count    ${JOB_EXECUTION_COMPLETED_STEPS}
    Should Be True    ${COMPLETED_STEPS}==3

    ${FAILED_STEPS}=    Get Element Count    ${JOB_EXECUTION_FAILED_STEPS}
    Should Be True    ${FAILED_STEPS}==1

    ${UNEXECUTED_STEPS}=    Get Element Count    ${JOB_EXECUTION_UNEXECUTED_STEPS}
    Should Be True    ${UNEXECUTED_STEPS}==1





Get First BOM Item Data
    [Documentation]    To Get First BOM Item Data
    ${TD_FIRST_BOM_NAME}=    Get Text    ${FIRST_BOM_NAME}
    ${TD_FIRST_BOM_NAME}=    Strip String    ${TD_FIRST_BOM_NAME}
    ${TD_FIRST_BOM_NAME}=    Remove Trailing Dots    ${TD_FIRST_BOM_NAME}
    Set Test Variable    ${TD_FIRST_BOM_NAME}

    ${TD_FIRST_BOM_DESCRIPTION}=    Get Text    ${FIRST_BOM_DESCRIPTION}
    ${TD_FIRST_BOM_DESCRIPTION}=    Strip String    ${TD_FIRST_BOM_DESCRIPTION}
    ${TD_FIRST_BOM_DESCRIPTION}=    Remove Trailing Dots    ${TD_FIRST_BOM_DESCRIPTION}
    Set Test Variable    ${TD_FIRST_BOM_DESCRIPTION}

    ${TD_FIRST_BOM_QUANTITY}=    Get Text    ${FIRST_BOM_QUANTITY}
    ${TD_FIRST_BOM_QUANTITY}=    Strip String    ${TD_FIRST_BOM_QUANTITY}
    Set Test Variable    ${TD_FIRST_BOM_QUANTITY}

    ${TD_FIRST_BOM_UoM}=    Get Text    ${FIRST_BOM_UoM}
    ${TD_FIRST_BOM_UoM}=    Strip String    ${TD_FIRST_BOM_UoM}
    Set Test Variable    ${TD_FIRST_BOM_UoM}


Get First BOT Item Data
    [Documentation]    To Get First BOT Item Data
    ${TD_FIRST_BOT_NAME}=    Get Text    ${FIRST_BOT_NAME}
    ${TD_FIRST_BOT_NAME}=    Strip String    ${TD_FIRST_BOT_NAME}
    ${TD_FIRST_BOT_NAME}=    Remove Trailing Dots    ${TD_FIRST_BOT_NAME}
    Set Test Variable    ${TD_FIRST_BOT_NAME}

    ${TD_FIRST_BOT_DESCRIPTION}=    Get Text    ${FIRST_BOT_DESCRIPTION}
    ${TD_FIRST_BOT_DESCRIPTION}=    Strip String    ${TD_FIRST_BOT_DESCRIPTION}
    ${TD_FIRST_BOT_DESCRIPTION}=    Remove Trailing Dots    ${TD_FIRST_BOT_DESCRIPTION}
    Set Test Variable    ${TD_FIRST_BOT_DESCRIPTION}

    ${TD_FIRST_BOT_QUANTITY}=    Get Text    ${FIRST_BOT_QUANTITY}
    ${TD_FIRST_BOT_QUANTITY}=    Strip String    ${TD_FIRST_BOT_QUANTITY}
    Set Test Variable    ${TD_FIRST_BOT_QUANTITY}

    ${TD_FIRST_BOT_UoM}=    Get Text    ${FIRST_BOT_UoM}
    ${TD_FIRST_BOT_UoM}=    Strip String    ${TD_FIRST_BOT_UoM}
    Set Test Variable    ${TD_FIRST_BOT_UoM}

Validate The BOM Details In Modal
    [Documentation]    To Validate The BOM Details In Modal
    Click Element    ${FIRST_BOM_ITEM}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_HEADER_TITLE}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_NAME_KEY}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_QUANTITY_KEY}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_UOM_KEY}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_DESC_KEY}
    Wait Until Element Is Visible    ${FIRST_BOM_MODAL_IMG}

    Element Should Contain    ${FIRST_BOM_MODAL_NAME_VALUE}    ${TD_FIRST_BOM_NAME}
    Element Should Contain    ${FIRST_BOM_MODAL_QUANTITY_VALUE}    ${TD_FIRST_BOM_QUANTITY}
    Element Should Contain    ${FIRST_BOM_MODAL_UOM_VALUE}    ${TD_FIRST_BOM_UoM}
    Element Should Contain    ${FIRST_BOM_MODAL_DESC_VALUE}    ${TD_FIRST_BOM_DESCRIPTION}

    Wait For The Element And Click    ${FIRST_BOM_MODAL_DONE_BUTTON}

Validate The BOT Details In Modal
    [Documentation]    To Validate The BOT Details In Modal
    Click Element    ${FIRST_BOT_ITEM}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_HEADER_TITLE}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_NAME_KEY}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_QUANTITY_KEY}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_UOM_KEY}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_DESC_KEY}
    Wait Until Element Is Visible    ${FIRST_BOT_MODAL_IMG}

    Element Should Contain    ${FIRST_BOT_MODAL_NAME_VALUE}    ${TD_FIRST_BOT_NAME}
    Element Should Contain    ${FIRST_BOT_MODAL_QUANTITY_VALUE}    ${TD_FIRST_BOT_QUANTITY}
    Element Should Contain    ${FIRST_BOT_MODAL_UOM_VALUE}    ${TD_FIRST_BOT_UoM}
    Element Should Contain    ${FIRST_BOT_MODAL_DESC_VALUE}    ${TD_FIRST_BOT_DESCRIPTION}

    Wait For The Element And Click    ${FIRST_BOT_MODAL_DONE_BUTTON}

Add Comment And Save
    [Documentation]    To Add Comment And Save
    ${RANDOM_COMMENT}=    Generate Random Statement
    Add Item To List    ITEM=${RANDOM_COMMENT}   VAR_NAME=COMMENTS_LIST
    Scroll Element And Enter Value    ${COMMENT_INPUT}    ${RANDOM_COMMENT}
    Wait For The Element And Click    ${COMMENT_CREATE_BUTTON}

Add Comments To Procedure In Job Execution
    [Documentation]    Add Comments To Procedure In Job Execution
    Wait For The Element And Click    ${PROCEDURE_COMMENT_ICON_IN_JOB_EXECUTION}

    # Add comments
    Add Comment And Save
    Add Comment And Save

    # Add a reply
    Scroll Element And Enter Value    ${INPUT_SEARCH}    Operator
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${COMMENT_TEXT}    ${COMMENTS_LIST[1]}
    Wait For The Element And Click    ${COMMENT_REPLY_BUTTON}
    Add Comment And Save

    #Verify No Empty comment
    Element Should Be Disabled    ${COMMENT_CREATE_BUTTON}
    ${RANDOM_COMMENT}=    Generate Random Statement
    Input Text    ${COMMENT_INPUT}    ${RANDOM_COMMENT}
    Element Should Be Enabled    ${COMMENT_CREATE_BUTTON}
    Clear Element Text    ${COMMENT_INPUT}
    Wait For The Element And Click    ${COMMENT_CANCEL_BUTTON}


Validate The Added Comments
    [Documentation]    To Validate The Added Comments
    Wait Until Element Is Visible    ${PROCEDURE_COMMENT_ICON_IN_JOB_EXECUTION}    ${Max_limit}
    Wait For The Element And Click    ${PROCEDURE_COMMENT_ICON_IN_JOB_EXECUTION}
    Wait For The Page To Load

    #Verify the comments are added in order
    Element Should Contain    ${COMMENT_TEXT}    ${COMMENTS_LIST[1]}
    Element Should Contain    ${SECOND_COMMENT_TEXT}    ${COMMENTS_LIST[0]}

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    Log To Console    ${TODAY_DATE}
    Log               ${TODAY_DATE}

#    #Verify All comments
#    FOR    ${COMMENT}    IN    @{COMMENTS_LIST[::-1][1:]}
#        Scroll Element And Enter Value    ${INPUT_SEARCH}    ${COMMENT}
#        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${COMMENT_TEXT}    ${COMMENT}
#        Element Should Be Visible    ${COMMENTER_PROFILE_LOGO}
#        Element Should Contain    ${COMMENTER_NAME}    ${AUTHOR1_NAME}
#        Element Should Contain    ${COMMENT_DATE}    ${TODAY_DATE}
#    END

    #Verify the Reply
    Wait For The Element And Click    ${COMMENT_EXPAND}
    Wait Until Page Contains Element    ${REPLY_PROFILE_LOGO}
    Element Should Contain    ${REPLY_TEXT}    ${COMMENTS_LIST[-1]}
    Element Should Contain    ${REPLY_DATE}    ${TODAY_DATE}


Verify The UI Of The Troubleshoot Window
    [Documentation]    To Verify The UI Of The Troubleshoot Window
    Wait For The Element And Click    ${TROUBLESHO0T_ICON}
    Wait Until Element Is Visible    ${TROUBLESHO0T_HEADER}    ${Max_limit}
    Wait Until Element Is Visible    ${POSSIBLE_CAUSE_TITLE}    ${Max_limit}
    Wait Until Element Is Visible    ${CORRECTIVE_ACTION_TITLE}
    Wait Until Element Is Visible    ${PREVENTIVE_ACTION_TITLE}
    Wait Until Element Is Visible    ${TROUBLESHO0T_LISTED_ISSUE}
    Wait Until Element Is Visible    ${TROUBLESHO0T_CANCEL_BUTTON}
    Wait Until Element Is Visible    ${TROUBLESHO0T_SUBMIT_REPORT}

    Element Should Contain    ${TROUBLESHO0T_POSSIBLE_CAUSE_VALUE}    ${PT_PossibleCause}
    Element Should Contain    ${TROUBLESHO0T_CORRECTIVE_ACTION_VALUE}    ${PT_CorrectiveAction}
    Element Should Contain    ${TROUBLESHO0T_PREVENTIVE_ACTION_VALUE}    ${PT_PreventiveAction}
    Wait For The Element And Click    ${TROUBLESHO0T_CANCEL_BUTTON}
    Wait Until Element Is Not Visible    ${TROUBLESHO0T_CANCEL_BUTTON}


Submit The NCR Report If the Issue Is Not Listed
    [Documentation]    To Submit The NCR Report If the Issue Is Not Listed
    Wait For The Element And Click    ${TROUBLESHO0T_ICON}
    ${RANDOM}=    Generate Random Statement
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${RANDOM}
    Wait Until Element Is Not Visible    ${TROUBLESHO0T_LISTED_ISSUE}

    Click Element    ${TROUBLESHO0T_SUBMIT_REPORT}
    Click Element    ${ncr_cancel_btn}
    Page Should Not Contain    ${Preventive_Troubleshooting_Title}

    Click Element    ${TROUBLESHO0T_SUBMIT_REPORT}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${NCR_POPUP_CROSS_BUTTON}
    Page Should Not Contain    Non conformance report

    Click Element    ${TROUBLESHO0T_SUBMIT_REPORT}
    Fill the NCR report
    Click on done button in NCR

Create Procedure With Attachments
    [Documentation]    To Create Procedure With Attachments
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    Add The Cycle Time To The Procedure
    User adds PPE to the procedure
    User Add Step To Procedure
    User adds Image attachments to the procedure
    User adds Video attachments to the procedure
    User adds PDF attachments to the procedure
    User Publishes The Procedure
    User Adds Release Notes

Create Procedure For Job Execution
    [Documentation]    Create Procedure For Job Execution
    [Arguments]    ${SAVE_DATA}=False
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    Add The Cycle Time To The Procedure
    User adds PPE to the procedure
    User Add Step To Procedure    16
    Click On The Step    1
    User adds Image attachments to the procedure
    User adds Video attachments to the procedure
    User adds PDF attachments to the procedure
    Verify that user is able to see icons of attachments
    Click On The Step    2
    User adds Preventive Troubleshooting to Step
    Click On The Step    3
    User Adds User Input to Step
    User Is Able To Save And Preview The User Input
    User add Options to Step
    Add Parts&Tools To Step   BOM
    Add Parts&Tools To Step   BOT
    Add Parts&Tools To Step   COM
    User Publishes The Procedure
    User Adds Release Notes
    Run Keyword If    ${SAVE_DATA}    Save Validation Data

Verify The Material Number Filter Functionality
    [Documentation]    To Verify The Material Number Filter Functionality
    Click On Filter Button
    Wait For The Element And Click    ${MATERIAL_FILTER_PANEL}
    Wait For The Element And Click    ${MATERIAL_FILTER_MORE_BUTTON}
    ${TD_MATERIAL_NUMBER}=    Get Text    (//mat-panel-title[normalize-space()='Material']//ancestor::mat-expansion-panel//search-bar//following-sibling::div//label)[1]
    ${TD_MATERIAL_NUMBER}=    Strip String    ${TD_MATERIAL_NUMBER}
    Set Variable    ${TD_MATERIAL_NUMBER}
    ${LOCATOR}=    Replace String    ${MATERIAL_NUMBER_FILTER_OPTION}    MATERIAL_NUMBER    ${TD_MATERIAL_NUMBER}
    Wait For The Element And Click    ${LOCATOR}
    Apply The Filters

    Wait For The Page To Load
    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    #Validate the Material Number Filters
    ${ALL_MATERIAL_NUMBER}=    Get Values In List For Validation    ${ALL_MATERIAL_NUMBERS_ON_CURRENT_PAGE}    1    ${MAX_LIMIT}
    Validate The Extracted List Data    ${ALL_MATERIAL_NUMBER}    ${TD_MATERIAL_NUMBER}

Apply Status Filter
    [Documentation]    To Apply Status Filter
    [Arguments]    ${FILTER}
    Click On Filter Button
    Wait For The Element And Click    ${STATUS_FILTER_PANEL}
    ${LOCATOR}=    Replace String    ${STATUS_FILTER_OPTION}    STATUS    ${FILTER}
    Wait For The Element And Click    ${LOCATOR}
    Apply The Filters
    Wait For The Page To Load


Verify The Status Filter Functionality
    [Documentation]    To Verify The Status Filter Functionality
    [Arguments]    ${ALL_ACTIVE_RECORDS}=False
    ${ALL_STATUS_FILTER}=    Create List    Not Started    In Progress    Completed    Failed
    IF    '${ALL_ACTIVE_RECORDS}'=='True'
        ${ALL_STATUS_FILTER}=    Create List    Active
    END
    FOR    ${FILTER}    IN    @{ALL_STATUS_FILTER}
        Apply Status Filter    ${FILTER}
        #Validate the Filter
        ${ALL_RECORDS}=    Get Current Record Count On Page
        IF    ${ALL_RECORDS}==0
            Click On Filter Button
            Clear All Filters And Apply Changes
        END
        Continue For Loop If       ${ALL_RECORDS}==0
        ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
        ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
        ${ALL_STATUS}=    Get Values In List For Validation    ${ALL_STATUS_ON_CURRENT_PAGE}    1    ${MAX_LIMIT}
        Validate The Extracted List Data    ${ALL_STATUS}    ${FILTER}
        Click On Filter Button
        Clear All Filters And Apply Changes
    END


Verify The Due Date Filter Functionality
    [Documentation]    To Verify The Due Date Filter Functionality

    Click On Filter Button
    Clear All Filters And Apply Changes

    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    Click On Filter Button
    Wait For The Element And Click    ${DUEDATE_FILTER_PANEL}

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    ${TOMORROW_DATE}=    Evaluate    (datetime.datetime.strptime('${TODAY_DATE}', '%b %d, %Y') + datetime.timedelta(days=1)).strftime('%b %d, %Y')    modules=datetime
    Log    Expected tomorrow: ${TOMORROW_DATE}
    
    Press Keys    None    ARROW_DOWN
    Wait For The Element And Click    ${JOB_FILTERS_DUEDATE_SELECT}

    # Get current time and process date values
    ${NOW}=           Get Time
    ${TODAY_MONTH}=   Evaluate    datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S').strftime('%m')    modules=datetime
    ${TOMORROW_DAY}=  Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') + datetime.timedelta(days=1)).strftime('%d')    modules=datetime
    ${TOMORROW_MONTH}=    Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') + datetime.timedelta(days=1)).strftime('%m')    modules=datetime

   # Convert to integer for proper comparison
    ${TODAY_MONTH}=    Convert To Integer    ${TODAY_MONTH}
    ${TOMORROW_DAY}=   Convert To Integer    ${TOMORROW_DAY}
    ${TOMORROW_MONTH}=    Convert To Integer    ${TOMORROW_MONTH}

    # If the month changes, click to go to the next month
    Run Keyword If    '${TOMORROW_MONTH}' != '${TODAY_MONTH}'    Click Element    ${btn_next_month}
    ${TOMORROW_DAY}=    Convert To String    ${TOMORROW_DAY}
    ${TOMORROW_LOCATOR}=    Replace String    ${DUE_DATE_FILTER_TOMORROW_LOCATOR}    TOMORROW    ${TOMORROW_DAY}
    Wait For The Element And Click    ${TOMORROW_LOCATOR}
    Wait For The Element And Click    ${TOMORROW_LOCATOR}
    Apply The Filters
    Wait For The Page To Load


    #Validate the Filter
    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    ${ALL_DUE_DATES}=    Get Values In List For Validation    ${ALL_DUE_DATES_ON_CURRENT_PAGE}    1    ${MAX_LIMIT}
    ${ALL_DUE_DATES}=    Get Date From Date Time    ${ALL_DUE_DATES}
    Validate The Extracted List Data    ${ALL_DUE_DATES}    ${TOMORROW_DATE}

Remove All Filters On Job Listing Page
    [Documentation]    To Remove All Filters On Job Listing Page
    Click On Filter Button
    Clear All Filters And Apply Changes


Verify The Completed Date Filter Functionality
    [Documentation]    To Verify The Completed Date Filter Functionality
    Click On Filter Button
    Clear All Filters And Apply Changes
    Apply Status Filter    Completed
    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    Click On Filter Button
    Wait For The Element And Click    ${DUEDATE_FILTER_PANEL}
    Press Keys    None    ARROW_DOWN
    Wait For The Element And Click    ${COMPLETED_ON_FILTER_PANEL}
    Wait For The Element And Click    ${JOB_FILTERS_COMPLETED_ON_DATE_SELECT}
    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    ${YESTERDAY_DATE}=    Evaluate    (datetime.datetime.strptime('${TODAY_DATE}', '%b %d, %Y') - datetime.timedelta(days=1)).strftime('%b %d, %Y')    modules=datetime
    Log    Expected YESTERDAY: ${YESTERDAY_DATE}


    # Get current time and process date values
    ${NOW}=           Get Time
    ${TODAY_MONTH}=   Evaluate    datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S').strftime('%m')    modules=datetime
    ${YESTERDAY_DAY}=  Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') - datetime.timedelta(days=1)).strftime('%d')    modules=datetime
    ${TODAY_DAY}=  Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S')).strftime('%d')    modules=datetime
    ${YESTERDAY_month}=    Evaluate    (datetime.datetime.strptime('${NOW}', '%Y-%m-%d %H:%M:%S') - datetime.timedelta(days=1)).strftime('%m')    modules=datetime

   # Convert to integer for proper comparison
    ${TODAY_MONTH}=    Convert To Integer    ${TODAY_MONTH}
    ${YESTERDAY_DAY}=   Convert To Integer    ${YESTERDAY_DAY}
    ${YESTERDAY_month}=    Convert To Integer    ${YESTERDAY_month}

    # If the month changes, click to go to the next month
    Run Keyword If    '${YESTERDAY_month}' != '${TODAY_MONTH}'    Click Element    ${btn_prev_month}
    ${YESTERDAY_DAY}=    Convert To String    ${YESTERDAY_DAY}
    ${TODAY_DAY}=    Convert To String    ${TODAY_DAY}
    ${YESTERDAY_LOCATOR}=    Replace String    ${COMPLETED_ON_DATE_FILTER_YESTERDAY_LOCATOR}    YESTERDAY    ${YESTERDAY_DAY}
    ${TODAY_LOCATOR}=    Replace String    ${COMPLETED_ON_DATE_FILTER_TODAY_LOCATOR}    TODAY    ${TODAY_DAY}
    Click Element By JS    ${TODAY_LOCATOR}
    Click Element By JS    ${TODAY_LOCATOR}
    Apply The Filters
    Wait For The Page To Load


    #Validate the Filter
    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    ${ALL_COMPLETED_ON_DATES}=    Get Values In List For Validation    ${ALL_COMPLETED_ON_DATES_ON_CURRENT_PAGE}    1    ${MAX_LIMIT}
    ${ALL_COMPLETED_ON_DATES}=    Get Date From Date Time    ${ALL_COMPLETED_ON_DATES}
    Validate The Extracted List Data    ${ALL_COMPLETED_ON_DATES}    ${TODAY_DATE}

Verify The Assigned To Filter Functionality
    [Documentation]    To Verify The Assigned To Filter Functionality
    Wait For The Element And Click    ${ASSIGNEDTO_FILTER_PANEL}
    ${LOCATOR}=    Replace String    ${ASSIGNED_TO_FILTER_OPTION}    ASSIGNED_TO    ${AUTHOR1_NAME}
    Wait For The Element And Click    ${LOCATOR}
    Apply The Filters

    ${MAX_LIMIT}=    Get Element Count    ${RECORDS_ON_CURRENT_PAGE}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT}-1
    #Validate the Material Number Filters
    ${ALL_ASSIGNED_TO}=    Get Values In List For Validation    ${ALL_ASSIGNED_TO_ON_CURRENT_PAGE}    1    ${MAX_LIMIT}
    Validate The Extracted List Data    ${ALL_ASSIGNED_TO}    ${AUTHOR1_NAME}



Empty The Job List Page
    [Documentation]    To Empty The Job List Page

    ${COUNT}=    Get Current Record Count On Page
    FOR    ${IT}    IN RANGE    ${COUNT}
        Wait Until Element Is Visible    ${DELETE_JOB}
        Click Element By JS    ${DELETE_JOB}
        Wait For The Element And Click    ${DELETE_JOB_POPUP_BUTTON}
        Wait For The Page To Load
    END
    Wait Until Element Is Not Visible    ${ToasterMessage}    ${Max_limit}
    
Assign Job To User From Details Page    
    [Documentation]    To Assign Job To User From Details Page     
    [Arguments]    ${USER}    ${JUST_ASSIGN}=True
    Wait Until Element Is Visible    ${ASSIGN_JOB_TO_USER_DETAILS_PAGE_SELECT}
    Click Element    ${ASSIGN_JOB_TO_USER_DETAILS_PAGE_SELECT}
    
    #selcting user
    ${LOCATOR}=    Replace String    ${ASSIGN_JOB_TO_USER_OPTION}    USERNAME    ${${USER}}
    Click Element By JS    ${LOCATOR}
    IF    '${JUST_ASSIGN}'=='True'
        Return From Keyword
    END
    Click Element    ${JobNext_Done}
    Click Element    ${btn_create}


Verify The Operator Is Not Able To Complete Job Without Getting Training
    [Documentation]    To Verify The Operator Is Not Able To Complete Job Without Getting Training
    Wait Until Element Is Visible    ${RIGHT_JOB_RIGHT_SKILL_MESSAGE}
    Element Should Contain    ${RIGHT_JOB_RIGHT_SKILL_REQUIRED_TRAINING_NAME}    ${TD_SKILL_NAME}

Reset The Procedure Step
    [Documentation]    To Reset The Procedure Step
    Run Keyword And Ignore Error    Close User Input Popup
    Wait For The Element And Click    ${RESET_STEP_IN_JOB_EXECUTION}
    Wait Until Element Is Not Visible    ${RESET_STEP_IN_JOB_EXECUTION}

Verify The User Input Value Is Reset
    [Documentation]    To Verify The User Input Value Is Reset
    
    Wait Until Element Is Visible    ${USER_INPUT_RESET_SELECT}

    ${CLASS}=    Get Element Attribute    ${DROPDOWN_IN_USER_INPUT_POPUP}    class
    Should Contain    ${CLASS}    mat-mdc-select-empty


Navigate To Job List Page From Paused Screen
    [Documentation]    To Navigate To Job List Page From Paused Screen
    Wait For The Element And Click    ${PAUSE_EXECUTION_BACK_TO_JOB_ORDER_BUTTON}

Verify The UI Of The Paused Job Screen And Resume Execution
    [Documentation]    To Verify The UI Of The Paused Job Screen And Resume Execution
    
    
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_DIALOG_HEADER}    ${Max_limit}
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_DIALOG_TIMER}
    
    ${TIME1}=    Get Text    ${PAUSE_EXECUTION_DIALOG_TIMER}
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_BACK_TO_JOB_ORDER_BUTTON}

    Sleep    1s
    ${TIME2}=    Get Text    ${PAUSE_EXECUTION_DIALOG_TIMER}
    
    Should Not Be Equal As Strings    ${TIME1}    ${TIME2}
    Wait For The Element And Click    ${PAUSE_EXECUTION_RESUME_BUTTON}
    Wait For The Page To Load


Click On The Reset Icon From Header
    [Documentation]    To Click On The Reset Icon From Header
    Wait For The Element And Click    ${JOB_EXECUTION_RESET_STEP_BUTTON}
    
    
Get Procedures List In Job Execution Screen
    [Documentation]    To Get Procedures List In Job Execution Screen
    ${END_LIMIT}=    Get Element Count    ${PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}
    ${ALL_PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}=    Get Values In List For Validation    (${PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN})[INDEX]    1    ${END_LIMIT}
    Set Test Variable    ${ALL_PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}

Reset The Job Execution Element
    [Documentation]    To Reset The Job Execution Element
    [Arguments]    ${RESET_TYPE}    ${PROCEDURE_NUMBER}
                  
    ${PROCEDURE_NUMBER_INDEX}    Evaluate    ${PROCEDURE_NUMBER}-1    
    ${PROCEDURE}=    Get From List    ${ALL_PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}    ${PROCEDURE_NUMBER_INDEX}
    
    IF    '${RESET_TYPE}'=='PROCEDURE'
        ${JOB_EXECUTION_PROCEDURE_RESET_LABEL_LOCATOR}=    Replace String    ${JOB_EXECUTION_PROCEDURE_RESET_LABEL}    PROCEDURE    ${PROCEDURE}  
        Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_RESET_LABEL_LOCATOR}
        
    ELSE IF    '${RESET_TYPE}'=='STEP'
        ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
        Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}
        Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_LABEL}
    END
    Wait For The Element And Click    ${JOB_EXECUTION_RESET_POPUP_BUTTON}


Reset The Step Group Step In Job Execution
    [Documentation]    To Reset The Step Group Step In Job Execution
    [Arguments]    ${PROCEDURE_NUMBER}

    ${PROCEDURE_NUMBER_INDEX}    Evaluate    ${PROCEDURE_NUMBER}-1
    ${PROCEDURE}=    Get From List    ${ALL_PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}    ${PROCEDURE_NUMBER_INDEX}

    #Expand The procedure
   ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
   Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}

    #Expand The step group
#   ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
#   Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}
   
    Wait For The Element And Click    ${JOB_EXECUTION_PROCEDURE_STEP_GROUP_RESET_LABEL}
    Wait For The Element And Click    ${JOB_EXECUTION_RESET_POPUP_BUTTON}


Expand The Procedure From The Left Panel  
    [Documentation]    To Expand The Procedure From The Left Panel
    [Arguments]    ${PROCEDURE_NUMBER}
    
    ${IS_EXPANDED}=    Run Keyword And Return Status    Wait Until Page Contains Element    (${JOB_EXECUTION_LEFT_PANEL_PROCEDURE_EXPAND_BUTTON})[${PROCEDURE_NUMBER}]${GENERIC_EXPANDED}
    Run Keyword If    not ${IS_EXPANDED}    Click Element    (${JOB_EXECUTION_LEFT_PANEL_PROCEDURE_EXPAND_BUTTON})[${PROCEDURE_NUMBER}]
      

Verify The Procedure Is Reset In Job Execution
    [Documentation]    To Verify The Procedure Is Reset
    [Arguments]    ${PROCEDURE_NUMBER}
      

    ${PROCEDURE_NUMBER_INDEX}    Evaluate    ${PROCEDURE_NUMBER}-1    
    ${PROCEDURE}=    Get From List    ${ALL_PROCEDURE_DISPLAYED_ON_JOB_EXECUTION_SCREEN}    ${PROCEDURE_NUMBER_INDEX}

    Expand The Procedure From The Left Panel    ${PROCEDURE_NUMBER}
    
    ${JOB_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK_LOCATOR}=    Replace String    ${JOB_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK}    PROCEDURE    ${PROCEDURE}
    Page Should Not Contain Element    ${JOB_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK_LOCATOR}


Verify The Step Group Procedure Step Is Reset IN Job Execution
    [Documentation]    To Verify The Step Group Procedure Step Is Reset IN Job Execution
    Wait Until Page Does Not Contain Element    (${JOB_EXECUTION_PROCEDURE_STEP_GROUP_RESET_CHECK})[2]

Verify The Expert Operator Toggle Functionality
    [Documentation]    To Verify The Expert Operator Toggle Functionality

    Wait Until Element Is Visible    ${EXPERT_MODE_LABEL}
    Wait Until Element Is Visible    ${JOB_EXECUTION_NOVICE_STEP}

    Wait For The Element And Click    ${EXPERT_OPERATOR_TOGGLE_BUTTON}
    Wait Until Element Is Not Visible    ${JOB_EXECUTION_NOVICE_STEP}

    Wait For The Element And Click    ${EXPERT_OPERATOR_TOGGLE_BUTTON}
    Wait Until Element Is Visible    ${JOB_EXECUTION_NOVICE_STEP}

Verify The Cycle Time Is Reset To Default
    [Documentation]    To Verify The Cycle Time Is Reset To Default
    
    Wait Until Element Is Visible    ${JOB_EXECUTION_TIMER_CYCLE_TIME}
    ${TIMER}=    Get Text    ${JOB_EXECUTION_TIMER_CYCLE_TIME}
    ${TIMER}=    Evaluate    '${TIMER}'.split(':')[-1]
    ${TIMER}=    Convert To Integer    ${TIMER}
    
    Should Be True    ${TIMER} <=10



Delete One Record From Job List Page
    [Documentation]    To Delete One Record From List Page
    Wait Until Page Contains Element    ${JOB_LISTING_THREE_DOTS}
    Wait Until Element Is Enabled    ${JOB_LISTING_THREE_DOTS}
    Wait For The Element And Click    ${JOB_LISTING_THREE_DOTS}
    Click Element By JS    ${DELETE_RECORD_ICON_JOB_LISTING_PAGE}
    Wait For The Element And Click    ${DELETE_RECORD_POPUP_BUTTON}
    Wait For The Page To Load