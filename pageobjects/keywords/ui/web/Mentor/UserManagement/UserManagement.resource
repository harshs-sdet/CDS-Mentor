*** Settings ***
Library    SeleniumLibrary
Library    String
Library    ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/UserManagement.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Resource    Teams.resource
Resource    ../Workspace/Workspace.resource
Resource    ../../../../../keywords/ui/web/Mentor/Login/Login.resource
Resource    ../Common/Common.resource

*** Variables ***
${tc_add_user_input_validation}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}PageActionData${/}UserPersonalDetailsValidationData.csv
${tc_add_new_user}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}PageActionData${/}NewUserPageActionData.csv
${DATE_FORMAT}    %b %d, %Y | %I:%M %p
${USERS_LIST_PAGE}    ${Url}/users
*** Keywords ***

Get The First User Details
    [Documentation]    To Get The First User Details
    Wait Until Element Is Visible    ${first_username}    ${Max_limit}
    ${td_user_name}=    Get Text    ${first_username}
    Set Test Variable    ${td_user_name}

    ${td_user_status}=    Get Text    ${first_user_status}
    Set Test Variable    ${td_user_status}



Navigate To User Details Page
    [Documentation]    To Navigate To User Details Page
    [Arguments]    ${USER_EMAIL}=False
    
    IF    '${USER_EMAIL}'!='False'
        Input Text    ${INPUT_SEARCH}    ${USER_EMAIL}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_USER_EMAIL_LIST_PAGE}    ${USER_EMAIL}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${first_username}
        Return From Keyword    
    END
    
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${first_username}
    Wait For The Page To Load
    Wait Until Page Does Not Contain Element    ${add_new_button}    ${Max_limit}




Toggle The Status
    [Documentation]    To Toggle The Status
    Wait Until Page Contains Element    ${toggle_button}
    Scroll And Click    ${toggle_button}
    Wait For The Page To Load


Click On Edit Button In User Details 
    [Documentation]    To Click On Edit Button In User Details
    Wait For The Element And Click    ${edit_user}
    Wait For The Page To Load
    Element Should Be Visible    ${verify_edit_user}


Save The User Changes
    [Documentation]    To Save The User Changes
    Navigate To Professional Details
    Navigate To Workspace Tab In New User Window
    Navigate To Skills Tab In New User Window
    Click On The Done Button On New User Window
#    Wait Until Page Contains Element    //div[@role="alert" and @aria-label="User updated successfully"]    ${Max_limit}


Navigate To Professional Details
    [Documentation]    To Navigate To Professional Details
    Wait For The Element And Click    ${ADD_NEW_USER_NEXT_BUTTON}
    Wait For The Page To Load

Navigate To Workspace Tab In New User Window
    [Documentation]    To Navigate To Workspace Tab In New User Window
    Wait For The Element And Click    ${ADD_NEW_USER_NEXT_BUTTON}
    Wait For The Page To Load


Navigate To Skills Tab In New User Window
    [Documentation]    To Navigate To Skills Tab In New User Window
    [Arguments]    ${MOVE_TO_SKILLS_TAB_DIRECTLY}=False
    
    IF    '${MOVE_TO_SKILLS_TAB_DIRECTLY}'=='True'
        Wait Until Element Is Visible    ${USERS_DETAILS_PAGE_SKILLS_TAB}
        Click Element By JS    ${USERS_DETAILS_PAGE_SKILLS_TAB}
        Wait For The Page To Load
        Return From Keyword
    END
        
    Wait For The Element And Click    ${ADD_NEW_USER_NEXT_BUTTON}
    Wait For The Page To Load


Click On The Done Button On New User Window
    [Documentation]    To Click On The Done Button On New User Window
    Wait For The Element And Click    ${ADD_NEW_USER_DONE_BUTTON}
    Wait Until Keyword Succeeds    5x    1s    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}




Validate The User Status
    [Documentation]    To Verify The User Status
    Wait Until Element Is Visible    ${first_user_status}    ${Max_limit}
    ${updated_user_status}=    Get Text    ${first_user_status}
    IF    '${td_user_status}'=='Active'
        Should Be Equal As Strings    ${updated_user_status}    Inactive
    ELSE
         Should Be Equal As Strings    ${updated_user_status}    Active
    END


Enter the User Email
    [Documentation]    To Enter the User Email
    [Arguments]     ${Role}
    #Email
#    ${updated}=  Replace String    ${Role}    ${SPACE}    _
    ${NAMES_ARRAY}=    Split String    ${Role}    ${SPACE}
    IF    '${NAMES_ARRAY[0]}'!='Mentor'
        VAR    ${updated}    ${NAMES_ARRAY[0]}
    ELSE
        VAR    ${updated}    ${NAMES_ARRAY[1]}
    END
    ${number}=      Generate Random String      4       [LETTERS][NUMBERS]
    ${final}=      Catenate   SEPARATOR=     ${updated}    ${number}
    ${final}=     Get Substring    ${final}    0    15
