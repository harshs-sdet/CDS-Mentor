*** Settings ***
Library    SeleniumLibrary
Library    RPA.JSON
Library    OperatingSystem
Library    String
Resource    ../Procedure/AuthorScreen.resource
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/Skill.yaml
Variables    ../../../../../../testdata/ui/web/Mentor/testdata.yaml

*** Variables ***
${BROWSER}    Chrome
${SKILL_PROFILE_LIST_PAGE}    ${Url}/skill-profiles
${SKILL_LIST_PAGE}    ${Url}/skills

*** Keywords ***

User Navigates To Skill Management Page
    [Documentation]    To User Navigates To Skill Management Page
    Reload Page
    Wait For The Page To Load
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_SKILL_TAB_OPEN}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SKILL_OPTION}    5s
    IF    '${IF_SKILL_TAB_OPEN}'=='True'
        Click Element By JS    ${SKILL_OPTION}
    ELSE
        Wait For The Element And Click    ${SKILL_MANAGEMENT_OPTION}
        Click Element By JS    ${SKILL_OPTION}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}    ${Max_limit}
    Mouse Over    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}


Navigate To My Skills Page
    [Documentation]    To Navigate To My Skills Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_SKILL_TAB_OPEN}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SKILL_OPTION}    5s
    IF    '${IF_SKILL_TAB_OPEN}'!='True'
        Wait For The Element And Click    ${SKILL_MANAGEMENT_OPTION}
    END
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${MY_SKILLS_TAB}
    Wait For The Page To Load

User Clicks on Skills Button
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${skill_btn}   ${MaxTime}
    Click Element    ${skill_btn}

User Clicks on Add New Skill
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}

Verify The User Navigates To Create New Skill Page
    Wait Until Element Is Visible    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}   ${MaxTime}

Verify User Lands On The Skill Page
    [Documentation]    To Verify User Lands On The Skill Page
    Wait Until Location Is    ${Url}/skills    15s

Verify User Lands On The Skill Profile Page
    [Documentation]    To Verify User Lands On The Skill Profile Page
    Wait Until Location Is    ${SKILL_PROFILE_LIST_PAGE}    ${Max_limit}

User Adds Skills Details
    [Documentation]    To Add Skills Details
    [Arguments]    ${FREQUENCY_TYPE}=Daily    ${CHECK_DEFAULT_IMAGE}=False
    
    IF    '${CHECK_DEFAULT_IMAGE}'=='True'
        Element Should Be Visible    ${DEFAULT_IMAGE_ON_SKILL_DETAILS_PAGE}
    END    
        
    ${UniqueNumberTest}=    Generate Random String
    Click Element    ${SKILL_NAME_INPUT}
    Input Text    ${SKILL_NAME_INPUT}    Skill-${UniqueNumberTest}
    Set Test Variable    ${TD_SKILL_NAME}    Skill-${UniqueNumberTest}

    Click Element    ${SKILL_DESCRIPTION_INPUT}
    ${TD_SKILL_DESC}=    Generate Random String    20
    Input Text    ${SKILL_DESCRIPTION_INPUT}    ${TD_SKILL_DESC}
    Set Test Variable    ${TD_SKILL_DESC}
    
    Select The Frequency On Skill Details Page    ${FREQUENCY_TYPE}

Select The Frequency On Skill Details Page
    [Documentation]    To Select The Frequency On Skill Details Page
    [Arguments]    ${FREQUENCY_TYPE}=Daily
    Click Element    ${ASSESSMENT_FREQUENCY_SELECT}
    Scroll Element And Enter Value    ${INPUT_SEARCH_SKILLS}    ${FREQUENCY_TYPE}
    Set Test Variable    ${FREQUENCY_TYPE}
    Wait Until Keyword Succeeds    10x    2s    Element Should Contain    ${FIRST_FREQUENCY_OPTION}/span    ${FREQUENCY_TYPE}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${FIRST_FREQUENCY_OPTION}
    
Search The Training To Be Added In Skill
    [Documentation]    To Search The Training To Be Added In Skill
    [Arguments]    ${CUSTOM_TRAINING}
    Scroll Element And Enter Value    ${ADD_TRAINING_TO_SKILL_INPUT_SEARCH}    ${CUSTOM_TRAINING}
    Press Keys    ${ADD_TRAINING_TO_SKILL_INPUT_SEARCH}    ENTER
    ${LOCATOR}=    Replace String    ${SKILL_DETAILS_ADD_SEARCHED_TRAINING}    TRAINING    ${CUSTOM_TRAINING}
    Wait Until Element Is Visible    ${LOCATOR}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}


Verify The Trainings Are Added For Different levels
    [Documentation]    To Verify The Trainings Are Added For Different levels
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_LIST}[0]

    Click Element    ${BEGINNER_LEVEL_TAB}
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_LIST}[1]

    Click Element    ${INTERMEDIATE_LEVEL_TAB}
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_LIST}[2]

    Click Element    ${ADVANCE_LEVEL_TAB}    
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_LIST}[3]

    Click Element    ${EXPERT_LEVEL_TAB}
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_LIST}[4]



User Adds Trainings
    [Arguments]    ${DIFFICULTY_LEVEL}    ${CUSTOM_TRAINING_NAME}=None
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
    IF    '${DIFFICULTY_LEVEL}'=='Elementary'
        Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
        IF    '${CUSTOM_TRAINING_NAME}'=='None'
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_TRAINING_TO_SKILL_FIRST_TRAINING_LISTED}
        ELSE
            Search The Training To Be Added In Skill    ${CUSTOM_TRAINING_NAME}
        END
        Click Element    ${ADD_TRAINING_TO SKILL_DONE_BUTTON}

    ELSE IF    '${DIFFICULTY_LEVEL}'=='Beginner'
        Click Element    ${BEGINNER_LEVEL_TAB}
        Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
        IF    '${CUSTOM_TRAINING_NAME}'=='None'
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_TRAINING_TO_SKILL_SECOND_TRAINING_LISTED}
        ELSE
            Search The Training To Be Added In Skill    ${CUSTOM_TRAINING_NAME}
        END
        
        Click Element    ${ADD_TRAINING_TO SKILL_DONE_BUTTON}

    ELSE IF    '${DIFFICULTY_LEVEL}'=='Intermediate'
        Click Element    ${INTERMEDIATE_LEVEL_TAB}
        Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
        IF    '${CUSTOM_TRAINING_NAME}'=='None'
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_TRAINING_TO_SKILL_THIRD_TRAINING_LISTED}
        ELSE
            Search The Training To Be Added In Skill    ${CUSTOM_TRAINING_NAME}
        END
        
        Click Element    ${ADD_TRAINING_TO SKILL_DONE_BUTTON}

    ELSE IF    '${DIFFICULTY_LEVEL}'=='Advance'
        Click Element    ${ADVANCE_LEVEL_TAB}
        Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
        IF    '${CUSTOM_TRAINING_NAME}'=='None'
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_TRAINING_TO_SKILL_FOURTH_TRAINING_LISTED}
        ELSE
            Search The Training To Be Added In Skill    ${CUSTOM_TRAINING_NAME}
        END
        
        Click Element    ${ADD_TRAINING_TO SKILL_DONE_BUTTON}

    ELSE IF    '${DIFFICULTY_LEVEL}'=='Expert'
        Click Element    ${EXPERT_LEVEL_TAB}
        Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
        IF    '${CUSTOM_TRAINING_NAME}'=='None'
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_TRAINING_TO_SKILL_FIFTH_TRAINING_LISTED}
        ELSE
            Search The Training To Be Added In Skill    ${CUSTOM_TRAINING_NAME}
        END
        Click Element    ${ADD_TRAINING_TO SKILL_DONE_BUTTON}

    END


User Clicks on Create Button On Skill Details Page
    Wait Until Element Is Visible    ${SKILL_DETAILS_CREATE_BUTTON}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${SKILL_DETAILS_CREATE_BUTTON}

Verify The User Lands On The Skill list Page After Creating Or Updating The Skill
    [Documentation]    To Verify The User Lands On The Skill list Page After Creating Or Updating The Skill
    Wait Until Location Is    ${SKILL_LIST_PAGE}    ${Max_limit}

User Clicks on Cancel Skill/Profile Button
    Wait Until Element Is Visible    ${SKILL_DETAILS_CANCEL_BUTTON}
    Click Element    ${SKILL_DETAILS_CANCEL_BUTTON}


Search The Skill On List Page
    [Documentation]    To Search The Skill On List Page
    [Arguments]    ${CUSTOM_SKILL_NAME}=False    ${SKILL_DELETED}=False
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    IF    '${CUSTOM_SKILL_NAME}'!='False'
        Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH_SKILLS}    ${CUSTOM_SKILL_NAME}
        Run Keyword If    '${SKILL_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_LIST_PAGE}    ${CUSTOM_SKILL_NAME}
        Return From Keyword
    END
    Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH_SKILLS}    ${TD_SKILL_NAME}
    Run Keyword If    '${SKILL_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_LIST_PAGE}    ${TD_SKILL_NAME}


Search The Skill Profile On List Page
    [Documentation]    To Search The Skill Profile On List Page
    [Arguments]    ${CUSTOM_SKILL_PROFILE_NAME}=False    ${SKILL_PROFILE_DELETED}=False
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    IF    '${CUSTOM_SKILL_PROFILE_NAME}'!='False'
        Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH_SKILL_PROFILES}    ${CUSTOM_SKILL_PROFILE_NAME}
        Run Keyword If    '${SKILL_PROFILE_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_PROFILE_LIST_PAGE}    ${CUSTOM_SKILL_PROFILE_NAME}
        Return From Keyword
    END
    Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH_SKILL_PROFILES}    ${TD_SKILL_PROFILE_NAME}
    Run Keyword If    '${SKILL_PROFILE_DELETED}'=='False'    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_PROFILE_LIST_PAGE}    ${TD_SKILL_PROFILE_NAME}


