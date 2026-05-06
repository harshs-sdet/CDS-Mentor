*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource    ../Common/Common.resource
Resource    ../UserManagement/UserManagement.resource
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/SiteManagement.yaml

*** Variables ***
${SITE_LIST_PAGE}    ${Url}/sites
*** Keywords ***

Click on the Site option
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SiteIcon}     ${MaxTime}
    Click Element    ${SiteIcon}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}

Click on the Add Button
    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}     ${MaxTime}
    Click Element    ${ADD_NEW_BUTTON}


#Select Image
#    Wait Until Element Is Visible    ${UPLOAD_BUTTON}     ${MaxTime}
#    Click Element    ${UPLOAD_BUTTON}
#   Wait Until Element Is Visible    ${UPLOAD_BUTTON}    ${MaxTime}
#    Choose File    ${UPLOAD_BUTTON}    ${IMAGE_PATH}
#   Click Element    //div[contains(@class, 'upload-placeholder')]
#   Sleep    4s
#   Press Keys    C T R L + L    # Move to address bar
#   Press Keys    C:\Users\divyank.gupta\Documents\sample images\samp4.jpg
#   Press Keys    ENTER


Enter name on Name input Field
    [Arguments]     ${Name}
    Wait Until Element Is Visible    ${INPUT_SITE_NAME}     timeout=60s
    Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SITE_NAME}    ${Name}

Enter Address on Addresline1
    [Arguments]     ${Address1}
    Wait Until Element Is Visible    ${INPUT_ADDRESS_LINE1}     ${MaxTime}
    Input Text    ${INPUT_ADDRESS_LINE1}    ${Address1}

Enter Address on Addresline2
    [Arguments]     ${Address2}
    Wait Until Element Is Visible    ${INPUT_ADDRESS_LINE2}     ${MaxTime}
    Input Text    ${INPUT_ADDRESS_LINE2}    ${Address2}

Click on the Select Country dropdown and select country
    Wait Until Element Is Visible    ${Country_select}     ${MaxTime}
    Click Element    ${Country_select}
#    Select From List By Value  ${Country_select}    ${CountryValue}
    Select span by value    ${CountryValue}

Select span by value
    [Arguments]        ${txt_value}
    Click Element    ${txt_spantxt_genericstart}${txt_value}${txt_spantxt_genericend}

Click on the Select State dropdown and select state
    Click Element    ${State_select}
    Select span by value     ${State_value}
#    Select From List By Value  ${State_select}    ${State_value}
    
Enter The City
    [Arguments]    ${City_value}
    Input Text    ${INPUT_CITY}    ${City_value}

#Click on the Select City dropdown and select city
#    Wait Until Element Is Visible    ${City_select}     ${MaxTime}
#    Click Element    ${City_select}
#    Select From List By Value  ${City_select}    ${City_value}

Click and Enter Postal code
    [Arguments]     ${Post_code}
    Wait Until Element Is Visible    ${INPUT_POSTAL_CODE}     ${MaxTime}
    Input Text    ${INPUT_POSTAL_CODE}    ${Post_code}

Enter Email id
    [Arguments]     ${EmailId}
    Scroll Element Into View    ${INPUT_SITE_EMAIL}
    Wait Until Element Is Visible    ${INPUT_SITE_EMAIL}     ${MaxTime}
    Input Text    ${INPUT_SITE_EMAIL}    ${EmailId}

Select Country code and Enter phone Number
    [Arguments]         ${CodeCountry}    ${Phone_number}
    Input Text    ${INPUT_PHONE_NUMBER}    ${Phone_number}

Enter description in description field
    [Arguments]     ${description_text}
    Wait Until Element Is Visible    ${INPUT_DESCRIPTION}     ${MaxTime}
    Input Text    ${INPUT_DESCRIPTION}    ${description_text}

