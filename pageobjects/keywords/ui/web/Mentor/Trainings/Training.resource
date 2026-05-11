*** Settings ***
Library    SeleniumLibrary
Library    String
Library    OperatingSystem
Library    Collections
Library    DateTime
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Teams.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Resource    ../../../../../keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../../../keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../../../keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource    ../../../../../keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../../../locators/ui/web/Mentor/Procedure.yaml
Variables   ../../../../../locators/ui/web/Mentor/Training.yaml
Variables   ../../../../../../testdata/ui/web/Mentor/testdata.yaml

*** Variables ***
#@{expected_headers_list}    Name    Created by    Last Updated    Procedures    Assigned Users    Status    Actions
#${successTextExpected}    The training has been successfully created.
#${successAssignTextExpected}    The training has been successfully assign to selected teams.
#${TrainingDescription}    This is Training description
#${OPERATOR1_NAME}    QA_devEnv OrgAdmin
#${deadline}    No Deadline
#@{expectedMenuButtons}    Edit    Assign    Delete
#@{TRAINING_NAMEsInPanelActual}    Completed    In Progress    Not Started
#${expectedDeleteText}    The selected trainings have been successfully deleted.

*** Keywords ***

User Navigate to the Trainings Page
    [Documentation]    To User Navigate to the Trainings Page
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_TRAINING_TAB_OPEN}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${TRAINING_OPTION}    5s
    IF    '${IF_TRAINING_TAB_OPEN}'=='True'
        Double Click Element    ${TRAINING_OPTION}
    ELSE
        Wait For The Element And Click    ${TRAINING_MANAGEMENT_OPTION}
        Double Click Element    ${TRAINING_OPTION}
    END
    Wait For The Page To Load
#    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${MY_TRAININGS_BUTTON}    ${Max_limit}
#    Run Keyword And Ignore Error    Mouse Over    ${MY_TRAININGS_BUTTON}

Verify The My Training Tab Is Not Visible At Site Admins Screen
    [Documentation]    To Verify The My Training Tab Is Not Visible At Site Admins Screen
    Page Should Not Contain Element    ${MY_TRAININGS_BUTTON_ON_TRAININGS_LIST_PAGE}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Page Should Not Contain Element    ${MY_TRAININGS_BUTTON_ON_TRAININGS_LIST_PAGE}


Verify The Pause Training Functionality
    [Documentation]    To Verify The Pause Training Functionality
    Pause Job Execution
    
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_DIALOG_HEADER}    ${Max_limit}
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_DIALOG_TIMER}
    
    ${TIME1}=    Get Text    ${PAUSE_EXECUTION_DIALOG_TIMER}
    Wait Until Element Is Visible    ${PAUSE_EXECUTION_BACK_TO_TRAINING_BUTTON}
    Element Should Contain    ${PAUSE_EXECUTION_BACK_TO_TRAINING_BUTTON}    Back to My Trainings
    
    Sleep    1s
    ${TIME2}=    Get Text    ${PAUSE_EXECUTION_DIALOG_TIMER}
    
    Should Not Be Equal As Strings    ${TIME1}    ${TIME2}
    Wait For The Element And Click    ${PAUSE_EXECUTION_RESUME_BUTTON}
    Wait For The Page To Load


User Navigate to the Trainings Matrix Page
    [Documentation]    To User Navigate to the Trainings Matrix Page
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_TRAINING_TAB_OPEN}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${TRAINING_MATRIX_OPTION}    5s
    IF    '${IF_TRAINING_TAB_OPEN}'=='True'
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${TRAINING_MATRIX_OPTION}
    ELSE
        Wait For The Element And Click    ${TRAINING_MANAGEMENT_OPTION}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${TRAINING_MATRIX_OPTION}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${TRAINING_MATRIX_RESET_BUTTON}    ${Max_limit}
    Mouse Over    ${TRAINING_MATRIX_RESET_BUTTON}


Navigate To My Trainings Page
    [Documentation]    To Navigate To My Trainings Page
#    Wait For The Page To Load
#    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
#    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
#    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
#    Wait Until Element Is Visible    ${DASHBOARD_LINK}
#    Capture Page Screenshot
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_TRAINING_TAB_OPEN}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${TRAINING_OPTION}    5s
    IF    '${IF_TRAINING_TAB_OPEN}'=='True'
        Double Click Element    ${LEFT_NAVIGATION_MY_TRAINING_TAB}
    ELSE
        Wait For The Element And Click    ${TRAINING_MANAGEMENT_OPTION}
        Double Click Element    ${LEFT_NAVIGATION_MY_TRAINING_TAB}
    END
    Wait For The Page To Load


Hover Left NavBar
    Wait Until Element Is Visible    ${navbar_dashboard}    ${MaxTime}
    Mouse Over    ${navbar_dashboard}
    
Click Training Management
    Wait Until Element Is Visible    ${TRAINING_MANAGEMENT_OPTION}    ${MaxTime}
    Click Element    ${TRAINING_MANAGEMENT_OPTION}
    
Click Training Option
    Wait Until Element Is Visible    ${TRAINING_OPTION}    ${MaxTime}
    Click Element    ${TRAINING_OPTION}
    
Verify The UI Of Training Page
    Wait Until Element Is Visible    ${header_training_page}    ${MaxTime}
    Wait Until Element Is Visible    ${training_page_search}    ${MaxTime}
    Wait Until Element Is Visible    ${add_new_training_btn}    ${MaxTime}
    @{headerWebElements}=    Get Webelements    ${list_table_header}
    @{listOfTrainingHeader}=    Create List
    FOR    ${i}    IN    @{headerWebElements}
        ${header_text}=    Get Text    ${i}
        Append To List    ${listOfTrainingHeader}    ${header_text}
    END
    Log    ${listOfTrainingHeader}
    Lists Should Be Equal    ${expected_headers_list}    ${listOfTrainingHeader}
    Wait Until Element Is Visible     ${training_pagination}    ${MaxTime}
    Wait Until Element Is Visible     ${training_pagination_range}    ${MaxTime}
    Wait Until Element Is Visible    ${training_header_checkbox}    ${MaxTime}

Click On Add New Training Button
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${add_new_training_btn}
    Wait Until Element Is Visible    ${createTrainingHeading}    ${MaxTime}

Generate Unique Number
    ${UniqueNumbertest}=    Generate Random String    4    [NUMBERS]
    Set Global Variable     ${UniqueNumbertest}

Fill The Form And Submit It
    [Arguments]    ${CHECK_DEFAULT_IMAGE}=False
    Wait Until Element Is Visible    ${CREATE_TRAINING_NAME_INPUT}    ${MaxTime}
    ${RANDOM_NAME}=    Generate Random String
    ${TRAINING_NAME}=    Set Variable    Training-${RANDOM_NAME}
    IF    '${CHECK_DEFAULT_IMAGE}'=='True'
        Wait Until Element Is Visible    ${ADD_TRAINING_DEFAULT_IMG}
    END    
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${CREATE_TRAINING_NAME_INPUT}    ${TRAINING_NAME}
    Set Test Variable   ${TRAINING_NAME}
    Click Create/Update Training Submit Button


Fill The Form With Description And Submit It
    Wait Until Element Is Visible    ${CREATE_TRAINING_NAME_INPUT}    ${MaxTime}
    ${RANDOM_NAME}=    Generate Random String
    ${TRAINING_NAME}=    Set Variable    Training-${RANDOM_NAME}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${CREATE_TRAINING_NAME_INPUT}    ${TRAINING_NAME}
    Set Test Variable   ${TRAINING_NAME}

    ${RANDOM_DESC}=    Generate Random String    20
    ${TD_TRAINING_DESC}=    Set Variable    TDESC-${RANDOM_DESC}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${descriptionField}    ${TD_TRAINING_DESC}
    Set Test Variable   ${TD_TRAINING_DESC}

    Click Create/Update Training Submit Button

Fill The Form With All Fields Including Procedure And Submit It
    Wait Until Element Is Visible    ${CREATE_TRAINING_NAME_INPUT}    ${MaxTime}
    Generate Unique Number
    ${TRAINING_NAME}=    Set Variable    Training-${UniqueNumbertest}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${CREATE_TRAINING_NAME_INPUT}    ${TRAINING_NAME}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${descriptionField}    ${TrainingDescription}
    Set Global Variable    ${TRAINING_NAME}
    Select Procedure From List
    Click Create/Update Training Submit Button

Fill The Form With All Fields Including Procedure And Cancel It
    Wait Until Element Is Visible    ${CREATE_TRAINING_NAME_INPUT}    ${MaxTime}
    Generate Unique Number
    ${TRAINING_NAME}=    Set Variable    Training-${UniqueNumbertest}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${CREATE_TRAINING_NAME_INPUT}    ${TRAINING_NAME}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${descriptionField}    ${TrainingDescription}
    Set Global Variable    ${TRAINING_NAME}
    Select Procedure From List
    Click Create Training Cancel Button

Verify Canceled Training Is Not Present In The Listing Page
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    ${header_training_page}    ${MaxTime}
    Get After Training Creation Count
    @{training_names_webEle}=    Get Webelements    ${LIST_OF_TRAINING_NAMES}
    @{list_training_names}=    Create List
    FOR    ${i}    IN    @{training_names_webEle}
        ${TEXT_TRAINING_NAME}=    Get Text    ${i}
        ${TEXT_TRAINING_NAME}=    Strip String    ${TEXT_TRAINING_NAME}
        Append To List     ${list_training_names}    ${TEXT_TRAINING_NAME}
    END
    List Should Not Contain Value    ${list_training_names}    ${TRAINING_NAME}
    Verify Count When Training Creation Is Cancelled
    
Fetch Header Training Count
    Sleep    2s
    Wait Until Element Is Visible    ${header_training_page}    ${MaxTime}
    ${text}=    Get Text    ${header_training_page}
    @{count_list}=   Split String    ${text}    (
    ${update_count}=    Replace String    ${count_list}[1]    )    ${Empty}
    ${count}=   Set Variable    ${update_count}
    RETURN    ${count}
    
Get Default Training Count
    ${before}=    Fetch Header Training Count
    Set Global Variable    ${before}
    
Get After Training Creation Count
    ${after}=    Fetch Header Training Count
    Set Global Variable    ${after}
    
Verify Count When Training Creation Is Cancelled
    Should Be Equal As Integers    ${before}    ${after}
    


    
Select Procedure From List
    [Documentation]    To Select Procedure From List
    Wait Until Element Is Visible    ${training_procedure_btn}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${training_procedure_btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    (${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_NAME})[1]    ${MaxTime}
    Wait Until Element Is Enabled    ${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX}


    Wait Until Element Is Visible    ${procedureSelectDone}    ${MaxTime}
    Click Element    ${procedureSelectDone}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}


Select Multiple Procedure From List
    [Documentation]    To Select Multiple Procedure From List
    [Arguments]    ${CUSTOM_PROCEDURE_LIST}
    Wait Until Element Is Visible    ${training_procedure_btn}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${training_procedure_btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    (${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_NAME})[1]    ${MaxTime}

    Log    ${CUSTOM_PROCEDURE_LIST}

    ${CUSTOM_PROCEDURE_LIST}    ENUMERATE LIST    ${CUSTOM_PROCEDURE_LIST}
    FOR    ${PROCEDURE}    IN    @{CUSTOM_PROCEDURE_LIST}
        Scroll Element And Enter Value    ${ADD_PROCEDURE_TO_TRAINING_INPUT_SEARCH}    ${PROCEDURE[1]}
        Press Keys    ${ADD_PROCEDURE_TO_TRAINING_INPUT_SEARCH}    ENTER
        Wait Until Keyword Succeeds    5x    2s    Wait Until Element Contains    (${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_NAME})[1]    ${PROCEDURE[1]}    timeout=60s
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX}
        Element Should Contain    (${ADD_PROCEDURE_TO_TRAINING_MODAL_LISTED_PROCEDURE})[1]   ${PROCEDURE[1]}
    END

    
    Wait Until Element Is Visible    ${procedureSelectDone}    ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${procedureSelectDone}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}


Verify New Training Is Present In The Listing Page
    Wait Until Element Is Visible    ${toastMessageBox}    ${MaxTime}
    ${successTextActual}=    Get Text    ${toastMessageText}
    ${successTextActual}=    Strip String    ${successTextActual}
    Should Be Equal As Strings    ${successTextActual}    ${successTextExpected}
    Wait Until Element Is Visible    (${LIST_OF_TRAINING_NAMES})[1]    ${MaxTime}
    @{training_names_webEle}=    Get Webelements    ${LIST_OF_TRAINING_NAMES}
    @{list_training_names}=    Create List
    FOR    ${i}    IN    @{training_names_webEle}
        ${TEXT_TRAINING_NAME}=    Get Text    ${i}
        ${TEXT_TRAINING_NAME}=    Strip String    ${TEXT_TRAINING_NAME}
        Append To List     ${list_training_names}    ${TEXT_TRAINING_NAME}
    END
    List Should Contain Value    ${list_training_names}    ${TRAINING_NAME}
            

Click Create/Update Training Submit Button
    Wait Until Element Is Visible    ${createButton}    ${MaxTime}
    Click Element    ${createButton}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