#    ${temp}=    Generate Random String    10
    ${TD_USER_EMAIL}    Get Random Email    ${final}
    Log    ${TD_USER_EMAIL}
    Set Test Variable    ${TD_USER_EMAIL}
    Scroll Element And Enter Value   ${input_email}    ${TD_USER_EMAIL}
    Sleep    2s


Update The Personal Detail
    [Documentation]    To Update The Personal Detail
    [Arguments]     ${role}
    #first Name
    ${role}=    Strip String    ${role}
    ${td_first_name}    Evaluate    "${role}".split(" ")[0]
    IF    '${role}' != 'Author' and '${role}' != 'Supervisor'
        ${td_last_name}    Evaluate    "${role}".split(" ")[1]
    ELSE
         ${td_last_name}=   Set Variable    Mentor
    END
#    ${td_first_name}=    Generate Random String
    Set Test Variable    ${td_first_name}
    Scroll Element And Enter Value   ${input_first_name}    ${td_first_name}


    #Last Name
    ${td_last_name}=    Generate Random String
    Set Test Variable    ${td_last_name}
    Scroll Element And Enter Value   ${input_last_name}    ${td_last_name}


    #Mobile Number
    ${td_mobile_number}=    Generate Random String    10    [NUMBERS]
    Set Test Variable    ${td_mobile_number}
    Scroll Element And Enter Value   ${input_mobile_no}    ${td_mobile_number}


    #Landline Number
    ${td_landline_number}=    Generate Random String    10    [NUMBERS]
    Set Test Variable    ${td_landline_number}
    Scroll Element And Enter Value   ${input_landline_no}    ${td_landline_number}


    #Fax
    ${td_fax}=    Generate Random String    10    [NUMBERS]
    Set Test Variable    ${td_fax}
    Scroll Element And Enter Value   ${input_fax}    ${td_fax}


    #Language
    Click Element    ${language_select}
    Wait Until Page Contains Element    ${language_option}    ${Max_limit}
    ${td_language}=    Get Text    ${language_option}
    Set Test Variable    ${td_language}
    Wait For The Element And Click    ${language_option}



    #TimeZone
    Wait For The Element And Click   ${timezone_select}
    Wait Until Page Contains Element    ${timezone_option}    ${Max_limit}
    ${td_timezone}=    Get Text    ${timezone_option}
    Set Test Variable    ${td_timezone}
    Wait For The Element And Click    ${timezone_option}


Validate The Updated User Details
    [Documentation]    To Validate The Updated User Details
    #first Name
    ${user_fn_from_SF}=    Get Element Attribute    ${input_first_name}    value
    Check The Strings Are Equal    ${user_fn_from_SF}    ${td_first_name}

    #Last Name
    ${user_ln_from_SF}=   Get Element Attribute    ${input_last_name}    value
    Check The Strings Are Equal    ${user_ln_from_SF}    ${td_last_name}


    #Mobile Number
    ${mobile_number_from_SF}=   Get Element Attribute    ${input_mobile_no}    value
    Check The Strings Are Equal    ${mobile_number_from_SF}    ${td_mobile_number}


    #Landline Number
    ${landline_number_from_SF}=   Get Element Attribute    ${input_landline_no}    value
    Check The Strings Are Equal    ${landline_number_from_SF}    ${td_landline_number}


    #Fax
    ${user_fax_from_SF}=   Get Element Attribute    ${input_fax}    value
    Check The Strings Are Equal    ${user_fax_from_SF}    ${td_fax}

    #Language
    ${user_language_from_SF}=   Get Text    ${saved_user_language}
    Check The Strings Are Equal    ${user_language_from_SF}    ${td_language}


    #TimeZone
    ${user_timezone_from_SF}=   Get Text    ${saved_user_timezone}
    Check The Strings Are Equal    ${user_timezone_from_SF}    ${td_timezone}



Click Add New Button On User List Page
    [Documentation]    To Click Add New Button On User List Page
    Wait For The Page To Load
    Wait For The Element And Click    ${ADD_NEW_BUTTON}
    Wait For The Page To Load


Update The Professional Details
    [Documentation]    To Update The Professional Details

    #Site
    Click Element    ${site_dropdown}
    TRY
        Input Text    ${input_search}    ${TD_SITE_NAME}
        ${locator}=    Replace String    ${site_option_workspace}    SITE    ${TD_SITE_NAME}
        Wait For The Element And Click    ${locator}
    EXCEPT        
    #    ${site_index}=    Generate Random Number Between Range As String    2    3
        ${site_index}=    Set Variable    3
        ${locator}=    Replace String    ${ADD_NEW_USER_SITE_OPTION}    INDEX    ${site_index}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
        ${td_site}=    Get Text    ${locator}
        Set Test Variable    ${td_site}
        Wait For The Element And Click    ${locator}
        Sleep    2s
    END
    Press Keys    None    ESC


    #Role
    Select The User Role

    #Job Title
    ${td_job_title}=    Generate Random String
    Set Test Variable    ${td_job_title}
    Scroll Element And Enter Value   ${input_job_title}    ${td_job_title}


    #Department
    ${td_department}=    Generate Random String
    Set Test Variable    ${td_department}
    Scroll Element And Enter Value   ${input_department}    ${td_department}


    #Devision
    ${td_division}=    Generate Random String
    Set Test Variable    ${td_division}
    Scroll Element And Enter Value   ${input_devision}    ${td_division}