Click On Next Button On New Site Window
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${NEXT_BUTTON_SITE_DETAILS_PAGE}     ${MaxTime}
    Scroll Element Into View     ${NEXT_BUTTON_SITE_DETAILS_PAGE}
    Wait Until Keyword Succeeds   5x    1s    Click Element    ${NEXT_BUTTON_SITE_DETAILS_PAGE}

Click On Next Button On Workspace Window
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${NEXT_BUTTON_SITE_DETAILS_PAGE}     ${MaxTime}
    Scroll Element Into View     ${NEXT_BUTTON_SITE_DETAILS_PAGE}
    Wait Until Keyword Succeeds   5x    1s    Click Element    ${NEXT_BUTTON_SITE_DETAILS_PAGE}    

Click On Done Button On New Site Window
    [Documentation]    To Click On Done Button On New Site Window
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${NEW_SITE_WINDOW_DONE_BUTTON}
    Wait Until Keyword Succeeds   5x    1s    Click Element    ${NEW_SITE_WINDOW_DONE_BUTTON}

Verify The Counts
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}
    ${CURRENT_COUNT}=   Get Current Record Count On Page
    Should Be Equal As Numbers   ${PREV_RECORD_COUNT}     ${CURRENT_COUNT}

Get Initial Site Count
    Sleep    5s
    Wait Until Page Contains Element    ${SITE_COUNT_XPATH}    ${MaxTime}
    ${initial_text}    Get Text    ${SITE_COUNT_XPATH}
    ${initial_count}    Get Regexp Matches    ${initial_text}    \d+
    ${INITIAL_COUNT}    Set Variable    ${initial_count}[0]
    Convert To Integer    ${INITIAL_COUNT}
    Set Global Variable    ${INITIAL_COUNT}
    Log    Initial site count: ${INITIAL_COUNT}

Get Final Site Count And Validate
    Sleep    5s
    Wait Until Page Contains Element    ${SITE_COUNT_XPATH}    ${MaxTime}
    ${final_text}    Get Text    ${SITE_COUNT_XPATH}
    ${final_count}    Get Regexp Matches    ${final_text}    \d+
    ${FINAL_COUNT}    Set Variable    ${final_count}[0]
    Convert To Integer    ${FINAL_COUNT}
    Log    Final site count: ${FINAL_COUNT}


Navigate To Site List Page
    [Documentation]    To Navigate To Site List Page
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${status}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SITE_TAB}    5s
    IF    '${status}'=='True'
        Click Element    ${SITE_TAB}
    ELSE
        Wait For The Element And Click    ${ADMINISTRATION_LINK}
        Wait For The Element And Click    ${SITE_TAB}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}    ${Max_limit}
    Mouse Over    ${ADD_NEW_BUTTON}

Verify The User Is Not Able Create Empty Site
    [Documentation]    To Verify The User Is Not Able Create Empty Site
    Click On Next Button On New Site Window
    Click On Next Button On Workspace Window
    Click On Done Button On New Site Window
    Sleep    2s
    Wait Until Page Contains    Please enter valid information for Name    ${Max_limit}