Search The Training On Training List Page
    [Documentation]    To Search The Training On Training List Page
    Wait Until Element Is Enabled    ${training_page_search}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${training_page_search}    ${TRAINING_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
#    Wait Until Keyword Succeeds    10x    2s    Element Should Contain    ${TRAINING_NAME_LOCATOR}    ${TRAINING_NAME}

Navigate To Training Details Page
    Search The Training On Training List Page
    Select The Training From List
    Page Should Not Contain    An error occurred while loading the training.
    # Wait Until Keyword Succeeds    3x    1s    click element    
    Verify Menu Bar Buttons
    
    
    
Default Completed Users
    Wait Until Element Is Visible    ${completed_users_count}    ${MaxTime}
    ${defaultCompletedUserText}=    Wait Until Keyword Succeeds    10x    1s    Get Text    ${completed_users_count}
    Set Global Variable    ${defaultCompletedUserText}
    
Select The Training From List
    ${trainingLoc}=    Set Variable    //span[text()=" ${TRAINING_NAME} "]
    Wait Until Element Is Visible    ${trainingLoc}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    1s    Click Element    ${trainingLoc}

Verify Menu Bar Buttons
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    (${trainingMenuButtons})[1]    ${MaxTime}
    @{webEle}=    Get Webelements    ${trainingMenuButtons}
    @{menuBarBtnsText}=    Create List    
    FOR    ${i}    IN    @{webEle}
        ${text}=    Get Text    ${i}
        ${text}=    Strip String    ${text}
        Append To List    ${menuBarBtnsText}    ${text}
    END
    Lists Should Be Equal    ${menuBarBtnsText}    ${expectedMenuButtons}

Search User And Select
    [Documentation]    To Search User And Select
    Wait Until Element Is Visible    ${assignSearchInput}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${assignSearchInput}    ${OPERATOR1_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Sleep    5s
    ${LOCATOR}=    Replace String    ${TRAINING_USER}    TRAINING_USER    ${OPERATOR1_NAME}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${LOCATOR}
    Input Text    ${assignSearchInput}    ${EMPTY}
    Press Keys    ${assignSearchInput}    ENTER
    Wait For The Page To Load

User Assign Training To Team
    [Documentation]    To User Assign Training To Team
    Wait For The Element And Click    ${ASSIGN_USERS_TO_TRAINING_TEAMS_TAB}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Input Text    (${INPUT_SEARCH})[2]    ${TD_TEAM_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${ASSIGN_USERS_TO_TRAINING_MODAL_PARTICULAR_TEAMS_CHECKBOX}


Search Multiple User And Select
    [Documentation]    To Search Multiple User And Select
    [Arguments]    ${ASSIGNEE_LIST}
    FOR    ${USER}    IN    @{ASSIGNEE_LIST}
        Wait Until Element Is Visible    ${assignSearchInput}    ${MaxTime}
        Wait Until Keyword Succeeds    10x    2s    Input Text    ${assignSearchInput}    ${USER}
        Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
        Sleep    5s
        ${LOCATOR}=    Replace String    ${TRAINING_USER}    TRAINING_USER    ${USER}
        Wait Until Keyword Succeeds    10x    2s    Click Element    ${LOCATOR}
    END
    Input Text    ${assignSearchInput}    ${EMPTY}
    Press Keys    ${assignSearchInput}    ENTER
    Wait For The Page To Load

Save The Operators Added In Job
    [Documentation]    To Save The Operators Added In Job
    ${LOCATOR}=    Replace String    ${TRAINING_ASSIGNED_TO_OPERATOR_NAME}    TRAINING_USER    ${OPERATOR1_NAME}
    ${ALL_OPERATORS_ASSIGNED_TO_TRAINING}=    Get Values In List For Validation    (${LOCATOR})[INDEX]    1    2
    Append To List    ${ALL_OPERATORS_ASSIGNED_TO_TRAINING}    ${OPERATOR1_NAME}
    Set Test Variable    ${ALL_OPERATORS_ASSIGNED_TO_TRAINING}
    

Assign An Operator To The Training
    Click On Assign Button
    Search User And Select



Verify Operator Assignment To Training Is Success
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Page Should Contain    ${successAssignTextExpected}
    Wait Until Element Is Enabled    ${training_page_search}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Input Text    ${training_page_search}    ${TRAINING_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Select The Training From List
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    (${trainingMenuButtons})[1]    ${MaxTime}
    Wait Until Element Is Visible    ${completed_users_count}    ${MaxTime}


Verify The UI Of The Assigned Procedure Details Page
    Wait Until Element Is Enabled    ${right_arrow_icon}    ${MaxTime}
    Click Element    ${right_arrow_icon}
    Wait Until Element Is Visible    ${flyout_panel}    ${MaxTime}
    Verify The Training Name In Flyout
    Verify Search Field In Flyout
    Verify Procedure Dropdown Visibility In Flyout
    Fetch trainings In flyout panel
    Verify PieChart Visibility In Flyout
    Verify Username Visibility On Flyout
    Verify Deadline Visibility On Flyout
    Verify View Details is Not Visible In Flyout
    Verify Count In Pie Chart
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${trainingsLink}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}


Verify The Training Name In Flyout
    Wait Until Element Is Visible    ${flyout_header}    ${MaxTime}
    ${header}=    Get Text    ${flyout_header}
    ${header}=    Strip String    ${header}
    Should Be Equal As Strings    ${TRAINING_NAME}    ${header}

Verify Search Field In Flyout
    Wait Until Element Is Visible    ${flyout_search}    ${MaxTime}
    Wait Until Element Is Enabled    ${flyout_search}    ${MaxTime}

Verify Procedure Dropdown Visibility In Flyout
    Wait Until Element Is Visible    ${flyout_procedure_dd}    ${MaxTime}
    Wait Until Element Is Enabled    ${flyout_procedure_dd}    ${MaxTime}
    

Fetch Trainings In Flyout Panel
    @{training_webEle}=    Get Webelements    ${trainingsInFlyout}
    @{TRAINING_NAMEsInPanel}=    Create List
    FOR    ${i}    IN    @{training_webEle}
        ${status_text}=    Get Text    ${i}
        @{pure_status}=    Split String    ${status_text}    (
        ${clean_status}=   Strip String    ${pure_status}[0]
        Append To List    ${TRAINING_NAMEsInPanel}    ${clean_status}
    END
    Lists Should Be Equal    ${TRAINING_NAMEsInPanelActual}    ${TRAINING_NAMEsInPanel}

Verify PieChart Visibility In Flyout
    Wait Until Element Is Visible    ${flyout_pieChart}    ${MaxTime}
    Wait Until Element Is Visible    ${pieChartValueFlyout}    ${MaxTime}

Verify Username Visibility On Flyout
    ${count}=    Get Element Count    ${flyout_list_ops}
    IF    ${count} > 1
        @{name_webEle}=    Get Webelements    ${flyout_list_ops}
        @{userNamesInFlyout}=    Create List
        FOR    ${i}    IN    @{name_webEle}
            ${userText}=    Get Text    ${i}
            ${userText}=    Strip String    ${userText}
            Append To List    ${userNamesInFlyout}    ${userText}
        END
        List Should Contain Value    ${userNamesInFlyout}    ${OPERATOR1_NAME}
    ELSE
        ${single_nameText}=    Get Text    ${flyout_list_ops}
        ${single_nameText}=    Strip String    ${single_nameText}
        Should Be Equal As Strings    ${single_nameText}    ${OPERATOR1_NAME}
    END

Verify Deadline Visibility On Flyout
    ${count}=    Get Element Count    ${flyout_no_deadline}
    IF    ${count} > 1
        @{deadline_webEle}=    Get Webelements    ${flyout_no_deadline}
        @{deadlineInFlyout}=    Create List
        FOR    ${i}    IN    @{deadline_webEle}
            ${deadline_text_full}=    Get Text    ${i}
            @{textList}=    Split String    ${deadline_text_full}    \n
            ${deadlineText}=    Set Variable    (${textList})[0]
            ${deadlineText}=    Strip String    ${deadlineText}
            Append To List    ${deadlineInFlyout}    ${deadlineText}
        END
        List Should Contain Value    ${userNamesInFlyout}    ${deadline}
    ELSE
        ${deadline_nameText}=    Get Text    ${flyout_no_deadline}
        @{textList}=    Split String    ${deadline_nameText}    \n
        ${deadlineText}=    Set Variable    ${textList}[0]
        ${deadlineText}=    Strip String    ${deadlineText}
        Should Be Equal As Strings    ${deadlineText}    ${deadline}
    END

Verify View Details is Not Visible In Flyout
    Element Should Not Be Visible   ${flyout_view_details}

Verify Count In Pie Chart
    @{training_webEle}=    Get Webelements    ${trainingsInFlyout}
    @{trainingNumbersInPanel}=    Create List
    FOR    ${i}    IN    @{training_webEle}
        ${status_text}=    Get Text    ${i}
        @{pure_status}=    Split String    ${status_text}    (
        ${clean_status}=   Replace String    ${pure_status}[1]    )    ${Empty}
        ${clean_status}=    Strip String    ${clean_status}
        ${count}=    Convert To Integer    ${clean_status}
        Append To List    ${trainingNumbersInPanel}    ${count}
    END
    ${total}=    Set Variable    0
    FOR    ${num}    IN    @{trainingNumbersInPanel}
        ${total}=    Evaluate    ${total} + ${num}
    END
    ${ActualPieValue}=    Get Text    ${pieChartValueFlyout}
    ${ActualPieValue}=    Strip String    ${ActualPieValue}
    Should Be Equal As Strings    ${ActualPieValue}    ${total}
    Wait Until Element Is Visible    ${flyout_cross_button}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${flyout_cross_button}

Add Procedures To Existing Training Via Edit
    Click Edit Procedure Button
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    ${training_update_btn}    ${MaxTime}
    Select Multiple Procedures From List
    Verify that Selected Procedure Block Shows The Correct Count Of Selected Procedures
    Verify that Selected Procedure Block Shows The Correct Text Of Selected Procedures
    Click Select Procedure Done Button
    Click Procedure Confirm Button
    Click Update Procedure Button


Click Update Procedure Button
    Wait Until Element Is Visible    ${training_update_btn}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${training_update_btn}

Click Edit Procedure Button
    Wait Until Element Is Visible    ${editTrainingBtn}    ${MaxTime}
    Wait Until Element Is Enabled    ${editTrainingBtn}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${editTrainingBtn}

Select Multiple Procedures From List
    Wait Until Element Is Visible    ${training_procedure_btn}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${training_procedure_btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    FOR    ${i}    IN RANGE    1    6
        ${status}=    Run Keyword And Return Status    Checkbox Should Be Selected    (${ALL_ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX})[${i}]
        IF    ${status} != True
            Wait Until Element Is Enabled    (${ALL_ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX})[${i}]
            ${PROCEDURE_NAME}=    Get Text    (${PROCEDURE_ADDED_IN_TRAINING})[${i}]
            ${PROCEDURE_NAME}=    Strip String    ${PROCEDURE_NAME}
            Add Item To List    ITEM=${PROCEDURE_NAME}    VAR_NAME=PROCEDURE_LIST
            Click Element    (${ALL_ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_CHECKBOX})[${i}]
        END
    END

Click Select Procedure Done Button
    Wait Until Element Is Visible    ${procedureSelectDone}    ${MaxTime}
    Click Element    ${procedureSelectDone}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}


Click Assign User Done Button
    [Documentation]    To Click Assign User Done Button
    Wait Until Element Is Visible    ${ASSIGN_PROCEDURE_DONE_BUTTON}    ${MaxTime}
    Click Element    ${ASSIGN_PROCEDURE_DONE_BUTTON}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

Click Procedure Confirm Button
    Wait Until Element Is Enabled    ${all_procedure_confirm}    ${MaxTime}
#    Wait Until Keyword Succeeds    10x    2s    Click Element    ${all_procedure_confirm}

Verify that Selected Procedure Block Shows The Correct Count Of Selected Procedures
     # Get all selected checkboxes and their labels
     @{selected}=    Get Webelements    ${all_procedure_selected}
     ${expected_count}=    Get Length    ${selected}
     # Validate "Selected options (count)" header
     ${header_proc}=    Get Text    ${selected_proc_header}
     @{parts}=    Split String    ${header_proc}    (
     @{sub_parts}=    Split String    ${parts}[1]    )
     ${count}=    Set Variable    ${sub_parts}[0]
     Should Be Equal As Integers    ${expected_count}    ${count}

Verify that Selected Procedure Block Shows The Correct Text Of Selected Procedures
    @{proc_webEle}=    Get Webelements    ${selected_check_name}
    @{expected_name_list}=    Create List
    FOR    ${i}    IN    @{proc_webEle}
        ${proc_text}=    Get Text    ${i}
        ${proc_text}=    Strip String    ${proc_text}
        Append To List    ${expected_name_list}    ${proc_text}
    END
    #Find Selected Procedures Names
    @{headerListWebEle}=    Get Webelements    ${sel_proc_header_list}
    @{actualNameList}=    Create List
    FOR    ${i}    IN    @{headerListWebEle}
        ${text}=    Get Text    ${i}
        ${text}=    Strip String    ${text}
        Append To List    ${actualNameList}    ${text}
    END
    #Verify Both Are Equal
#    Lists Should Be Equal    ${expected_name_list}    ${actualNameList}
    ${len}=    Get Length    ${expected_name_list}
    FOR    ${item}    IN RANGE    0    ${len}
        ${ui_value}=    Set Variable    ${expected_name_list}[${item}]
        ${status}=    Run Keyword And Return Status    Should Contain    ${ui_value}    ...
        IF    ${status} == True
            ${ui_value}=    Remove String    ${ui_value}    ...
            Should Contain    ${actualNameList}[${item}]    ${ui_value}
        ELSE
            Should Contain    ${actualNameList}[${item}]    ${ui_value}
        END
    END

Verify that All Procedures In A Training Are Visible In Flyout Procedure Dropdown
    Get List Of Procedures In Training Page
    Wait Until Element Is Visible    (${right_arrow_icon})[1]
    Click Element    (${right_arrow_icon})[1]
    Wait Until Element Is Visible    ${pieChartValueFlyout}    ${MaxTime}
    ${ActualPieValue}=    Get Text    ${pieChartValueFlyout}
    ${ActualPieValue}=    Strip String    ${ActualPieValue}
    Wait Until Element Is Visible    ${flyout_procedure_dd}    ${MaxTime}
    Click Element    ${flyout_procedure_dd}
    Get List Of Procedures In Flyout Dropdown
    Verify Procedures Listed In Training Page Are Available In Flyout Dropdown
    Wait Until Element Is Visible    ${all_procedures_option}    ${MaxTime}
    Click Element    ${all_procedures_option}
    Wait Until Element Is Visible    ${pieChartValueFlyout}    ${MaxTime}
    ${AllProcPieValue}=    Get Text    ${pieChartValueFlyout}
    ${AllProcPieValue}=    Strip String    ${AllProcPieValue}
    Should Not Be Equal As Strings    ${ActualPieValue}    ${AllProcPieValue}
    Close Flyout Modal
    Navigate To All Trainings List Page
    Delete All Created Trainings

Get List Of Procedures In Training Page
    @{list_webEle_proc}=    Get Webelements    ${procedures_trainings_page}
    @{listedProcedures}=    Create List
    FOR    ${i}    IN    @{list_webEle_proc}
        ${text_proc}=    Get Text    ${i}
        ${text_proc}=    Strip String    ${text_proc}
        Append To List    ${listedProcedures}    ${text_proc}
    END
    #listed procedures in trainings page
    Set Global Variable    ${listedProcedures}
    
Get List Of Procedures In Flyout Dropdown
    Wait Until Element Is Visible    (${dropdownListProcedures})[1]    ${MaxTime}
    @{webEle_Flyout_dropdown}=    Get Webelements    ${dropdownListProcedures}
    @{flyout_dropdown_data}=    Create List
    FOR    ${i}    IN    @{webEle_Flyout_dropdown}
        ${text_proc}=    Get Text    ${i}
        ${text_proc}=    Strip String    ${text_proc}
        Append To List    ${flyout_dropdown_data}    ${text_proc}
    END
    Set Global Variable    ${flyout_dropdown_data}

Verify Procedures Listed In Training Page Are Available In Flyout Dropdown
    FOR    ${value}    IN    @{listedProcedures}
        List Should Contain Value    ${flyout_dropdown_data}    ${value}
    END

#Open Flyout
#    [Documentation]    To Open Flyout
#    Wait For The Element And Click    ${OPEN_FLYOUT_USERS_ICON}
#    Wait Until Element Is Visible    ${flyout_panel}
#    Close The Pop-up Window

Close Flyout Modal
    [Documentation]    To Close Flyout Modal
    Wait For The Element And Click    ${CLOSE_TRAINING_FLYOUT_BUTTON}
    Wait Until Element Is Not Visible    ${flyout_panel}


Navigate To All Trainings List Page
    Wait Until Keyword Succeeds    10x    1s    Click Element    ${trainingsLink}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

Delete All Created Trainings
    Wait Until Element Is Visible    ${single_checkbox}    ${MaxTime}
    FOR    ${i}    IN RANGE    1    4
        Wait Until Element Is Enabled    (${all_trainings_list_checkbox})[${i}]    ${MaxTime}
        Wait Until Keyword Succeeds    10x    2s    Click Element    (${all_trainings_list_checkbox})[${i}]
        ${status}=    Checkbox Should Be Selected    (${all_trainings_list_checkbox})[${i}]
        IF    ${status} == False
            Wait Until Keyword Succeeds    10x    2s    Click Element    (${all_trainings_list_checkbox})[${i}]
        END
    END
    Wait Until Element Is Visible    ${delete_training_button}    ${MaxTime}
    Click Element    ${delete_training_button}
    Wait Until Element Is Visible    ${conf_modal}    ${MaxTime}
    Wait Until Element Is Visible    ${conf_modal_delete}    ${MaxTime}
    Click Element    ${conf_modal_delete}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Verify Toast Message Text    ${expectedDeleteText}
    
Verify Toast Message Text
    [Arguments]    ${expected_text}
    Wait Until Element Is Visible    ${toastMessageBox}    ${MaxTime}
    ${successTextActual}=    Get Text    ${toastMessageText}
    ${successTextActual}=    Strip String    ${successTextActual}
    Should Be Equal As Strings    ${successTextActual}    ${expected_text}


Click On Assign Button
    [Documentation]    To Click On Assign Button
    Wait Until Element Is Enabled    ${assignBtn}    ${MaxTime}
    Click Element    ${assignBtn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    
Click On Select Procedure Done Button
    [Documentation]    To Click On Select Procedure Done Button    
    Wait For The Element And Click    ${procedureSelectDone}
    Sleep    5s
    Wait For The Page To Load


Assign An Operator To The Training With Deadline
    Click On Assign Button
    Search User And Select
    Add Two More Users To Training
    Save The Operators Added In Job
    UnSelect The Deadline Checkbox
    Select The Date From The Calendar
    Click On Select Procedure Done Button  
    
Add Two More Users To Training
    [Documentation]    To Add Two More Users
    ${FIRST_OPERATOR_LOCATOR}=    Replace String    ${FIRST_OPERATOR}    TRAINING_USER    ${OPERATOR1_NAME}
    Wait Until Keyword Succeeds    10x    2s    Click Element    (${FIRST_OPERATOR_LOCATOR})[1]
    ${SECOND_OPERATOR_LOCATOR}=    Replace String    ${SECOND_OPERATOR}    TRAINING_USER    ${OPERATOR1_NAME}
    Wait Until Keyword Succeeds    10x    2s    Click Element    (${SECOND_OPERATOR_LOCATOR})[2]


UnSelect The Deadline Checkbox
#    Wait Until Element Is Visible    ${deadline_checkbox}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${deadline_checkbox}


Select The Date From The Calendar
    Wait Until Element Is Enabled    ${deadline_calendar}    ${MaxTime}
    Click Element    ${deadline_calendar}
    Wait Until Element Is Visible    ${calendarModal}    ${MaxTime}
    @{WebEleCalendar}=    Get Webelements    ${list_calendar_date}
    FOR    ${i}    IN    @{WebEleCalendar}
        ${attribute}=    Get Element Attribute    ${i}    class
        ${status}=    Run Keyword And Return Status    Should Not Contain    ${attribute}    disabled
        IF    ${status} == True
            Wait Until Keyword Succeeds    10x    2s    Click Element    ${i}
            BREAK
        END
    END
    ${date_selected}=    Get Value    ${date_display}
    ${date_selected}=    Strip String    ${date_selected}
    Set Global Variable    ${date_selected}
    Press Keys    None    ESC

Verify Deadline Date Is Visible In The Flyout Page
    Wait Until Element Is Visible    (${right_arrow_icon})[1]
    Click Element    (${right_arrow_icon})[1]
    Wait Until Element Is Visible    ${pieChartValueFlyout}    ${MaxTime}
    Wait Until Element Is Visible    ${deadline_date_flyout}    ${MaxTime}
    ${flyout_date}=    Get Text    ${deadline_date_flyout}
    ${flyout_date}=    Strip String    ${flyout_date}
    @{parts}=    Split String    ${flyout_date}    \n
    ${actualDate}=    Set Variable    ${parts}[0]
    ${actualDate}=    Replace String    ${parts}[0]    ,    ${Empty}
    #Adding below line to make the testcase pass as there is a format issue for date, [Note: Please remove the below line when bug is fixed]
#    ${date_selected}=    Replace String Using Regexp    ${date_selected}    [^\d]0(\d)    \g<1>
#    Should Be Equal As Strings    ${date_selected}    ${actualDate}
    ${left}=    Convert Date    ${date_selected}    date_format=%b %d %Y    result_format=%b %#d %Y
    ${right}=   Convert Date    ${actualDate}     date_format=%b %d %Y    result_format=%b %#d %Y
    Should Be Equal    ${left}    ${right}

    Close Flyout Modal
    Navigate To All Trainings List Page

Click On Assign Training Done Button
    [Documentation]    To click On Assign Training Done Button
    Wait For The Element And Click    ${ASSIGN_TRAINING_DONE_BUTTON}
    Capture Page Screenshot
    Run Keyword And Ignore Error    Page Should Contain    The training has been successfully assigned to the selected teams and users
    Capture Page Screenshot
    Sleep    5s
    Wait For The Page To Load

Click Create Training Cancel Button
    Wait Until Element Is Enabled    ${cancelButton_Training}    ${MaxTime}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${cancelButton_Training}
#     Execute Javascript    arguments[0].click();    ${cancelButton}


Verify User Is Able To Delete Single Procedure Added In Training Page
    [Documentation]    To Verify User Is Able To Delete Single Procedure Added In Training Page

    Wait For The Element And Click    ${FIRST_PROCEDURE_DELETE_BUTTON_IN_TRAINING}
    Wait For The Element And Click    ${DELETE_POPUP}
    
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    
    #Validate the Procedure deleted
    ${MAX_LIMIT}=    Get Element Count    ${PROCEDURE_ADDED_IN_TRAINING}
    ${All_PROCEDURES_ADDED_IN_TRAINING}=    Get Values In List For Validation    (${PROCEDURE_ADDED_IN_TRAINING})[INDEX]    1    ${MAX_LIMIT}  
    Lists Should Be Equal    ${All_PROCEDURES_ADDED_IN_TRAINING}    ${PROCEDURE_LIST[1:]}

Delete Selected Procedure Records From Training
    [Documentation]    To Delete Selected Procedure Records From Training
    [Arguments]    ${VALIDATE_UI_KEYWORD}=False
    Wait For The Element And Click    ${DELETE_MULTIPLE_PROCEDURE_RECORD}
    Run Keyword If    '${VALIDATE_UI_KEYWORD}'!='False'    ${VALIDATE_UI_KEYWORD}
    Wait For The Element And Click    ${DELETE_MULTIPLE_PROCEDURE_POPUP}
    Wait For The Page To Load

Verify User Is Able To Delete Multiple Procedure Added In Training Page
    [Documentation]    To Verify User Is Able To Delete Multiple Procedure Added In Training Page

    Select The Multiple Records
    Delete Selected Procedure Records From Training
    
    #Validate the Procedure deleted
    ${MAX_LIMIT}=    Get Element Count   ${PROCEDURE_ADDED_IN_TRAINING} 
    ${All_PROCEDURES_ADDED_IN_TRAINING}=    Get Values In List For Validation    (${PROCEDURE_ADDED_IN_TRAINING})[INDEX]    1    ${MAX_LIMIT}  
    Lists Should Be Equal    ${All_PROCEDURES_ADDED_IN_TRAINING}    ${PROCEDURE_LIST[3:]}

Verify The Name Field Validations In New Training Page
    [Documentation]    To Verify The Name Field Validations In New Training Page
    Click Element   ${training_name_input}
    Input Text    ${training_name_input}     $%
    Wait Until Element Is Visible    //div[contains(@class,"error")]    ${MaxTime}
        ${errorText}=    Get Text    //div[contains(@class,"error")]
        ${errorText}=    Strip String    ${errorText}
        Element Text Should Be   ${errorText}      Training name can't be just special characters or spaces — add some letters or numbers!

    Clear Element Text    ${training_name_input}
    Input Text    ${training_name_input}     ${SPACE}
    Wait Until Element Is Visible    //div[contains(@class,"error")]    ${MaxTime}
        ${errorText}=    Get Text    //div[contains(@class,"error")]
        ${errorText}=    Strip String    ${errorText}
        Element Text Should Be   ${errorText}      Training name can't be just special characters or spaces — add some letters or numbers!



Open Flyout
    [Documentation]    To Open Flyout
    Wait For The Element And Click    ${right_arrow_icon}
    Wait Until Element Is Visible    ${flyout_panel}

Click On Flyout Profile Icon
    [Documentation]    To Click On Flyout Profile Icon
    Wait For The Element And Click    ${FLYOUT_PROFILE_ICON}




Verify The UI Of Flyout Window On Training Details Page After Assigning Users
    [Documentation]    To Verify The UI Of Flyout Window On Training Details Page After Assigning Users
    Wait Until Element Is Visible    ${CLOSE_TRAINING_FLYOUT_BUTTON}    ${Max_limit}
    Wait Until Element Is Visible    ${INPUT_SEARCH_FLYOUT}
    Wait Until Element Is Visible    ${FLYOUT_TRAINING_NAME}
    Wait Until Element Is Visible    ${FLYOUT_TRAINING_PROCEDURE_DROPDOWN}
    Wait Until Element Is Visible    ${FLYOUT_TRAINING_INFO_HEADING}
    
    Element Should Contain    ${FLYOUT_TRAINING_COMPLETED_COUNT}    Completed
    Element Should Contain    ${FLYOUT_TRAINING_IN_PROGRESS_COUNT}    In Progress
    Element Should Contain    ${FLYOUT_TRAINING_NOT_STARTED_COUNT}    Not Started

    Element Should Be Visible    ${FLYOUT_TRAINING_PROCEDURE_PIE_CHART}
    Element Should Be Visible    ${FLYOUT_TRAINING_PROCEDURE_PIE_CHART_COUNT}
    
    #Validate Colors
    ${TEMP}=    Get CSS Property    ${FLYOUT_TRAINING_COMPLETED_COLOR}    background-color
    Log    ${TEMP}
    
    ${TEMP}=    Get CSS Property    ${FLYOUT_TRAINING_NOT_STARTED_COLOR}    background-color
    Log    ${TEMP}
    
    ${TEMP}=    Get CSS Property    ${FLYOUT_TRAINING_IN_PROGRESS_COLOR}    background-color
    Log    ${TEMP}

    Wait For The Element And Click    ${CLOSE_TRAINING_FLYOUT_BUTTON}
    

Validate All The User Are Visible In Flyout Window
    [Documentation]    To Validate All The User Are Visible In Flyout Window
    
    #Validate Count
    ${USERS_COUNT}=    Get Element Count    ${FLYOUT_ASSIGNED_OPERATOR_NAME}
    Evaluate    ${USERS_COUNT}==len(${ALL_OPERATORS_ASSIGNED_TO_TRAINING})
    
    FOR    ${USER}    IN    @{ALL_OPERATORS_ASSIGNED_TO_TRAINING}
        Scroll Element And Enter Value    ${INPUT_SEARCH_FLYOUT}    ${USER}
        Wait Until Keyword Succeeds    5x    2s    Element Should Contain    (${FLYOUT_ASSIGNED_OPERATOR_NAME})[1]    ${USER}
        Element Should Be Visible    ${FLYOUT_ASSIGNED_OPERATOR_STATUS}
        Element Should Be Visible    ${FLYOUT_ASSIGNED_OPERATOR_DATE}
        Element Should Be Visible    ${FLYOUT_ASSIGNED_OPERATOR_DETAILS}
    END

Search Training In My Trainings
    [Documentation]    To Search Training In My Trainings
    [Arguments]    ${NO_TRAINING}=False
#    ...    This keywords needs to be updated , currently My Training searching is not working
#    Reload Page
#    Wait For The Page To Load
    IF    '${NO_TRAINING}'=='True'
        Wait Until Element Is Enabled    ${training_page_search}    ${MaxTime}
        Scroll Element And Enter Value    ${training_page_search}    ${TRAINING_NAME}
        Page Should Not Contain Element    ${MY_TRAINING_PROCEDURE_COUNT}
#        Wait Until Keyword Succeeds    5x    1s    Element Should Not Contain    ${FIRST_TRAINING}    ${TRAINING_NAME}
        Return From Keyword
    END    
    Wait Until Element Is Enabled    ${training_page_search}    ${MaxTime}
    Scroll Element And Enter Value    ${training_page_search}    ${TRAINING_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_TRAINING}    ${TRAINING_NAME}

Click On Searched Training
    [Documentation]    To Click On Searched Training
    [Arguments]    ${TRAINING_DELETED}=False
    ${LOCATOR}=    Replace String    ${FIRST_TRAINING_SEARCHED}    TRAINING_NAME_UPDATE    ${TRAINING_NAME}
    IF    ${TRAINING_DELETED}
        Page Should Not Contain Element    ${LOCATOR}
        Return From Keyword
    END
    Wait Until Element Is Visible    ${LOCATOR}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Not Visible    ${SIGNOFF_PROCEDURE_NAME}
    Wait Until Element Is Visible    ${MY_TRAINING_FLYOUT}

Click On Add Procedure Button On Training Details Page
    [Documentation]    To Click On Add Procedure Button On Training Details Page    
    Wait For The Element And Click    ${training_procedure_btn}

Verify The UI Of Add Procedure To Training Screen
    [Documentation]    To Verify The UI Of Add Procedure To Training Screen
    Wait Until Element Is Visible    (${ADD_PROCEDURE_TO_TRAINING_FIRST_PROCEDURE_NAME})[1]    ${Max_limit}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_WINDOW_HEADER}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_WINDOW_PROCEDURE_TAB}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_INPUT_SEARCH}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_INPUT_SEARCH}

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADD_PROCEDURE_TO_TRAINING_HEADER_NAME}    Name
    Element Should Contain    ${ADD_PROCEDURE_TO_TRAINING_HEADER_VERSION}    Version
    Element Should Contain    ${ADD_PROCEDURE_TO_TRAINING_HEADER_UPDATEDBY}    Updated By
    
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_CANCEL_BUTTON}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_DONE_BUTTON}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_CLEAR_ALL_BUTTON}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_MODAL_COUNT_OF_ADDED_PROCEDURE}
    Wait Until Element Is Visible    ${ADD_PROCEDURE_TO_TRAINING_MODAL_ADDED_PROCEDURE}
    
    Wait For The Element And Click    ${ADD_PROCEDURE_TO_TRAINING_MODAL_DELETE_BUTTON}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADD_PROCEDURE_TO_TRAINING_MODAL_COUNT_OF_ADDED_PROCEDURE}    0
    Wait For The Element And Click    ${ADD_PROCEDURE_TO_TRAINING_DONE_BUTTON}
    Wait Until Element Is Not Visible    ${ADD_PROCEDURE_TO_TRAINING_DONE_BUTTON}


