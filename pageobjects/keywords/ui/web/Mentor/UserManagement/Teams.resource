*** Settings ***
Library    SeleniumLibrary
Library    String
Library   ../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Teams.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Resource    ../../../../../keywords/ui/web/Mentor/Login/Login.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Trainings/Training.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource

*** Variables ***
${Name}    Team 1
${UserName}     DG
${tc_add_new_user}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}PageActionData${/}NewUserPageActionData.csv

*** Keywords ***
Click On Administration
    Run Keyword and Ignore Error    Wait Until Element Is Visible    ${Administration}     ${MaxTime}
    Mouse Over    ${Administration}
    Click Element    ${Administration}

#Click on User Management Button
#    Run Keyword and Ignore Error    Wait Until Element Is Visible    ${User_Management}     ${MaxTime}
#    Click Element    ${User_Management}

#Click on Site Management Button
#    Wait Until Element Is Visible    ${User_Management}     ${MaxTime}
#    Click Element    ${Site_Btn}

#Click on Teams
#    Run Keyword and Ignore Error    Wait Until Element Is Visible    ${TeamIcon}     ${MaxTime}
#    Click Element    ${TeamIcon}
#    Run Keyword and Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
#    Wait Until Element Is Visible    ${TEAMS_LIST_PAGE_ADD_NEW_BUTTON}     ${MaxTime}

#Fetch the Initial count
#    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
#    Sleep    5s
#    Wait Until Page Contains Element    ${FeatureCountText}    ${MaxTime}
#    ${CountText}      Get Text    ${FeatureCountText}
#    ${FeatureCount}=  Evaluate    "${CountText}".split("(")[1].strip()
#    ${CountInitial}=  Evaluate    "${FeatureCount}".split(")")[0].strip()
#    Set Global Variable    ${CountInitial}

#Fetch the Final count
#    Sleep  2s
#    Wait Until Element Is Visible    ${FeatureCountText}    ${MaxTime}
#    ${CountText}      Get Text    ${FeatureCountText}
#    ${FeatureCount}=  Evaluate    "${CountText}".split("(")[1].strip()
#    ${CountFinal}=  Evaluate    "${FeatureCount}".split(")")[0].strip()
#    Set Global Variable    ${CountFinal}

#Click Add New Button
#    Run Keyword And Ignore Error    Wait Until Page Contains Element   ${TEAMS_LIST_PAGE_ADD_NEW_BUTTON}      ${MaxTime}
#    Click Element    ${TEAMS_LIST_PAGE_ADD_NEW_BUTTON}
#    Wait Until Element Is Visible    ${Cancel_Button}   10s
#    Input Text    ${Name_Field}     ${Name}
#    Click Element    ${Select_Site}
#    Wait Until Element Is Visible    ${Select_SiteDropdown}   10s
#    Select From List By Index    ${Select_SiteDropdown}    1
#    Press Keys      None    ESC
#    Wait Until Page Contains Element    ${Add_button}   10s

#Click on Add Button On New Teams Window
#    Click Element    ${ADD_USERS_TO_TEAM_BUTTON}
#    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
#    Wait Until Page Contains Element    ${AddUser_Text}    10s
#    Select Checkbox    ${Select_Checkbox}
#    Wait Until Page Contains Element    ${Add_SelectedUser}    8s

Adding selected users to user group
    Wait For The Element And Click    ${ADD_WORKSPACE_DONE_BUTTON}
    Wait Until Element Is Visible    ${NEXT_BUTTON_TEAMS_DETAILS_PAGE}

Click on Add Workspace On Teams Details Page
    Wait For The Element And Click     ${ADD_WORKSPACE_TO_TEAM_DETAILS_PAGE}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}


#Click on Search bar
#    [Arguments]     ${UserGroupTo_Search}
#    Input Text    ${Search_field}        ${UserGroupTo_Search}

#Searched group should appear
#    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
#    ${TeamsName}    Replace String  ${TeamsCard_Name}  replace     ${UserGroupTo_Search}
#    Sleep    2s
#    Capture Page Screenshot


#Verify that Count is Increased
#    ${CountInitial}  Evaluate    ${CountInitial}+1
#    ${CountFinal}   Convert To Integer    ${CountFinal}
#    Should Be Equal     ${CountInitial}       ${CountFinal}