Enter The Site Detail
    [Documentation]    To Enter The Site Detail
    #SITE Name
    ${TD_SITE_NAME}=    Generate Random String
    Set Test Variable    ${TD_SITE_NAME}
    Enter name on Name input Field   ${TD_SITE_NAME}


    #Address Line 1
    ${TD_ADD_LINE1}=    Generate Random String
    Set Test Variable    ${TD_ADD_LINE1}
    Enter Address on Addresline1    ${TD_ADD_LINE1}


    #Address Line 2
    ${TD_ADD_LINE2}=    Generate Random String
    Set Test Variable    ${TD_ADD_LINE2}
    Enter Address on Addresline2    ${TD_ADD_LINE2}


    #Country
    Set Selenium Speed    0.3s
    Click Element    ${COUNTRY_DROPDOWN}
    ${country_index}=    Generate Random Number Between Range As String    3    4
    ${locator}=    Replace String    ${COUNTRY_OPTION}    INDEX    ${country_index}
    Wait Until Page Contains Element    ${locator}    ${Max_limit}
    ${TD_SITE_COUNTRY}=    Get Text    ${locator}
    Set Test Variable    ${TD_SITE_COUNTRY}
    Wait For The Element And Click    ${locator}



    #State
    Wait Until Element Is Not Visible    ${Toaster}    timeout=10s
    # Wait Until Element Is Visible    ${STATE_DROPDOWN}    ${Max_limit}
    Click Element    ${STATE_DROPDOWN}
    ${state_index}=    Generate Random Number Between Range As String    3    4
    ${locator}=    Replace String    ${STATE_OPTION}    INDEX    ${state_index}
    Wait Until Page Contains Element    ${locator}    ${Max_limit}
    ${TD_SITE_STATE}=    Get Text    ${locator}
    Set Test Variable    ${TD_SITE_STATE}
    Wait For The Element And Click    ${locator}


    #City
    ${TD_SITE_CITY}=    Generate Random String
    Set Test Variable    ${TD_SITE_CITY}
    Enter The City     ${TD_SITE_CITY}


    #Postal Code
    ${TD_SITE_POSTAL_CODE}=    Generate Random String    7
    Set Test Variable    ${TD_SITE_POSTAL_CODE}
    Click and Enter Postal code   ${TD_SITE_POSTAL_CODE}



    #Email
    ${temp}=    Generate Random String
    ${TD_SITE_EMAIL}=    Get Random Email    ${temp}
    Set Test Variable    ${TD_SITE_EMAIL}
    Enter Email id   ${TD_SITE_EMAIL}


    #Phone Number
    ${TD_SITE_PHONE_NUMBER}=    Generate Random String    10    [NUMBERS]
    Set Test Variable    ${TD_SITE_PHONE_NUMBER}
    Input Text    ${INPUT_PHONE_NUMBER}    ${TD_SITE_PHONE_NUMBER}


    #Description
    ${TD_SITE_DESC}=    Generate Random String
    Set Test Variable    ${TD_SITE_DESC}
    Enter description in description field   ${TD_SITE_DESC}
    Set Selenium Speed    0s

Verify The Workspaces Tab On New Site Page
    [Documentation]    To Verify The Workspaces Tab On New Site Page
    Wait Until Element Is Visible    ${NEW_SITE_WINDOW_DONE_BUTTON}


Verify The New Created Site
    [Documentation]    To Verify The New Created Site
#    Run Keyword And Ignore Error     Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SITE_NAME}
    ${SITE_SEARCHED_STOREFRONT}=    Get Text    ${SEARCHED_SITE}
    Should Be Equal As Strings    ${SITE_SEARCHED_STOREFRONT}    ${TD_SITE_NAME}


Verify The New Created Site Should Not Be Visible
    [Documentation]    To Verify The New Created Site Should Not Be Visible
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${INPUT_SEARCH}      ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SITE_NAME}
    Wait Until Element Is Visible   ${ZERO_RECORDS}
    Element Should Be Visible    ${ZERO_RECORDS}



Delete The Site
    [Documentation]    To Delete and verify The Deleted Site
    Retry Until Element Clickable    ${DELETE_ICON}
    Wait For The Element And Click    ${DELETE_POPUP}
    Wait For The Page To Load
    Run Keyword And Ignore Error     Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SITE_NAME}
    Wait Until Element Is Visible    ${NO_SITE_FOUND}    ${Max_limit}

    #Other Skill records after deleting a Site
    Clear Element Text    ${INPUT_SEARCH}
    Reload Page
    Wait Until Element Is Not Visible    ${NO_SITE_FOUND}    ${Max_limit}


Click On ADD New Button On Site List Page
    [Documentation]    To Click Add New Button
    Wait For The Element And Click    ${ADD_NEW_BUTTON}
    Wait For The Page To Load


