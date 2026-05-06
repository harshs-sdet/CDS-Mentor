*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource    ../Common/Common.resource
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/SkillProfile.yaml
Variables    ../../../../../../testdata/ui/web/Mentor/testdata.yaml

*** Variables ***

#${SKILL_PROFILE_LIST_PAGE}    ${Url}/skill-profiles
#
#*** Keywords ***
#
#
#Navigate To Skill Profile List Page
#    [Documentation]    To Navigate To Skill Profile List Page
#    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
#    Mouse Over    ${DASHBOARD_LINK}
#    ${status}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SKILL_PROFILE_TAB}    5s
#    IF    '${status}'=='True'
#        Click Element    ${SKILL_PROFILE_TAB}
#    ELSE
#        Wait For The Element And Click    ${SKILL_MANAGEMENT_TAB}
#        Wait For The Element And Click    ${SKILL_PROFILE_TAB}
#    END
#    Wait For The Page To Load
#    Wait Until Element Is Visible    ${ADD_NEW_BUTTON}    ${Max_limit}
#    Mouse Over    ${ADD_NEW_BUTTON}
#
#
#
#
#Get The First Skill Profile Details
#    [Documentation]    To Get The First Skill Profile Details
#    Wait Until Element Is Visible    ${FIRST_SKILL_PROFILE}    ${Max_limit}
#    ${TD_FSP_NAME}=    Get Text    ${FIRST_SKILL_PROFILE}
#    Set Test Variable    ${TD_FSP_NAME}
#
#
#Navigate To Skill Profile Details Page
#    [Documentation]    To Navigate To Skill Profile Details Page
#    Click Element    ${FIRST_SKILL_PROFILE}
#    Wait For The Page To Load
#    Wait Until Page Does Not Contain Element    ${ADD_NEW_BUTTON}    ${Max_limit}
#
#
#Enter The Skill Profile Detail
#    [Documentation]    To Enter The Skill Profile Detail
#    #SP Name
#    ${TD_SKILL_PROFILE_NAME}=    Generate Random String
#    Set Test Variable    ${TD_SKILL_PROFILE_NAME}
#    Scroll Element And Enter Value   ${INPUT_SP_NAME}    ${TD_SKILL_PROFILE_NAME}
#
#
#    #Description
#    ${TD_SP_DESC}=    Generate Random String
#    Set Test Variable    ${TD_SP_DESC}
#    Scroll Element And Enter Value   ${INPUT_SP_DESC}    ${TD_SP_DESC}
#
#
#Click On Create Button On Skill Profile Details Page
#    [Documentation]    To Click On Create Button On Skill Profile Details Page
#    Wait For The Element And Click    ${SKILL_PROFILE_CREATE_BUTTON}
#
#    #Wait Untill page is fully loaded
#    Wait For The Page To Load
#
#    #homepage validation
#    Wait Until Location Is    ${SKILL_PROFILE_LIST_PAGE}    ${Max_limit}
#    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}
#
#
#Validate The Updated Skill Profile Details
#    [Documentation]    To Validate The Updated SP Details
#    #SP Name
#    ${SP_NAME_FROM_SF}=    Get Element Attribute    ${INPUT_SP_NAME}    value
#    Check The Strings Are Equal    ${SP_NAME_FROM_SF}    ${TD_SKILL_PROFILE_NAME}
#
#    #prev name before edit record
#    Should Not Be Equal As Strings    ${TD_FSP_NAME}    ${SP_NAME_FROM_SF}
#
#
#    #Description
#    ${SP_DESC_FROM_SF}=    Get Element Attribute    ${INPUT_SP_DESC}    value
#    Check The Strings Are Equal    ${SP_DESC_FROM_SF}    ${TD_SP_DESC}
#
#
#Verify The New Created Skill Profile
#    [Documentation]    To Verify The New Created Skill Profile
#    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
#    ${SKILL_PROFILE_SEARCHED_SF}=    Get Text    ${SEARCHED_SP}
#    Should Be Equal As Strings    ${SKILL_PROFILE_SEARCHED_SF}    ${TD_SKILL_PROFILE_NAME}
#
#
#
#Delete The New Created Skill Pofile
#    [Documentation]    To Delete The New Created Skill Profile
#    Wait For The Element And Click    ${DELETE_ICON_SKILL_PROFILE}
#    Wait For The Element And Click    ${DELETE_POPUP_SKILL_PROFILE}
#    Wait For The Page To Load
#    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
#    Sleep    3s
#    Wait Until Element Is Visible    ${NO_RECORD_FOUND}    ${Max_limit}
#
#
#Verify The Table Column Labels On Skill Profile List Page
#    [Documentation]    To Verify The Table Column Labels
#    Wait Until Element Is Visible    ${SKILL_PROFILE_LABEL_NAME}    ${Max_limit}
#    ${NAME_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_NAME}
#    Should Be Equal As Strings    ${NAME_LABEL_TEXT}      Name
#
#    ${DESC_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_DESC}
#    Should Be Equal As Strings    ${DESC_LABEL_TEXT}     Description
#
#    ${SKILL_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_SKILLS}
#    Should Be Equal As Strings    ${SKILL_LABEL_TEXT}      Skills
#
#    ${TRAINING_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_TRAININGS}
#    Should Be Equal As Strings    ${TRAINING_LABEL_TEXT}      Trainings
#
#    ${DATE_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_CREATED_ON}
#    Should Be Equal As Strings    ${DATE_LABEL_TEXT}      Created on
#
#    ${ACTION_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_ACTION}
#    Should Be Equal As Strings    ${ACTION_LABEL_TEXT}      Actions
#
#
#Ensure Skill Profile List Page Is Open
#    [Documentation]    To Ensure Skill Profile List Page Is Open
#    ${status}=    Run Keyword And Return Status    Navigate To Skill Profile List Page
#    Run Keyword If    ${status}    RETURN FROM KEYWORD
#
#    Reload Page
#    Wait For The Page To Load
#
#    Sleep    2s
#    ${status}=    Run Keyword And Return Status    Navigate To Skill Profile List Page
#    Run Keyword If    ${status}    RETURN FROM KEYWORD
#
#    # Final fallback: restart browser
#    Close Browser
#    Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
#    Navigate To Skill Profile List Page
#
#
#Add Skills To Skill Profile
#    [Documentation]    To Add Skills To Skill Profile
#    Click Element    ${SKILL_PROFILE_Add_BUTTON}
#    Wait For The Page To Load
#    Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_RECORDS_CHECKBOX}
#    @{ADDED_SKILLS_LIST}=    Create List
#    ${end_index}=    Get Element Count    ${SKILL_ON_CURRENT_PAGE}
#    ${end_index}=    Evaluate    ${end_index}-1
#    ${ADDED_SKILLS_LIST}    Get Values In List For Validation    ${SKILLS_ADDED_TO_SP}    2    ${end_index}
#    Set Test Variable    ${ADDED_SKILLS_LIST}
#    Wait Until Element Is Enabled    ${DONE_BUTTON_SP}    ${Max_limit}
#    Click Element    ${DONE_BUTTON_SP}
#    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
#
#
#
#Check The Skills Added to New Skill Profile
#    [Documentation]    To Check The Skills Added to New Skill Profile
#    Wait Until Keyword Succeeds    5x    2s    Click Element    ${SEARCHED_SP}
#    Wait For The Page To Load
#    FOR     ${skill}    IN     @{ADDED_SKILLS_LIST}
#        Input Text    ${INPUT_SEARCH}    ${skill}
#        ${locator}=    Replace String    ${SKILL_PROFILE_SEARCHED_SKILL}    VALUE    ${skill}
#        Wait Until Element Is Visible    ${locator}    10s
#    END
#
#Click On The Done Button On Skill Profile Details Page
#    [Documentation]    To Click On The Done Button On Skill Profile Details Page
#    Wait For The Element And Click    ${done_button}
#    Wait For The Page To Load
#
#
#Click On ADD New Button On Skill Profile Page
#    [Documentation]    To Click Add New Button
#    Wait For The Element And Click    ${ADD_NEW_BUTTON}
#    Wait For The Page To Load
#
#Delete The Skill Profile
#    [Documentation]    To Delete and verify The Deleted Skill Profile
#    Retry Until Element Clickable    ${DELETE_ICON_SKILL_PROFILE}
#    Wait For The Element And Click    ${DELETE_POPUP_SKILL_PROFILE}
#    Wait For The Page To Load
#    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
#    Wait Until Element Is Visible    ${NO_RECORD_FOUND}    ${Max_limit}
#
#    #Other Skill records after deleting a skill profile
#    Clear Element Text    ${INPUT_SEARCH}
#    Reload Page
#    Wait Until Element Is Not Visible    ${NO_RECORD_FOUND}    ${Max_limit}
#
#Click On Edit Skill Profile Button
#    [Documentation]    To Click On Edit Skill Profile Button
#    Wait For The Element And Click    ${EDIT_SKILL_PROFILE}
#    Wait For The Page To Load
#
#Click On Update Skill Profile Button
#    [Documentation]    To Click On Update Skill Profile Button
#    Wait For The Element And Click    ${UPDATE_BUTTON_SKILL_PROFILE}