#Click on Delete icon
#    ${TeamsName}    Replace String  ${TeamsDeleteCard_Name}  replace     ${UserName}
#    Log To Console    ${TeamsName}
#    Sleep    2s
#    Click Element    ${TeamsName}


#Click On Delete Button
#    Wait Until Page Contains Element    ${Teams_delete_popup_button}    ${MaxTime}
#    Click Element    ${Teams_delete_popup_button}
#    Wait Until Page Contains Element    ${TEAMS_LIST_PAGE_ADD_NEW_BUTTON}

#Verify that count is reduced
#    ${CountInitial}  Evaluate    ${CountInitial}-1
#    ${CountFinal}   Convert To Integer    ${CountFinal}
#    Should Be Equal     ${CountInitial}       ${CountFinal}

#Select checkboxes to delete
##    Sleep    3s
##    Log To Console  ${Delete_checkboxes}
##    Click Element   (${Delete_checkboxes})[2]
##    Click Element   (${Delete_checkboxes})[3]
#
#
#    ${checkboxes_count}=    Get Element Count    ${Delete_checkboxes}
#    @{checkboxes}=  SeleniumLibrary.Get WebElements  ${Delete_checkboxes}
#    Log    ${checkboxes_count}
#    Log    ${checkboxes}
#
#    FOR    ${index}    IN    2    3
##        Wait Until Element Is Visible    ${checkboxes}[${index}]    timeout=5s
#        Click Element    ${checkboxes}[${index}]
#    END

#Verify that Selected and Delete button appears
#    Wait Until Element Is Visible    ${Selected_button}     ${MaxTime}
#    Wait Until Element Is Visible    ${Delete_button}     ${MaxTime}
#    Capture Page Screenshot
#
#Delete selected User Groups
#    Click Element    ${Delete_button}
#    Wait Until Element Is Visible    ${pop-up_Window}
#    Click Element    ${Delete_confirmation_button}
#    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
#
#Verify that Multiple User groups are deleted
#    sleep   3s
#    ${CountInitial}  Evaluate    ${CountInitial}-2
#    ${CountFinal}   Convert To Integer    ${CountFinal}
#    Should Be Equal     ${CountInitial}       ${CountFinal}
#
#Click on the Rows per Page
#    Scroll Element Into View    ${RowsPerPage}
#    Set Focus To Element     ${RowsPerPage}
#    Click Element    ${RowsPerPage}
#    Wait Until Element Is Visible    ${20RowsPerPage}
#    Click Element    ${20RowsPerPage}
#    Sleep    2s
#    Should Be Equal    ${20RowsPerPage}    ${ItemPerPage_count}
#
#Verify that by default only 10 rows are visible
#    Click Element    ${Header_checkbox}
#    Sleep    3s
#    Page Should Contain Element    ${Selected_Count_Btn}
#    Wait Until Element Is Visible    ${Selected_Count_Btn}    ${MaxTime}
#    ${SelectedCountText}      Get Text    ${Selected_Count_Btn}
#    ${Selected_Count}=  Evaluate    "${SelectedCountText}".split("\n")[1].strip()
#    ${SelectedCountFinal}=  Evaluate    "${Selected_Count}".split("(")[0].strip()
#    Set Global Variable    ${SelectedCountFinal}
#    Should Be Equal    ${SelectedCountFinal}    10
#
#Verify the count
#    IF    ${CountInitial} <= 10
#         Element Should Be Disabled    ${UG_Previous_btn}
#         Element Should Be Disabled    ${UG_Next_btn}
#    END
#    
#    IF    ${CountInitial} >= 10
#        Element Should Be Enabled    ${UG_Next_btn}
#    END
        
Click on the filter icon
    Wait Until Element Is Visible    ${Filter icon}     ${MaxTime}
    Click Element    ${Filter icon}

Verify that the side window opens
    Sleep    3s
    Element Should Be Visible    ${Status_dropdown}
    Sleep    3s
    Click Element    ${Arrow_key_UG}