Verify Invalid Search On Skills Page
    [Documentation]    To Verify Invalid Search On Skills Page
     Scroll Element And Enter Value    ${INPUT_SEARCH_SKILLS}    GARBAGE_VALUE
     Wait Until Element Is Visible    ${SKILLS_NO_RESULTS_FOUND}

Verify That A New Skill Is Created
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Search The Skill On List Page
    
Verify The Empty Skill Can't Be Assigned
    [Documentation]    To Verify The Empty Skill Can't Be Assigned
    Wait Until Element Is Visible    ${SKILL_DETAILS_ASSIGN_EDIT_BUTTON}
#    Element Should Be Disabled    ${SKILL_DETAILS_ASSIGN_EDIT_BUTTON}
    Capture Page Screenshot

Navigate To Skill Details Page
    [Documentation]    To Navigate To Skill Details Page
    [Arguments]    ${CUSTOM_SKILL_NAME}=False
    IF    '${CUSTOM_SKILL_NAME}'!='False'
        Search The Skill On List Page     ${CUSTOM_SKILL_NAME}
    ELSE
        Search The Skill On List Page
    END
#    Wait Until Keyword Succeeds    5x    1s    Double Click Element    ${FIRST_SKILL_LIST_PAGE}
    Wait Until Keyword Succeeds    3x    1s    Wait Until Element Is Visible    ${FIRST_SKILL_LIST_PAGE}
    Click Element By JS    ${FIRST_SKILL_LIST_PAGE}
#    Wait For The Page To Load
#    ${STATUS}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${FIRST_SKILL_LIST_PAGE}
#    IF    '${STATUS[0]}'=='PASS'
#        Wait Until Keyword Succeeds    5x    1s    Double Click Element    ${FIRST_SKILL_LIST_PAGE}
#    END
    Wait For The Page To Load
    Wait Until Location Is Not    ${SKILL_PROFILE_LIST_PAGE}    ${Max_limit}


Navigate To Skill Profile Details Page
    [Documentation]    To Navigate To Skill Profile Details Page
    [Arguments]    ${CUSTOM_SKILL_PROFILE_NAME}=False
    IF    '${CUSTOM_SKILL_PROFILE_NAME}'!='False'
        Search The Skill Profile On List Page     ${CUSTOM_SKILL_PROFILE_NAME}
    ELSE
        Search The Skill Profile On List Page
    END
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${FIRST_SKILL_PROFILE_LIST_PAGE}
    Wait For The Page To Load


Verify that an Empty Skill is Created
    Search The Skill On List Page
    Wait Until Keyword Succeeds    3x    1s    Element Text Should Be    ${TRAININGS_COUNT_ADDED_IN_SKILL}    0

Verify that no Skill is created after clicking on the cancel button
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}      ${maxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}

#Teardown For Skill Management
#    ${status}=    Run Keyword And Return Status    Page Should Contain Element    //div[@class="header-title-container"]//mat-icon
#    ${status1}=    Run Keyword And Return Status    Page Should Contain Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
#    IF    ${status}== True
#        Run Keywords    Click Element    //div[@class="header-title-container"]//mat-icon
#        ...    AND      Click Element    //a[@class="link"]
#        ...    AND      Wait Until Element Is Visible    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}   ${MaxTime}
#    ELSE IF    ${status1}== True
#        Run Keywords    Click Element    //a[@class="link"]
#        ...   AND       Wait Until Element Is Visible    ${ADD_NEW_SKILL_BUTTON_LIST_PAGE}   ${MaxTime}
#    END


Verify UI of Skills Page
    [Documentation]    To Verify UI of Skills Page
    Wait Until Element Is Visible    ${SKILL_LISTING_NAME_HEADER}    ${Max_limit}
    Element Should Contain    ${SKILL_LISTING_NAME_HEADER}    Name
    Element Should Contain    ${SKILL_LISTING_DESCRIPTION_HEADER}    Description
    Element Should Contain    ${SKILL_LISTING_ASSESSMENT_FREQUENCY_HEADER}    Assessment Frequency
    Element Should Contain    ${SKILL_LISTING_TRAINING_HEADER}    Trainings
    Element Should Contain    ${SKILL_LISTING_CREATED_BY_HEADER}    Created by
    Element Should Contain    ${SKILL_LISTING_CREATED_ON_HEADER}    Created on
    Element Should Contain    ${SKILL_LISTING_ACTIONS_HEADER}    Actions

Verify The Skill Details
    [Documentation]    To Verify The Skill Details
    [Arguments]    ${DETAILS_UPDATED}=True

    Wait Until Element Is Visible    ${ASSESSMENT_FREQUENCY_SELECT}

    IF    '${DETAILS_UPDATED}'=='False'
        ${SKILL_NAME_FROM_STORE_FRONT}=    Get Value     ${SKILL_NAME_INPUT}
        Should Not Contain    ${SKILL_NAME_FROM_STORE_FRONT}    ${TD_SKILL_NAME}
        Return From Keyword
    END

    ${SKILL_NAME_FROM_STORE_FRONT}=    Get Value     ${SKILL_NAME_INPUT}
    Should Contain    ${SKILL_NAME_FROM_STORE_FRONT}    ${TD_SKILL_NAME}

    ${SKILL_DESC_FROM_STORE_FRONT}=    Get Value    ${SKILL_DESCRIPTION_INPUT}
    Should Contain    ${SKILL_DESC_FROM_STORE_FRONT}    ${TD_SKILL_DESC}

#    ${ASSESSMENT_FREQUENCY_FROM_STORE_FRONT}=    Get Text    ${ASSESSMENT_FREQUENCY_SELECT}//span/span
#    Should Contain    ${ASSESSMENT_FREQUENCY_FROM_STORE_FRONT}    ${FREQUENCY_TYPE}

Click On The Edit Button On Skill Details Page
    [Documentation]    To Click On The Edit Button On Skill Details Page
    Wait For The Element And Click    ${SKILL_EDIT_BUTTON}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}


Verify The Added Skill And Its Training Count For A Skill Profile Is Reset
    [Documentation]    To Verify The Added Skill And Its Training Count For A Skill Profile Is Reset
    Search The Skill Profile On List Page
    Wait Until Element Is Visible    ${FIRST_SKILL_PROFILE_TRAININGS_COUNT}
    Element Should Contain    ${FIRST_SKILL_PROFILE_TRAININGS_COUNT}    0
    Element Should Contain    ${FIRST_SKILL_PROFILE_SKILLS_COUNT}    0
    Capture Page Screenshot


Navigate To Skill Profile List Page
    [Documentation]    To Navigate To Skill Profile List Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${status}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SKILL_PROFILE_TAB}    5s
    IF    '${status}'=='True'
        Wait Until Keyword Succeeds    5x    0.5    Click Element    ${SKILL_PROFILE_TAB}
    ELSE
        Wait For The Element And Click    ${SKILL_MANAGEMENT_TAB}
        Wait For The Element And Click    ${SKILL_PROFILE_TAB}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADD_NEW_BUTTON_SKILL_PROFILE}    ${Max_limit}
    Mouse Over    ${ADD_NEW_BUTTON_SKILL_PROFILE}



Navigate To Skill Matrix Page
    [Documentation]    To Navigate To Skill Matrix Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${status}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${SKILL_MATRIX_TAB}    5s
    IF    '${status}'=='True'
        Click Element    ${SKILL_MATRIX_TAB}
    ELSE
        Wait For The Element And Click    ${SKILL_MANAGEMENT_TAB}
        Wait For The Element And Click    ${SKILL_MATRIX_TAB}
    END
    Wait For The Page To Load
    Wait Until Element Is Visible    ${SKILL_MATRIX_RESET_BUTTON}    ${Max_limit}
    Mouse Over    ${SKILL_MATRIX_RESET_BUTTON}



Enter The Skill Profile Detail
    [Documentation]    To Enter The Skill Profile Detail
    #SP Name
    ${TD_SKILL_PROFILE_NAME}=    Generate Random String
    Set Test Variable    ${TD_SKILL_PROFILE_NAME}
    Wait Until Element Is Visible    ${INPUT_SP_NAME}    ${Max_limit}
    Clear Element Text    ${INPUT_SP_NAME}
    Scroll Element And Enter Value   ${INPUT_SP_NAME}    ${TD_SKILL_PROFILE_NAME}


    #Description
    ${TD_SP_DESC}=    Generate Random String
    Set Test Variable    ${TD_SP_DESC}
    Scroll Element And Enter Value   ${INPUT_SP_DESC}    ${TD_SP_DESC}


Click On Create Button On Skill Profile Details Page
    [Documentation]    To Click On Create Button On Skill Profile Details Page
    Wait For The Element And Click    ${SKILL_PROFILE_CREATE_BUTTON}

    #Wait Untill page is fully loaded
    Wait For The Page To Load

    #homepage validation
    Wait Until Location Is    ${SKILL_PROFILE_LIST_PAGE}    ${Max_limit}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}