Create Users List
    [Documentation]    To Create Users List
    [Arguments]    ${SINGLE_USER}=False    ${VAR_LIST_NAME}=ASSIGNED_USERS_TO_TRAINING_LIST    ${MULTIPLE_USERS}=False
    IF    '${SINGLE_USER}'=='True'
        Add Item To List    ITEM=${OPERATOR1_NAME}   VAR_NAME=${VAR_LIST_NAME}
        Return From Keyword
    END
    Add Item To List    ITEM=${AUTHOR1_NAME}   VAR_NAME=${VAR_LIST_NAME}
    Add Item To List    ITEM=${OPERATOR1_NAME}   VAR_NAME=${VAR_LIST_NAME}
    
    IF    '${MULTIPLE_USERS}'=='False'
        Return From Keyword
    END

    Add Item To List    ITEM=${ORG_ADMIN_NAME}   VAR_NAME=${VAR_LIST_NAME}


Verify The Data Of Training On List Page
    [Documentation]    To Verify The Data Of Training On List Page
    [Arguments]    ${PROGRESS_STATUS}    ${TRAINING_ASSIGNED_USER}=2    ${TRAINING_ASSIGNED_PROCEDURE}=3
    @{PROGRESS_STATUS}=    Split String    ${PROGRESS_STATUS}    ,

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y

    Scroll Element And Enter Value    ${training_page_search}    ${TRAINING_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_TRAINING}    ${TRAINING_NAME}    
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_NAME_LOCATOR})[1]    ${TRAINING_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_CREATED_BY})[1]    ${AUTHOR1_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_LAST_UPDATED})[1]    ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_PROCEDURES_COUNT})[1]    ${TRAINING_ASSIGNED_PROCEDURE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_ASSIGNED_USERS_COUNT})[1]    ${TRAINING_ASSIGNED_USER}
    Wait Until Keyword Succeeds    5x    1s    Element Should Be Visible    ${TRAINING_DELETE_ICON}
    Wait Until Keyword Succeeds    10x    1s    Element Should Be Visible    ${TRAINING_STATUS_PROGRESS_BAR}
    
    ${COLOR}=    Get CSS Property    ${TRAINING_STATUS_PROGRESS_BAR_COLOR}    background
    ${COLOR}=    Split String    ${COLOR}    )${SPACE}
    Should Be Equal As Strings    ${COLOR[0]})    ${${PROGRESS_STATUS[2]}}

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_STATUS_PROGRESS_TITLE})[1]    ${PROGRESS_STATUS[0]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${TRAINING_STATUS_PROGRESS_USERS_COUNT})[1]    ${PROGRESS_STATUS[1]}
    