Apply the Filter
#    Wait Until Element Is Visible    ${Active_checkbox}
    Click Element    ${Active_checkbox}
    Wait Until Element Is Enabled    ${Apply_button}    ${MaxTime}
    Click Element    ${Apply_button}

Verify that filter is applied
    Sleep    3s
    Page Should Contain Element    ${Applied_Filter}

Remove the filter
    Click Element    ${Applied_Filter}
    Wait Until Element Is Visible    ${clear_all}
    Click Element    ${clear_all}
    Wait Until Element Is Enabled    ${Apply_button}
    Click Element    ${Apply_button}

Verify the filter is removed
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Sleep    2s
#    Wait Until Element Is Not Visible    ${Applied_Filter}

Click on User Group Hyperlink
    Wait Until Element Is Visible    ${First_UG_Entry}
    Click Element    ${First_UG_Entry}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}

Verify that Breadcrumb links are visible
    Sleep    3s
    Wait Until Element Is Visible    ${UG_Breadcrumb}
    Page Should Contain Element    ${UG_Name_Breadcrumb}

Click on the breadcrumb link
    Click Element    ${UG_Breadcrumb}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${maxTime}

Verify That User navigate to User Group screen
    Wait Until Element Is Visible    ${TEAMS_LIST_PAGE_ADD_NEW_BUTTON}

Navigate To Teams Page
    [Documentation]    To Navigate To Teams Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${if_teams_tab_open}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${teams_tab}    5s
    ${if_user_management_tab_open}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${left_Navigation_user_management}    5s
    ${combined}=    Evaluate    ${if_user_management_tab_open} == ${if_teams_tab_open}
    IF    '${if_teams_tab_open}'=='True'
        Click Element    ${teams_tab}
        Wait For The Page To Load
        Return From Keyword
    ELSE IF    '${combined}'=='False'
        Wait For The Element And Click    ${left_Navigation_user_management}
        Wait For The Element And Click    ${teams_tab}
        Wait For The Page To Load
    ELSE
        Wait For The Element And Click    ${ADMINISTRATION_LINK}
        ${if_teams_tab_open}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${teams_tab}    5s
        Run Keyword If    not ${if_teams_tab_open}    Wait For The Element And Click    ${left_Navigation_user_management}
        Wait For The Element And Click    ${teams_tab}
        Wait For The Page To Load
    END
    
    Wait Until Element Is Visible    ${ADD_NEW_TEAM}
    Mouse Over    ${ADD_NEW_TEAM}

Click On Add New Button On Teams List Page
    [Documentation]    To Click On Add New Button On Teams List Page
    Wait For The Element And Click    ${ADD_NEW_TEAM}

Verify The User Is Not Able Create Empty Team
    [Documentation]    To Verify The User Is Not Able Create Empty Team
    Click On Next Button On New Site Window
    Click On Done Button On New Site Window
    Wait Until Page Contains    Please enter valid information for Name
    Capture Page Screenshot

Enter The Teams Details
    [Documentation]    To Enter The Teams Details
    [Arguments]    ${CUSTOM_TEAM_SITE}=False    ${UPDATE_DETAILS}=False

    #Team Name
    ${TD_TEAM_NAME}=    Generate Random String    10
    Set Test Variable    ${TD_TEAM_NAME}
    Scroll Element And Enter Value   ${INPUT_TEAM_NAME}    ${TD_TEAM_NAME}
    Sleep    2s

    #Description
    ${TD_DESC}=    Generate Random String    20
    Set Test Variable    ${TD_DESC}
    Scroll Element And Enter Value   ${INPUT_TEAM_DESCP}    ${TD_DESC}
    Sleep    2s


    Run Keyword If    ${UPDATE_DETAILS}    Return From Keyword      
    #Site
    Wait For The Element And Click    ${USER_GROUP_SITE_DROPDOWN}
    IF    '${CUSTOM_TEAM_SITE}'!='False'
        Input Text    ${input_site}   ${CUSTOM_TEAM_SITE}
        ${locator}=    Replace String    ${site_option}    SITE    ${CUSTOM_TEAM_SITE}
        Wait For The Element And Click    ${locator}
        Set Test Variable    ${CUSTOM_TEAM_SITE}
        Return From Keyword
    END
    Wait For The Element And Click    ${USER_GROUP_SITE_FIRST_OPTION}