Click On Cancel Button On Skill Profile Page
    [Documentation]    To Click On Cancel Button On Skill Profile Page
    Wait For The Element And Click    ${SKILL_PROFILE_CANCEL_BUTTON}

    #Wait Untill page is fully loaded
    Wait For The Page To Load

    #homepage validation
    Wait Until Location Is    ${SKILL_PROFILE_LIST_PAGE}    ${Max_limit}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}


Validate The Updated Skill Profile Details
    [Documentation]    To Validate The Updated SP Details
    [Arguments]    ${DETAILS_UPDATED}=True

    IF    '${DETAILS_UPDATED}'=='False'
        ${SP_NAME_FROM_SF}=    Get Element Attribute    ${INPUT_SP_NAME}    value
        Should Not Be Equal As Strings    ${SP_NAME_FROM_SF}    ${TD_SKILL_PROFILE_NAME}
        Return From Keyword
    END

    #SP Name
    ${SP_NAME_FROM_SF}=    Get Element Attribute    ${INPUT_SP_NAME}    value
    Check The Strings Are Equal    ${SP_NAME_FROM_SF}    ${TD_SKILL_PROFILE_NAME}

    #prev name before edit record
    Check The Strings Are Equal    ${TD_SKILL_PROFILE_NAME}    ${SP_NAME_FROM_SF}


    #Description
    ${SP_DESC_FROM_SF}=    Get Element Attribute    ${INPUT_SP_DESC}    value
    Check The Strings Are Equal    ${SP_DESC_FROM_SF}    ${TD_SP_DESC}

Verify The New Created Skill Profile
    [Documentation]    To Verify The New Created Skill Profile
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
    Wait Until Page Contains Element    ${SEARCHED_SP}
    ${SKILL_PROFILE_SEARCHED_SF}=    Get Text    ${SEARCHED_SP}
    Should Be Equal As Strings    ${SKILL_PROFILE_SEARCHED_SF}    ${TD_SKILL_PROFILE_NAME}

Delete The New Created Skill Pofile
    [Documentation]    To Delete The New Created Skill Profile
    Wait For The Element And Click    ${DELETE_ICON_SKILL_PROFILE}
    Wait For The Element And Click    ${DELETE_POPUP_SKILL_PROFILE}
    Wait For The Page To Load
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
    Sleep    3s
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}    ${Max_limit}

Verify The Table Column Labels On Skill Profile List Page
    [Documentation]    To Verify The Table Column Labels
    Wait Until Element Is Visible    ${SKILL_PROFILE_LABEL_NAME}    ${Max_limit}
    ${NAME_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_NAME}
    Should Be Equal As Strings    ${NAME_LABEL_TEXT}      Name

    ${DESC_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_DESC}
    Should Be Equal As Strings    ${DESC_LABEL_TEXT}     Description

    ${SKILL_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_SKILLS}
    Should Be Equal As Strings    ${SKILL_LABEL_TEXT}      Skills

    ${TRAINING_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_TRAININGS}
    Should Be Equal As Strings    ${TRAINING_LABEL_TEXT}      Trainings

    ${DATE_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_CREATED_ON}
    Should Be Equal As Strings    ${DATE_LABEL_TEXT}      Created on

    ${ACTION_LABEL_TEXT}=    Get Text    ${SKILL_PROFILE_LABEL_ACTION}
    Should Be Equal As Strings    ${ACTION_LABEL_TEXT}      Actions

Ensure Skill Profile List Page Is Open
    [Documentation]    To Ensure Skill Profile List Page Is Open
    ${status}=    Run Keyword And Return Status    Navigate To Skill Profile List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Reload Page
    Wait For The Page To Load

    Sleep    2s
    ${status}=    Run Keyword And Return Status    Navigate To Skill Profile List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    Navigate To Skill Profile List Page

Add Skills To Skill Profile
    [Documentation]    To Add Skills To Skill Profile
    [Arguments]    ${CUSTOM_SKILLS}=None    ${CUSTOM_SKILLS_LIST}=None 
    
    Click Element    ${SKILL_PROFILE_Add_BUTTON}
    Wait For The Page To Load    
    
    IF    '${CUSTOM_SKILLS}'=='True'
        FOR    ${SKILL}    IN    @{CUSTOM_SKILLS_LIST}
            Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH}    ${SKILL}
            Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_TO_ADD_IN_SKILL_PROFILE}    ${SKILL}
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_SKILL_TO_SKILL_PROFILE_CHECKBOX}
            Wait For The Page To Load
        END
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_RECORDS_CHECKBOX}
        @{ADDED_SKILLS_LIST}=    Create List
        ${end_index}=    Get Element Count    ${SKILL_ON_CURRENT_PAGE}
        ${end_index}=    Evaluate    ${end_index}-1
        ${ADDED_SKILLS_LIST}    Get Values In List For Validation    ${SKILLS_ADDED_TO_SP}    2    ${end_index}
        Set Test Variable    ${ADDED_SKILLS_LIST}
    END

    Wait Until Element Is Enabled    ${DONE_BUTTON_SP}    ${Max_limit}
    Click Element    ${DONE_BUTTON_SP}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
    
Check The Skills Added to New Skill Profile
    [Documentation]    To Check The Skills Added to New Skill Profile
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${SEARCHED_SP}
    Wait For The Page To Load
    ${LISTED_SKILLS_COUNT}=    Get Element Count    ${SKILL_ADDED_IN_SKILL_PROFILE_DETAILS_PAGE}
    Should Be True    len(${ADDED_SKILLS_LIST})    ${LISTED_SKILLS_COUNT}
    FOR     ${skill}    IN     @{ADDED_SKILLS_LIST}
        Input Text    ${INPUT_SEARCH}    ${skill}
        ${locator}=    Replace String    ${SKILL_PROFILE_SEARCHED_SKILL}    VALUE    ${skill}
        Wait Until Element Is Visible    ${locator}    10s
    END
    Click On Edit Skill Profile Button
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${SKILL_PROFILE_Add_BUTTON}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${ADDED_RECORDS_COUNT}
    Element Should Contain    ${ADDED_RECORDS_COUNT}    10
    Press Keys    None    ESC
    

Click On The Done Button On Skill Profile Details Page
    [Documentation]    To Click On The Done Button On Skill Profile Details Page
    Wait For The Element And Click    ${done_button}
    Wait For The Page To Load

Click On ADD New Button On Skill Profile Page
    [Documentation]    To Click Add New Button
    Wait For The Element And Click    ${ADD_NEW_BUTTON_SKILL_PROFILE}
    Wait For The Page To Load

Delete The Skill Profile
    [Documentation]    To Delete and verify The Deleted Skill Profile
    Retry Until Element Clickable    ${DELETE_ICON_SKILL_PROFILE}
    Wait For The Element And Click    ${DELETE_POPUP_SKILL_PROFILE}
    Wait For The Page To Load
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_PROFILE_NAME}
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}    ${Max_limit}

    #Other Skill records after deleting a skill profile
    Clear Element Text    ${INPUT_SEARCH}
    Reload Page
    Wait Until Element Is Not Visible    ${NO_RECORD_FOUND}    ${Max_limit}

Click On Edit Skill Profile Button
    [Documentation]    To Click On Edit Skill Profile Button
    Wait For The Element And Click    ${EDIT_SKILL_PROFILE}
    Wait For The Page To Load
    Sleep    5s

Click On Update Skill Profile Button
    [Documentation]    To Click On Update Skill Profile Button
    Wait For The Element And Click    ${UPDATE_BUTTON_SKILL_PROFILE}


#Click On Assign Button On Skill Profile Details Page
#    [Documentation]    To Click On Assign Button On Skill Details Page
#    Wait For The Element And Click    ${SKILL_DETAILS_ASSIGN_EDIT_BUTTON}
#    sleep    5s

Verify The Skill Can't Be Assigned To Org Admin And Site Admin Persona
    [Documentation]    To Verify The Skill Can't Be Assigned To Org Admin And Site Admin Persona
    
    ${RESTRICTED_PERSONA_USER_LIST}=    Create List
    Add Item To List     ITEM=${SITE_ADMIN_NAME}   VAR_NAME=RESTRICTED_PERSONA_USER_LIST
    Add Item To List     ITEM=${ORG_ADMIN_NAME}   VAR_NAME=RESTRICTED_PERSONA_USER_LIST

    FOR    ${USER}    IN    @{RESTRICTED_PERSONA_USER_LIST}
        Scroll Element And Enter Value    ${ASSIGNED_SKILLS_TO_USERS_INPUT_FIELD}    ${USER}
        Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
        ${LOCATOR}=    Replace String    ${SKILL_DETAILS_ASSIGN_SEARCHED_USER}    USERNAME    ${USER}
        #Ignore error should be removed once the unselect bug is fixed
        Page Should Not Contain Element    ${LOCATOR}
        Capture Page Screenshot
    END
    

Click On Assign Button On Skill Details Page
    [Documentation]    To Click On Assign Button On Skill Details Page
    Wait For The Element And Click    ${SKILL_DETAILS_ASSIGN_EDIT_BUTTON}
    sleep    5s
#    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${ASSIGNED_SKILLS_TO_USERS_INPUT_FIELD}    ${Max_limit}
#    IF    '${status}'=='False'    Wait For The Element And Click    ${SKILL_DETAILS_ASSIGN_EDIT_BUTTON}