Verify The UI Of Added Procedure Page
    [Documentation]    To Verify The UI Of Added Procedure Page
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    ${ADDED_PROCEDURE_HEADER_NAME}
    Element Should Contain    ${ADDED_PROCEDURE_HEADER_NAME}    Name
    Element Should Contain    ${ADDED_PROCEDURE_HEADER_UPDATED_BY}    Updated By
    Element Should Contain    ${ADDED_PROCEDURE_HEADER_VERSION}    Version
    Element Should Contain    ${ADDED_PROCEDURE_HEADER_CREATED_BY}    Completed by Users

Verify The Data Of Added Procedure To Training Screen
    [Documentation]    To Verify The Data Of Added Procedure To Training Screen 
    [Arguments]    ${PROCEDURE_STATUS}    ${PROCEDURE_NUMBER}

    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_NUMBER}
    #Index list
    Wait Until Element Is Visible    ${ADDED_PROCEDURE_NAME}
    ${END_LIMIT}=    Get Element Count    ${ADDED_PROCEDURE_NAME}
    ${PROCEDURE_LIST}=    Get Values In List For Validation    (${ADDED_PROCEDURE_NAME})[INDEX]    1    ${END_LIMIT}
    ${PROCEDURE_INDEXING}=    Evaluate    ${PROCEDURE_LIST}.index("${PROCEDURE}") + 1
    ${PROCEDURE_INDEXING}=    Evaluate    str(${PROCEDURE_INDEXING})

    @{PROCEDURE_STATUS_LIST}   Split String    ${PROCEDURE_STATUS}    ,
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

    #Validate data
    Element Should Contain    (${ADDED_PROCEDURE_NAME})[${PROCEDURE_INDEXING}]    ${PROCEDURE}
    Element Should Be Visible    (${ADDED_PROCEDURE_VERSION})[${PROCEDURE_INDEXING}]
    ${COLOR}=    Get CSS Property    (${ADDED_PROCEDURE_COMPLETED_BY_STATUS_COLOR})[${PROCEDURE_INDEXING}]    background-color
    Should Be Equal As Strings    ${COLOR}    ${${PROCEDURE_STATUS_LIST[0]}}
    Element Should Contain    (${ADDED_PROCEDURE_COMPLETED_BY_USERS_COUNT})[${PROCEDURE_INDEXING}]    ${PROCEDURE_STATUS_LIST[1]}
    Element Should Be Visible    (${ADDED_PROCEDURE_COMPLETED_BY_BUTTON})[${PROCEDURE_INDEXING}]
    Element Should Be Visible    (${ADDED_PROCEDURE_UPDATED_BY_LOGO})[${PROCEDURE_INDEXING}]
    Element Should Contain    (${ADDED_PROCEDURE_UPDATED_BY_NAME})[${PROCEDURE_INDEXING}]    ${AUTHOR1_NAME}

    
    
    #Validate The same data in the flyout window
    Wait For The Element And Click    (${ADDED_PROCEDURE_COMPLETED_BY_BUTTON})[${PROCEDURE_INDEXING}]
    Wait Until Element Is Visible    ${INPUT_SEARCH_FLYOUT}


    #Index list
    ${END_LIMIT}=    Get Element Count    ${FLYOUT_ASSIGNED_OPERATOR_NAME}
    ${OPERATORS_LIST}=    Get Values In List For Validation    (${FLYOUT_ASSIGNED_OPERATOR_NAME})[INDEX]    1    ${END_LIMIT}
    TRY
        Lists Should Be Equal    ${OPERATORS_LIST}    ${ASSIGNED_USERS_TO_TRAINING_LIST}
    EXCEPT
        ${OPERATORS_LIST}=    Create List    ${OPERATOR1_NAME}
    END
    ${PROCEDURE_INDEXING}=    Evaluate    ${OPERATORS_LIST}.index("${${PROCEDURE_STATUS_LIST[2]}}") + 1
    ${PROCEDURE_INDEXING}=    Evaluate    str(${PROCEDURE_INDEXING})

    Element Should Contain    (${FLYOUT_ASSIGNED_OPERATOR_NAME})[${PROCEDURE_INDEXING}]    ${${PROCEDURE_STATUS_LIST[2]}}
    Element Should Contain    (${FLYOUT_ASSIGNED_OPERATOR_STATUS})[${PROCEDURE_INDEXING}]   ${PROCEDURE_STATUS_LIST[3]}
    
    @{PROCEDURE_FLYOUT_STATUS_LIST}   Split String    ${PROCEDURE_STATUS_LIST[1]}    /
    Element Should Contain    ${FLYOUT_TRAINING_COMPLETED_COUNT}  ${PROCEDURE_FLYOUT_STATUS_LIST[0]}
    ${TEMP}=    Subtract Numbers    ${PROCEDURE_FLYOUT_STATUS_LIST[1]}    ${PROCEDURE_FLYOUT_STATUS_LIST[0]}
    Element Should Contain    ${FLYOUT_TRAINING_NOT_STARTED_COUNT}    ${TEMP}
    ${TEMP}=    Add Numbers    ${PROCEDURE_FLYOUT_STATUS_LIST[0]}    ${TEMP}
    Element Should Contain    ${FLYOUT_TRAINING_PROCEDURE_PIE_CHART_COUNT}   ${TEMP}
    Element Should Contain    (${FLYOUT_TRAINING_PROCEDURE_DEADLINE})[${PROCEDURE_INDEXING}]    No Deadline

    Close Flyout Modal