Verify The Team Details
    [Documentation]    To Verify The Team Details
    [Arguments]    ${DETAILS_UPDATED}=True    ${DETAILS_EDITED}=False

    Wait Until Element Is Visible    ${INPUT_TEAM_NAME}

    IF    '${DETAILS_UPDATED}'=='False'
        ${TEAM_NAME_FROM_STORE_FRONT}=    Get Value     ${INPUT_TEAM_NAME}
        Should Not Contain    ${TEAM_NAME_FROM_STORE_FRONT}    ${TD_TEAM_NAME}
        Return From Keyword
    END

    ${TEAM_NAME_FROM_STORE_FRONT}=    Get Value     ${INPUT_TEAM_NAME}
    Should Contain    ${TEAM_NAME_FROM_STORE_FRONT}    ${TD_TEAM_NAME}

    ${TEAM_DESC_FROM_STORE_FRONT}=    Get Value    ${INPUT_TEAM_DESCP}
    Should Contain    ${TEAM_DESC_FROM_STORE_FRONT}    ${TD_DESC}
    
    Run Keyword If    ${DETAILS_EDITED}    Return From Keyword
    ${USER_GROUP_SITE_DROPDOWN_FROM_STORE_FRONT}=    Get Text    ${USER_GROUP_SITE_DROPDOWN}//span/span
    Should Contain    ${USER_GROUP_SITE_DROPDOWN_FROM_STORE_FRONT}    ${CUSTOM_TEAM_SITE}

Delete The Team From The List Page
    [Documentation]    To Delete The Team From The List Page
    Wait For The Element And Click    ${DELETE_ICON_TEAMS_DETAILS}
    Wait For The Element And Click    ${DELETE_POPUP_TEAMS_DETAILS}
    Wait For The Page To Load
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_TEAM_NAME}
    Sleep    3s
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}    ${Max_limit}


Navigate To Teams Details Page
    [Documentation]    To Navigate To Teams Details Page
    [Arguments]    ${CUSTOM_TEAM_NAME}=False
    IF    '${CUSTOM_TEAM_NAME}'!='False'
        Search The Team On List Page     ${CUSTOM_TEAM_NAME}
    ELSE
        Search The Team On List Page
    END
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${FIRST_TEAM_LIST_PAGE}
    Wait For The Page To Load


Search The Team On List Page
    [Documentation]    To Search The Team On List Page
    [Arguments]    ${CUSTOM_TEAM_NAME}=False    ${TEAM_DELETED}=False
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    IF    '${CUSTOM_TEAM_NAME}'!='False'
        Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH}    ${CUSTOM_TEAM_NAME}
        Run Keyword If    '${TEAM_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_TEAM_LIST_PAGE}    ${CUSTOM_TEAM_NAME}
        Return From Keyword
    END
    Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH}    ${TD_TEAM_NAME}
    Run Keyword If    '${TEAM_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_TEAM_LIST_PAGE}    ${TD_TEAM_NAME}



Add Users To New Team And Save Count
    [Documentation]    To Add Users To New Team And Save Count
    Wait For The Element And Click    ${ADD_ELE}
    Wait Until Keyword Succeeds    5x    1    Click Element    ${all_users}
    ${PREVIOUS_USERS_COUNT_IN_SITE}=    Get The Users Count In The New Team
    Set Test Variable  ${PREVIOUS_USERS_COUNT_IN_SITE}
    Wait For The Element And Click    ${add_users_to_team}
    Wait For The Element And Click    ${NEXT_BUTTON_TEAMS_DETAILS_PAGE}
    Wait For The Element And Click    ${SAVE_BUTTON_TEAMS_DETAILS_PAGE}


Get The Users Count In The New Team
    [Documentation]    To Get The Users Count In The New Team
    ${count}=    Get Text    ${users_count}
    ${count}=    Split String    ${count}    of
    ${count}=    Strip String    ${count}[1]
    RETURN    ${count}

Verify New Team Is Created
    [Documentation]    To Verify New Team Is Created
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_TEAM_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${TEAM_RECORD_LISTED_ON_LIST_PAGE}    ${TD_TEAM_NAME}
    ${locator}=    Replace String    ${new_team}    TEAMNAME    ${TD_TEAM_NAME}
    Wait Until Page Contains Element    ${locator}    ${Max_limit}