Verify The New Created User
    [Documentation]    To Verify The New Created User
    Scroll Element And Enter Value    ${user_search}    ${TD_USER_EMAIL}
    Wait Until Element Is Visible    ${searched_user_name}    ${Max_limit}
    ${full_name_from_SF}=    Wait Until Keyword Succeeds    5x    1s    Get Text    ${searched_user_name}
    ${obtained_fullname}=    Get User Full Name From FN LN    ${td_first_name}    ${td_last_name}
    Should Be Equal As Strings    ${full_name_from_SF}    ${obtained_fullname}

Verify User Is not Visible
    [Arguments]     ${USER_EMAIL}
    Scroll Element And Enter Value    ${user_search}    ${USER_EMAIL}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}  #
    Wait Until Element Is Visible    ${ZERO_RECORDS}    ${Max_limit}

Delete The New Created User
    [Documentation]    To Delete The New Created User
    Wait For The Element And Click    ${delete_icon}
    Wait For The Element And Click    ${delete_popup}
    Wait For The Page To Load
    Scroll Element And Enter Value    ${user_search}    ${TD_USER_EMAIL}
    Sleep    3s




Click On Personal Details Tab And Verify Navigation
    [Documentation]    To Click On Personal Details Tab
    Wait For The Element And Click    ${left_panel_personal}
    Wait Until Element Is Visible    ${input_email}    ${Max_limit}


Click On Professional Details Tab And Verify Navigation
    [Documentation]    To Click On Professional Details Tab
    Wait For The Element And Click    ${left_panel_professional}
    Wait Until Element Is Visible    ${site_dropdown}    ${Max_limit}

Click On Workspace Tab And Verify Navigation
    [Documentation]    To Click On Workspace Tab
    Wait For The Element And Click    ${left_panel_workspace}
    Wait Until Element Is Not Visible    ${site_dropdown}    ${Max_limit}


Input Number And Verify The Invalid Value Validations
    [Documentation]    To Input Number And Verify The Invalid Value Validations
    GetTestDataVariables    ${tc_add_user_input_validation}    InvalidPhoneNumber
    ${invalid_number1}    ${invalid_number2}     ${invalid_number3} =    Split String    ${PAD_IncorrectPhoneNumber}    ,
    Scroll Element And Enter Value   ${input_mobile_no}    ${invalid_number1}
    Press Keys    ${input_mobile_no}    SHIFT+TAB
    Scroll Element And Enter Value   ${input_landline_no}    ${invalid_number2}
    Press Keys    ${input_mobile_no}    SHIFT+TAB
    Scroll Element And Enter Value   ${input_fax}    ${invalid_number3}
    Press Keys    ${input_mobile_no}    SHIFT+TAB
    Click Element    ${input_mobile_no}
    Wait Until Element Is Visible    ${phone_number_validation}    ${Max_limit}
    ${count}=    Get Element Count   ${phone_number_validation}
    Should Be True    ${count}>=1



Verify The Read-Only Fields And Save Changes
    [Documentation]    To Verify The Read-Only Fields And Save Changes
    Wait Until Element Is Visible    ${input_email}
    Element Should Be Disabled    ${input_email}
    Navigate To Professional Details
#    Wait Until Element Is Visible    ${disabled_site_dropdown}    ${Max_limit}
    Navigate To Workspace Tab In New User Window
    Navigate To Skills Tab In New User Window
    Click On The Done Button On New User Window


Verify The Table Column Labels On User List Page
    [Documentation]    To Verify The Table Column Labels On User List Page
    Wait Until Element Is Visible    ${label_name}    ${Max_limit}
    ${name_label_text}=    Get Text    ${label_name}
    Should Be Equal As Strings    ${name_label_text}      Name
    ${email_label_text}=    Get Text    ${label_email}
    Should Be Equal As Strings    ${email_label_text}     Email
    ${site_label_text}=    Get Text    ${LABEL_SITE_Workspace}
    Should Be Equal As Strings    ${site_label_text}      Site/Company
    ${role_label_text}=    Get Text    ${label_role}
    Should Be Equal As Strings    ${role_label_text}      Role
    ${status_label_text}=    Get Text    ${label_status}
    Should Be Equal As Strings    ${status_label_text}      Status
    ${date_label_text}=    Get Text    ${label_createdOn}
    Should Be Equal As Strings    ${date_label_text}      Created on
    ${action_label_text}=    Get Text    ${label_action}
    Should Be Equal As Strings    ${action_label_text}      Actions