Verify All The Users Assigned To Skill Are Visible On Assign Window
    [Documentation]    To Verify All The Users Assigned To Skill Are Visible On Assign Window
    ${MAX_LIMIT}=    Get Element Count    ${USERS_ASSIGNED_FOR_SKILL}
    ${ASSIGNED_SKILLS_TO_USERS_LIST_FROM_THE_STOREFRONT}=    Get Values In List For Validation    (${USERS_ASSIGNED_FOR_SKILL})[INDEX]    1    ${MAX_LIMIT}
    Should Be True    len(${ASSIGNED_SKILLS_TO_USERS_LIST})    ${MAX_LIMIT}
    Validate The Extracted List Data    ${ASSIGNED_SKILLS_TO_USERS_LIST_FROM_THE_STOREFRONT}    ${ASSIGNED_SKILLS_TO_USERS_LIST}



Verify All The Teams Assigned To Skill Are Visible On Assign Window
    [Documentation]    To Verify All The Teams Assigned To Skill Are Visible On Assign Window
    Element Should Contain    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}    ${TEAMS_LIST_LENGTH}
    Capture Page Screenshot

Select The Difficulty Level
    [Documentation]    To Select The Difficulty Level
    [Arguments]    ${LEVEL}=Elementary
    Return From Keyword If    '${LEVEL}'=='Elementary' 
    Wait For The Element And Click    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN}
    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN_OPTION}=    Replace String    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN_OPTION}    DIFFICULTY    ${LEVEL}
    Wait Until Keyword Succeeds    3x    1s    Double Click Element    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN_OPTION}
    
Verify The Empty Levels Of The Skill Are Disabled
    [Documentation]    To Select The Difficulty Level
    ${LEVEL_LIST}=    Create List    Intermediate     Expert    Beginner
    Wait For The Element And Click    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN}
    FOR    ${LEVEL}    IN    @{LEVEL_LIST}
        Wait Until Keyword Succeeds    3x    1s    Input Text    ${DIFFICULTY_LEVEL_INPUT_SEARCH}    ${LEVEL}
        Wait Until Keyword Succeeds    3x    1s    Element Should Contain    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN_OPTION}    ${LEVEL}
        Mouse Over    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN_OPTION}
        Wait Until Element Is Visible    ${N0_TRAININGS_TOOLTIP}
        Capture Page Screenshot    
    END
    Press Keys    ${SKILL_DETAILS_DIFFICULTY_LEVEL_DROPDOWN}    ESC

    
Verify The Empty Levels Of The Skill Are Disabled In The Unassign Skill Flyout
    [Documentation]    To Verify The Empty Levels Of The Skill Are Disabled In The Unassign Skill Flyout
    Open The Unassign Flyout Window
    Wait For The Element And Click    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_LEVEL_SELECT}
    Capture Page Screenshot
    Close The Unassign Flyout Window

    
Remove the Previous Training From The Skill
    [Documentation]    To Remove the Previous Training From The Skill

    Click On The Edit Button On Skill Details Page
    Wait For The Element And Click    ${SKILL_TRAINING_DELETE_ICON}
    Wait For The Element And Click    ${SKILL_TRAINING_DELETE_CONFIRMATION_BUTTON}
    User Clicks on Create Button On Skill Details Page
    Wait For The Page To Load




Verify Search Functionality In Users Popup Of Assigned Skills
    [Documentation]    To Verify Search Functionality In Users Popup Of Assigned Skills
    FOR    ${USER}    IN    @{ASSIGNED_SKILLS_TO_USERS_LIST}
        Scroll Element And Enter Value    (${INPUT_SEARCH})[1]    ${USER}
        ${LOCATOR}=    Replace String    ${SKILL_DETAILS_ASSIGN_SEARCHED_USER}    USERNAME    ${USER}
        Wait Until Element Is Visible    ${LOCATOR}
        Wait Until Keyword Succeeds    3x    1s    Checkbox Should Be Selected    ${LOCATOR}//input
    END

Verify Search Functionality In Teams Popup Of Assigned Skills
    [Documentation]    To Verify Search Functionality In Teams Popup Of Assigned Skills
    FOR    ${TEAM}    IN    @{EXTRACTED_TEAMS_LIST}
        Scroll Element And Enter Value    ${ASSIGN_SKILL_TO_TEAM_INPUT_SEARCH}    ${TEAM}
        ${LOCATOR}=    Replace String    ${SKILL_DETAILS_ASSIGN_SEARCHED_TEAM}    TEAMNAME    ${TEAM}
        Wait Until Element Is Visible    ${LOCATOR}    ${Max_limit}
        Wait Until Keyword Succeeds    3x    1s    Checkbox Should Be Selected    ${LOCATOR}//input
    END

Verify Close Icon Functionality In Users Popup Of Assigned Skills
    [Documentation]    To Verify Close Icon Functionality In Users Popup Of Assigned Skills
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${CLOSE_ICON_ASSIGN_SKILL_TO_USER_WINDOW}
    Wait Until Page Does Not Contain Element    ${USERS_ASSIGNED_FOR_SKILL_COUNT}


Verify Close Icon Functionality In Team Popup Of Assigned Skills
    [Documentation]    To Verify Close Icon Functionality In Team Popup Of Assigned Skills
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${CLOSE_ICON_ASSIGN_SKILL_TO_TEAM_WINDOW}
    Wait Until Page Does Not Contain Element    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}


Assign The Skill To User
    [Documentation]    To Assign The Skill To User
    [Arguments]    ${ACTION}=Assign    ${MULTIPLE_USERS}=False
    
    Wait Until Element Is Visible    ${ASSIGN_SKILL_USER_TEAM_DIALOG_HEADER}
    Wait Until Element Is Visible    ${ASSIGN_SKILL_USERS_TAB}
    Capture Page Screenshot
    IF    '${MULTIPLE_USERS}'=='True'
        Add Item To List     ITEM=${AUTHOR2_NAME}   VAR_NAME=ASSIGNED_SKILLS_TO_USERS_LIST
    END    
    FOR    ${USER}    IN    @{ASSIGNED_SKILLS_TO_USERS_LIST}
        Scroll Element And Enter Value    ${ASSIGNED_SKILLS_TO_USERS_INPUT_FIELD}    ${USER}
        Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
        ${LOCATOR}=    Replace String    ${SKILL_DETAILS_ASSIGN_SEARCHED_USER}    USERNAME    ${USER}
        #Ignore error should be removed once the unselect bug is fixed
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    END
    IF    '${ACTION}'=='CANCEL_ASSIGNMENT'
        Wait Until Keyword Succeeds    2x    1s    Click Element    ${SKILL_DETAILS_ASSIGN_CANCEL_BUTTON}
        Return From Keyword    
    END
    
    Wait Until Keyword Succeeds    2x    1s    Click Element    ${SKILL_DETAILS_ASSIGN_DONE_BUTTON}
    Wait Until Element Is Not Visible    ${SKILL_DETAILS_ASSIGN_DONE_BUTTON}
    

Assign The Skill Profile To User
    [Documentation]    To Assign The Skill Profile To User
    [Arguments]    ${ACTION}=Assign    ${MULTIPLE_USERS}=False
    
    IF    '${MULTIPLE_USERS}'=='True'
        Add Item To List     ITEM=${AUTHOR2_NAME}   VAR_NAME=ASSIGNED_SKILL_PROFILE_TO_USERS_LIST
    END    
    FOR    ${USER}    IN    @{ASSIGNED_SKILL_PROFILE_TO_USERS_LIST}
        Scroll Element And Enter Value    ${ASSIGNED_SKILL_PROFILE_TO_USERS_INPUT_FIELD}    ${USER}
        Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
        ${LOCATOR}=    Replace String    ${SKILL_PROFILE_DETAILS_ASSIGN_SEARCHED_USER}    USERNAME    ${USER}
        #Ignore error should be removed once the unselect bug is fixed
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    END

    IF    '${ACTION}'=='CANCEL_ASSIGNMENT'
        Wait Until Keyword Succeeds    2x    1s    Click Element    ${SKILL_PROFILE_DETAILS_ASSIGN_CANCEL_BUTTON}
        Return From Keyword    
    END
    
    Wait Until Keyword Succeeds    2x    1s    Click Element    ${SKILL_PROFILE_DETAILS_ASSIGN_DONE_BUTTON}
    Wait Until Element Is Not Visible    ${SKILL_PROFILE_DETAILS_ASSIGN_DONE_BUTTON}
    
    
Get The First Skill Details
    [Documentation]    To Get The First Skill Details
    Wait Until Element Is Visible    ${FIRST_SKILL_LIST_PAGE}
    ${TD_SKILL_NAME}=    Get Text    ${FIRST_SKILL_LIST_PAGE}
    ${TD_SKILL_NAME}=    Strip String    ${TD_SKILL_NAME}
    Set Test Variable    ${TD_SKILL_NAME}

Get The First Skill Profile Details
    [Documentation]    To Get The First Skill Profile Details
    Wait Until Element Is Visible    ${FIRST_SKILL_PROFILE_LIST_PAGE}
    ${TD_SKILL_PROFILE_NAME}=    Get Text    ${FIRST_SKILL_PROFILE_LIST_PAGE}
    ${TD_SKILL_PROFILE_NAME}=    Strip String    ${TD_SKILL_PROFILE_NAME}
    Set Test Variable    ${TD_SKILL_PROFILE_NAME}

    