Click On Edit Button On Site Details Page
    [Documentation]    To Click On Edit Button On Site Details Page
    Wait For The Element And Click    ${EDIT_SITE}
    Wait For The Page To Load

Verify The Workspace Is Deleted From The Site
    [Documentation]    To Verify The Workspace Is Deleted From The Site
    Element Should Not Be Visible    ${DELETE_WORKSPACE_FROM_SITE}

Validate The Updated Site Details
    [Documentation]    To Validate The Updated SITE Details

    #SITE Name
    ${SITE_NAME_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_SITE_NAME}    value
    Check The Strings Are Equal    ${SITE_NAME_FROM_STOREFRONT}    ${TD_SITE_NAME}

    #Address Line 1
    ${SITE_ADD1_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_ADDRESS_LINE1}    value
    Check The Strings Are Equal    ${SITE_ADD1_FROM_STOREFRONT}    ${TD_ADD_LINE1}


    #Address Line 2
    ${SITE_ADD2_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_ADDRESS_LINE2}    value
    Check The Strings Are Equal    ${SITE_ADD2_FROM_STOREFRONT}    ${TD_ADD_LINE2}

    #City
    ${SITE_CITY_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_CITY}    value
    Check The Strings Are Equal    ${SITE_CITY_FROM_STOREFRONT}    ${TD_SITE_CITY}


    #Postal Code
    ${SITE_POSTAL_CODE_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_POSTAL_CODE}    value
    Check The Strings Are Equal    ${SITE_POSTAL_CODE_FROM_STOREFRONT}    ${TD_SITE_POSTAL_CODE}


    #Email
    ${SITE_EMAIL_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_EMAIL}    value
    Check The Strings Are Equal    ${SITE_EMAIL_FROM_STOREFRONT}    ${TD_SITE_EMAIL}


    #Phone Number
    ${SITE_PHONE_NUMBER_STOREFRONT}=    Get Element Attribute    ${INPUT_PHONE_NUMBER}    value
    Check The Strings Are Equal    ${SITE_PHONE_NUMBER_STOREFRONT}    ${TD_SITE_PHONE_NUMBER}


    #Description
    ${SITE_DESC_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_DESCRIPTION}    value
    Check The Strings Are Equal    ${SITE_DESC_FROM_STOREFRONT}    ${TD_SITE_DESC}


Navigate To Site Details Page
#    [Arguments]     ${TD_SITE_NAME}
    [Documentation]    To Navigate To Site Details Page
    Wait Until Page Contains Element    ${INPUT_SEARCH}    ${Max_limit}
    Run Keyword And Ignore Error     Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SITE_NAME}
    Wait Until Element Is Visible    ${FIRST_SITE}
    Wait Until Keyword Succeeds    5x    2s    Element Should Contain    ${FIRST_SITE}    ${TD_SITE_NAME}
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${FIRST_SITE}
    Wait For The Page To Load
    Wait Until Page Does Not Contain Element    ${ADD_NEW_BUTTON}    ${Max_limit}

Ensure Site List Page Is Open
    [Documentation]    To Ensure Site List Page Is Open
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}    ${Max_limit}
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Reload Page
    Wait For The Page To Load

    Sleep    2s
    ${status}=    Run Keyword And Return Status    Navigate To Site List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${OrgAdminPass}
    Navigate To Site List Page

Debug Mat Select Full
    Capture Page Screenshot    before_dropdown.png
    ${count}=    Get Element Count    xpath=//mat-select
    Log    Total mat-select count: ${count}    console=True
    ${ready}=    Execute Javascript    return document.readyState
    Log    Page ready state: ${ready}    console=True
    ${overlay}=    Get Element Count    xpath=//*[contains(@class,'overlay') or contains(@class,'spinner') or contains(@class,'snack') or contains(@class,'backdrop')]
    Log    Blocking overlays found: ${overlay}    console=True
    ${hidden}=    Get Element Count    xpath=//mat-select[ancestor::*[contains(@style,'display:none') or contains(@style,'visibility:hidden')]]
    Log    Hidden mat-selects: ${hidden}    console=True