Create A Team With New User And Save Added Users Count
    [Documentation]    To Create A Team With New User And Save Count
    Enter The Teams Details
    Add Users To New Team And Save Count


Verify The User Is Deleted From The Team
    [Documentation]    To Verify The User Is Deleted From The Team
    ${LOCATOR}=    Replace String    ${NEWLY_CREATED_TEAM_USER_COUNT}    TEAM_NAME    ${TD_TEAM_NAME}
    ${current_count}=    Get Text    ${LOCATOR}
    ${PREVIOUS_USERS_COUNT_IN_SITE}=    Evaluate    str(int(${PREVIOUS_USERS_COUNT_IN_SITE})-1)
    Should Be Equal    ${PREVIOUS_USERS_COUNT_IN_SITE}    ${current_count}

Search The Newly Created User In The Add User To Team Window
    [Documentation]    To Search The Newly Created User In The Add User To Team Window 
    [Arguments]    ${TARGET_USER_EMAIL}
    Scroll Element And Enter Value    (${INPUT_SEARCH})[2]    ${TARGET_USER_EMAIL}
    Wait For The Page To Load
    ${locator}=    Replace String    ${TEAM_ADD_USER_SEARCHED_RESULT}    USER_EMAIL    ${TARGET_USER_EMAIL}
    Wait Until Element Is Visible    ${locator}    ${Max_limit}

Select The Different Site On New Team Window
    [Documentation]    To Select The Different Site On New Team Window
    Wait For The Element And Click    ${USER_GROUP_SITE_DROPDOWN}
    ${locator}=    Replace String    ${DIFFERENT_SITE_OPTION}    SITE    ${TD_SITE_NAME}
    Wait For The Element And Click    ${locator}

Verify The Cross-Site Users Not Listed
    [Documentation]    To Verify The Cross-Site Users Not Listed
    [Arguments]    ${TARGET_USER_EMAIL}
    Scroll Element And Enter Value    ${input}    ${TARGET_USER_EMAIL}
    Wait For The Page To Load
    ${locator}=    Replace String    ${TEAM_ADD_USER_SEARCHED_RESULT}    USER_EMAIL    ${TARGET_USER_EMAIL}
    Element Should Not Be Visible   ${locator}
    
Add The Users In The Teams List
    [Documentation]    To Add The Users In The Teams List
    [Arguments]    ${NEW_SITE_WITH_NO_USERS}=False    ${VERIFY_EMPTY_NAME_TEAM}=False
    Wait For The Element And Click    ${ADD_ELE}

    IF    ${NEW_SITE_WITH_NO_USERS}
        Return From Keyword
    END

    FOR    ${USER}    IN    @{ASSIGNED_USERS_TO_TEAM_LIST}
        Scroll Element And Enter Value    (${INPUT_SEARCH})[2]    ${USER}
        ${LOCATOR}=    Replace String    ${SEARCHED_USER_IN_TEAM}    USERNAME    ${USER}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    END
    
    Wait For The Element And Click    ${add_users_to_team}           
    IF    ${VERIFY_EMPTY_NAME_TEAM}
        Clear Element Text    ${INPUT_TEAM_NAME}
        Wait For The Element And Click    ${NEXT_BUTTON_TEAMS_DETAILS_PAGE}
        Wait For The Element And Click    ${SAVE_BUTTON_TEAMS_DETAILS_PAGE}
        Wait Until Page Contains    Please enter valid information for Name
        Capture Page Screenshot
        Scroll Element And Enter Value   ${INPUT_TEAM_NAME}    ${TD_TEAM_NAME}
        Sleep    2s
    END

    Wait For The Element And Click    ${NEXT_BUTTON_TEAMS_DETAILS_PAGE}
    Wait For The Element And Click    ${SAVE_BUTTON_TEAMS_DETAILS_PAGE}

Click On Next Button On Teams Details Page
    [Documentation]    To Click On Next Button On Teams Details Page
    Wait For The Element And Click    ${NEXT_BUTTON_TEAMS_DETAILS_PAGE}