Search The Skill In My Skills Page
    [Documentation]    To Search The Skill In My Skills Page
    [Arguments]    ${ACTION}=False

    Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH}    ${TD_SKILL_NAME}
    Run Keyword And Ignore Error    Mouse Over    ${INPUT_SEARCH}
    Press Keys    ${INPUT_SEARCH}    ENTER
    Wait For The Page To Load
    
    IF    '${ACTION}'=='NO_SKILLS'
        Wait Until Keyword Succeeds    5x    1s    Wait Until Element Is Visible    ${NO_RECORD_FOUND}
        Return From Keyword
    END

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_IN_MY_SKILLS}    ${TD_SKILL_NAME}

Remove The Skills From The Skill Profile
    [Documentation]    To Remove The Skills From The Skill Profile
    
    FOR    ${SKILL}    IN    @{ADDED_SKILLS_LIST}
        Wait For The Element And Click    ${SKILL_TRAINING_DELETE_ICON}
        Wait For The Element And Click    ${SKILL_TRAINING_DELETE_CONFIRMATION_BUTTON}
        Wait For The Page To Load
    END       

Delete The Skills From Listing Page Added In The Skill Profile
    [Documentation]    To Delete The Skills From Listing Page Added In The Skill Profile

    FOR    ${SKILL}    IN    @{ADDED_SKILLS_LIST}
        Search The Skill On List Page    CUSTOM_SKILL_NAME=${SKILL}
        Delete The Skill From The List Page
    END

Search The Skill Of Skill Profile In My Skills Page
    [Documentation]    To Search The Skill Of Skill Profile In My Skills Page
    [Arguments]    ${SKILLS_DELETED}=False
    
    FOR    ${SKILL}    IN    @{ADDED_SKILLS_LIST}
        Wait Until Keyword Succeeds    5x    1s    Input Text    ${INPUT_SEARCH}    ${SKILL}
        Press Keys    ${INPUT_SEARCH}    ENTER
        Wait For The Page To Load
        IF    ${SKILLS_DELETED}
            Page Should Not Contain Element    ${FIRST_SKILL_IN_MY_SKILLS}
        ELSE
            Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SKILL_IN_MY_SKILLS}    ${SKILL}
        END    
    END       
    
Delete The Skill From The List Page
    [Documentation]    To Delete The Skill From The List Page
    Wait For The Element And Click    ${FIRST_SKILL_RECORD_DELETE_ICON}
    Wait For The Element And Click    ${FIRST_SKILL_RECORD_DELETE_POPUP}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}

Teardown For Skills Page   
    [Documentation]    Teardown For Skills Page   
    Go To    ${Url}/skills
    Delete The Skill From The List Page
    
Verify The Skill Is Deleted
    [Documentation]    To Verify The Skill Is Deleted
    Search The Skill On List Page    SKILL_DELETED=True
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}
    
        
Verify The Skill Profile Is Deleted
    [Documentation]    To Verify The Skill Profile Is Deleted
    Search The Skill Profile On List Page   SKILL_PROFILE_DELETED=True
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}

Verify The Invalid Search On Skill Profile Page
    [Documentation]    To Verify The Invalid Search On Skill Profile Page
    Search The Skill Profile On List Page    CUSTOM_SKILL_PROFILE_NAME=INVALID VALUE    SKILL_PROFILE_DELETED=True
    Wait Until Element Is Visible    ${NO_RECORD_FOUND}

Delete The Skill From Skill Details Page
    [Documentation]    To Delete The Skill From Skill Details Page
    Wait For The Element And Click    ${SKILL_DETAILS_ASSIGN_DELETE_BUTTON}
    Wait For The Element And Click    ${FIRST_SKILL_RECORD_DELETE_POPUP}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}


Delete The Skill Profile From Details Page
    [Documentation]    To Delete The Skill Profile From Details Page
    Wait For The Element And Click    ${SKILL_PROFILE_DETAILS_ASSIGN_DELETE_BUTTON}
    Wait For The Element And Click    ${FIRST_SKILL_PROFILE_RECORD_DELETE_POPUP}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}


Click On The Teams Tab On The Skill User Assign Window
    [Documentation]    To Click On The Teams Tab On The Skill User Assign Window
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    3s    1s    Click Element    ${ASSIGN_SKILL_TEAMS_TAB}

Assign The Skill To Team
    [Documentation]    To Assign The Skill To Team
    [Arguments]    ${EXISTING_TEAMS}=False
    Click On The Teams Tab On The Skill User Assign Window
    IF    '${EXISTING_TEAMS}'=='True'
        ${EXTRACTED_TEAMS_LIST}=    Evaluate    [item for item in ${EXTRACTED_TEAMS_LIST} if item != '']
        FOR    ${TEAM}    IN    @{EXTRACTED_TEAMS_LIST}
            Continue For Loop If    '${TEAM}'==''
            Input Text    ${ASSIGN_SKILL_TO_TEAM_INPUT_SEARCH}    ${TEAM}
            ${LOCATOR}=    Replace String    ${ASSIGN_SKILL_TO_SEARCHED_TEAMS}    VALUE    ${TEAM}
            Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR}
        END
        ${TEAMS_LIST_LENGTH}    Evaluate    len(${EXTRACTED_TEAMS_LIST})
        Set Test Variable    ${TEAMS_LIST_LENGTH}
        Element Should Contain    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}    ${TEAMS_LIST_LENGTH}
        Click On Done Button On Assign Member/Team To Skill
        Return From Keyword
    END

    Input Text    ${ASSIGN_SKILL_TO_TEAM_INPUT_SEARCH}    ${TD_TEAM_NAME}
    ${LOCATOR}=    Replace String    ${ASSIGN_SKILL_TO_SEARCHED_TEAMS}    VALUE    ${TD_TEAM_NAME}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR}
    Click On Done Button On Assign Member/Team To Skill

#Verify The Skill Is Assigned To The Teams
#    [Documentation]    To Verify The Skill Is Assigned To The Teams
#    Click On The Teams Tab On The Skill User Assign Window
#    Wait Until Element Is Visible    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}
#    Element Should Contain    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}    ${TEAMS_LIST_LENGTH}
#
Assign The Skill Profile To Team
    [Documentation]    To Assign The Skill Profile To Team
    [Arguments]    ${EXISTING_TEAMS}=False
    Click On The Teams Tab On The Skill User Assign Window

    Input Text    (${INPUT_SEARCH})[3]    ${TD_TEAM_NAME}
    ${LOCATOR}=    Replace String    ${ASSIGN_SKILL_TO_SEARCHED_TEAMS}    VALUE    ${TD_TEAM_NAME}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR}
    Click On Done Button On Assign Member/Team To Skill

Click On Done Button On Assign Member/Team To Skill
    [Documentation]    To Click On Done Button On Assign Member/Team To Skill
    Wait Until Keyword Succeeds    2x    1s    Click Element    ${SKILL_DETAILS_ASSIGN_DONE_BUTTON}
    Wait Until Element Is Not Visible    ${SKILL_DETAILS_ASSIGN_DONE_BUTTON}    ${Max_limit}

Get The Teams Data
    [Documentation]    To Get The Teams Data
    Wait Until Element Is Visible    ${TEAM_RECORD_LISTED_ON_LIST_PAGE}
    ${MAX_LIMIT}=    Get Element Count    ${TEAM_RECORD_LISTED_ON_LIST_PAGE}
    ${EXTRACTED_TEAMS_LIST}=    Get Values In List For Validation    (${TEAM_RECORD_LISTED_ON_LIST_PAGE})[INDEX]    1    ${MAX_LIMIT}

    Set Test Variable    ${EXTRACTED_TEAMS_LIST}

Create Training For Skills
    [Documentation]    To Create Training For Skills
    [Arguments]    ${SINGLE_RECORDS_COUNT}=False
    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    Empty List    NEW_TRAINING_CREATED_DESCRIPTION_LIST
    Empty List    NEW_TRAINING_CREATED_LIST
    IF    '${SINGLE_RECORDS_COUNT}'!='False'
        Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    ELSE
        Create Procedure Records    COUNT=4    SIGNOFF=NOT REQUIRED
        Create Procedure Records    COUNT=1    SIGNOFF=REQUIRED
    END
    User Navigate To The Trainings Page
    FOR    ${PROCEDURE_ITEM}    IN    @{ADD_PROCEDURE_TO_TRAINING_LIST}
        Click On Add New Training Button
        Fill The Form With Description And Submit It
        Navigate To Training Details Page
        Click Edit Procedure Button
        ${TEMP_LIST}=    Create List    ${PROCEDURE_ITEM}
        Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${TEMP_LIST}
        Click Create/Update Training Submit Button
        Add Item To List   ITEM=${TRAINING_NAME}   VAR_NAME=NEW_TRAINING_CREATED_LIST
        Add Item To List   ITEM=${TD_TRAINING_DESC}   VAR_NAME=NEW_TRAINING_CREATED_DESCRIPTION_LIST
    END

Create Training For Skill Completion
    [Documentation]    To Create Training For Skill Completion
    [Arguments]    ${REQUIRED_PROCEDURE_COUNT}=2
    ${ADD_PROCEDURE_TO_TRAINING_LIST}=    Get Slice From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    0    ${REQUIRED_PROCEDURE_COUNT}
    Set Test Variable    ${ADD_PROCEDURE_TO_TRAINING_LIST}
    Empty List    NEW_TRAINING_CREATED_LIST
    Empty List    NEW_TRAINING_CREATED_DESCRIPTION_LIST