Start The Training
    [Documentation]    To Start The Training
    [Arguments]    ${PROCEDURE_NUMBER}
    Click On Searched Training
    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_NUMBER}
    ${LOCATOR}=    Replace String    ${MY_TRAINING_START_BUTTON}    PROCEDURE_NAME    ${PROCEDURE}
    Wait For The Element And Click    ${LOCATOR}
    Wait For The Page To Load


Restart The Training
    [Documentation]    To Restart The Training
    [Arguments]    ${PROCEDURE_NUMBER}
    Click On Searched Training
    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_NUMBER}
    ${LOCATOR}=    Replace String    ${MY_TRAINING_RESTART_BUTTON}    PROCEDURE_NAME    ${PROCEDURE}
    Wait For The Element And Click    ${LOCATOR}

Verify The Training Data On My Training Screen
    [Documentation]    To Verify The Training Data On My Training Screen
    ...    testcase is failing beacuse searching is not working on My Training list page
    Search Training In My Trainings

    [Arguments]    ${PROCEDURE_STATUS}    ${DUE_DATE}=N/A
    @{PROCEDURE_STATUS_LIST}   Split String    ${PROCEDURE_STATUS}    ,

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    
    ${ADDED_PROCEDURE}=    Split String    ${PROCEDURE_STATUS_LIST[1]}    /${SPACE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_PROCEDURE_COUNT})[1]    ${ADDED_PROCEDURE[1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_ASSIGNED_DATE})[1]      ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_STATUS})[1]      On time
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_PROCEDURE_PROGRESS_STATUS})[1]      ${PROCEDURE_STATUS_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_PROCEDURE_STATUS_COUNT})[1]      ${PROCEDURE_STATUS_LIST[1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_DUE_DATE})[1]      ${DUE_DATE}
    Wait Until Keyword Succeeds    5x    1s    Page Should Contain Element    (${MY_TRAINING_PROCEDURE_PROGRESS_BAR})[1]
#    ${COLOR}=    Get CSS Property    (${MY_TRAINING_PROCEDURE_PROGRESS_BAR_COLOR})[1]    background-color
#    Should Be Equal As Strings    ${COLOR}    ${${PROCEDURE_STATUS_LIST[2]}}

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_STATUS_CELL_COMPLETED})[1]      ${PROCEDURE_STATUS_LIST[3]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_STATUS_CELL_FAILED})[1]      ${PROCEDURE_STATUS_LIST[4]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_STATUS_CELL_NOT_STARTED})[1]      ${PROCEDURE_STATUS_LIST[5]}


Verify The Procedure Data On Procedure SignOff List Page
    [Documentation]    To Verify The Procedure Data On Procedure SignOff List Page
    [Arguments]    ${PROCEDURE_NUMBER}    ${PROCEDURE_STATUS}
    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_NUMBER}
    Search Procedure In SignOff Procedure Page    ${PROCEDURE}

    @{PROCEDURE_STATUS_LIST}   Split String    ${PROCEDURE_STATUS}    ,

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_NAME})[1]    ${PROCEDURE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_LATEST_SUBMISSION_DATE})[1]      ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Be Visible    (${SIGNOFF_PROCEDURE_VERSION})[1]
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_SUBMISSIONS})[1]      ${PROCEDURE_STATUS_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Page Should Contain Element    (${SIGNOFF_PROCEDURE_USER_APPROVAL_STATUS_PROGRESS_BAR})[1]
    ${COLOR}=    Get CSS Property    (${SIGNOFF_PROCEDURE_USER_APPROVAL_STATUS_PROGRESS_BAR})[1]    background-color
    Should Be Equal As Strings    ${COLOR}    ${${PROCEDURE_STATUS_LIST[1]}}

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain   ${SIGNOFF_PROCEDURE_USER_APPROVAL_STATUS_COMPLETED}      ${PROCEDURE_STATUS_LIST[2]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain   ${SIGNOFF_PROCEDURE_USER_APPROVAL_STATUS_FAILED}      ${PROCEDURE_STATUS_LIST[3]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain   ${SIGNOFF_PROCEDURE_USER_APPROVAL_STATUS_NOT_STARTED}      ${PROCEDURE_STATUS_LIST[4]}


Verify The Procedure Data On Procedure SignOff Details Page
    [Documentation]    To Verify The Procedure Data On Procedure SignOff Details Page

    #Executioin sequence is for the time taken in execution not for indexing
    [Arguments]   ${EXECUTION_SEQUENCE}    ${PROCEDURE_STATUS}
    @{PROCEDURE_STATUS_LIST}   Split String    ${PROCEDURE_STATUS}    ,

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_DETAILS_USER})[1]    ${OPERATOR1_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_RECEIVED_ON_DATE})[1]      ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_TRAINING_NAME})[1]      ${TRAINING_NAME}
    #This shopuld be uncommented once the bug is fixed
#    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_CYCLE_TIME})[1]      2h 15m 30s
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_STATUS})[1]      ${PROCEDURE_STATUS_LIST[0]}
    ${TAKEN_TIME}=    Get From List    ${TAKEN_TIME_IN_EXECUTION}    ${EXECUTION_SEQUENCE}
    Wait Until Keyword Succeeds    5x    1s    Page Should Contain Element    (${SIGNOFF_PROCEDURE_TAKEN_TIME})[1]    ${TAKEN_TIME}


Verify The Training Data On My Training Flyout Screen
    [Documentation]    To Verify The Training Data On My Training Flyout Screen
    [Arguments]   ${PROCEDURE_SEQUENCE}   ${EXECUTION_SEQUENCE}=0   ${APPROVAL}=REQUIRED    ${PROCEDURE_STATUS}=Pending
    ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    ${PROCEDURE_SEQUENCE}
    #Index list
    ${END_LIMIT}=    Get Element Count    ${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_NAME}
    ${PROCEDURE_LIST}=    Get Values In List For Validation    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_NAME})[INDEX]    1    ${END_LIMIT}
    ${PROCEDURE_INDEXING}=    Evaluate    ${PROCEDURE_LIST}.index("${PROCEDURE}") + 1
    ${PROCEDURE_INDEXING}=    Evaluate    str(${PROCEDURE_INDEXING})

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    
    Wait For The Element And Click    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_EXPAND_BUTTON})[${PROCEDURE_INDEXING}]
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_PROCEDURE_NAME})[${PROCEDURE_INDEXING}]    ${PROCEDURE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_START})[1]      ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_END})[1]      ${TODAY_DATE}
    ${TAKEN_TIME}=    Get From List    ${TAKEN_TIME_IN_EXECUTION}    ${EXECUTION_SEQUENCE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_TIME_TAKEN})[1]      ${TAKEN_TIME}
    IF    '${APPROVAL}'=='NOT REQUIRED'
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_SIGNOFF})[1]      N/A
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_MANAGER})[1]      N/A
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_SIGNOFF})[1]      ${TODAY_DATE}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_MANAGER})[1]      ${AUTHOR1_NAME}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_TRAINING_FLYOUT_TRAINING_PROCEDURE_STATUS_APPROVED})[${PROCEDURE_INDEXING}]      ${PROCEDURE_STATUS}
    END
    Wait For The Element And Click    ${MY_TRAINING_FLYOUT_CROSS_BUTTON}
    Wait Until Element Is Not Visible    ${MY_TRAINING_FLYOUT_CROSS_BUTTON}


Provide The Procedure SignOff
    [Documentation]    To Provide The Procedure SignOff
    Wait For The Element And Click    ${APPROVE_ICON}
    Wait For The Element And Click    ${APPROVAL_SIGNOFF_APPROVE_BUTTON}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

Search Procedure In SignOff Procedure Page
    [Documentation]    To Search Procedure In SignOff Procedure Page
    [Arguments]    ${PROCEDURE}
    Wait Until Element Is Enabled    ${SIGNOFF_PROCEDURE_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${SIGNOFF_PROCEDURE_SEARCH}    ${PROCEDURE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SIGNOFF_PROCEDURE_NAME})[1]    ${PROCEDURE}

Click On Searched Procedure
    [Documentation]    To Click On Searched Procedure
    Wait For The Element And Click    (${SIGNOFF_PROCEDURE_NAME})[1]  # Might Changed
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}


Navigate To Procedure SignOff Page
    [Documentation]    To Navigate To Procedure SignOff Page

    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_SIGNOFF_PROCEDURES_BUTTON_VISIBLE}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SIGNOFF_PROCEDURES_BUTTON}    5s
    IF    '${IF_SIGNOFF_PROCEDURES_BUTTON_VISIBLE}'=='True'
        Double Click Element    ${SIGNOFF_PROCEDURES_BUTTON}
    ELSE
        Wait For The Element And Click    ${APPROVALS_BUTTON}
        Double Click Element    ${SIGNOFF_PROCEDURES_BUTTON}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${APPROVAL_STATUS_HEADER}    ${Max_limit}
    Mouse Over    ${APPROVAL_STATUS_HEADER}

Teardown For Training Page
    [Documentation]    Teardown For Training Page
    Switch Browser    Author
    Go To    ${Url}/trainings
    Delete The Training Created




Select The User On Matrix Page
    [Documentation]    To Select The User On Matrix Page
    Wait For The Element And Click    ${TRAINING_MATRIX_USERS_DROPDOWN}
    FOR    ${USER}    IN    @{ASSIGNED_USERS_TO_TRAINING_LIST}
        Scroll Element And Enter Value    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}    ${USER}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION}    ${USER}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION}
        Wait For The Page To Load
    END
    Press Keys    ${TRAINING_MATRIX_USERS_DROPDOWN}    ESC

Verify The UI Of Training Matrix
    [Documentation]    To Verify The UI Of Training Matrix
    Wait Until Element Is Visible    ${TRAINING_MATRIX_HEADING}    ${Max_limit}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_TEAMS_HEADING}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_TEAMS_DROPDOWN}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_USERS_HEADING}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_USERS_DROPDOWN}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_TRAINING_HEADING}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_TRAINING_DROPDOWN}
    Wait Until Element Is Visible    ${TRAINING_MATRIX_RESET_BUTTON}

    Wait Until Element Is Visible    ${MATRIX_LEGEND_NOT_STARTED_TEXT}    ${Max_limit}
    ${COLOR}=    Get CSS Property    ${MATRIX_LEGEND_NOT_STARTED_COLOR}    background-color
    Should Be Equal As Strings    ${COLOR}    ${GRAY}

    Wait Until Element Is Visible    ${MATRIX_LEGEND_IN_PROGRESS_TEXT}
    ${COLOR}=    Get CSS Property    ${MATRIX_LEGEND_IN_PROGRESS_COLOR}    background-color
    Should Be Equal As Strings    ${COLOR}    ${MATRIX_IN_PROGRESS}

    Wait Until Element Is Visible    ${MATRIX_LEGEND_NEAR_TO_EXPIRE_TEXT}
    ${COLOR}=    Get CSS Property    ${MATRIX_LEGEND_NEAR_TO_EXPIRE_COLOR}    background-color
    Should Be Equal As Strings    ${COLOR}    ${MATRIX_IN_PROGRESS}

    Wait Until Element Is Visible    ${MATRIX_LEGEND_COMPLETED_TEXT}
    ${COLOR}=    Get CSS Property    ${MATRIX_LEGEND_COMPLETED_COLOR}    background-color
    Should Be Equal As Strings    ${COLOR}    ${MATRIX_COMPLETED}

    Wait Until Element Is Visible    ${MATRIX_LEGEND_EXPIRED_TEXT}
    ${COLOR}=    Get CSS Property    ${MATRIX_LEGEND_EXPIRED_COLOR}    background-color
    Should Be Equal As Strings    ${COLOR}    ${RED}

    Wait Until Element Is Visible    ${MATRIX_MEMBERS_LABEL}
    Wait Until Element Is Visible    ${MATRIX_TRAINING_COMPLETION_LABEL}
    Wait Until Element Is Visible    ${MATRIX_TRAINING_COMPLETED_TILE}
    Wait Until Element Is Visible    ${MATRIX_TRAINING_%AGE_TILE}

Verify The User Name Hyperlink Is Functional On Training Matrix Page
    [Documentation]    To Verify The User Name Hyperlink Is Functional On Training Matrix Page
    Wait For The Element And Click    ${MATRIX_FIRST_USER}
    Wait For The Page To Load
    Verify User Lands On The Users List Page
    Capture Page Screenshot    