Click On Cancel Button On New Site Window
    [Documentation]    To Click On Cancel Button On New Site Window
    Wait For The Element And Click    ${CANCEL_BUTTON}

Verify User Lands On The Site List Page
    [Documentation]    To Verify User Lands On The Site List Page
    Wait Until Location Is    ${SITE_LIST_PAGE}    ${Max_limit}

Get The First Site Details
    [Documentation]    To Get The First Site Details
    Wait Until Element Is Visible    ${FIRST_SITE}    ${Max_limit}
    ${TD_SITE_NAME}=    Get Text    ${FIRST_SITE}
    Set Test Variable    ${TD_SITE_NAME}


Verify The Site Name is Displayed In The Breadcrumbs
    [Documentation]    To Verify The Site Name is Displayed In The Breadcrumbs
    ${locator}=    Replace String    ${BREADCRUMBS_SITE}    SITE   ${TD_SITE_NAME}
    Wait Until Element Is Visible    ${locator}    ${Max_limit}


Click On Site Link In Breadcrumb
    [Documentation]    To Click On Site Link In Breadcrumb
    Wait For The Element And Click    ${LINK_SITE_PAGE}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}    ${Max_limit}


Verify The User Is Not Able To Add Workspaces
    [Documentation]    To Verify The User Is Not Able To Add Workspaces
    Wait Until Element Is Visible    ${NO_WORKSPACES}