#    Create Procedure Records    COUNT=${REQUIRED_PROCEDURE_COUNT}    SIGNOFF=NOT REQUIRED
    User Navigate To The Trainings Page
    FOR    ${PROCEDURE_ITEM}    IN    @{ADD_PROCEDURE_TO_TRAINING_LIST}
        Click On Add New Training Button
        Fill The Form With Description And Submit It
        Navigate To Training Details Page
        Click Edit Procedure Button
        ${TEMP_LIST}=    Create List    ${PROCEDURE_ITEM}
        Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${TEMP_LIST}
        Click Create/Update Training Submit Button
        Add Item To List   ITEM=${TRAINING_NAME}   VAR_NAME=NEW_TRAINING_CREATED_LIST
        Add Item To List   ITEM=${TD_TRAINING_DESC}   VAR_NAME=NEW_TRAINING_CREATED_DESCRIPTION_LIST
    END


Create Training For Skill Completion With Multiple Procedures
    [Documentation]    To Create Training For Skill Completion With Multiple Procedures
    [Arguments]    ${REQUIRED_PROCEDURE_COUNT}=4    ${SIGNOFF_REQUIRED}=NOT REQUIRED
    Empty List    ADD_PROCEDURE_TO_TRAINING_LIST
    Empty List    NEW_TRAINING_CREATED_LIST
    Empty List    NEW_TRAINING_CREATED_DESCRIPTION_LIST
    Create Procedure Records    COUNT=${REQUIRED_PROCEDURE_COUNT}    SIGNOFF=${SIGNOFF_REQUIRED}
    User Navigate To The Trainings Page
    ${ADD_PROCEDURE_TO_TRAINING_LIST}=    Create List    ${ADD_PROCEDURE_TO_TRAINING_LIST[0:2]}    ${ADD_PROCEDURE_TO_TRAINING_LIST[3:]}
    ${ADD_PROCEDURE_TO_TRAINING_LIST}=    ENUMERATE LIST    ${ADD_PROCEDURE_TO_TRAINING_LIST}
    FOR    ${PROCEDURE_ITEM}    IN    @{ADD_PROCEDURE_TO_TRAINING_LIST}
        Click On Add New Training Button
        Fill The Form With Description And Submit It
        Navigate To Training Details Page
        Click Edit Procedure Button
        ${TEMP_LIST}=    Set Variable    ${PROCEDURE_ITEM[1]}
        Select Multiple Procedure From List    CUSTOM_PROCEDURE_LIST=${TEMP_LIST}
        Click Create/Update Training Submit Button
        Add Item To List   ITEM=${TRAINING_NAME}   VAR_NAME=NEW_TRAINING_CREATED_LIST
    END

Click On The Details Button On My Skill
    [Documentation]    To Click On The Details Button On My Skill
    Wait Until Element Is Visible    ${FIRST_SKILL_UPGRADE_BUTTON}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${FIRST_SKILL_UPGRADE_BUTTON}


Verify All The Trainings Of The Skills Are Displayed
    [Documentation]    To Verify All The Trainings Of The Skills Are Displayed
    Click On The Details Button On My Skill
    Wait Until Element Is Visible    ${MY_SKILL_FLYOUT_TRAININGS}
    ${MAX_LIMIT}=    Get Element Count    ${MY_SKILL_FLYOUT_TRAININGS}
    ${MY_SKILL_FLYOUT_TRAININGS_LIST}=    Get Values In List For Validation    (${MY_SKILL_FLYOUT_TRAININGS})[INDEX]    1    ${MAX_LIMIT}
    Validate The Extracted List Data    ${NEW_TRAINING_CREATED_LIST}    ${MY_SKILL_FLYOUT_TRAININGS_LIST}

Verify The Count Of Skills On Skills Page Is Correct
    [Documentation]    To Verify The Count Of Skills On Skills Page Is Correct
    ${COUNT}=    Get Current Record Count On Page    
    Element Should Contain    ${SKILL_LISTING_PAGE_HEADER}    ${COUNT}

Click On The Skills/Skill Profile Link From The Breadcrumbs
    [Documentation]    To Click On The Skills/Skill Profile Link From The Breadcrumbs
    Wait Until Element Is Visible    ${SKILLS_LINK_FROM_BREADCRUMB}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${SKILLS_LINK_FROM_BREADCRUMB}


Verify The Input Field Validation On New Skill Page
    [Documentation]    To Verify The Input Field Validation On New Skill Page
    User Clicks on Create Button On Skill Details Page
    Wait Until Element Is Visible    ${EMPTY_SKILL_NAME_VALIDATION_TOASTER}
    Wait Until Element Is Visible    ${UNSELECTED_SKILL_FREQUENCY_VALIDATION_TOASTER}

    Input Text    ${SKILL_NAME_INPUT}    Skill Name
    User Clicks on Create Button On Skill Details Page
    Wait Until Element Is Visible    ${UNSELECTED_SKILL_FREQUENCY_VALIDATION_TOASTER}
    
    Select The Frequency On Skill Details Page
    
    #Clear text
    Repeat Keyword    14x    Press Keys    ${SKILL_NAME_INPUT}    BACKSPACE
    Page Should Contain    Skill Name is required


Verify That User Is Not Able To Create A Skill With Invalid Name(Space, Empty, Special Character)
    [Documentation]    To Verify That User Is Not Able To Create A Skill With Invalid Name(Space, Empty, Special Character)
    #verify validation for name field
    VAR    ${TEMP}    @,#,$,%,^,*,)a
    ${INVALID_CHARACTERS}=    Split String    ${TEMP}    ,
    FOR    ${CHAR}    IN    @{INVALID_CHARACTERS[:-1]}
        Scroll Element And Enter Value    ${SKILL_NAME_INPUT}    ${CHAR}
        Wait Until Element Is Visible    ${SKILL_DETAILS_ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}
    END
    Scroll Element And Enter Value    ${SKILL_NAME_INPUT}    ${INVALID_CHARACTERS[-1]}
    Wait Until Element Is Not Visible    ${SKILL_DETAILS_ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}
    Scroll Element And Enter Value    ${SKILL_NAME_INPUT}    Skill Name
    Wait Until Element Is Not Visible    ${SKILL_DETAILS_ERROR_MESSAGE_SPECIAL_CHAR_NOT_ALLOWED}


Save Skill Validation Data
    [Documentation]    To Save Skill Validation Data
    &{data}=    Create Dictionary
    ...    NEW_TRAINING_CREATED_LIST=${NEW_TRAINING_CREATED_LIST}
    ...    NEW_TRAINING_CREATED_DESCRIPTION_LIST=${NEW_TRAINING_CREATED_DESCRIPTION_LIST}
    ...    ADD_PROCEDURE_TO_TRAINING_LIST=${ADD_PROCEDURE_TO_TRAINING_LIST}


    ${json}=    Convert Json To String    ${data}
    Create File    skill_validation_data.json    ${json}

  
Load Skill Validation Data
    ${VALIDATION_DATA}=    Load Json From File    skill_validation_data.json
    Set Suite Variable    ${VALIDATION_DATA}
    Log    ${VALIDATION_DATA}
    FOR    ${key}    IN    @{VALIDATION_DATA.keys()}
        ${value}=    Get From Dictionary    ${VALIDATION_DATA}    ${key}
        Set Suite Variable    ${${key}}    ${value}
        Log    ${${key}}
    END    
    
    
Verify The Count And Name Of Selected Trainings Are Visible On Select Training Page
    [Documentation]    To Verify The Count And Name Of Selected Trainings Are Visible On Select Training Page
    Click Element    ${INTERMEDIATE_LEVEL_TAB}
    Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
    Wait Until Element Is Visible    ${ADDED_TRAININGS_TO_SKILL_AT_LEVEL}
    ${LENGTH}=    Evaluate    len(${NEW_TRAINING_CREATED_LIST})   
    Element Should Contain    ${ADDED_TRAININGS_TO_SKILL_AT_LEVEL}    ${LENGTH}
    
    #Validate trainings listed
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${SKILL_DETAILS_ASSIGN_CANCEL_BUTTON}
    
    Wait Until Element Is Visible    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    ${TRAININGS_LISTED_SKILL_DETAILS_COUNT}=    Get Element Count    ${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE}
    Should Be True    len(${NEW_TRAINING_CREATED_LIST})    ${TRAININGS_LISTED_SKILL_DETAILS_COUNT}
    
    @{UPDATED_NEW_TRAINING_CREATED_LIST}=    ENUMERATE LIST    ${NEW_TRAINING_CREATED_LIST}
    FOR    ${TRAINING}    IN    @{UPDATED_NEW_TRAINING_CREATED_LIST}
        Input Text    ${INPUT_SEARCH}    ${TRAINING[1]}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${ADDED_TRAINING_TO_SKILL_LISTED_ON_DETAILS_PAGE})[1]    ${TRAINING[1]}
        ${DESC_INDEX}=    Evaluate    str(int(${TRAINING[0]})-1)
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_DESCRIPTION_LISTED_ON_DETAILS_PAGE}    ${NEW_TRAINING_CREATED_DESCRIPTION_LIST}[${DESC_INDEX}]
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${ADDED_TRAINING_PROCEDURE_COUNT_LISTED_ON_DETAILS_PAGE}    1
        Element Should Be Visible    ${ADDED_TRAINING_PROCEDURE_DELETE_ICON}
    END


Verify The User Can Select All Rows On The Skill List Page
    [Documentation]    To Verify The User Can Select All Rows On The Skill List Page
    Wait For The Element And Click    ${ALL_RECORDS_CHECKBOX_ON_LIST_PAGE}
    ${COLOR}=    Get CSS Property    ${ALL_SKILL_RECORDS_SELECTED}    background-color
    Should Be Equal As Strings    ${SELECTED_RECORDS_COLOR}    ${COLOR}
    Wait For The Element And Click    ${ALL_RECORDS_CHECKBOX_ON_LIST_PAGE}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    
    