Validate Dates Are Sorted On User/Teams List Page
    [Documentation]    To Validate Dates Are Sorted On User/Teams List Page
    ${date_texts}=    Get The User Creation Dates    ${user_creation_dates}

    #verify sorting Descending
    @{parsed_dates}=    Evaluate    [__import__('datetime').datetime.strptime(d, '''${DATE_FORMAT}''') for d in ${date_texts}]
    Log    ${parsed_dates}
    ${sorted_dates}=    Evaluate    sorted(${parsed_dates}, reverse=True)
    Log    ${sorted_dates}
    Should Be Equal    ${parsed_dates}    ${sorted_dates}

    Capture Page Screenshot
    #Sort Ascending
    Click On The 'Created On' Column Header

    #verify sorting Ascending
    ${asc_date_texts}=    Get The User Creation Dates    ${user_creation_dates}
    @{parsed_dates}=    Evaluate    [__import__('datetime').datetime.strptime(d, '''${DATE_FORMAT}''') for d in ${asc_date_texts}]
    Log    ${parsed_dates}
    ${sorted_dates}=    Evaluate    sorted(${parsed_dates}, reverse=False)
    Log    ${sorted_dates}
    Should Be Equal    ${parsed_dates}    ${sorted_dates}
    Capture Page Screenshot

Validate The Names Are Sorted On User /Teams List Page
    [Documentation]    To Validate The Names Are Sorted On User /Teams List Page

    # Open sort
    Mouse Over    ${LABEL_NAME_SORT}
    Wait For The Element And Click    ${LABEL_NAME_SORT}
    Wait For The Page To Load

    ${MAX_LIMIT}=    Get Element Count    ${USER_NAME_LIST_PAGE}

    # ===== Verify sorting ASCENDING (case-insensitive) =====
    ${USER_NAMES}=    Get Values In List For Validation
    ...    (${USER_NAME_LIST_PAGE})[INDEX]    1    ${MAX_LIMIT}

    ${EXPECTED_ASC}=    Evaluate
    ...    sorted(${USER_NAMES}, key=lambda x: x.lower())

    Should Be Equal    ${USER_NAMES}    ${EXPECTED_ASC}

    # Click again to sort DESC
    Mouse Over    ${LABEL_NAME_SORT}
    Wait For The Element And Click    ${LABEL_NAME_SORT}
    Wait For The Page To Load

    # ===== Verify sorting DESCENDING (case-insensitive) =====
    ${USER_NAMES}=    Get Values In List For Validation
    ...    (${USER_NAME_LIST_PAGE})[INDEX]    1    ${MAX_LIMIT}

    ${EXPECTED_DESC}=    Evaluate
    ...    sorted(${USER_NAMES}, key=lambda x: x.lower(), reverse=True)

    Should Be Equal    ${USER_NAMES}    ${EXPECTED_DESC}



Get The User Creation Dates
    [Documentation]    To Get The User creation Dates
    [Arguments]    ${locator}
    @{dates}=    Get WebElements    ${locator}
    @{date_texts}=    Create List
    FOR    ${el}    IN    @{dates}
        ${text}=    Get Text    ${el}
        Append To List    ${date_texts}    ${text}
    END
    RETURN    ${date_texts}

Click On The 'Created On' Column Header
    [Documentation]    To  Click On The 'Created On' Column Header
#    Mouse Over    ${label_createdOn}
    Double Click Element    ${label_createdOn}
    Wait For The Page To Load


Ensure Users List Page Is Open
    [Documentation]    To Ensure Users List Page Is Open
    ${status}=    Run Keyword And Return Status    Navigate To Users List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Reload Page
    Wait For The Page To Load

    Sleep    2s
    ${status}=    Run Keyword And Return Status    Navigate To Users List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    Navigate To Users List Page

Validate The Correct Filtered Results Shown
    [Documentation]    To Validate The Correct Filtered Results Shown
    ${user_records}=    Get Current Users Count On Page
    ${upper_bound}=    Get Element Count    ${ALL_RECORDS_DISPLAYED_AFTER_FILTERS}
    ${RECORD_COUNT_WITH_FILTER}=    Get Upper Bound    ${user_records}    ${upper_bound}
    Set Test Variable    ${RECORD_COUNT_WITH_FILTER}
    ${filtered_user_roles}    Create List
    ${filtered_user_status}    Create List
    ${role_validation_list}    Create List    Mentor Trainer    Standard Operator    Site Administrator    Mentor Site Admin
    FOR    ${i}    IN RANGE    1    ${upper_bound}
        ${i}=    Evaluate    str(${i})
        ${locator}=    Replace String    ${user_record_role}    INDEX    ${i}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
        ${role}=    Get Text    ${locator}
        ${role}=    Strip String    ${role}
        Append To List    ${filtered_user_roles}    ${role}
        #status
        ${locator}=    Replace String   ${user_record_status}    INDEX    ${i}
        ${status}=    Get Text    ${locator}
        ${status}=    Strip String    ${status}
        Append To List    ${filtered_user_status}    ${status}
    END

    #Validate status
    FOR    ${user_status}    IN    @{filtered_user_status}
        Should Be Equal As Strings    ${user_status}    Active
    END

    #Validate roles
    FOR    ${user_role}    IN    @{filtered_user_roles}
        List Should Contain Value    ${role_validation_list}    ${user_role}
    END