Verify The Workspace Is Associated To The Site
    [Documentation]    To Verify The Workspace Is Associated To The Site
    ${locator}=    Replace String    ${ASSOCIATED_WORKSPACE}    WORKSPACE    ${TD_WORKSPACE_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible    ${locator}    ${MaxTime}


Navigate To Workspace Tab Under Site Details
    [Documentation]    To Navigate To Workspace Tab Under Site Details
    Wait For The Element And Click    ${WORKSPACES_UNDER_SITE_DETAILS}

Get The All Site Names
    [Documentation]    To Get The All Site Names
    @{ALL_SITES}=    Extract Values In List From All Pages    Get Values In List For Validation    ${ALL_SITE_NAMES}    2
    Set Test Variable    @{ALL_SITES}


Delete The Workspace From The Site
    [Documentation]    To Delete The Workspace From The Site
    Wait For The Element And Click    ${DELETE_WORKSPACE_FROM_SITE}
    Wait For The Element And Click    ${DELETE_POPUP}
    Click On Next Button On Workspace Window
    Click On Done Button On New Site Window

Verify The Pagination On Add Procedures To Workspaces In Site Details Page
    [Documentation]    To Verify The Pagination On Add Procedures To Workspaces In Site Detials Page
    Verify The Pagination On Custom Page    ${SITE_DETAILS_INSIDE_PAGE_SIZE_SELECT}    ${SITE_DETAILS_INSIDE_RECORDS_COUNT}    ${SITE_DETAILS_INSIDE_PAGINATION_NEXT_PAGE}

Click On Cancel Button On Add Procedures To Workspace Window On Site Details Page
    [Documentation]    To Click On Cancel Button On Add Procedures To Workspace Window On Site Details Page
    Wait For The Element And Click    ${CANCEL_ADDING_PROCEDURES_TO_SITE_ON_SITE_DETAILS}
    Wait Until Element Is Visible    ${WORKSPACE_PROCEDURE}


Verify The Workspace Is Removed From The Mapped Site
    [Documentation]    To Verify The Workspace Is Removed From The Mapped Site
    Page Should Not Contain    ${TD_WORKSPACE_NAME}
#    Wait Until Element Is Visible    ${NO_WORKSPACES_IN_SITE}
#    Wait Until Element Is Visible    ${ADD_WORKSPACES_LINK_IN_SITE}


Verify The Users Count In Site Is Changed By
    [Documentation]    To Verify The Records Count Is Changed By given argument
    [Arguments]    ${CHANGE_FACTOR}=0
    ${CURRENT_COUNT}=   Get The Users Count In The Site
    Check The Count Is Changed    ${PREVIOUS_USERS_COUNT_IN_SITE}   ${CURRENT_COUNT}    ${CHANGE_FACTOR}


Get The Users Count In The Site
    [Documentation]    To Get The Users Count In The Site
    ${LOCATOR}=    Replace String    ${NEW_CREATED_SITE}    SITE    ${TD_SITE_NAME}
    Wait Until Element Is Visible    ${LOCATOR}
    ${USERS_COUNT_IN_SITE}=    Get Text    ${USERS_COUNT_IN_SITE}
    RETURN    ${USERS_COUNT_IN_SITE}


Save The Previous Users Count In The Site
    [Documentation]    To Save The Previous Users Count In The Site
    ${PREVIOUS_USERS_COUNT_IN_SITE}=    Get The Users Count In The Site
    Set Test Variable    ${PREVIOUS_USERS_COUNT_IN_SITE}


Verify that Site Is Not Editable At User Group's Screen
    [Documentation]    To Verify that Site Is Not Editable At User Group's Screen
    Run Keyword And Ignore Error     Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_TEAM_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${TEAM_RECORD_LISTED_ON_LIST_PAGE}    ${TD_TEAM_NAME}
    Click Element    ${TEAM_RECORD_LISTED_ON_LIST_PAGE}
    Wait Until Element Is Visible    ${site_dropdown}
#    Element Should Be Disabled    ${site_dropdown}
    ${ELEMENT_CLASS}=    Get Element Attribute    ${site_dropdown}    class
    Should Contain    ${ELEMENT_CLASS}    mat-form-field-disabled
    
    
Create And Activate User    
    [Documentation]    To Create And Activate User 
    [Arguments]    ${USER_PERSONA_OF_NEW_USER}=Site Administrator
    Navigate To Users List Page
    Save User Count Before Updating Users List
    Verify User Is Able To Create New Users Persona   ${USER_PERSONA_OF_NEW_USER}
    Logout From Mentor
    Navigate To Inbox To Get The Data    ${TD_USER_EMAIL}
    Get The Temporary Creds Emailed
    Close All Browsers
    Login To Mentor Application    ${TD_USER_EMAIL}    ${TEMP_PASS}
    Reset The Password      ${NewPassword}
    Wait For The Page To Load
    Verify User Is Able To Navigate To Home Page 
    Add Item To List       ${TD_USER_EMAIL}    CREATED_USERS_LIST


Verify The Sorting Functionality On The Site List Page
    [Documentation]    Verify sorting on Site List page for Name, Created On, Workspaces, Assigned Users.

    ${MAX_LIMIT}=    Get Element Count    ${SITE_NAME_LOCATOR}

    # 1) SITE NAME
    Wait For The Element And Click    ${SITE_HEADER_NAME}
    Wait For The Page To Load
    ${SITE_NAMES}=    Get Values In List For Validation    (${SITE_NAME_LOCATOR})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_SITE_NAMES}=    Evaluate    sorted(${SITE_NAMES}, key=lambda x: x.lower())
    Should Be Equal    ${SITE_NAMES}    ${SORTED_SITE_NAMES}
    Capture Page Screenshot

    Wait For The Element And Click    ${SITE_HEADER_NAME}
    Wait For The Page To Load
    ${SITE_NAMES}=    Get Values In List For Validation    (${SITE_NAME_LOCATOR})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_SITE_NAMES_DESC}=    Evaluate    sorted(${SITE_NAMES}, key=lambda x: x.lower(), reverse=True)
    Should Be Equal    ${SITE_NAMES}    ${SORTED_SITE_NAMES_DESC}
    Capture Page Screenshot

    # 2) CREATED ON
    Wait For The Element And Click    ${SITE_HEADER_CREATED_ON}
    Wait For The Page To Load
    ${SITE_CREATED_ON_RAW}=    Get Values In List For Validation    (${SITE_CREATED_ON})[INDEX]    1    ${MAX_LIMIT}
    ${SITE_CREATED_ON_LIST}=    Evaluate    [__import__('datetime').datetime.strptime(d, '%b %d, %Y | %I:%M %p') for d in ${SITE_CREATED_ON_RAW}]
    ${SORTED_SITE_CREATED_ON_ASC}=    Evaluate    sorted(${SITE_CREATED_ON_LIST})
    Should Be Equal    ${SITE_CREATED_ON_LIST}    ${SORTED_SITE_CREATED_ON_ASC}
    Capture Page Screenshot

    Wait For The Element And Click    ${SITE_HEADER_CREATED_ON}
    Wait For The Page To Load
    ${SITE_CREATED_ON_RAW}=    Get Values In List For Validation    (${SITE_CREATED_ON})[INDEX]    1    ${MAX_LIMIT}
    ${SITE_CREATED_ON_LIST}=    Evaluate    [__import__('datetime').datetime.strptime(d, '%b %d, %Y | %I:%M %p') for d in ${SITE_CREATED_ON_RAW}]
    ${SORTED_SITE_CREATED_ON_DESC}=    Evaluate    sorted(${SITE_CREATED_ON_LIST}, reverse=True)
    Should Be Equal    ${SITE_CREATED_ON_LIST}    ${SORTED_SITE_CREATED_ON_DESC}
    Capture Page Screenshot

    # 3) WORKSPACES COUNT (numeric)
    Wait For The Element And Click    ${SITE_HEADER_WORKSPACES}
    Wait For The Page To Load
    ${SITE_WORKSPACES_COUNT_LIST}=    Get Values In List For Validation    (${SITE_WORKSPACES_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_WORKSPACES_ASC}=    Evaluate    sorted(${SITE_WORKSPACES_COUNT_LIST}, key=int)
    Should Be Equal    ${SITE_WORKSPACES_COUNT_LIST}    ${SORTED_WORKSPACES_ASC}
    Capture Page Screenshot

    Wait For The Element And Click    ${SITE_HEADER_WORKSPACES}
    Wait For The Page To Load
    ${SITE_WORKSPACES_COUNT_LIST}=    Get Values In List For Validation    (${SITE_WORKSPACES_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_WORKSPACES_DESC}=    Evaluate    sorted(${SITE_WORKSPACES_COUNT_LIST}, key=int, reverse=True)
    Should Be Equal    ${SITE_WORKSPACES_COUNT_LIST}    ${SORTED_WORKSPACES_DESC}
    Capture Page Screenshot

    # 4) ASSIGNED USERS COUNT (numeric)
    Wait For The Element And Click    ${SITE_HEADER_ASSIGNED_USERS}
    Wait For The Page To Load
    ${SITE_ASSIGNED_USERS_COUNT_LIST}=    Get Values In List For Validation    (${SITE_ASSIGNED_USERS_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_USERS_ASC}=    Evaluate    sorted(${SITE_ASSIGNED_USERS_COUNT_LIST}, key=int)
    Should Be Equal    ${SITE_ASSIGNED_USERS_COUNT_LIST}    ${SORTED_USERS_ASC}
    Capture Page Screenshot

    Wait For The Element And Click    ${SITE_HEADER_ASSIGNED_USERS}
    Wait For The Page To Load
    ${SITE_ASSIGNED_USERS_COUNT_LIST}=    Get Values In List For Validation    (${SITE_ASSIGNED_USERS_COUNT})[INDEX]    1    ${MAX_LIMIT}
    ${SORTED_USERS_DESC}=    Evaluate    sorted(${SITE_ASSIGNED_USERS_COUNT_LIST}, key=int, reverse=True)
    Should Be Equal    ${SITE_ASSIGNED_USERS_COUNT_LIST}    ${SORTED_USERS_DESC}
    Capture Page Screenshot