Verify That User Can Select All Trainings By Clicking On All Checkbox On Select Training Page
    [Documentation]    To Verify That User Can Select All Trainings By Clicking On All Checkbox On Select Training Page
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${SKILL_DETAILS_PAGE_ADD_TRAINING_BUTTON}
    Verify The User Can Select All Rows On The Skill List Page
    
Search The Training in My Skill Flyout
    [Documentation]    To Search The Training in My Skill Flyout
    [Arguments]    ${TRAINING_IN_SKILL}    ${OTHER_LEVEL_TRAINING}=False    ${APPROVED/CONFIRMED}=False

    IF    '${APPROVED/CONFIRMED}'=='True'
        Wait For The Element And Click    ${MY_SKILL_FLYOUT_APPROVED_CONFIRMED_BUTTON}
    END
    
    Wait Until Element Is Visible    ${MY_SKILL_FLYOUT_INPUT_SEARCH}    ${Max_limit}
    Scroll Element And Enter Value    ${MY_SKILL_FLYOUT_INPUT_SEARCH}    ${TRAINING_IN_SKILL}
    IF    '${OTHER_LEVEL_TRAINING}'=='True'
        Wait Until Keyword Succeeds    5x    1s    Element Should Not Contain    ${MY_SKILL_FLYOUT_TRAININGS}    ${TRAINING_IN_SKILL}
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${MY_SKILL_FLYOUT_TRAININGS}    ${TRAINING_IN_SKILL}
    END        

        
Complete The Trainings In My Skills
    [Documentation]    To Complete The Trainings In My Skills
    [Arguments]    ${TRAINING_IN_SKILL}    ${DO_NOT_COMPLETE_EXECUTION}=False    ${START_AGAIN_BUTTON_VISIBLE}=False    ${PROCEDURE_COUNT}=None    ${START_SIGNOFF_PROCEDURE}=None    ${APPROVED/CONFIRMED}=None
    Search The Skill In My Skills Page
    Click On The Details Button On My Skill

    Search The Training in My Skill Flyout    ${TRAINING_IN_SKILL}    APPROVED/CONFIRMED=${APPROVED/CONFIRMED}
    Wait For The Element And Click     ${MY_SKILL_FLYOUT_TRAININGS}
    
    IF    '${START_AGAIN_BUTTON_VISIBLE}'=='True'
        Wait Until Element Is Visible    ${START_AGAIN_SKILL_TRAINING_BUTTON}
        Reload Page
        Return From Keyword
    END
        
    #Start the procedure
    IF    '${START_SIGNOFF_PROCEDURE}'=='True'
        ${PROCEDURE}=    Get From List    ${ADD_PROCEDURE_TO_TRAINING_LIST}    0
        ${LOCATOR}=    Replace String    ${MY_SKILL_FLYOUT_START_SPECIFIC_PROCEDURE_BUTTON}    PROCEDURE_NAME    ${PROCEDURE}
        Wait For The Element And Click    ${LOCATOR}
    ELSE
        Wait For The Element And Click    ${MY_SKILL_FLYOUT_START_PROCEDURE_BUTTON}
    END
    
    
    Return From Keyword If    ${DO_NOT_COMPLETE_EXECUTION}
    Complete Job/Training Execution


Verify The Skill Data On My Skill Page
    [Documentation]    To Verify The Skill Data On My Skill Page
    [Arguments]    ${SKILL_STATUS}
    
    @{SKILL_STATUS_LIST}=    Split String    ${SKILL_STATUS}    ,
    
    Search The Skill In My Skills Page    

    #Validate data
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_SKILL_NAME})[1]    ${TD_SKILL_NAME}
#    ${COLOR}=    Get CSS Property    (${ADDED_PROCEDURE_COMPLETED_BY_STATUS_COLOR})[1]    background-color
#    Should Be Equal As Strings    ${COLOR}    ${${PROCEDURE_STATUS_LIST[0]}}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_CURRENT_LEVEL})[1]    ${SKILL_STATUS_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_REQUIRED_LEVEL})[1]    ${SKILL_STATUS_LIST[1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAININGS_REQUIRED})[1]    ${SKILL_STATUS_LIST[2]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAININGS_STATUS})[1]    ${SKILL_STATUS_LIST[3]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAININGS_COUNT})[1]    ${SKILL_STATUS_LIST[4]}

Verify The Skill Training Completion Details
    [Documentation]    To Verify The Skill Training Completion Details
    Click On The Details Button On My Skill
    Search The Training in My Skill Flyout    TRAINING_IN_SKILL=${NEW_TRAINING_CREATED_LIST[-1]}    APPROVED/CONFIRMED=True
    Wait For The Element And Click    ${MY_SKILL_FLYOUT_TRAININGS}

    ${CURRENT_DATE}=    Get Current Date
    ${TODAY_DATE}=    Convert Date    ${CURRENT_DATE}    result_format=%b %d, %Y
    Log To Console    ${TODAY_DATE}
    Log               ${TODAY_DATE}

    Wait For The Element And Click    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_PROCEDURE_EXPAND_BUTTON})[1]
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_PROCEDURE_NAME})[1]    ${ADD_PROCEDURE_TO_TRAINING_LIST[-1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_START})[1]      ${TODAY_DATE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_END})[1]      ${TODAY_DATE}
    ${TAKEN_TIME}=    Set Variable    ${TAKEN_TIME_IN_EXECUTION[-1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_TIME_TAKEN})[1]      ${TAKEN_TIME}

    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_PROCEDURE_SIGNOFF})[1]      N/A
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_PROCEDURE_MANAGER})[1]      N/A
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_TRAINING_FLYOUT_TRAINING_PROCEDURE_STATUS_APPROVED})[1]      Not Required

Verify The Trainings Data On My Skill Flyout Page
    [Documentation]    To Verify The Trainings Data On My Skill Flyout Page
    [Arguments]    ${TRAINING_IN_SKILL}        ${TRAINING_STATUS}        ${OTHER_LEVEL_TRAINING}=False    ${APPROVED/CONFIRMED}==False

    Click On The Details Button On My Skill
    Search The Training in My Skill Flyout    ${TRAINING_IN_SKILL}    ${OTHER_LEVEL_TRAINING}    ${APPROVED/CONFIRMED}

    @{SKILL_TRAINING_STATUS_LIST}=    Split String    ${TRAINING_STATUS}    ,



    #Validate data
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_SKILL_NAME})[1]    ${TD_SKILL_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_CURRENT_LEVEL})[1]    ${SKILL_TRAINING_STATUS_LIST[0]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_REQUIRED_LEVEL})[1]    ${SKILL_TRAINING_STATUS_LIST[1]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_TRAININGS})[1]    ${TRAINING_IN_SKILL}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_PROCEDURE_IN_TRAININGS})[1]    ${SKILL_TRAINING_STATUS_LIST[2]}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    (${MY_SKILL_FLYOUT_TRAININGS_STATUS})[1]    ${SKILL_TRAINING_STATUS_LIST[3]}

    Wait For The Element And Click    ${MY_SKILL_FLYOUT_CROSS_ICON}

Add Skill To The Procedure
    [Documentation]    To Add Skill To The Procedure
    Wait Until Element Is Visible    ${SKILLS_TAB_PROCEDURE_DETAILS}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${SKILLS_TAB_PROCEDURE_DETAILS}

    #add skill
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${PROCEDURE_DETAILS_CHOOSE_SKILL_BUTTON}
    Wait Until Element Is Visible    (${INPUT_SEARCH})[4]    ${Max_limit}
    Input Text    (${INPUT_SEARCH})[4]    ${TD_SKILL_NAME}
    ${LOCATOR}=    Replace String    ${PROCEDURE_DETAILS_CHOOSE_SKILL_LISTED}    SKILL_NAME    ${TD_SKILL_NAME}
    Wait Until Keyword Succeeds    10x    2s    Click Element    ${LOCATOR}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${PROCEDURE_DETAILS_DONE_BUTTON}
    
Select The Skill In Skill Matrix Page
    [Documentation]    To Select The Skill In Skill Matrix Page
    Wait For The Element And Click    ${SKILL_MATRIX_SKILLS_SELECT}    
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_SKILL_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${SKILL_MATRIX_SKILLS_OPTION}    ${TD_SKILL_NAME}
    Wait For The Element And Click    ${SKILL_MATRIX_SKILLS_OPTION}
    Wait For The Page To Load
    Press Keys    None    ESC
    
Verify The Skill Data In Skill Matrix Page
    [Documentation]    To Verify The Skill Data In Skill Matrix Page
    [Arguments]    ${SKILL_DATA}    
    
    @{SKILL_DATA_LIST}=    Split String    ${SKILL_DATA}    ,
    
    Element Should Contain    ${SKILL_MATRIX_SKILLS_LISTED}    ${TD_SKILL_NAME[0:13]}
    Element Should Contain    ${SKILL_MATRIX_USER_SKILL_STATUS}    ${SKILL_DATA_LIST[0]}
    ${COLOR}=    Get CSS Property    ${SKILL_MATRIX_USER_SKILL_STATUS}    background-color
    Log    ${COLOR}
    Element Should Contain    ${SKILL_MATRIX_SKILL_MEMBER_COUNT}    ${SKILL_DATA_LIST[2]}
    Element Should Contain    ${SKILL_MATRIX_SKILL_COMPLETION_PERCENT}    ${SKILL_DATA_LIST[3]}
    ${COLOR}=    Get CSS Property    ${SKILL_MATRIX_SKILL_COMPLETION_PERCENT}    background-color
    Log    ${COLOR}