Get Current Users Count On Page
    [Documentation]    To Get Current Users Count On Page
    ${count}=    Get Text    ${users_count}
    ${count}=    Split String    ${count}    of
    ${count}=    Strip String    ${count}[1]
    RETURN    ${count}



Verify The Correct Persona Selected
    [Documentation]    To Verify The Correct Persona Selected
    Wait Until Element Is Visible    ${user_persona_selected}
    ${selected_user_persona}=    Get Text   ${user_persona_selected}
    Should Be Equal As Strings    ${selected_user_persona}    Mentor Site Admin


Verify The User Name is Displayed In The Breadcrumbs
    [Documentation]    To Verify The User Name is Displayed In The Breadcrumbs
    ${locator}=    Replace String    ${breadcrumbs_username}    USERNAME   ${td_user_name}
    Wait Until Element Is Visible    ${locator}    ${Max_limit}


Click On Users Link And Verify User Lands On The Users List Page
    [Documentation]    To Click On Users Link And Verify User Lands On The Users List Page
    Wait For The Element And Click    ${link_users_page}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${add_new_button}    ${Max_limit}


Verify The Same Total Users Count From Header And Pagination
    [Documentation]    To Verify The Same Total Users Count From Header And Pagination
    Wait Until Element Is Visible    ${user_count_in_header}
    ${user_count_from_header}=    Get Text    ${user_count_in_header}
    ${user_count_from_header}=    Extract Numbers    ${user_count_from_header}
    ${count_from_pagination}=    Get Current Users Count On Page
    Check The Strings Are Equal    ${user_count_from_header}    ${count_from_pagination}


Save User Count Before Updating Users List
    [Documentation]    To Save User Count Before Updating Users List
    ${count}=    Get Current Users Count On Page
    ${user_count_before}=    Set Variable    ${count}
    Set Test Variable    ${user_count_before}

Verify The User Count Is Updated After Adding New User
    [Documentation]    To Verify The User Count Is Updated After Adding New User
    ${count}=    Get Current Users Count On Page
    ${user_count_before}=    Evaluate    str(int(${user_count_before})+1)
    Should Be Equal As Strings    ${user_count_before}      ${count}

Select The Site Option
    [Documentation]    To Select The Site Option
    Wait For The Element And Click    ${site_dropdown}
    TRY
        Input Text    ${input_search}    ${PAD_Site}
        ${locator}=    Replace String    ${site_option_workspace}    SITE    ${PAD_Site}
        Wait For The Element And Click    ${locator}
    EXCEPT
        Input Text    ${input_search}    ${TD_SITE_NAME}
        ${locator}=    Replace String    ${site_option_workspace}    SITE    ${TD_SITE_NAME}
        Wait For The Element And Click    ${locator}
    END        


Select The Site With Correct Workspaces
    [Documentation]    To Select The Site With Correct Workspaces
#    GetTestDataVariables    ${tc_add_new_user}    NewUserWorkSpace
    Select The Site Option

Get The Existing Site And Workspace Data
    [Documentation]    To Get The Existing Site And Workspace Data
    Navigate To Workspace Page
    Get The First Workspace Details
    VAR    ${PAD_Workspace}
    Set Test Variable    ${PAD_Workspace}    ${TD_WORKSPACE_NAME}
    Navigate To Workspace Details Page
    Wait Until Element Is Visible    ${SITE_FROM_DETAILS_PAGE}    ${Max_limit}
    ${PAD_Site}=    Get Text    ${SITE_FROM_DETAILS_PAGE}
    ${PAD_Site}=    Strip String    ${PAD_Site}
    Set Test Variable    ${PAD_Site}



Verify The Workspaces Displayed Corresponding To The Site
    [Documentation]    To Verify The Workspaces Displayed Corresponding To The Site
    @{workspaces_list}=    Split String    ${PAD_Workspace}    ,
    FOR    ${workspace_item}    IN   @{workspaces_list}
        ${locator}=    Replace String    ${workspace_record}    WORKSPACE    ${workspace_item}
        Scroll Element And Enter Value      ${input_search}    ${workspace_item}
        Wait Until Element Is Visible    ${locator}
    END

    ${temp}=    Generate Random String
    Scroll Element And Enter Value      ${input_search}    ${temp}
    Wait Until Page Does Not Contain Element    ${locator}    ${Max_limit}
    Clear Element Text    ${input_search}
    Input Text    ${input_search}    ${workspaces_list}[-1]
    Wait Until Page Contains Element    ${locator}    ${Max_limit}