Click On Previous Button On Teams Details Page And Verify The User Navigation
    [Documentation]    To Click On Previous Button On Teams Details Page And Verify The User Navigation
    Wait For The Element And Click    ${PREVIOUS_BUTTON_TEAMS_DETAILS_PAGE}
    
    Wait Until Element Is Visible    ${INPUT_TEAM_NAME}
    Wait Until Element Is Not Visible    ${DELETE_ICON_TEAMS_DETAILS}


Click On The Save Button On The Team Details Page
    [Documentation]    To Click On The Save Button On The Team Details Page
    Wait For The Element And Click    ${SAVE_BUTTON_TEAMS_DETAILS_PAGE}


Verify That A Workspace Is Automatically Added Based On The Selected Site
    [Documentation]    To Verify That A Workspace Is Automatically Added Based On The Selected Site
    ${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE_COUNT}=    Get Element Count    ${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE}
    Evaluate    ${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE_COUNT}==len(${EXTRACTED_WORKSPACE_LIST})
    
    ${MAX_LIMIT}=    Get Element Count    ${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE}
    ${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE_LIST}=    Get Values In List For Validation    (${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE})[INDEX]    1    ${MAX_LIMIT}

Search The Workspace On Teams Details Page
    [Documentation]    To Search The Workspace On Teams Details Page
    [Arguments]    ${CUSTOM_WORKSPACE}
    
    Wait Until Element Is Visible    ${INPUT_SEARCH}
    Input Text    ${INPUT_SEARCH}    ${CUSTOM_WORKSPACE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE})[1]    ${CUSTOM_WORKSPACE}