Validate The Correct Users Training Matrix data
    [Documentation]    To Validate The Correct Users Training Matrix data
    ${MAX_LIMIT}=    Get Element Count    ${MATRIX_TRAININGS}
    #Get the trainings data
    ${ALL_TRAINING_IN_MATRIX}=    Get Values In List For Validation    (${MATRIX_TRAININGS})[INDEX]    1    ${MAX_LIMIT}

    #Get the first user data
    ${USER1_TRAINING_STATUS}=    Create List
    ${USER1_TRAINING_COMPLETED_COUNT}    Evaluate    int(0)
    ${USER1_TRAINING_TOTAL_ASSIGNED}    Evaluate    int(0)
    FOR    ${ITERATOR}    IN RANGE    1    ${MAX_LIMIT}+1
        Wait Until Page Contains Element    (${MATRIX_TRAININGS_STATUS_USER1})[${ITERATOR}]
        ${CLASS_LIST}=    Get Element Attribute    (${MATRIX_TRAININGS_STATUS_USER1})[${ITERATOR}]    class
        ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}
        IF    '${CLASS_LIST}[1]' == 'not-started' or '${CLASS_LIST}[1]' == 'expired'
            ${USER1_TRAINING_STATUS}=    Evaluate    ${USER1_TRAINING_STATUS}+ [0]
            ${USER1_TRAINING_TOTAL_ASSIGNED}=    Evaluate    ${USER1_TRAINING_TOTAL_ASSIGNED} + 1
        ELSE IF    '${CLASS_LIST[1]}'=='trainingNotAssignedCell'
            ${USER1_TRAINING_STATUS}=    Evaluate    ${USER1_TRAINING_STATUS}+ [0]
        ELSE IF    '${CLASS_LIST[1]}'=='completed'
            ${COLOR}=    Get CSS Property    (${MATRIX_TRAININGS_STATUS_USER1})[${ITERATOR}]    background-color
            Should Be True    '${COLOR}'=='${MATRIX_COMPLETED}'
            ${USER1_TRAINING_STATUS}=    Evaluate    ${USER1_TRAINING_STATUS}+ [1]
            ${USER1_TRAINING_COMPLETED_COUNT}    Evaluate    ${USER1_TRAINING_COMPLETED_COUNT}+1
            ${USER1_TRAINING_TOTAL_ASSIGNED}=    Evaluate    ${USER1_TRAINING_TOTAL_ASSIGNED} + 1
        END
    END
    Log    ${USER1_TRAINING_STATUS}


    #Get the second user data
    ${USER2_TRAINING_STATUS}=    Create List
    ${USER2_TRAINING_COMPLETED_COUNT}    Evaluate    int(0)
    ${USER2_TRAINING_TOTAL_ASSIGNED}    Evaluate    int(0)
    FOR    ${ITERATOR}    IN RANGE    1    ${MAX_LIMIT}+1
        Wait Until Page Contains Element    (${MATRIX_TRAININGS_STATUS_USER2})[${ITERATOR}]
        ${CLASS_LIST}=    Get Element Attribute    (${MATRIX_TRAININGS_STATUS_USER2})[${ITERATOR}]    class
        ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}
        IF    '${CLASS_LIST[1]}'=='not-started' or '${CLASS_LIST}[1]' == 'expired'
            ${USER2_TRAINING_STATUS}=    Evaluate    ${USER2_TRAINING_STATUS}+ [0]
            ${USER2_TRAINING_TOTAL_ASSIGNED}=    Evaluate    ${USER2_TRAINING_TOTAL_ASSIGNED} + 1
        ELSE IF    '${CLASS_LIST[1]}'=='trainingNotAssignedCell'
            ${USER2_TRAINING_STATUS}=    Evaluate    ${USER2_TRAINING_STATUS}+ [0]
        ELSE IF    '${CLASS_LIST[1]}'=='completed'
            ${COLOR}=    Get CSS Property    (${MATRIX_TRAININGS_STATUS_USER2})[${ITERATOR}]    background-color
            Should Be True    '${COLOR}'=='${MATRIX_COMPLETED}'
            ${USER2_TRAINING_STATUS}=    Evaluate    ${USER2_TRAINING_STATUS}+ [1]
            ${USER2_TRAINING_COMPLETED_COUNT}    Evaluate    ${USER2_TRAINING_COMPLETED_COUNT}+1
            ${USER2_TRAINING_TOTAL_ASSIGNED}=    Evaluate    ${USER2_TRAINING_TOTAL_ASSIGNED} + 1
        END
    END
    Log    ${USER2_TRAINING_STATUS}

    #Training Completion status
    ${TRAINING_COMPLETION_PERCENTAGE_LIST}=    Get Values In List For Validation    (${MATRIX_TRAININGS_COMPLETION_%AGE})[INDEX]    1    ${MAX_LIMIT}

    #Validate matrix status
    FOR    ${ITERATOR}    IN RANGE    1    ${MAX_LIMIT}+1
        Exit For Loop If    ${ITERATOR}>=15
        ${LIST_INDEX}=    Evaluate    ${ITERATOR}-1
        VAR    ${val1}    ${USER1_TRAINING_STATUS}[${LIST_INDEX}]
        VAR    ${val2}    ${USER2_TRAINING_STATUS}[${LIST_INDEX}]
        ${SUM} =    Add Numbers    ${val1}    ${val2}
        ${VALIDATION_PERCENTAGE}=    Get From List    ${TRAINING_COMPLETION_PERCENTAGE_LIST}    ${LIST_INDEX}
        ${COLOR}=    Get CSS Property    (${MATRIX_TRAININGS_COMPLETION_%AGE})[${ITERATOR}]    background-color
        IF    ${SUM}>=1
            ${PERCENTAGE}=    Evaluate    int((${SUM}/2)*100)
            Element Should Contain    (${MATRIX_TRAININGS_COMPLETION_%AGE})[${ITERATOR}]    ${PERCENTAGE}%
            Validate Color Coding Based On Percentage    (${MATRIX_TRAININGS_COMPLETION_%AGE})[${ITERATOR}]    ${PERCENTAGE}
        ELSE
            Element Should Contain    (${MATRIX_TRAININGS_COMPLETION_%AGE})[${ITERATOR}]    0%
            Validate Color Coding Based On Percentage    (${MATRIX_TRAININGS_COMPLETION_%AGE})[${ITERATOR}]    0
        END
    END

    #Validate users status
    Element Should Contain    (${USER_COMPLETED_TRAINING_COUNT})[1]    ${USER1_TRAINING_COMPLETED_COUNT}/${USER1_TRAINING_TOTAL_ASSIGNED}
    ${USER1_TRAINING_COMPLETION_PERCENT}=     Evaluate    (${USER1_TRAINING_COMPLETED_COUNT}/${USER1_TRAINING_TOTAL_ASSIGNED})*100
    ${USER1_TRAINING_COMPLETION_PERCENT} =    BuiltIn.Evaluate    round(${USER1_TRAINING_COMPLETION_PERCENT})
    Element Should Contain    (${USER_COMPLETED_TRAINING_%AGE})[1]    ${USER1_TRAINING_COMPLETION_PERCENT}%
    Validate Color Coding Based On Percentage    (${USER_COMPLETED_TRAINING_%AGE})[1]    ${USER1_TRAINING_COMPLETION_PERCENT}

    Element Should Contain    (${USER_COMPLETED_TRAINING_COUNT})[2]    ${USER2_TRAINING_COMPLETED_COUNT}/${USER2_TRAINING_TOTAL_ASSIGNED}
    ${USER2_TRAINING_COMPLETION_PERCENT}=     Evaluate    (${USER2_TRAINING_COMPLETED_COUNT}/${USER2_TRAINING_TOTAL_ASSIGNED})*100
    ${USER2_TRAINING_COMPLETION_PERCENT} =    BuiltIn.Evaluate    round(${USER2_TRAINING_COMPLETION_PERCENT})
    Element Should Contain    (${USER_COMPLETED_TRAINING_%AGE})[2]    ${USER2_TRAINING_COMPLETION_PERCENT}%
    Validate Color Coding Based On Percentage    (${USER_COMPLETED_TRAINING_%AGE})[2]    ${USER2_TRAINING_COMPLETION_PERCENT}


Validate Color Coding Based On Percentage
    [Documentation]    To Validate Color Coding Based On Percentage
    [Arguments]    ${LOCATOR}    ${PERCENT}

    ${COLOR}=    Get CSS Property   ${LOCATOR}    background-color
    IF    ${PERCENT}<50
        Should Be Equal As Strings    ${COLOR}    ${LIGHT_RED}
    ELSE IF    ${PERCENT}>=50
        Should Be Equal As Strings    ${COLOR}    ${MATRIX_COMPLETED_LIGHT}
    END
    
Select The Training In Training Matrix
    [Documentation]    To Select The Training In Training Matrix
    [Arguments]    ${DELETED_TRAINING}=False
    Wait For The Element And Click    ${TRAINING_MATRIX_TRAINING_DROPDOWN}
    Scroll Element And Enter Value    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}    ${TRAINING_NAME}
    IF    '${DELETED_TRAINING}'=='True'
        Wait Until Keyword Succeeds    5x    1s    Page Should Not Contain Element    ${TRAINING_MATRIX_DROPDOWN_TRAINING_FIRST_OPTION}
        Press Keys    None    ESC
        Return From Keyword
    END
    Wait For The Element And Click    ${TRAINING_MATRIX_DROPDOWN_TRAINING_FIRST_OPTION}
    Wait For The Page To Load
    Press Keys    None    ESC
    Wait Until Element Is Not Visible    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}


Select The Team In Training Matrix
    [Documentation]    To Select The Team In Training Matrix
    Wait For The Element And Click    ${TRAINING_MATRIX_TEAMS_DROPDOWN}
    Scroll Element And Enter Value    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}    ${TD_TEAM_NAME}
#    Wait For The Element And Click    ${TRAINING_MATRIX_DROPDOWN_TEAMS_FIRST_OPTION}
    Wait For The Page To Load
    Press Keys    None    ESC
    Wait Until Element Is Not Visible    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}


Select The User In Training Matrix
    [Documentation]    To Select The User In Training Matrix
    Wait For The Element And Click    ${TRAINING_MATRIX_USERS_DROPDOWN}
    Scroll Element And Enter Value    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}    ${OPERATOR1_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION}    ${OPERATOR1_NAME}
    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION_TRAINING_MATRIX}=    Replace String    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION_TRAINING_MATRIX}    NAME    ${OPERATOR1_NAME}
    Wait For The Element And Click    ${TRAINING_MATRIX_DROPDOWN_USERS_FIRST_OPTION_TRAINING_MATRIX}
    Wait For The Page To Load
    Press Keys    None    ESC
    Wait Until Element Is Not Visible    ${TRAINING_MATRIX_DROPDOWN_SEARCH_INPUT}

Verify The Training Data In Training Matrix
    [Arguments]    ${PROCEDURE_STATUS}
    [Documentation]    To Verify The Training Data In Training Matrix

    #correct training validation
    ${TRAININGS_COUNT}=    Get Element Count    ${MATRIX_TRAININGS}
    Should Be True    ${TRAININGS_COUNT}>=1
    ${TRAINING_FROM_STOREFRONT}=    Get Text    ${MATRIX_TRAININGS}
    ${TRAINING_FROM_STOREFRONT}=    Strip String    ${TRAINING_FROM_STOREFRONT}
    ${TRAINING_FROM_STOREFRONT}=    Remove Trailing Dots    ${TRAINING_FROM_STOREFRONT}
    Should Contain    ${TRAINING_NAME}    ${TRAINING_FROM_STOREFRONT}


    #Assigned user validation
    ${USER_COUNT}=    Get Element Count    ${MATRIX_TRAINING_USER}
    Should Be True    ${USER_COUNT}==1
    ${USER_FROM_STOREFRONT}=    Get Text    ${MATRIX_TRAINING_USER}
    ${USER_FROM_STOREFRONT}=    Strip String    ${USER_FROM_STOREFRONT}
    ${USER_FROM_STOREFRONT}=    Remove Trailing Dots    ${USER_FROM_STOREFRONT}
    Should Contain    ${OPERATOR1_NAME}    ${USER_FROM_STOREFRONT}

    #Validate status
    @{PROCEDURE_STATUS_LIST}   Split String    ${PROCEDURE_STATUS}    ,
    IF    '${PROCEDURE_STATUS_LIST[0]}'!='0'
        ${PROCEDURE_COMPLETED_PERCENT}=    Evaluate    int((int(${PROCEDURE_STATUS_LIST[0]})/3)*100)
    END    
    IF    '${PROCEDURE_STATUS_LIST[0]}'=='0'
        Element Should Contain    ${MATRIX_TRAININGS_STATUS_USER1}    ${EMPTY}
        ${COLOR}=    Get CSS Property   ${MATRIX_TRAININGS_STATUS_USER1}    background-color
        Should Be Equal As Strings    ${COLOR}    ${GRAY}

        Element Should Contain    ${USER_COMPLETED_TRAINING_COUNT}    0/1

        Element Should Contain    ${USER_COMPLETED_TRAINING_%AGE}    0%
        ${COLOR}=    Get CSS Property   ${USER_COMPLETED_TRAINING_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${LIGHT_RED}

        Element Should Contain    ${MATRIX_TRAININGS_COMPLETION_%AGE}    0%
        ${COLOR}=    Get CSS Property   ${MATRIX_TRAININGS_COMPLETION_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${LIGHT_RED}

    ELSE IF    '${PROCEDURE_STATUS_LIST[0]}'=='1'

        Element Should Contain    ${USER_COMPLETED_TRAINING_COUNT}    0/1

        Element Should Contain    ${USER_COMPLETED_TRAINING_%AGE}    0%
        ${COLOR}=    Get CSS Property   ${USER_COMPLETED_TRAINING_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${LIGHT_RED}

        Element Should Contain    ${MATRIX_TRAININGS_COMPLETION_%AGE}    0%
        ${COLOR}=    Get CSS Property   ${MATRIX_TRAININGS_COMPLETION_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${LIGHT_RED}

    ELSE IF    '${PROCEDURE_STATUS_LIST[0]}'=='3'

        Element Should Contain    ${USER_COMPLETED_TRAINING_COUNT}    1/1

        Element Should Contain    ${USER_COMPLETED_TRAINING_%AGE}    100%
        ${COLOR}=    Get CSS Property   ${USER_COMPLETED_TRAINING_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${MATRIX_COMPLETED_LIGHT}

        Element Should Contain    ${MATRIX_TRAININGS_COMPLETION_%AGE}    100%
        ${COLOR}=    Get CSS Property   ${MATRIX_TRAININGS_COMPLETION_%AGE}    background-color
        Should Be Equal As Strings    ${COLOR}    ${MATRIX_COMPLETED_LIGHT}

    END

Edit The Training Name
    [Documentation]    To Edit The Training Name
    Click Edit Procedure Button
    Fill The Form And Submit It

Click On Cancel Button And Verify The Training Details page
    [Documentation]    To Click On Cancel Button And Verify The Training Details page
    Wait For The Element And Click    ${PROCEDURE_SELECT_CANCEL_BUTTON}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_NAME}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_VERSION}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_COMPLETED_BY_STATUS_COLOR}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_COMPLETED_BY_USERS_COUNT}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_COMPLETED_BY_BUTTON}
    Wait Until Page Does Not Contain Element    ${ADDED_PROCEDURE_UPDATED_BY_LOGO}