Delete Selected Users
    [Documentation]    To Delete Selected Users
    #save the user count before deleting the users
    ${user_count_before_del_mul_users}=    Get Current Users Count On Page
    Set Test Variable    ${user_count_before_del_mul_users}
    Wait Until Element Is Visible    ${selected_users}    ${Max_limit}
    Wait For The Element And Click    ${delete_multiple_users}
    Wait For The Element And Click    ${DELETE_MULTIPLE_POPUP}
    Wait For The Page To Load


Verify The Users Count After Deleting The Users
    [Documentation]    To Verify The Users Count After Deleting The Users
    Reload Page
    Wait For The Page To Load
    ${current_count}=    Get Current Record Count On Page
    ${user_count_before_del_mul_users}=    Evaluate    str(int(${user_count_before_del_mul_users})-2)
    Should Be Equal As Strings    ${current_count}    ${user_count_before_del_mul_users}


Verify The Users Count Should Not Change
    [Documentation]    To Verify The Users Count Should Not Change
    ${current_count}=    Get Current Users Count On Page
    Should Be Equal As Strings    ${current_count}    ${user_count_before_del_mul_users}


Cancel User Record Deletion
    [Documentation]    To Cancel User Record Deletion
    ${user_count_before_del_mul_users}=    Get Current Users Count On Page
    Set Test Variable    ${user_count_before_del_mul_users}
    Wait Until Element Is Visible    ${selected_users}   ${Max_limit}
    Wait For The Element And Click    ${delete_multiple_users}
    Wait For The Element And Click    ${CANCEL_THE_RECORDS_DELETION}
    Wait For The Page To Load

Get Other Orgs User Details
    [Documentation]    To Get Other Orgs User Details
    GetTestDataVariables    ${tc_add_user_input_validation}    InvalidUsers
    ${other_orgs_users}=    Split String    ${PAD_IncorrectUsers}    ,
    Set Test Variable    ${other_orgs_users}


Verify The Different Org Users Records Not Visible
    [Documentation]    To Verify The Different Org Users Records Not Visible
    FOR    ${user}    IN     @{other_orgs_users}
        Scroll Element And Enter Value    ${user_search}    ${user}
        Wait Until Element Is Visible    ${no_user_record}    ${Max_limit}
    END



# Select The User Role
#     [Documentation]    To Select The User Role
#     [Arguments]    ${user_role}=Mentor Site Admin
#     ${roles_matrix}=    Split String    ${user_role}    ${SPACE}
#     ${length}=    Evaluate    len(${roles_matrix})
#     IF    ${length}==1 or '${roles_matrix[0]}'!='Mentor'
#         ${user_role}=    Set Variable   ${roles_matrix[0]}
#     ELSE
#         ${user_role}=    Set Variable   ${roles_matrix[1]}
#     END
#     Wait For The Element And Click    ${role_select}
#     Scroll Element And Enter Value    ${input_search}    ${user_role}
#     ${locator}=    Replace String    ${input_select_role}    ROLE    ${user_role}
#     Wait For The Element And Click    ${locator}
#     Press Keys    None    ESC

Select The User Role
    [Documentation]    To Select The User Role
    [Arguments]    ${user_role}=Site
    Wait For The Element And Click    ${role_select}
    Scroll Element And Enter Value    ${input_search}    ${user_role}
    ${locator}=    Replace String    ${input_select_role}    ROLE    ${user_role}
    Wait For The Element And Click    ${locator}
    Press Keys    None    ESC


Verify User Is Able To Create New Users Persona
   [Documentation]    To Verify User Is Able To Create New Users Persona
   [Arguments]    ${PARTICULAR_PERSONA}=False
   IF    '${PARTICULAR_PERSONA}'!='False'
       ${persona_list}    Create List   ${PARTICULAR_PERSONA}
   ELSE
       ${persona_list}    Create List   Mentor Trainer    Mentor Site   Quality Manager    Standard Operator    Author    Expert Operator    Supervisor
   END
   FOR    ${persona}    IN    @{persona_list}
       Navigate To Users List Page
       Click Add New Button On User List Page
       Enter the User Email     ${persona}
       Update The Personal Detail   ${persona}
       Navigate To Professional Details
       Update The Professional Details
       Select The User Role    ${persona}
       Navigate To Workspace Tab In New User Window
    #    Navigate To Skills Tab In New User Window
       Click On The Done Button On New User Window
       Verify The New Created User
   END