Delete The Workspace From The Teams
    [Documentation]    To Delete The Workspace From The Teams
    Wait Until Keyword Succeeds    5x    1s    Wait Until Element Is Visible    (//div[@class="mat-grid-tile-content"]//span)[1]    ${Max_limit}
    ${SearchedWorkspace}     Get Text    (//div[@class="mat-grid-tile-content"]//span)[1]
    Search The Workspace On Teams Details Page    ${SearchedWorkspace}
    Wait For The Element And Click    ${DELETE_ICON_TEAMS_DETAILS}
    Wait For The Element And Click    ${DELETE_POPUP_TEAMS_DETAILS}


Verify The Workspace In Teams Details Page
    [Documentation]    To Verify The Workspace In Teams Details Page
    [Arguments]    ${ACTION}
    
    Wait Until Element Is Visible    ${INPUT_SEARCH}
    Input Text    ${INPUT_SEARCH}    ${EXTRACTED_WORKSPACE_LIST[0]}
    
    IF    '${ACTION}'=='Deleted'
        Wait Until Element Is Visible    ${NO_WORKSPACES_TITLE_IN_TEAMS}
        Wait Until Element Is Visible    ${ADD_WORKSPACES_TITLE_IN_TEAMS_DETAILS}
    ELSE IF    '${ACTION}'=='Added'
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${WORKSPACE_LISTED_ON_TEAMS_DETAILS_PAGE})[1]    ${EXTRACTED_WORKSPACE_LIST[0]}
    END


Add The Deleted Workspace To The Team
    [Documentation]    To Add The Deleted Workspace To The Team
    Click on Add Workspace On Teams Details Page

    #Add The Workspace
    Input Text    (${INPUT_SEARCH})[2]    ${EXTRACTED_WORKSPACE_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${SEARCHED_WORKSPACE_IN_TEAMS_DETAILS})[1]    ${EXTRACTED_WORKSPACE_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${SEARCHED_WORKSPACE_CHECKBOX_IN_TEAMS_DETAILS}
    Adding selected users to user group


Verify The Count Displayed On The User Group Page
    [Documentation]    To Verify The Count Displayed On The User Group Page
    ${TOTAL_TEAMS_COUNT}=    Get Current Record Count On Page
    ${COUNT_FROM_PAGE_HEADING}=    Get Text    ${TEAMS_COUNT_FROM_PAGE_HEADING}
    ${COUNT_FROM_PAGE_HEADING}=    Extract Numbers    ${COUNT_FROM_PAGE_HEADING}
    Should Be Equal As Strings    ${COUNT_FROM_PAGE_HEADING}    ${TOTAL_TEAMS_COUNT}
      

Verify The Invalid Search Functionality On Teams List Page
    [Documentation]    To Verify The Invalid Search Functionality On Teams List Page
    Input Text    ${INPUT_SEARCH}    INVALID_VALUE
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}     
    

Verify The Procedures Of The Workspace On Teams Details Page
    [Documentation]    To Verify The Procedures Of The Workspace On Teams Details Page

    Search The Workspace On Teams Details Page    CUSTOM_WORKSPACE=${TD_WORKSPACE_NAME}
    Wait For The Element And Click    ${TEAMS_DETAIL_WORKSPACE_PAGE_PROCEDURE_BUTTON}
    Wait For The Page To Load
    
    Wait Until Element Is Visible    ${TEAMS_DETAIL_WORKSPACE_PROCEDURE_LISTED_IN_POPUP}
    ${MAX_LIMIT}=    Get Element Count    ${TEAMS_DETAIL_WORKSPACE_PROCEDURE_LISTED_IN_POPUP}
    
    ${TEAMS_DETAIL_WORKSPACE_PROCEDURE_LIST}=    Get Values In List For Validation    (${TEAMS_DETAIL_WORKSPACE_PROCEDURE_LISTED_IN_POPUP})[INDEX]    1    ${MAX_LIMIT}
    
    Lists Should Be Equal    ${TEAMS_DETAIL_WORKSPACE_PROCEDURE_LIST}     ${ADD_PROCEDURE_TO_WORKSPACE_LIST}


Get The First Team Details
    [Documentation]    To Get The First Team Details

    #Name
    Wait Until Element Is Visible    (${FIRST_TEAM_LIST_PAGE})[1]
    ${TD_TEAM_NAME}=    Get Text    ${FIRST_TEAM_LIST_PAGE}
    ${TD_TEAM_NAME}=    Strip String    ${TD_TEAM_NAME}
    Set Test Variable    ${TD_TEAM_NAME}

    #Status
    ${TD_TEAM_STATUS}=    Get Text    (${FIRST_TEAM_STATUS_LIST_PAGE})[1]
    ${TD_TEAM_STATUS}=    Strip String    ${TD_TEAM_STATUS}
    Set Test Variable    ${TD_TEAM_STATUS}

Toggle The Status In Teams Details
    [Documentation]    To Toggle The Status In Teams Details
    Wait Until Element Is Visible    ${TOGGLE_BUTTON_TEAMS_DETAILS_PAGE}
    Click Element    ${TOGGLE_BUTTON_TEAMS_DETAILS_PAGE}
    
    #check the toggle status changed
    sleep    2s
    ${UPDATED_STATUS}=    Get Text    ${TOGGLE_BUTTON_UPDATED_TEXT}
    ${UPDATED_STATUS}=    Strip String    ${UPDATED_STATUS}
    ${UPDATED_STATUS}=    Set Test Variable    ${UPDATED_STATUS}
    
    IF    '${TD_TEAM_STATUS}'=='Active'
        Should Not Be Equal As Strings    ${UPDATED_STATUS}    Inactive
    ELSE
        Should Not Be Equal As Strings    ${UPDATED_STATUS}    Active
    END
    
Verify The Teams Status Is Changed
    [Documentation]    To Verify The Teams Status Is Changed
    Wait Until Element Is Visible    (${FIRST_TEAM_STATUS_LIST_PAGE})[1]
    Element Should Contain    (${FIRST_TEAM_STATUS_LIST_PAGE})[1]    ${UPDATED_STATUS}


Verify The Data Of Team On List Page
    [Documentation]    To Verify The Data Of Team On List Page
    [Arguments]    ${SITE_NAME}    ${USER_ROLE}


    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_NAME_LIST_PAGE})[1]    ${td_last_name}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_EMAIL_LIST_PAGE})[1]    ${TD_USER_EMAIL}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_COMPANY_LIST_PAGE})[1]    ${SITE_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_ROLE_LIST_PAGE})[1]    ${USER_ROLE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_STATUS_LIST_PAGE})[1]    Active
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${USER_CREATEDON_LIST_PAGE})[1]    ${TODAY_DATE}