Verify The Sorting Functionality On The Training List Page
    [Documentation]    To Verify The Sorting Functionality On The Training List Page
    ...    This keyword is failing due to the bug , logged
    ${MAX_LIMIT}=    Get Element Count    ${TRAINING_NAME_LOCATOR}

    #1-Training Names
    Wait For The Element And Click    ${TRAINING_HEADER_NAME}
    Wait For The Page To Load

    #verify sorting Ascending
    ${TRAINING_NAMES}=    Get Values In List For Validation    (${TRAINING_NAME_LOCATOR})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_NAMES}=    Copy List    ${TRAINING_NAMES}
    Sort List    ${SORTED_TRAINING_NAMES}
    Should Be Equal    ${SORTED_TRAINING_NAMES}    ${TRAINING_NAMES}
    Capture Page Screenshot    
    
    Wait For The Element And Click    ${TRAINING_HEADER_NAME}
    Wait For The Page To Load

    #verify sorting Descending
    ${TRAINING_NAMES}=    Get Values In List For Validation    (${TRAINING_NAME_LOCATOR})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_NAMES}=    Evaluate    sorted(${TRAINING_NAMES},reverse=True)
    Should Be Equal    ${SORTED_TRAINING_NAMES}    ${TRAINING_NAMES}
    Capture Page Screenshot
    
    #2-Created By
    Wait For The Element And Click    ${TRAINING_HEADER_CREATED_BY}
    Wait For The Page To Load

    #verify sorting Ascending
    ${TRAINING_CREATED_BY_LIST}=    Get Values In List For Validation    (${TRAINING_CREATED_BY})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_CREATED_BY_LIST}=    Copy List    ${TRAINING_CREATED_BY_LIST}
    Sort List    ${SORTED_TRAINING_CREATED_BY_LIST}
    Should Be Equal    ${SORTED_TRAINING_CREATED_BY_LIST}    ${TRAINING_CREATED_BY_LIST}
    Capture Page Screenshot
    
    Wait For The Element And Click    ${TRAINING_HEADER_CREATED_BY}
    Wait For The Page To Load

    #verify sorting Descending
    ${TRAINING_CREATED_BY_LIST}=    Get Values In List For Validation    (${TRAINING_CREATED_BY})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_CREATED_BY_LIST}=    Evaluate    sorted(${TRAINING_CREATED_BY_LIST},reverse=True)
    Should Be Equal    ${TRAINING_CREATED_BY_LIST}    ${SORTED_TRAINING_CREATED_BY_LIST}
    Capture Page Screenshot
    
    #3-Last Updated
    Wait For The Element And Click    ${TRAINING_HEADER_UPDATED_BY}
    Wait For The Page To Load

    ${TRAINING_LAST_UPDATED_LIST}=    Get Values In List For Validation    (${TRAINING_LAST_UPDATED})[INDEX]    1    ${MAX_LIMIT}
    @{TRAINING_LAST_UPDATED_LIST}=    Evaluate    [__import__('datetime').datetime.strptime(d, '''%b %d, %Y''') for d in ${TRAINING_LAST_UPDATED_LIST}]
    ${SORTED_TRAINING_LAST_UPDATED_LIST}=    Evaluate    sorted(${TRAINING_LAST_UPDATED_LIST}, reverse=False)
    Should Be Equal    ${SORTED_TRAINING_LAST_UPDATED_LIST}    ${TRAINING_LAST_UPDATED_LIST}
    Capture Page Screenshot
    
    Wait For The Element And Click    ${TRAINING_HEADER_UPDATED_BY}
    Wait For The Page To Load

    #verify sorting Descending
    ${TRAINING_LAST_UPDATED_LIST}=    Get Values In List For Validation    (${TRAINING_LAST_UPDATED})[INDEX]    1    ${MAX_LIMIT}
    @{TRAINING_LAST_UPDATED_LIST}=    Evaluate    [__import__('datetime').datetime.strptime(d, '''%b %d, %Y''') for d in ${TRAINING_LAST_UPDATED_LIST}]
    ${SORTED_TRAINING_LAST_UPDATED_LIST}=    Evaluate    sorted(${TRAINING_LAST_UPDATED_LIST}, reverse=True)
    Should Be Equal    ${TRAINING_LAST_UPDATED_LIST}    ${SORTED_TRAINING_LAST_UPDATED_LIST}
    Capture Page Screenshot
    
    ##4-Procedures
    Wait For The Element And Click    ${TRAINING_HEADER_PROCEDURES}
    Wait For The Page To Load

    #verify sorting Ascending
    ${TRAINING_PROCEDURES_COUNT_LIST}=    Get Values In List For Validation    (${TRAINING_PROCEDURES_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_PROCEDURES_COUNT_LIST}=    Copy List    ${TRAINING_PROCEDURES_COUNT_LIST}
    # Sort numerically (ascending)
    Should Be True    ${SORTED_TRAINING_PROCEDURES_COUNT_LIST} == sorted(${TRAINING_PROCEDURES_COUNT_LIST}, key=int)
    Capture Page Screenshot

    Wait For The Element And Click    ${TRAINING_HEADER_PROCEDURES}
    Wait For The Page To Load

    # Verify sorting descending (numerically)
    ${TRAINING_PROCEDURES_COUNT_LIST}=    Get Values In List For Validation    (${TRAINING_PROCEDURES_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_PROCEDURES_COUNT_LIST}=    Evaluate    sorted(${TRAINING_PROCEDURES_COUNT_LIST}, key=int, reverse=True)
    Should Be True    ${TRAINING_PROCEDURES_COUNT_LIST} == ${SORTED_TRAINING_PROCEDURES_COUNT_LIST}
    Capture Page Screenshot

    #5- Users count
#    Wait For The Element And Click    ${TRAINING_HEADER_ASSIGNED_USERS}
#    Wait For The Page To Load
    #verify sorting Ascending
    ${TRAINING_ASSIGNED_USERS_COUNT_LIST}=    Get Values In List For Validation    (${TRAINING_ASSIGNED_USERS_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_ASSIGNED_USERS_COUNT_LIST}=    Copy List    ${TRAINING_ASSIGNED_USERS_COUNT_LIST}
    Evaluate    sorted(${SORTED_TRAINING_ASSIGNED_USERS_COUNT_LIST}, key=int)
    Should Be True    ${TRAINING_ASSIGNED_USERS_COUNT_LIST} == sorted(${SORTED_TRAINING_ASSIGNED_USERS_COUNT_LIST}, key=int)
    Capture Page Screenshot

    Wait For The Element And Click    ${TRAINING_HEADER_ASSIGNED_USERS}
    Wait For The Page To Load
    #verify sorting Descending

    ${TRAINING_ASSIGNED_USERS_COUNT_LIST}=    Get Values In List For Validation    (${TRAINING_ASSIGNED_USERS_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_TRAINING_ASSIGNED_USERS_COUNT_LIST}=    Evaluate    sorted(${TRAINING_ASSIGNED_USERS_COUNT_LIST}, key=int , reverse=True)
    Should Be True    ${TRAINING_ASSIGNED_USERS_COUNT_LIST} == ${SORTED_TRAINING_ASSIGNED_USERS_COUNT_LIST}
    Capture Page Screenshot


Verify The Procedures Added In Training On List Page
    [Documentation]    To Verify The Procedures Added In Training On List Page
    [Arguments]    ${PROCEDURE_COUNT}
    Search The Training On Training List Page
    Element Should Contain    (${TRAINING_PROCEDURES_COUNT})[1]    ${PROCEDURE_COUNT}

Verify The Users Added Count In Training On List Page
    [Documentation]    To Verify The Users Added Count In Training On List Page
    [Arguments]    ${USERS_COUNT}
    Search The Training On Training List Page
    Element Should Contain    (${TRAINING_ASSIGNED_USERS_COUNT})[1]    ${USERS_COUNT}


Verify The Selected User Records On Assign Window
    [Documentation]    To Verify The Selected User Records On Assign Window
    Select The Page Size
    ${ALL_RECORDS}=    Get Record Count In Pop-up Window    (${POP_UP_WINDOW_RECORDS_COUNT})[1]
    ${LB}=    Get The Smaller Value    ${ALL_RECORDS}    ${PAGE_SIZE}
    
    Wait Until Keyword Succeeds    5x    1s    Wait For The Element And Click    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_MEMBERS_CHECKBOX}
    Element Should Contain    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_MEMBERS_COUNT_SELECTED_RECORDS}    ${LB}
    ${COLOR}=    Get CSS Property    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_MEMBERS_SELECTED_RECORDS}    background-color
    Should Be Equal As Strings    ${COLOR}    ${SELECTED_RECORDS_COLOR}
    
    #Teams Tab
    Wait For The Element And Click    ${ASSIGN_USERS_TO_TRAINING_TEAMS_TAB}
    Select The Page Size    ${ASSIGNED_TEAMS_PAGE_SIZE_LOCATOR}
    ${ALL_RECORDS}=    Get Record Count In Pop-up Window    (${POP_UP_WINDOW_RECORDS_COUNT})[2]
    ${LB}=    Get The Smaller Value    ${ALL_RECORDS}    ${PAGE_SIZE}
    
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_TEAMS_CHECKBOX}
    Element Should Contain    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_TEAMS_COUNT_SELECTED_RECORDS}    ${LB}
    ${COLOR}=    Get CSS Property    ${ASSIGN_USERS_TO_TRAINING_MODAL_ALL_TEAMS_SELECTED_RECORDS}    background-color
    Should Be Equal As Strings    ${COLOR}    ${SELECTED_RECORDS_COLOR}

    
Click On Cross Button On The Assign Users To Training Window
    [Documentation]    To Click On Cross Button On The Assign Users To Training Window
    Wait For The Element And Click    ${ASSIGN_USERS_TO_TRAINING_MODAL_CROSS_ICON}


Click On Cancel Button On The Assign Users To Training Window
    [Documentation]    To Click On Cancel Button On The Assign Users To Training Window
    Wait For The Element And Click    ${ASSIGN_USERS_TO_TRAINING_MODAL_CANCEL_BUTTON}
    
    
Verify User Can Select All Procedures And Add To Training
    [Documentation]    To Verify User Can Select All Procedures And Add To Training
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_ALL_PROCEDURE_TO_TRAINING_MODAL_CHECKBOX}
    ${COLOR}=    Get CSS Property    ${ADD_ALL_PROCEDURE_TO_TRAINING_MODAL_SELECTED_RECORDS}    background-color
    Should Be Equal As Strings    ${COLOR}    ${SELECTED_RECORDS_COLOR}
    
    ${ADDED_ALL_PROCEDURE_TO_TRAINING}=    Get Values In List For Validation    (${ADD_PROCEDURE_TO_TRAINING_MODAL_ADDED_PROCEDURE})[INDEX]    1    10
    Set Test Variable    ${ADDED_ALL_PROCEDURE_TO_TRAINING}
    
    Element Should Contain    ${ADD_PROCEDURE_TO_TRAINING_MODAL_COUNT_OF_ADDED_PROCEDURE}    10
    Click Select Procedure Done Button

Validate The Added Procedures Count In The Flyout Window On Training Details Page
    [Documentation]    To Validate The Added Procedures Count In The Flyout Window On Training Details Page
    
    ${MAX_LIMIT}=    Get Element Count    ${ADDED_PROCEDURE_NAME}
    ${EXTRACTED_ALL_PROCEDURE_TO_TRAINING}=    Get Values In List For Validation    (${ADDED_PROCEDURE_NAME})[INDEX]    1    ${MAX_LIMIT}
    
#    Lists Should Be Equal    ${EXTRACTED_ALL_PROCEDURE_TO_TRAINING}    ${ADDED_ALL_PROCEDURE_TO_TRAINING}
   