Enter the User Blacklisted Domain Email
    [Documentation]    To Enter the User Blacklisted Domain Email
    #Email
    ${temp}=    Generate Random String    10
    ${TD_USER_EMAIL}=    Evaluate    '${temp}'+'@yopmail.com'
    Set Test Variable    ${TD_USER_EMAIL}
    Scroll Element And Enter Value   ${input_email}    ${TD_USER_EMAIL}
    Sleep    2s


Verify The Error Message Displayed For Incorrect Domain
    [Documentation]    To Verify The Error Message Displayed For Incorrect Domain
    Run Keyword And Ignore Error    Element Should Be Visible    ${error_in_creating_user}
    Wait Until Element Is Visible    ${ADD_NEW_USER_DONE_BUTTON}



Delete The Workspace From The User Details Page
    [Documentation]    To Delete The Workspace From The User Details Page
    ${SearchedWorkspace}     Get Text    (//div[@class="mat-grid-tile-content"]//span)[1]
    Set Global Variable     ${SearchedWorkspace}
    Search The Workspace On Teams Details Page    ${SearchedWorkspace}
    Wait For The Element And Click    ${DELETE_ICON_USER_DETAILS}
    Wait For The Element And Click    ${DELETE_POPUP_USER_DETAILS}


Search The Removed Workspace And Add Again
    [Documentation]    To Search The Removed Workspace And Add Again
    ...    Bug Is logged - Not able add removed workspace
    Wait For The Element And Click    ${Add_ELE}

    Scroll Element And Enter Value    ${SEARCH_ELE_WORK}    ${EXTRACTED_WORKSPACE_LIST[0]}
    Wait For The Page To Load
    ${locator}=    Replace String    ${SEARCHED_WORKSPACE}    WORKSPACE    ${EXTRACTED_WORKSPACE_LIST[0]}
    Select Checkbox    ${locator}
    Wait For The Element And Click    ${ADD_WORKSPACE_AGAIN}
    ${locator}=    Replace String    ${ADDED_WORKSPACE}    WORKSPACE    ${EXTRACTED_WORKSPACE_LIST[0]}
    Wait Until Element Is Visible    ${locator}

Get The Workspace Data
    [Documentation]    To Get The Workspace Data
    GetTestDataVariables    ${tc_add_new_user}    WorkspaceProcedures



Select The Workspace And Validate The Procedures
    [Documentation]    To Select The Workspace And Validate The Procedures
    ${locator}=    Replace String    ${WORKS_ASSOCIATES_PROCEDURE}    WORKSPACE    ${PAD_Workspace}
    Wait For The Element And Click    ${locator}
    FOR    ${procedure}    IN    @{WORKSPACE_All_PROCEDURES}
        ${locator}=    Replace String    ${PROCEDURE_IN_WORKS}    PROCEDURE    ${procedure}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
    END

Get The Procedure Data
    [Documentation]    To Get The Procedure Data
    Scroll Element And Enter Value    ${input_search}    ${PAD_Workspace}
    Wait For The Page To Load
    ${locator}=    Replace String    ${workspace_record}    WORKSPACE    ${PAD_Workspace}
    Wait For The Element And Click    ${locator}
    Wait For The Element And Click    ${PROCEDURES_LIST}
    Wait Until Element Is Visible    ${PROCEDURE_LIST_ITEM}
    @{procedures}=    Get WebElements    ${PROCEDURE_LIST_ITEM}
    @{WORKSPACE_All_PROCEDURES}=    Create List
    FOR    ${procedure}    IN    @{procedures}
        ${text}=    Get Text    ${procedure}
        ${text}=    Strip String    ${text}
        ${text}=    Remove Trailing Dots    ${text}
        Append To List    ${WORKSPACE_All_PROCEDURES}    ${text}
    END
    Set Test Variable    ${WORKSPACE_All_PROCEDURES}

Navigate To Users Page From Workspaces
    [Documentation]    To Navigate To Users Page From Workspaces
    Mouse Over    ${dashboard_link}
    Wait For The Element And Click    ${left_Navigation_user_management}
    Wait For The Element And Click    ${USERS_TAB}

Click On ADD New Button On Users List Page 
    [Documentation]    To Click Add New Button
    Wait For The Element And Click    ${ADD_NEW_BUTTON}
    Wait For The Page To Load

Select The Filters On Users List Page
    [Documentation]    To Select The Filters On Users List Page
    Click Element     ${role_filter}
    Wait Until Keyword Succeeds   10x     2s    Click Element     ${filter_view_more}
    VAR    ${END_INDEX}    5
    FOR     ${i}    IN RANGE    2    ${END_INDEX}
        ${i}=    Evaluate    str(${i})
        ${locator}=    Replace String    ${option_role_filter}    INDEX    ${i}
        Wait For The Element And Click    ${locator}
    END
    #Select the Status As Active
    Repeat Keyword    10x    Press Keys    None    ARROW_DOWN
    Scroll And Click    ${status_filter}
    Wait For The Element And Click    ${status_option}

Click On The Workspace Procedure
    [Documentation]    To Click On The Workspace Procedure
    Wait For The Element And Click    ${WORKSPACE_PROCEDURE}
#    Wait For The Element And Click    ${WORKSPACE_PROCEDURE_LIST_WINDOW}
    Execute Javascript    window.scrollBy(0, 500);
    
    
Search The Skill In User Details Skill Tab
    [Documentation]    To Search The Skill In User Details Skill Tab
    [Arguments]    ${SKILL_DELETED}=False
    Wait Until Element Is Visible    ${INPUT_SEARCH}
    Input Text    ${INPUT_SEARCH}    ${TD_SKILL_NAME}
    IF    '${SKILL_DELETED}'=='True'
        Wait Until Keyword Succeeds    5x    1s    Element Should Not Contain    ${USER_DETAILS_FIRST_SKILL}    ${TD_SKILL_NAME}
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${USER_DETAILS_FIRST_SKILL}    ${TD_SKILL_NAME}
    END

    
Delete The Skill From The User Details Page
    [Documentation]    To Delete The Skill From The User Details Page
    Wait For The Element And Click    ${DELETE_SKILL_ICON_USER_DETAILS}
    Capture Page Screenshot
    Wait For The Element And Click    ${DELETE_SKILL_POPUP_USER_DETAILS}
    Capture Page Screenshot


Select The Current Level In User Details
    [Documentation]    To Select The Current Level In User Details
    [Arguments]    ${LIST_VALUE}
    Wait For The Element And Click    ${USER_DETAILS_FIRST_SKILL_CURRENT_LEVEL}
    Capture Page Screenshot
    Press Keys    None    ESC
    Wait For The Element And Click    ${USER_DETAILS_FIRST_SKILL_TARGET_LEVEL}
    Capture Page Screenshot
    Press Keys    None    ESC
    Wait Until Keyword Succeeds    5x    1s    Select From List By Value    ${USER_DETAILS_FIRST_SKILL_CURRENT_LEVEL}    ${LIST_VALUE}

Switch to Workspace Tab
    Click Element       ${UserWorkspaceTab}

Verify User can access the Procedures Of The Workspace
    Wait Until Keyword Succeeds   10x     2s    Click Element       ${WorkspaceProcedures}

Observe the Count Of Workspaces After Deletion
    ${CountUpdated}=   Get Element Count    ${WorkspaceCount}
    ${CountPrevious}=   Evaluate    ${CountPrevious}-1
    Should Be Equal   ${CountUpdated}     ${CountPrevious}

Observe the Count Of Workspaces Before Deletion
    ${CountPrevious}=   Get Element Count    ${WorkspaceCount}
    Set Global Variable    ${CountPrevious}

Verify The 'User is inactive' Is Displayed When Attempting To Login
    [Documentation]    To Verify The 'User is inactive' Is Displayed When Attempting To Login
    Wait Until Page Contains    User not found


Verify The User Can Create New Personas when Logged In As
    [Documentation]    To Verify The User Can Create New Personas when Logged In As
    [Arguments]    ${PERSONA}
    
    ${USERS_LIST}=    Create List    Org Admin    Mentor Site
    IF    '${PERSONA}'=='Site Admin'
        Wait For The Element And Click    ${role_select}
        Capture Page Screenshot
        Wait Until Element Is Visible    ${LISTED_PERSONA_ROLE}
        ${COUNT}=    Get Element Count    ${LISTED_PERSONA_ROLE}
        Should Be True    ${COUNT}==9
    ELSE IF    '${PERSONA}'=='Org Admin'
        
        FOR    ${USER}    IN    @{USERS_LIST}
            Select The User Role    ${USER}
        END    
        Wait For The Element And Click    ${role_select}
        Capture Page Screenshot
        Wait Until Element Is Visible    ${LISTED_PERSONA_ROLE}
        ${COUNT}=    Get Element Count    ${LISTED_PERSONA_ROLE}
        Should Be True    ${COUNT}==4
        Press Keys    None    ESC
    END

Verify The Data Of Users On List Page
    [Documentation]    To Verify The Data Of Users On List Page
    [Arguments]    ${SITE_NAME}    ${USER_ROLE}


    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_NAME_LIST_PAGE})[1]    ${td_last_name}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_EMAIL_LIST_PAGE})[1]    ${TD_USER_EMAIL}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_COMPANY_LIST_PAGE})[1]    ${SITE_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_ROLE_LIST_PAGE})[1]    ${USER_ROLE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_STATUS_LIST_PAGE})[1]    Active
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_CREATEDON_LIST_PAGE})[1]    ${TODAY_DATE}

Verify User Lands On The Users List Page
    [Documentation]    To Verify User Lands On The Users List Page
    Wait Until Location Is    ${USERS_LIST_PAGE}    ${Max_limit}