Open The Unassign Flyout Window
   [Documentation]    To Open The Unassign Flyout Window
   Wait For The Element And Click    ${SKILL_DETAILS_UNASSIGN_USERS_ICON}
   Wait For The Page To Load
   Set Page Zoom Level    .5

Close The Unassign Flyout Window
   [Documentation]    To Close The Unassign Flyout Window
   Wait For The Element And Click    ${SKILL_DETAILS_CLOSE_FLYOUT_BUTTON}
   Wait For The Page To Load
   Set Page Zoom Level    0

Verify The UI Of The Unassign Flyout Window
    [Documentation]    To Verify The UI Of The Unassign Flyout Window

    #Header
    Wait Until Element Is Visible    ${SKILL_DETAILS_UNASSIGN_FLYOUT_HEADER}
    Wait Until Element Is Visible    ${SKILL_DETAILS_CLOSE_FLYOUT_BUTTON}
    Wait Until Element Is Visible    ${SKILL_DETAILS_FLYOUT_SEARCH}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_NAME}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_PERSONA}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_LEVEL_SELECT}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_ICON}
    
Verify The UI Of Unassign User Popup
    [Documentation]    To Verify The UI Of Unassign User Popup
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_HEADER}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_CLOSE_ICON}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_TEXT}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_CANCEL_BUTTON}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_UNASSIGN_BUTTON}

Delete The User From The Flyout Screen
    [Documentation]    To Delete The User From The Flyout Screen
    Wait For The Element And Click    (${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_ICON})[1]
    Verify The UI Of Unassign User Popup
    Wait For The Element And Click    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_POPUP_UNASSIGN_BUTTON}
    Wait For The Page To Load
    Run Keyword And Ignore Error    Wait Until Page Contains    User unassigned successfully.
    Wait Until Element Is Not Visible    ${LoadingBar}    60s
    
    
Unassign The User From The Skill
    [Documentation]    To Unassign The User From The Skill
    [Arguments]    ${USER_NAME}    ${SKILL_ASSIGNED_AT_LEVEL}    ${VERIFY_FLYOUT}=False
    
    Open The Unassign Flyout Window
    Verify The UI Of The Unassign Flyout Window
    
    #Search The User
    Search The User In Unassign Skill Flyout Window    ${USER_NAME}

    #Delete The User
    Delete The User From The Flyout Screen     
    
    IF    '${VERIFY_FLYOUT}'=='True'
        Wait Until Element Is Not Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_DELETE_ICON}
        Wait Until Element Is Not Visible    ${SKILL_DETAILS_FLYOUT_SEARCH}
    END

    Capture Page Screenshot
    Close The Unassign Flyout Window

Search The User In Unassign Skill Flyout Window       
    [Documentation]    To Search The User In Unassign Skill Flyout Window       
    [Arguments]    ${USER_NAME}
    Scroll Element And Enter Value    ${SKILL_DETAILS_FLYOUT_SEARCH}    ${USER_NAME}
        
Verify The Skill Assigned To User At Level
    [Documentation]    To Verify The Skill Assigned To User At Level
    [Arguments]    ${USER_NAME}    ${CURRENT_LEVEL}=Elementary

    Open The Unassign Flyout Window
    Search The User In Unassign Skill Flyout Window    ${USER_NAME}
    
    #Expand The users list under the target level
    ${CURRENT_LEVEL_HEADER}=    Replace String    ${SKILL_DETAILS_SKILL_LEVEL_ASSIGNED_TO_USERS_HEADER}    LEVEL    ${CURRENT_LEVEL}
    Element Should Be Visible    ${CURRENT_LEVEL_HEADER}
    
    ${USER_VISIBLE}=    Run Keyword And Return Status    Element Should Be Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_NAME}
    
    ${EXPAND_USERS_LIST_IN_FLYOUT_WINDOW}=    Replace String    ${SKILL_DETAILS_SKILL_LEVEL_ASSIGNED_TO_USERS_HEADER_EXPAND_COLLAPSE_BUTTON}    LEVEL    ${CURRENT_LEVEL}  
    Run Keyword If    not ${USER_VISIBLE}    Click Element    ${EXPAND_USERS_LIST_IN_FLYOUT_WINDOW}
    
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_NAME}
    Close The Unassign Flyout Window

Verify The UI Of Change User Level Popup
    [Documentation]    To Verify The UI Of Change User Level Popup
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_HEADER}    ${Max_limit}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_TEXT}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_CANCEL_BUTTON}
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_DONE_BUTTON}
               
Change The Level Of Skill Assigned To User To
    [Documentation]    To Change The Level Of Skill Assigned To User To
    [Arguments]    ${USER_NAME}    ${TARGET_LEVEL}    ${CANCEL_LEVEL_CHANGE}=False

    Open The Unassign Flyout Window
    Search The User In Unassign Skill Flyout Window    ${USER_NAME}
    
    Wait Until Element Is Visible    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_LEVEL_SELECT}
    Select From List By Value    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_LEVEL_SELECT}    ${TARGET_LEVEL}
    
    #Change Level popup
    Verify The UI Of Change User Level Popup
    
    
    IF    '${CANCEL_LEVEL_CHANGE}'=='True'
        Wait For The Element And Click    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_CANCEL_BUTTON}
        Wait For The Page To Load
        Close The Unassign Flyout Window
        Return From Keyword
    END

    Wait For The Element And Click    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_CHANGE_LEVEL_POPUP_DONE_BUTTON}
    #Validate the success message
#    Wait Until Page Contains    Skill Level Changed Successfully
    Capture Page Screenshot
    Wait For The Page To Load
    Close The Unassign Flyout Window
    
Verify The Skill Is Assigned To All The Members Of The Team
    [Documentation]    To Verify The Skill Is Assigned To All The Members Of The Team
    
    Open The Unassign Flyout Window
    
    ${PERSONA_LIST_ASSIGNED_TO_SKILL}=    Create List    Author    Operator    Organization Admin
    
    ${ASSIGNED_USERS_TO_TEAM_LIST}=    ENUMERATE LIST    ${ASSIGNED_USERS_TO_TEAM_LIST}
    FOR    ${USER}    IN    @{ASSIGNED_USERS_TO_TEAM_LIST}
        Search The User In Unassign Skill Flyout Window    ${USER[1]}
        ${USER_PERSONA_INDEX}=    Evaluate    int(${USER[0]})-1
        ${USER_PERSONA_FROM_LIST}=    Get From List    ${PERSONA_LIST_ASSIGNED_TO_SKILL}    ${USER_PERSONA_INDEX}
        Verify The UI Of The Unassign Flyout Window
        Element Should Contain    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_NAME}    ${USER[1]}
        Element Should Contain    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_PERSONA}    ${USER_PERSONA_FROM_LIST}    
        ${COUNT}=    Get Element Count    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_PERSONA}
        Should Be True    ${COUNT}==1
    END


    Close The Unassign Flyout Window
    
Verify The Skill Is Assigned To The User
    [Documentation]    To Verify The Skill Is Assigned To The User

    Open The Unassign Flyout Window

    Capture Page Screenshot
    Search The User In Unassign Skill Flyout Window    ${OPERATOR1_NAME}
    Element Should Contain    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_NAME}    ${OPERATOR1_NAME}
    Element Should Contain    ${SKILL_DETAILS_SKILL_ASSIGNED_TO_USERS_PERSONA}    Operator

    Close The Unassign Flyout Window

Delete All Team Members From The Skill
    [Documentation]    To Delete All Team Members From The Skill
    [Arguments]    ${CURRENT_ASSIGNED_USERS}=2
    
    Open The Unassign Flyout Window
    FOR    ${IT}    IN RANGE      ${CURRENT_ASSIGNED_USERS}
        Delete The User From The Flyout Screen
    END
    
    Wait Until Element Is Visible    ${SKILL_DETAILS_NO_USERS_ASSIGNED_TO_SKILL}
    Close The Unassign Flyout Window
    
Verify The Skill Is Unassigned From
    [Documentation]    To Verify The Skill Is Unassigned From
    [Arguments]    ${TAB}
    
    Click On Assign Button On Skill Details Page 
    
    #Currently assigned teams count is not visible , a bug is logged
#    IF    '${TAB}'=='Team'
#        Click On The Teams Tab On The Skill User Assign Window
#         Element Should Contain    ${TEAMS_ASSIGNED_FOR_SKILL_COUNT}    0
#         Return From Keyword
#    END
    
    Element Should Contain    ${USERS_ASSIGNED_FOR_SKILL_COUNT}    0
    
    
Create Skill Records
    [Documentation]    To Create Skill Records
    [Arguments]    ${COUNT}=2    ${LIST_NAME}=ADDED_SKILLS_LIST
    FOR    ${IT}    IN RANGE    ${COUNT}
        User Clicks on Add New Skill
        Verify The User Navigates To Create New Skill Page
        User Adds Skills Details
        IF    '${IT}'=='1'
            User Adds Trainings    Beginner
        ELSE    
            User Adds Trainings    Elementary
        END    
        User Clicks on Create Button On Skill Details Page
        Verify That A New Skill Is Created
        Add Item To List    ITEM=${TD_SKILL_NAME}   VAR_NAME=${LIST_NAME}
    END