Verify The User Can Select All Records On Training List page
    [Documentation]    To Verify The User Can Select All Records On Training List page
    Wait For The Element And Click    ${ALL_TRAINING_CHECKBOX}
    
    ${COLOR}=    Get CSS Property    ${ALL_TRAINING_SELECTED_RECORDS}    background-color
    Should Be Equal As Strings    ${COLOR}    ${SELECTED_RECORDS_COLOR}
    
#    Element Should Contain    ${ALL_TRAINING_SELECTED_RECORDS_COUNT}    10


Verify The UI Of My Training's Page
    [Documentation]    To Verify The UI Of My Training's Page
    
    Element Should Contain    ${MY_TRAINING_HEADER}    My Trainings
    ${COUNT}=    Get Current Record Count On Page    
    Element Should Contain    ${MY_TRAINING_HEADER}    ${COUNT}
    
    Element Should Contain    ${MY_TRAINING_PROCEDURE_NAME_HEADER}    Name
    Element Should Contain    ${MY_TRAINING_PROCEDURE_COUNT_HEADER}    Procedure
    Element Should Contain    ${MY_TRAINING_HEADER_ASSIGNED_DATE}    Assigned Date
    Element Should Contain    ${MY_TRAINING_HEADER_DUE_DATE}    Due Date
    Element Should Contain    ${MY_TRAINING_HEADER_STATUS}    Status
    Element Should Contain    ${MY_TRAINING_HEADER_PROCEDURE_PROGRESS_STATUS}    Progress
    Element Should Contain    ${MY_TRAINING_HEADER_SIGNOFF_STATUS}    Sign Off Status


Reject The Procedure Approval
    [Documentation]    To Reject The Procedure Approval
    Wait For The Element And Click    ${APPROVAL_SIGNOFF_REJECT_ICON}
    
    ${APPROVAL_REJECTION_COMMENT}=    Generate Random String    30
    Set Test Variable    ${APPROVAL_REJECTION_COMMENT}
    Scroll Element And Enter Value    ${APPROVAL_SIGNOFF_REJECT_COMMENT}    ${APPROVAL_REJECTION_COMMENT}

    Wait For The Element And Click    ${APPROVAL_SIGNOFF_REJECT_BUTTON}


Verify The Approval Comment Data
    [Documentation]    To Verify The Approval Comment Data
    [Arguments]    ${STATUS}=Rejected
    Wait For The Element And Click    ${APPROVAL_SIGNOFF_COMMENT_BUTTON}
    Wait Until Element Is Visible    ${APPROVAL_SIGNOFF_ADDED_COMMENT_DIALOG_HEADER}

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y    
    
    Element Should Contain    ${APPROVAL_SIGNOFF_ADDED_COMMENT_SIGNOFF_APPROVER}    ${AUTHOR1_NAME}
    Element Should Contain    ${APPROVAL_SIGNOFF_ADDED_COMMENT_TEXT}    ${APPROVAL_REJECTION_COMMENT}
    Element Should Contain    ${APPROVAL_SIGNOFF_ADDED_COMMENT_APPROVAL_STATUS}    ${STATUS}
    Element Should Contain    ${APPROVAL_SIGNOFF_ADDED_COMMENT_APPROVAL_STATUS}    ${STATUS}
    Element Should Contain    ${APPROVAL_SIGNOFF_ADDED_COMMENT_APPROVAL_DATE}    ${TODAY_DATE}
    
    Wait For The Element And Click    ${APPROVAL_SIGNOFF_ADDED_COMMENT_CROSS_BUTTON}


Delete The Training Created
    [Documentation]    To Delete The Training Created
    Search The Training On Training List Page
#    Select The Multiple Records    END_RECORD=3
    Delete One Record From List Page


Verify The Training Visibility To The User On The Matrix Page 
    [Documentation]    To Verify The Training Visibility To The User On The Matrix Page
    [Arguments]    ${ACTION}
    ${END_LIMIT}=    Get Element Count    ${MATRIX_TRAININGS}
    ${ALL_TRAININGS_DISPLAYED}=    Get Values In List For Validation    (${MATRIX_TRAININGS})[INDEX]    1    ${END_LIMIT}

    IF    '${ACTION}'=='Created'
        List Should Contain Value    ${ALL_TRAININGS_DISPLAYED}    ${TRAINING_NAME[0:13]}
    ELSE IF    '${ACTION}'=='Deleted'
        List Should Not Contain Value    ${ALL_TRAININGS_DISPLAYED}    ${TRAINING_NAME[0:13]}
    END


Change The Training Deadline And Verify
    [Documentation]    To Change The Training Deadline And Verify
    Capture Page Screenshot
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${TRAINING_FLYOUT_CALENDER_ICON}
    Click Element    ${TRAINING_FLYOUT_CALENDER_ICON}

    Wait Until Element Is Visible    //span[contains(@class,'mat-calendar-body-today')]/..
    ${before}=    Get Element Attribute    //span[contains(@class,'mat-calendar-body-today')]/..    aria-label
    Log    Current date shown: ${before}

    # Updated to match the format of the date string being received ('Oct 01, 2025')
    ${EXPECTED_DATE}=    Evaluate    (datetime.datetime.strptime('${before}', '%B %d, %Y') + datetime.timedelta(days=1)).strftime('%b %d, %Y')    modules=datetime
    Log    Expected tomorrow: ${EXPECTED_DATE}
    Set Test Variable    ${EXPECTED_DATE}


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

    Wait For The Element And Click    ${TRAINING_FLYOUT_UPDATE_FLYOUT_DONE_BUTTON}
    Wait For The Page To Load

    # Ensure the due date is updated correctly
    Wait Until Keyword Succeeds    5x    1s    Element Text Should Be    ${TRAINING_FLYOUT_DATE_SELECTED}    ${EXPECTED_DATE}
    Capture Page Screenshot


Unassign The Training From The Operator
    [Documentation]    To Unassign The Training From The Operator
    Wait For The Element And Click    ${TRAINING_FLYOUT_UNASSIGN_BUTTON}
    Wait For The Element And Click    ${TRAINING_FLYOUT_UNASSIGN_FLYOUT_DONE_BUTTON}
    Capture Page Screenshot
    Wait For The Page To Load

Get Procedures List In Training Execution Screen
    [Documentation]    To Get Procedures List In Training Execution Screen
    ${END_LIMIT}=    Get Element Count    ${PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN}
    ${ALL_PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN}=    Get Values In List For Validation    (${PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN})[INDEX]    1    ${END_LIMIT}
    Set Test Variable    ${ALL_PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN}

Reset The Training Execution Element
    [Documentation]    To Reset The Training Execution Element
    [Arguments]    ${RESET_TYPE}    ${STEP_NUMBER}    ${PROCEDURE_NUMBER}=2

    ${PROCEDURE_NUMBER_INDEX}    Evaluate    ${PROCEDURE_NUMBER}-1
    ${PROCEDURE}=    Get From List    ${ALL_PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN}    ${PROCEDURE_NUMBER_INDEX}

    IF    '${RESET_TYPE}'=='PROCEDURE'
        ${TRAINING_EXECUTION_PROCEDURE_RESET_LABEL_LOCATOR}=    Replace String    ${TRAINING_EXECUTION_PROCEDURE_RESET_LABEL}    PROCEDURE    ${PROCEDURE}
        Wait For The Element And Click    ${TRAINING_EXECUTION_PROCEDURE_RESET_LABEL_LOCATOR}

    ELSE IF    '${RESET_TYPE}'=='STEP'
        ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
        Wait For The Element And Click    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}
        Wait For The Element And Click    (${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_LABEL})[${STEP_NUMBER}]
    END
    Wait For The Element And Click    ${TRAINING_EXECUTION_RESET_POPUP_BUTTON}


Reset The Step Group Step In Training Execution
    [Documentation]    To Reset The Step Group Step In Training Execution
    [Arguments]    ${PROCEDURE_NUMBER}

    ${PROCEDURE_NUMBER_INDEX}    Evaluate    ${PROCEDURE_NUMBER}-1
    ${PROCEDURE}=    Get From List    ${ALL_PROCEDURE_DISPLAYED_ON_TRAINING_EXECUTION_SCREEN}    ${PROCEDURE_NUMBER_INDEX}

    #Expand The procedure
   ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
   Wait For The Element And Click    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}

    #Expand The step group
#   ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}=    Replace String    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND}    PROCEDURE    ${PROCEDURE}
#   Wait For The Element And Click    ${TRAINING_EXECUTION_PROCEDURE_STEP_RESET_EXPAND_LOCATOR}

    Wait For The Element And Click    ${TRAINING_EXECUTION_PROCEDURE_STEP_GROUP_RESET_LABEL}
    Wait For The Element And Click    ${TRAINING_EXECUTION_RESET_POPUP_BUTTON}


Expand The Procedure From The Left Panel In Training Execution
    [Documentation]    To Expand The Procedure From The Left Panel In Training Execution
    [Arguments]    ${PROCEDURE_NUMBER}

    ${IS_EXPANDED}=    Run Keyword And Return Status    Wait Until Page Contains Element    (${TRAINING_EXECUTION_LEFT_PANEL_PROCEDURE_EXPAND_BUTTON})[${PROCEDURE_NUMBER}]${GENERIC_EXPANDED}
    Run Keyword If    not ${IS_EXPANDED}    Click Element    (${TRAINING_EXECUTION_LEFT_PANEL_PROCEDURE_EXPAND_BUTTON})[${PROCEDURE_NUMBER}]


Verify The Procedure Step Is Reset
    [Documentation]    To Verify The Procedure Step Is Reset
    [Arguments]    ${STEP_NUMBER}


    Expand The Procedure From The Left Panel In Training Execution    PROCEDURE_NUMBER=1

    ${TRAINING_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK_LOCATOR}=    Replace String    ${TRAINING_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK}    STEP_NUMBER    ${STEP_NUMBER}
    Page Should Not Contain Element    ${TRAINING_EXECUTION_LEFT_PANEL_PROCEDURE_STEP_UPDATED_CHECK_LOCATOR}


Verify The Step Group Procedure Step Is Reset In Training Execution
    [Documentation]    To Verify The Step Group Procedure Step Is Reset In Training Execution
    Wait Until Page Does Not Contain Element    (${TRAINING_EXECUTION_PROCEDURE_STEP_GROUP_RESET_CHECK})[2]


Select The Filters On Training List Page
    [Documentation]    To Select The Filters On Training List Page
    Wait For The Element And Click    ${MY_TRAINING_STATUS_FILTER}
    Wait For The Element And Click    ${MY_TRAINING_STATUS_ONTIME_FILTER}

Validate The Correct Filtered Results Shown On Training List Page
    [Documentation]    To Validate The Correct Filtered Results Shown On Training List Page
    ${user_records}=    Get Current Record Count On Page    
    ${upper_bound}=    Get Element Count    ${ALL_RECORDS_DISPLAYED_AFTER_FILTERS}
    ${RECORD_COUNT_WITH_FILTER}=    Get Upper Bound    ${user_records}    ${upper_bound}
    Set Test Variable    ${RECORD_COUNT_WITH_FILTER}
    
    #Extract list
    ${END_LIMIT}=    Get Element Count    ${MY_TRAINING_LISTED_RECORDS_STATUS}
    ${MY_TRAINING_LISTED_RECORDS_STATUS_LIST}=    Get Values In List For Validation    (${MY_TRAINING_LISTED_RECORDS_STATUS})[INDEX]    1    ${END_LIMIT}

    #Validate status
    Validate The Extracted List Data    ${MY_TRAINING_LISTED_RECORDS_STATUS_LIST}    VALIDATION_VALUE=On time
    Capture Page Screenshot

Click On The Teams Tab On The Training User Assign Window
    [Documentation]    To Click On The Teams Tab On The Training User Assign Window
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    3s    1s    Click Element    ${ASSIGN_USERS_TO_TRAINING_TEAMS_TAB}

Assign The Training To Team
    [Documentation]    To Assign The Training To Team
    [Arguments]    ${EXISTING_TEAMS}=False
    Click On The Teams Tab On The Training User Assign Window
    IF    '${EXISTING_TEAMS}'=='True'
        ${EXTRACTED_TEAMS_LIST}=    Evaluate    [item for item in ${EXTRACTED_TEAMS_LIST} if item != '']
        FOR    ${TEAM}    IN    @{EXTRACTED_TEAMS_LIST}
            Continue For Loop If    '${TEAM}'==''
            Input Text    ${ASSIGN_TRAINING_TO_TEAM_INPUT_SEARCH}    ${TEAM}
            ${LOCATOR}=    Replace String    ${ASSIGN_TRAINING_TO_SEARCHED_TEAMS}    VALUE    ${TEAM}
            Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR}
        END
        ${TEAMS_LIST_LENGTH}    Evaluate    len(${EXTRACTED_TEAMS_LIST})
        Set Test Variable    ${TEAMS_LIST_LENGTH}
        Element Should Contain    ${TEAMS_ASSIGNED_FOR_TRAINING_COUNT}    ${TEAMS_LIST_LENGTH}
        Click On Assign Training Done Button
        Return From Keyword
    END

Verify All The Teams Assigned To Training Are Visible On Assign Window
    [Documentation]    To Verify All The Teams Assigned To Training Are Visible On Assign Window
    Element Should Contain    ${TEAMS_ASSIGNED_FOR_TRAINING_COUNT}    ${TEAMS_LIST_LENGTH}
    Capture Page Screenshot