*** Settings ***
Library    SeleniumLibrary
#Library    Browser
Library    OperatingSystem
Library    String
Library    JSONLibrary
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Library     ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Resource    ../Common/Common.resource
Resource    ../Approvals/ProcedureApproval.resource
Resource    ../BOM_BOT/BOM.resource
Resource    ../BOM_BOT/BOT.resource
Variables   ../../../../../locators/ui/web/Mentor/AuthorScreen.yaml

Variables    ../../../../../../testdata/ui/web/Mentor/testdata.yaml


*** Variables ***
${BROWSER}    Chrome
${Upload_File_Path}         ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor
${User_Input_Title}     Planning?
${PROCEDURE_LIST_PAGE}    ${Url}/procedure
${TF_MIGRATION_DATA}=      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}MigrationData.csv

*** Keywords ***
Click on breadcrumb link
    Click Element    ${Breadcrumb link}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

User Clicks on Add Button On Procedures List Page
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    10s    2s    Click Element By JS    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${PROCEDURE_OPTION}
    IF    not ${status}
        Wait Until Keyword Succeeds    10s    2s    Click Element    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}
    END
    Select The Procedure Option On Procedure List Page

Verify Duplicate Columns Not Displayed On The Procedure List Page 
    [Documentation]    To Verify Duplicate Columns Not Displayed On The Procedure List Page 
    ${COUNT}=    Get Element Count    ${ACTIONS_COLUMN_ON_PROCEDURES_LIST_PAGE}
    Should Be True    ${COUNT}==1

Select The Procedure Option On Procedure List Page
    [Documentation]    To Select The Procedure Option On Procedure List Page
    Wait For The Element And Click    ${PROCEDURE_OPTION}

User Lands on Add New Procedure Page
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Sleep   3s
    Page Should Contain Element    ${GENERAL_DETAILS_SECTION}   ${MaxTime}

Generate Unique Number
    ${UniqueNumbertest}=    Generate Random String
    Set Global Variable     ${UniqueNumbertest}

User Adds General Details
    [Documentation]  To Add Procedure Details
    [Arguments]    ${FORM_FILLING}=None    ${AUTO_GENERATE}=None    ${CHANGES_REVERTED}=None    ${BLANK_DOCUMENT_ID}=False    ${BLANK_PREFIX_SUFFIX_VALUE}=False    ${VERIFY_DUPLICATE_MAT_NUM}=False
    Generate Unique Number
    Wait Until Element Is Visible    ${Name_input}
    Click Element    ${Name_input}
    Input Text    ${Name_input}    Pro-${UniqueNumberTest}
    VAR    ${TD_PROCEDURE_NAME}    Pro-${UniqueNumberTest}
    Set Test Variable    ${TD_PROCEDURE_NAME}
    Click Element    ${Name_input}
    Input Text    ${Material_Number}    MAT-${UniqueNumberTest}
    IF    '${VERIFY_DUPLICATE_MAT_NUM}'=='True'
        Click Element    ${Name_input}
        Sleep    2s    #To properly populate the text in the mat input field
        Input Text    ${Material_Number}    MAT-${UniqueNumberTest}
        Click Element    ${Name_input}
        Sleep    2s    #To properly populate the text in the mat input field
        ${TEMP}=    Get Element Attribute    ${Material_Number}    text
        Log    ${TEMP}
    END    
    VAR    ${TD_MATERIAL_NUMBER}    MAT-${UniqueNumberTest}
    Set Test Variable    ${TD_MATERIAL_NUMBER}
    
    Click Element    ${DOCUMENT_ID_INPUT}
    VAR    ${TD_DOCUMENT_ID}    DOCID-${UniqueNumberTest}
    Set Test Variable    ${TD_DOCUMENT_ID} 
       
    #Settings Validation
    IF    '${FORM_FILLING}'=='FREE_FORM'
        Element Text Should Be    ${DOCUMENT_ID_INPUT}    ${EMPTY}
    ELSE IF    '${FORM_FILLING}'=='AUTO_GENERATE'
        IF    '${AUTO_GENERATE}'=='PREFIX'
            IF    '${CHANGES_REVERTED}'=='True'
                ${STATUS}=    Run Keyword And Return Status    Element Attribute Value Should Be    ${DOCUMENT_ID_INPUT}    value    MAT-${TD_MATERIAL_NUMBER}
                Should Not Be True    ${STATUS}
            ELSE IF    '${BLANK_PREFIX_SUFFIX_VALUE}'=='True'
                ${EXTRACTED_VALUE}=        Get Element Attribute    ${DOCUMENT_ID_INPUT}    value
                Should Not Contain    ${EXTRACTED_VALUE}    MAT-${TD_MATERIAL_NUMBER}
            ELSE
                Element Attribute Value Should Be    ${DOCUMENT_ID_INPUT}    value    MAT-${TD_MATERIAL_NUMBER}
            END
        ELSE IF    '${AUTO_GENERATE}'=='SUFFIX'
            IF    '${CHANGES_REVERTED}'=='True'
                ${STATUS}=    Run Keyword And Return Status    Element Attribute Value Should Be    ${DOCUMENT_ID_INPUT}    value    ${TD_MATERIAL_NUMBER}-MAT
                Should Not Be True    ${STATUS}
            ELSE IF    '${BLANK_PREFIX_SUFFIX_VALUE}'=='True'
                ${EXTRACTED_VALUE}=        Get Element Attribute    ${DOCUMENT_ID_INPUT}    value
                Should Not Contain    ${EXTRACTED_VALUE}    ${TD_MATERIAL_NUMBER}-MAT
            ELSE
                Element Attribute Value Should Be    ${DOCUMENT_ID_INPUT}    value    ${TD_MATERIAL_NUMBER}-MAT
            END
            
        END

    END
    Log    ${BLANK_DOCUMENT_ID}
    Return From Keyword If    '${BLANK_DOCUMENT_ID}'=='True'
    Input Text    ${DOCUMENT_ID_INPUT}    ${TD_DOCUMENT_ID}


#    #Co-author
#    Wait Until Keyword Succeeds    3x    1s    Click Element    ${CO-AUTHOR_SELECT}
#    Wait For The Element And Click    ${CO-AUTHOR_FIRST_OPTION}
#    Press Keys    None    ESC

User Adds General Details Without Co-Author
    Generate Unique Number
    Wait Until Element Is Visible    ${Name_input}
    Click Element    ${Name_input}
    Input Text    ${Name_input}    Pro-${UniqueNumberTest}
    VAR    ${TD_PROCEDURE_NAME}    Pro-${UniqueNumberTest}
    Set Test Variable    ${TD_PROCEDURE_NAME}
    Click Element    ${Name_input}
    Input Text    ${Material_Number}    MAT-${UniqueNumberTest}
    VAR    ${TD_MATERIAL_NUMBER}    MAT-${UniqueNumberTest}
    Set Test Variable    ${TD_MATERIAL_NUMBER}  

Save The Material Number
    [Documentation]    To Save The Material Number
    VAR    ${TD_SAME_MATERIAL_NUMBER}    ${TD_MATERIAL_NUMBER}
    Set Test Variable    ${TD_SAME_MATERIAL_NUMBER}

Enter The Same Material Number
    [Documentation]    To Enter The Same Material Number
     Input Text    ${Material_Number}    ${TD_SAME_MATERIAL_NUMBER}

Validate The Procedures Details In Preview
    [Arguments]    ${VERIFY_DUPLICATE_MAT_NUM}=False
    [Documentation]    To Validate The Procedures Details In Preview
    Wait Until Element Is Visible    ${PROCEDURE_NAME_DETAILS_PAGE}    ${Max_limit}
    ${PROCEDURE_NAME_FROM_STOREFRONT}=    Get Text    ${PROCEDURE_NAME_DETAILS_PAGE}
    ${PROCEDURE_NAME_FROM_STOREFRONT}=    Strip String   ${PROCEDURE_NAME_FROM_STOREFRONT}
    ${PROCEDURE_NAME_FROM_STOREFRONT}=    Split String   ${PROCEDURE_NAME_FROM_STOREFRONT}    ${SPACE}
    Check The Strings Are Equal    ${PROCEDURE_NAME_FROM_STOREFRONT[0]}    Pro-${UniqueNumberTest}
    
    ${END_LIMIT}=    Get Element Count    ${MATERIAL_NUMBER_REVIEW_PAGE}
    ${MATERIAL_NUMBER_FROM_STOREFRONT_LIST}=    Get Values In List For Validation    (${MATERIAL_NUMBER_REVIEW_PAGE})[INDEX]    1    ${END_LIMIT}
    Should Contain    ${MATERIAL_NUMBER_FROM_STOREFRONT_LIST}    MAT-${UniqueNumberTest}
    IF    ${VERIFY_DUPLICATE_MAT_NUM}==True
        Should Be True    len(${MATERIAL_NUMBER_FROM_STOREFRONT_LIST})==1
    END    
    ${DOCUMENT_ID_FROM_STOREFRONT}=    Get Text    ${DOCUMENT_ID_REVIEW_PAGE}
    Check The Strings Are Equal    ${DOCUMENT_ID_FROM_STOREFRONT}    DOCID-${UniqueNumberTest}

    Wait Until Element Is Not Visible    ${ZERO_TIME_PROCEDURE_CYCLE_REVIEW_PAGE}    ${Max_limit}
    ${PROCEDURE_CYCLE_COUNT_FROM_STOREFRONT}=    Get Text    ${PROCEDURE_CYCLE_REVIEW_PAGE}
    Check The Strings Are Equal    ${PROCEDURE_CYCLE_COUNT_FROM_STOREFRONT}    2h 15m 30s

    #Verify step search on procedure preview
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${STEP_INSTRUCTIONS_LIST[0]}
    Wait Until Element Is Visible    ${Instruction_Editor}
    Wait Until Element Contains    ${Instruction_Editor}    ${STEP_INSTRUCTIONS_LIST[0]}    timeout=60s
    ${STEPS_DISPLAYED}=    Get Element Count    ${Instruction_Editor}
    Should Be Equal As Strings    ${STEPS_DISPLAYED}    1
    Reload Page

Add The Cycle Time To The Procedure
    [Arguments]    ${Hour}=2    ${Minute}=15    ${Second}=30
    Wait Until Element Is Visible    ${Cycle_hour}  ${MaxTime}
    Click Element    ${Cycle_hour}
    Input Text    ${Cycle_hour}    ${Hour}
    Click Element    ${Cycle_minute}
    Input Text    ${Cycle_minute}    ${Minute}
    Click Element    ${Cycle_second}
    Input Text    ${Cycle_second}    ${Second}
    VAR    ${CYCLE_TIME}    ${Hour}h ${Minute}m ${Second}s
    Set Test Variable    ${CYCLE_TIME}

  
User adds PPE to the procedure
    [Arguments]    ${REMOVE_PPE}=False
    Click Element    ${Choose_button}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible    ${PPE_Search_Bar}    ${MaxTime}
    Page Should Contain Element      ${PPE_Search_Bar}

    ${PPE_LIST}=    Create List    Safety Glasses    Hard Hat    Gloves    Respirator
    Set Test Variable    ${PPE_LIST}


    FOR    ${ppe}    IN    @{PPE_LIST}
        Click Element    ${PPE_Search_Bar}
        Wait Until Element Is Visible    ${PPE_Search_Bar}    ${MaxTime}
        Clear Element Text    ${PPE_Search_Bar}
        Input Text    ${PPE_Search_Bar}    ${ppe}
        Wait Until Keyword Succeeds    5x    1s    Checkbox Should Not Be Selected    ${Searched_PPE}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${Searched_PPE}
    END

    Click Element    ${Add_PPE}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    
    #Remove PPE
    IF    ${REMOVE_PPE}
        FOR    ${ppe}    IN    @{PPE_LIST}
            Wait For The Element And Click    ${ADDED_PPE_DELETE_ICON}
        END
        Wait Until Element Is Not Visible    ${ADDED_PPE_DELETE_ICON}
    END
        


Add PPE To The Procedure And Save For Validation
    [Documentation]    To Add PPE To The Procedure And Save For Validation
    [Arguments]    ${END_LIMIT}=10
    Click Element    ${Choose_button}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${All_PPE}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_PPE}
    @{PPE_ADDED_TO_PROCEDURE}=    Get Values In List For Validation    ${STEP_PPES}    1    ${END_LIMIT}
    Set Test Variable    ${PPE_ADDED_TO_PROCEDURE}
    Click Element    ${Add_PPE}

Verify The Added PPE's In Procedure Preview
    [Documentation]    To Verify The Added PPE's In Procedure Preview
    ...    Bug Is logged
    Wait For The Element And Click    ${PPE_TAB}
    FOR    ${ITEM}    IN     @{PPE_ADDED_TO_PROCEDURE}
        ${LOCATOR}=    Replace String    ${ADDED_PPES_PREVIEW_PAGE}    PPE    ${ITEM}
        Wait Until Page Contains Element    ${LOCATOR}
    END

Verify The Added PPE's In Change Logs Preview
    Wait For The Element And Click    ${PPE_TAB}
    FOR    ${ITEM}    IN     @{PPE_LIST}
        ${LOCATOR}=    Replace String    ${ADDED_PPES_PREVIEW_PAGE}    PPE    ${ITEM}
        Page Should Contain Element    ${LOCATOR}
    END

Add Parts&Tools To Step
      [Documentation]    To Add Parts&Tools To Step
      [Arguments]    ${BILL_OF_ITEM}
      Wait For The Element And Click    ${PARTS_TOOLS_TAB}
      IF    '${BILL_OF_ITEM}'=='BOM'
          Wait For The Element And Click    ${STEP_BOM_TAB}
          Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
          Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
          Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
          ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
          ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
          @{BOM_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_BOM_TO_STEP}    2    ${MAX_LIMIT}
          Set Test Variable    ${BOM_ADDED_TO_STEP}
          Click Element    ${ADD_PARTS&TOOLS_TO_STEP}
      ELSE IF    '${BILL_OF_ITEM}'=='BOT'
          Wait For The Element And Click    ${STEP_BOT_TAB}
          Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
          Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
          Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
          ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
          ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
          @{BOT_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_BOT_TO_STEP}    2    ${MAX_LIMIT}
          Set Test Variable    ${BOT_ADDED_TO_STEP}
          Click Element    ${ADD_PARTS&TOOLS_TO_STEP}
      ELSE IF    '${BILL_OF_ITEM}'=='COM'
          Wait For The Element And Click    ${STEP_COM_TAB}
          Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
          Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
          Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
          ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
          ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
          @{COM_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_COM_TO_STEP}    2    ${MAX_LIMIT}
          Set Test Variable    ${COM_ADDED_TO_STEP}
          Click Element    ${ADD_PARTS&TOOLS_TO_STEP}
      END

Add COM To Step
    Wait For The Element And Click    ${PARTS_TOOLS_TAB}
    Wait For The Element And Click    ${STEP_COM_TAB}
    Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
    Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
    ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
    @{COM_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_BOT_TO_STEP}    2    ${MAX_LIMIT}
    Set Test Variable    ${COM_ADDED_TO_STEP}
    Click Element    ${ADD_PARTS&TOOLS_TO_STEP}   

Navigate To Exact BOM/BOT Page
    [Arguments]    ${BILL_OF_ITEM}
      Wait For The Element And Click    ${PARTS_TOOLS_TAB}
      IF    '${BILL_OF_ITEM}'=='BOM'
          Wait For The Element And Click    ${STEP_BOM_TAB}
          Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
      ELSE IF    '${BILL_OF_ITEM}'=='BOT'
          Wait For The Element And Click    ${STEP_BOT_TAB}
          Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
      END        

Click on Add New on Parts & Materials
    Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}      

Validate BOM/BOT In Procedure Preview mode
    [Documentation]    To Validate BOM/BOT In Procedure Preview mode
    #BOM

    Wait For The Element And Click    ${PREVIEW_PROCEDURE_BOM_TAB}
    Validate Parts And Tools In General Details    ${BOM_ADDED_TO_STEP}    ELEMENTS_LOCATOR=${BOM_IN_GENERAL_DETAILS}

    #BOT
    Wait For The Element And Click    ${PREVIEW_PROCEDURE_BOT_TAB}
    Validate Parts And Tools In General Details    ${BOT_ADDED_TO_STEP}    ELEMENTS_LOCATOR=${BOT_IN_GENERAL_DETAILS}

Validate Parts And Tools In General Details
    [Documentation]    To Validate Parts And Tools In General Details
    [Arguments]    ${VALIDATION_LIST}    ${ELEMENTS_LOCATOR}
    FOR    ${ITEM}    IN     @{VALIDATION_LIST}
        ${LOCATOR}=    Replace String    ${ELEMENTS_LOCATOR}    VALUE    ${ITEM}
        Wait Until Page Contains Element    ${LOCATOR}
    END

Add Steps
    [Documentation]    To Add Steps
    [Arguments]    ${NO_OF_STEPS}
    FOR    ${it}    IN RANGE    1   ${NO_OF_STEPS}+1
        Click Element    ${Step_Plus_button}
        Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
        Run Keyword And Ignore Error    Wait For The Element And Click    ${ATTACHMENT_TAB}
        Wait Until Element Is Visible    ${Plus_Attachment}
        Sleep    2s
        Wait For The Element And Click    ${Instruction_Editor}
        ${RANDOM_STATE}=    Generate Random Statement
        Append To List    ${STEP_INSTRUCTIONS_LIST}   ${RANDOM_STATE}
        Input Text    ${Instruction_Editor}    ${RANDOM_STATE}
    END

User Add Step To Procedure
    [Arguments]    ${STEPS_ARG}=1
    @{STEP_INSTRUCTIONS_LIST}    Create List
    Set Test Variable    ${STEP_INSTRUCTIONS_LIST}
    Add Steps    ${STEPS_ARG}

User adds multiple options
    Click Element    ${Add_option_hyperlink}

User add Options to Step
    [Documentation]    To User add Options to Step
    #Maximize Browser Window
    [Arguments]    ${NO_OF_OPTIONS}=1    ${DO_NOT_ADD_OPTION_TO_STEP}=False
    &{OPTIONS_DICT}=    Generate Random Options    ${NO_OF_OPTIONS}
    &{OPTIONS_VALIDATION_DICT}=    Create Dictionary
    Set Test Variable    ${OPTIONS_DICT}
    Set Test Variable    ${OPTIONS_VALIDATION_DICT}
    Click Element    ${Options_Tab}
    ${KEY_INDEX}=    Set Variable    1
    FOR    ${OPTION_TITLE}    IN    @{OPTIONS_DICT.keys()}
        Wait Until Keyword Succeeds    10x    2s    Click Element    ${Create_Btn}
        Wait Until Element Is Visible    ${Create_NewOption_Heading}    ${MaxTime}
        Click Element    ${INPUT_OPTION_TITLE}
        Input Text    ${INPUT_OPTION_TITLE}    ${OPTION_TITLE}
        ${ENUMERATED}=    ENUMERATE LIST    ${OPTIONS_DICT["${OPTION_TITLE}"]}
        FOR    ${ITEM}    IN    @{ENUMERATED}
            VAR    ${i}    ${ITEM[0]}
            VAR    ${OPTION}    ${ITEM[1]}
            Click Element    ${Add_option}
            ${i}=    Evaluate    str(${i})
            ${LOCATOR}=    Replace String    ${OPTION_INPUT}    INDEX    ${i}
            Click Element    ${LOCATOR}
            Input Text    ${LOCATOR}    ${OPTION}
        END
        Wait Until Element Is Enabled    ${Save_Option_Btn}
        Click Element    ${Save_Option_Btn}
        
        #Skip saving the user option
        IF    '${DO_NOT_ADD_OPTION_TO_STEP}'=='True'
            Return From Keyword
        END
        Scroll Element Into View    ${Add_option_icon}
        Wait Until Element Is Visible    ${Add_option_icon}     ${MaxTime}
        Click Element    ${Add_option_icon}
        ${Selected_value}=    Get value after selecting Option    ${KEY_INDEX}
        Set To Dictionary    ${OPTIONS_VALIDATION_DICT}    ${OPTION_TITLE}    ${Selected_value}
        Press Keys    None     ESC
        ${KEY_INDEX}=    Evaluate    ${KEY_INDEX}+1
    END

Verify The Options Of The Step
    [Documentation]    To Verify The Options Of The Step
    Wait For The Element And Click    ${FIRST_STEP}
    Wait For The Element And Click    ${Options_Tab}
    ${count}=    Get Element Count    ${OPTION_ADDED_IN_STEP}
    Should Be True    ${count} > 1
#    FOR    ${key}    IN    @{OPTIONS_VALIDATION_DICT.keys()}
#        ${value}=    Get From Dictionary    ${OPTIONS_VALIDATION_DICT}    ${key}
#        Log    Key: ${key}, Value: ${value}
#        ${LOCATOR}=    Replace String    ${OPTION_ADDED_IN_STEP}    OPTION_TITLE    ${key}
#        Wait Until Element Is Visible    ${LOCATOR}
#    END

Get Initial Option value
    ${initial_value}=    Get Text    ${Default_option}
    Should Be Equal As Strings    ${initial_value}    SELECT
    RETURN    ${initial_value}

Get value after selecting Option
    [Arguments]    ${OPTION_INDEX}
    ${TARGET_OPTION_INDEX}=    Evaluate    ${OPTION_INDEX}-1
    Log    ${OPTIONS_DICT}
    ${RETURN_VALUE}=    Get Option Value Selected    ${OPTIONS_DICT}    ${TARGET_OPTION_INDEX}
    Wait Until Element Is Visible    ${options_arrow_dropdown}
    Click Element    ${options_arrow_dropdown}
    Wait Until Keyword Succeeds    5x    1s   Click Element    (${select_Option_arrow_locator})[${OPTION_INDEX}]
#    Scroll Element And Enter Value    ${ENTER_CORRECT_OPTION}    ${RETURN_VALUE}
#    Wait Until Keyword Succeeds    2x    1s    Element Should Contain    ${CORRECT_SELECTED_OPTION}    ${RETURN_VALUE}
#    Wait For The Element And Click    ${CORRECT_SELECTED_OPTION}

#    ${OPTION_INDEX}=    Evaluate    str(${OPTION_INDEX})
#    ${select_Option_arrow}=    Replace String    ${select_Option_arrow_locator}    INDEX    ${OPTION_INDEX}
#    Click Element    ${select_Option_arrow}
    Press Keys    None     ESC
    RETURN    ${RETURN_VALUE}

Verify that user is able to see the added option to step
    Get value after selecting Option    1

User adds Preventive Troubleshooting to Step
    Click Element    ${Preventive_Troubleshooting_tab}
    Wait Until Page Contains Element    ${Add_Preventive_Troubleshoot}
    Click Element    ${Add_Preventive_Troubleshoot}
    Verify the UI of Preventive Troubleshooting Page
    Element Should Be Disabled    ${Save_PT_Btn}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR_PT_PossibleCause}
    Input Text    ${LOCATOR_PT_PossibleCause}   ${PT_POSSIBLE_CAUSE_INPUT}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR_PT_CORRECTIVE_ACTION}
    Input Text    ${LOCATOR_PT_CORRECTIVE_ACTION}    ${PT_CorrectiveAction_Input}
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${LOCATOR_PT_PREVENTIVE_ACTION}
    Input Text    ${LOCATOR_PT_PREVENTIVE_ACTION}    ${PT_PreventiveAction_Input}
    Verify that Author is not able to add a new troubleshooting entry without filling the mandatory field
    Scroll Element Into View    ${PT_Title}
    Click Element    ${PT_Title}
    Input Text    ${PT_Title}    ${Preventive_Troubleshooting_Title}
    Wait Until Element Is Enabled    ${Save_PT_Btn}
    Click Element    ${Save_PT_Btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Sleep    2s
    Wait Until Element Is Visible    ${Options_Tab}     ${MaxTime}

Update The Preventive Troubleshooting to Step
    [Documentation]    To Update The Preventive Troubleshooting to Step
    Click Element    ${FIRST_STEP}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Preventive_Troubleshooting_tab}
    Wait Until Element Is Visible    ${PREVENTIVE_TROUBLESHOOTING_EDIT_BUTTON}    ${Max_limit}
    Click Element    ${PREVENTIVE_TROUBLESHOOTING_EDIT_BUTTON}

    Wait For The Element And Click    ${PT_Title}
    ${TD_Preventive_Troubleshooting_Title}=    Generate Random Statement
    Set Test Variable    ${TD_Preventive_Troubleshooting_Title}
    Input Text    ${PT_Title}    ${TD_Preventive_Troubleshooting_Title}

    Click Element    ${LOCATOR_PT_PossibleCause}
    ${TD_PossibleCause_Input}=    Generate Random Statement
    Set Test Variable    ${TD_PossibleCause_Input}
    Input Text    ${LOCATOR_PT_PossibleCause}   ${TD_PossibleCause_Input}

    Click Element    ${LOCATOR_PT_CORRECTIVE_ACTION}
    ${TD_CorrectiveAction_Input}=    Generate Random Statement
    Set Test Variable    ${TD_CorrectiveAction_Input}
    Input Text    ${LOCATOR_PT_CORRECTIVE_ACTION}    ${TD_CorrectiveAction_Input}

    Click Element    ${LOCATOR_PT_PREVENTIVE_ACTION}
    ${TD_PreventiveAction_Input}=    Generate Random Statement
    Set Test Variable    ${TD_PreventiveAction_Input}
    Input Text    ${LOCATOR_PT_PREVENTIVE_ACTION}    ${TD_PreventiveAction_Input}


    Wait Until Element Is Enabled    ${Save_PT_Btn}
    Click Element    ${Save_PT_Btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Sleep    2s
    Wait Until Element Is Visible    ${Options_Tab}     ${MaxTime}

Validate The Updated Preventive Troubleshooting to Step
    [Documentation]    To Update The Preventive Troubleshooting to Step
    Click Element    ${FIRST_STEP}
    Wait Until Element Is Visible    ${Preventive_Troubleshooting_tab}    ${Max_limit}
    Click Element    ${Preventive_Troubleshooting_tab}
    Wait Until Element Is Visible    ${PREVENTIVE_TROUBLESHOOTING_EXPAND_BUTTON}    ${Max_limit}
    Click Element    ${PREVENTIVE_TROUBLESHOOTING_EXPAND_BUTTON}

    Element Text Should Be    ${SAVED_PREVENTIVE_TROUBLESHOOTING_TITLE}    ${TD_Preventive_Troubleshooting_Title}
    Element Text Should Be    ${SAVED_PREVENTIVE_TROUBLESHOOTING_POSSIBLE_CAUSE}   ${TD_PossibleCause_Input}
    Element Text Should Be    ${SAVED_PREVENTIVE_TROUBLESHOOTING_CORRECTIVE_ACTION}    ${TD_CorrectiveAction_Input}
    Element Text Should Be    ${SAVED_PREVENTIVE_TROUBLESHOOTING_PREVENTIVE_ACTION}    ${TD_PreventiveAction_Input}

Delete The Preventive Troubleshooting to Step
    [Documentation]    To Delete The Preventive Troubleshooting to Step
    Click Element    ${FIRST_STEP}
    Click Element    ${Preventive_Troubleshooting_tab}
    Wait Until Element Is Visible    ${PREVENTIVE_TROUBLESHOOTING_DELETE_BUTTON}    ${Max_limit}
    Click Element    ${PREVENTIVE_TROUBLESHOOTING_DELETE_BUTTON}


Verify The Preventive Troubleshooting Entry Deleted
    [Documentation]    To Verify The Preventive Troubleshooting Entry Deleted
    Click Element    ${FIRST_STEP}
    Click Element    ${Preventive_Troubleshooting_tab}
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${PREVENTIVE_TROUBLESHOOTING_DELETE_BUTTON}    ${Max_limit}
    Should Not Be True    ${STATUS}    Preventive Troubleshooting Entry Not Deleted



Verify the UI of Preventive Troubleshooting Page
    Wait Until Page Contains Element    ${Add_New_Label}
    Page Should Contain Element    ${PT_Title_Name}
    Page Should Contain Element    ${LOCATOR_PT_PossibleCause}
    Page Should Contain Element    ${LOCATOR_PT_CORRECTIVE_ACTION}
    Page Should Contain Element    ${LOCATOR_PT_PREVENTIVE_ACTION}
    Page Should Contain Element    ${Save_PT_Btn}
    Page Should Contain Element    ${Cancel_PT_Btn}

Verify that Author is not able to add a new troubleshooting entry without filling the mandatory field
    Sleep    2s
    Scroll Element Into View    ${Save_PT_Btn}
    Element Should Be Disabled    ${Save_PT_Btn}

User Adds User Input to Step
    [Arguments]    ${START_OF_STEP}=True
    Click Element    ${User_Input_tab}
    Wait Until Page Contains Element     ${Block_Name}    ${maxTime}
    IF    '${START_OF_STEP}'=='True'
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${USE_INPUT_IN_START_OF_JOB}
    END
    Click Element    ${Block_Name}
    Input Text    ${Block_Name}    ${User_Input_Title}
    Click Element    ${Block_Title}
    Input Text    ${Block_Title}    Planning Done?
    Click Element    ${User_Input_Type}
    Input Text    ${ENTER_OPTION}    Dropdown
    Click Element    ${FIRST_INPUT_TYPE}
    Click Element    ${Required}
    Scroll Element Into View    ${Option_Name}
    Click Element    ${Option_Name}
    Input Text    ${Option_Name}    Yes
    Click Element    ${Add_option_hyperlink}
    Scroll Element Into View    ${Option_Name2}
    Click Element    ${Option_Name2}
    Input Text    ${Option_Name2}     No
    &{USER_INPUT_DATA}=    Create Dictionary
    ...    Block_Name=${User_Input_Title}
    ...    Block_Title=Planning Done?
    ...    OPTION1=Yes
    ...    OPTION2=No
    ...    USERINPUT_TYPE=Dropdown

    Set Test Variable    ${USER_INPUT_DATA}



User is able to Save and Preview the User Input
    Wait Until Element Is Enabled    ${Save}
    Click Element    ${Save}
    Click Element    ${Preview}
    Sleep    2s
    Page Should Not Contain Element    ${USER_INPUT_SUBMIT_BUTTON}
    Click Element    ${Cancel_Preview}

User Saves Procedure as Draft
    Wait For The Element And Click    ${Save_as_Draft}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Element Is Enabled    ${Save_as_Draft}
    Wait Until Element Is Enabled    ${Publish Procedure}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${Breadcrumb link}
    Wait For The Page To Load

Verify that the Procedure is saved
    Wait Until Element Is Visible    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}     ${MaxTime}
    ${ProcedureTitle}=    Replace String   ${ProcedureName}  replace    Pro-${UniqueNumberTest}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${Procedure_Search_Bar}
    Input Text   ${Procedure_Search_Bar}    Pro-${UniqueNumberTest}
    Sleep    2s
    Wait Until Element Is Visible     ${ProcedureTitle}   ${MaxTime}
    RETURN    Pro-${UniqueNumberTest}

Verify that Draft state Procedure has been created
    Wait Until Element Is Visible    ${Status_Indicator}   ${MaxTime}
    Page Should Contain Element    ${Status_Indicator}
    ${State}=   Get Text    ${Status_Indicator}
    Should Be Equal As Strings    ${State}    Draft

Select The Release
    [Documentation]    To Select The Release
    [Arguments]    ${ARG}
    ${LOCATOR}=    Replace String    ${RELEASE_RADIO_BUTTON}    RELEASE_TYPE    ${ARG}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}

Click On Publish Button
    [Documentation]    To Click On Publish Button
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Publish Procedure}

User Publishes the Procedure
    [Arguments]    ${EXISTING_PROCEDURE}=False    ${IGNORE_VERSION}=False
    Log    This Keyword might fail as the publish button is disabled intermittently
    Wait For The Element And Click    ${GENERAL_DETAILS_SECTION}
    ${UniqueNumbertest}=    Generate Random String    4    [NUMBERS]
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Publish Procedure}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Element Is Visible    ${Publish_Label}   ${MaxTime}
    Sleep    3s
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    20s    2s    Click Element    ${CRCO_Number}
    Click Element    ${CRCO_Number}
    Input Text    ${CRCO_Number}  CRCO-${UniqueNumbertest}
    ${TD_RELEASE_TYPE}=    Get Release Type
    Select The Release    ${TD_RELEASE_TYPE}
    ${text}=    Get Text    ${Version_Value}
    IF    '${EXISTING_PROCEDURE}'=='True'
        TRY
            ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    ${TD_PROCEDURE_VERSION}
        EXCEPT
            ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    ${TD_VERSION}
        END
    ELSE
        ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    0
    END
    Set Test Variable    ${TD_VERSION}
    Set Test Variable    ${TD_RELEASE_TYPE}
    Run Keyword If    '${IGNORE_VERSION}'=='False'    Should Be Equal As Strings    ${text}    ${TD_VERSION}

User Publishes the Updated Procedure
    [Arguments]    ${EXISTING_PROCEDURE}=False
    ${UniqueNumbertest}=    Generate Random String    4    [NUMBERS]
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Publish Procedure}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Element Is Visible    ${Publish_Label}   ${MaxTime}
    Sleep    3s
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    20s    2s    Click Element    ${CRCO_Number}
    Click Element    ${CRCO_Number}
    Input Text    ${CRCO_Number}  CRCO-${UniqueNumbertest}
    ${TD_RELEASE_TYPE}=    Get Release Type
    Select The Release    ${TD_RELEASE_TYPE}
    ${text}=    Get Text    ${Version_Value}
    IF    '${EXISTING_PROCEDURE}'=='True'
        TRY
            ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    ${TD_PROCEDURE_VERSION}
        EXCEPT
            ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    ${TD_VERSION}
        END
        Set Test Variable    ${TD_VERSION}
    ELSE
        ${TD_VERSION}=    Get Current Release Version    ${TD_RELEASE_TYPE}    0
        Set Test Variable    ${TD_VERSION}
        Set Test Variable    ${TD_RELEASE_TYPE}
    END

Validate The Updated Version Details On The Preview Page
    [Documentation]    To Validate The Updated Version Details On The Preview Page
    ${TD_VERSION}=    Evaluate    str(${TD_VERSION})
    ${LOCATOR}=    Replace String    ${PROCEDURE_VERSION_PREVIEW_PAGE}    PROCEDURE_VERSION    ${TD_VERSION}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${LOCATOR}

User Adds Release Notes
    [Arguments]    ${VALIDATE_PENDING_APPROVAL_ERROR_MESSAGE}=False       ${VERIFY_CANCEL_BUTTON}=False
    Scroll Element And Enter Value    ${Release_Note}    Added a thing or two
    Wait Until Element Is Enabled    ${Publish_button}  ${MaxTime}
    IF    ${VERIFY_CANCEL_BUTTON}
        Wait For The Element And Click    ${CANCEL_PUBLISH_PROCEDURE_BUTTON}
        Return From Keyword
    END
    ${STATUS}=    Run Keyword And Return Status    Click Element    ${Publish_button}
    IF    not $STATUS
        Scroll Element Into View    ${Publish_button}
        Sleep   2s
        Click Element    ${Publish_button}
    END
    IF    '${VALIDATE_PENDING_APPROVAL_ERROR_MESSAGE}'=='True'
        Capture Page Screenshot
        Run Keyword And Ignore Error    Wait Until Page Contains    A version of procedure is already in approval pending state, please take necessary action.
        Capture Page Screenshot
    END
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Sleep     2s
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}

Empty List
    [Documentation]    To Empty List
    [Arguments]    ${LIST_NAME}
    ${${LIST_NAME}}=    Create List
    Set Test Variable    ${${LIST_NAME}}


Add Item To List
    [Documentation]    To Add Item To List
    [Arguments]    ${ITEM}=${TD_PROCEDURE_NAME}   ${VAR_NAME}=PROCEDURE_LIST
     ${list}=    Get Variable Value    ${${VAR_NAME}}
     TRY
         IF    '${list}'=='None'
             ${list}=    Create List
         END
     EXCEPT
         Log    List Already Created
     END
    Append To List    ${list}    ${ITEM}
    Set Test Variable    ${${VAR_NAME}}    ${list}

Verify that Procedure is Published
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Run Keyword And Ignore Error     Page Should Contain Element    ${Status_Indicator}
    ${State}=   Get Text    ${Status_Indicator}
    Should Be Equal As Strings    ${State}     Published

Verify that Author is able to define a troubleshooting entry with all necessary fields
    Wait Until Element Is Visible    ${Add_Preventive_Troubleshoot}
    Page Should Contain Element    ${Added_PT_Entry}

Verify that Added PPE becomes visible on General Details tab
    [Documentation]    Verifies that all PPE items added to the procedure are visible on the page
    [Arguments]    @{PPE_LIST}

    FOR    ${ppe_item}    IN    @{PPE_LIST}
        Log To Console    Checking visibility for PPE: ${ppe_item}
        Wait Until Keyword Succeeds    10s    2s    Page Should Contain    ${ppe_item}
    END


User clicks on delete icon
    [Documentation]    Deletes all PPE items that were previously added to the procedure
    [Arguments]    @{PPE_LIST}

    FOR    ${ppe_item}    IN    @{PPE_LIST}

        ${delete_locator}=    Set Variable    //div[@class='ppe-item' and .//text()[normalize-space()='${ppe_item}']]//div[contains(@class,'item-action')]
       Wait Until Keyword Succeeds    10s    2s    Wait Until Element Is Visible    ${delete_locator}
        Click Element    ${delete_locator}
        Sleep    1s    # small wait for DOM update
    END

Verify that added PPE's gets removed from the UI
    Page Should Contain Element    ${No_PPE_List}

Verify that user is able to see icons of attachments
    Wait Until Element Is Visible    ${video_thumbnail}    ${Max_limit}
    Wait Until Element Is Visible    ${img_thumbnail}    ${Max_limit}

User clicks on cross icon
    Wait Until Element Is Visible    ${img_thumbnail}   ${MaxTime}
    Click Element    ${remove_attachment}
    Click Element    ${remove_attachment}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${remove_attachment}

Verify that added attachments get removed from the UI
    Sleep    2s
    Page Should Not Contain Element    ${thumbnail_attachment}

User clicks on Cancel Button
    Click Element    ${Cancel_Procedure}

Verify that no procedure is created after clicking on the cancel button
    Wait Until Element Is Not Visible    ${LoadingBar}      ${maxTime}
    Wait Until Element Is Visible    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}

User Navigates to User Input Page
    Wait Until Page Contains Element     ${User_Input_tab}    ${maxTime}
    Click Element    ${User_Input_tab}
    Wait Until Page Contains Element     ${Block_Name}    ${maxTime}

Verify the UI of User Input Page
    Page Should Contain Element    ${StepName}
    Page Should Contain Element    ${CycleTime}
    Wait Until Page Contains Element     ${Block_Name}    ${maxTime}
    Page Should Contain Element    ${Block_Title}
    Page Should Contain Element    ${Hint}
    Page Should Contain Element    ${User_Input_Type}
    Page Should Contain Element    ${Show_step_start}
    Page Should Contain Element    ${Add_Block}
    Page Should Contain Element    ${Preview}
    Page Should Contain Element    ${Save}
    Page Should Contain Element    ${PlusIcon}
    Page Should Contain Element    ${Required}

User Click Add Block and Verify that New User Input Block Gets Added
    ${initial_count}=    Get Element Count    ${UserInput_Block}
    Click Element    ${Add_Block}
    ${new_count}=    Get Element Count    ${UserInput_Block}
    ${expected_count}=    Evaluate    ${initial_count} + 1
    Should Be Equal As Integers    ${new_count}    ${expected_count}

User Click plus icon and Verify that New User Input Box Gets Added
    ${initial_count}=    Get Element Count    ${UserInput_Box}
    Click Element    ${PlusIcon}
    ${new_count}=    Get Element Count    ${UserInput_Box}
    ${expected_count}=    Evaluate    ${initial_count} + 1
    Should Be Equal As Integers    ${new_count}    ${expected_count}

User Add details for User Input
    Click Element    ${Block_Name}
    Input Text    ${Block_Name}    Planning
    Click Element    ${Block_Title}
    Input Text    ${Block_Title}    Planning Done?
    Click Element    ${User_Input_Type}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Dropdown_type}
    Click Element    ${Required}
    Click Element    ${Option_Name}
    Input Text    ${Option_Name}    Yes
    Click Element    ${Add_option_hyperlink}
    Scroll Element Into View    ${Option_Name2}
    Click Element    ${Option_Name2}
    Input Text    ${Option_Name2}    No


Click On Add Option Hyperlink and Verify User can Add Any Number Of Options using "+Add options"
    ${initial_count}=    Get Element Count    ${Option_Name}
    Click Element    ${Add_option_hyperlink}
    ${final_count}=    Get Element Count    ${Option_Name}
    ${expected_count}=    Evaluate    ${initial_count} + 1
    Should Be Equal As Integers    ${final_count}    ${expected_count}
    Element should be Visible   ${Add_option_hyperlink}


User Click on Delete icon and Verify the added options gets removed
    ${initial_count}=    Get Element Count    ${Option_Name}
    Scroll Element Into View    ${OptionDelete_icon}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${OptionDelete_icon}
    ${new_count}=    Get Element Count    ${Option_Name}
    ${expected_count}=    Evaluate    ${initial_count} - 1
    Should Be Equal As Integers    ${new_count}    ${expected_count}

User Skips Mandatory field
    Click Element   ${Block_Title}
    Click Element   ${Hint}
    Input Text    ${Hint}    Testing

Verify that User cannot proceed with missing mandatory field
    Element Should Be Visible   ${Error_message}
    Verify that Save button remains disabled

Verify that Save button remains disabled
    Element Should Be Disabled   ${Save}

Verify that "Delete Block" becomes enabled
    Element Should Be Enabled  ${Delete_Block}

User Clicks Delete Block button
    Click Element   ${Delete_Block}

User Clicks Delete Block button and Verify that User Input Block Gets Deleted
    ${initial_count}=    Get Element Count    ${UserInput_Block}
    @{elements}=    Get WebElements    ${Delete_Block}
    Click Element    ${elements[0]}
    ${new_count}=    Get Element Count    ${UserInput_Block}
    ${expected_count}=    Evaluate    ${initial_count} - 1
    Should Be Equal As Integers    ${new_count}    ${expected_count}

User Clicks On Cancel Button on Publish Screen
    Click Element    ${Cancel_Publish_button}
    Wait Until Element Is Not Visible    ${Publish_Label}

#User Clicks On Cross Icon on Publish Screen
#    Click Element    ${Publish Procedure}
#    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
#    Wait Until Element Is Visible    ${Publish_Label}   ${MaxTime}
#    Click Element    ${Cross_Publish_Window}
#    Wait Until Element Is Not Visible    ${Publish_Label}   ${MaxTime}

Verify The Visibility Of Step Name
    ${StepName}=     Get Text    ${StepName_Field}
    Should Not Be Empty    ${StepName}

Verify publish popup is closed on clicking cross icon
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    Click Element    ${Publish Procedure}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Element Is Visible    ${Publish_Label}   ${MaxTime}
    Click Element    ${Cross_Publish_Window}
    Wait Until Element Is Not Visible    ${Publish_Label}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Publish Procedure}    
    Wait Until Element Is Visible    ${Cross_PPE}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Cross_PPE}
    Wait Until Element Is Not Visible    ${Publish_Label}  ${MaxTime}

Verify that Pop-Up Window Closes And User Navigate Back To Procedure Page
    Wait Until Element Is Visible    ${Breadcrumb link}     ${MaxTime}

User Enter Alphanumeric CRCO number
    Click Element    ${CRCO_Number}
    Input Text    ${CRCO_Number}   ${CRCO_Input}

Verify That User Gets A Validation Message for Exceeding character length
    Element Should Be Visible    ${CRCO_Error}
#    Verify That User Is Not Able To Add Further Input
#
#Verify That User Is Not Able To Add Further Input
#    ${CRCO_Number}=    Get Text    ${CRCO_Number}
#    Should Be Equal As Strings    ${CRCO_Number}    ${CRCO_Input}

User adds Image attachments to the procedure
    [Arguments]    ${VERIFY_CROSS_ICON}=False
    Wait Until Element Is Visible    ${Plus_Attachment}     ${MaxTime}
    Click Element    ${Plus_Attachment}
    Wait Until Element Is Visible    ${Image_Attachment}    ${MaxTime}
    Click Element    ${Image_Attachment}
    Upload The File     ${Image_File}
    IF    ${VERIFY_CROSS_ICON}
        Wait Until Page Contains Element    ${ADDED_IMAGE_DELETE_ICON}
        Mouse Over    ${ADDED_IMAGE_DELETE_ICON}
        Wait For The Element And Click    ${ADDED_IMAGE_DELETE_ICON}
        Wait Until Element Is Not Visible    ${ADDED_IMAGE_DELETE_ICON}
        Upload The File     ${Image_File}
    END
    Wait Until Element Is Visible    ${Done_Btn}
    Click Element    ${Done_Btn}

User adds Video attachments to the procedure
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${Plus_Attachment}     ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Plus_Attachment}
    Wait Until Element Is Visible    ${Video_Attachment}    ${MaxTime}
    Click Element    ${Video_Attachment}
    Upload The File    ${MOV_File}
    Wait Until Element Is Visible    ${Done_Btn}
    Click Element    ${Done_Btn}

User adds PDF attachments to the procedure
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${Plus_Attachment}     ${MaxTime}
    Sleep    2s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Plus_Attachment}
    Wait Until Element Is Visible    ${PDF_Attachment}    ${MaxTime}
    Click Element    ${PDF_Attachment}
    Upload The File   ${File}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${Done_Btn}
    Click Element    ${Done_Btn}
    Wait Until Element Is Visible    ${EXPAND_ATTACHMENTS_PROCEDURE_DETAILS_PAGE}    ${Max_limit}
    Sleep    3s    #Wait for the pdf to upload properly


Upload The File
    [Arguments]     ${FileName}
    Wait Until Element Is Enabled    ${Attachment_File_Input}     ${MaxTime}
    ${Normalize_Path_Upload_Pdf}    Normalize Path    ${Upload_File_Path}${/}${FileName}
    Choose File    ${Attachment_File_Input}    ${Normalize_Path_Upload_Pdf}

Verify That Version Gets Updated
    Click Element    ${major_version}
    ${text}=    Get Text    ${Version_Value}
    Should Be Equal As Strings    ${text}    1.0

User Adds Another Entry For Preventive TroubleShooting Entry
    Click Element    ${Add_Another_Preventive_Troubleshoot}
    Wait Until Element Is Visible    ${LOCATOR_PT_PossibleCause}
    Click Element    ${LOCATOR_PT_PossibleCause}
    Input Text    ${LOCATOR_PT_PossibleCause}   ${PT_POSSIBLE_CAUSE_INPUT}
    Click Element    ${LOCATOR_PT_CORRECTIVE_ACTION}
    Input Text    ${LOCATOR_PT_CORRECTIVE_ACTION}    ${PT_CorrectiveAction_Input}
    Click Element    ${LOCATOR_PT_PREVENTIVE_ACTION}
    Input Text    ${LOCATOR_PT_PREVENTIVE_ACTION}    ${PT_PreventiveAction_Input}
    Click Element    ${PT_Title}
    Input Text    ${PT_Title}    ${Preventive_Troubleshooting_Title2}
    Wait Until Element Is Enabled    ${Save_PT_Btn}
    Click Element    ${Save_PT_Btn}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Sleep    2s
    Wait Until Element Is Visible    ${Add_Preventive_Troubleshoot}    ${MaxTime}

Verify publish popup is closed on clicking cancel button
    ${UniqueNumbertest}=    Generate Random String    4    [NUMBERS]
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    Click Element    ${Publish Procedure}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Element Is Visible    ${Publish_Label}   ${MaxTime}
    Sleep    3s
    Click Element    ${CRCO_Number}
    Input Text    ${CRCO_Number}  CRCO-${UniqueNumbertest}
    Click Element    ${minor_version}
    Click Element    ${Release_Note}
    Input Text    ${Release_Note}    Added a thing or two
    Wait Until Element Is Enabled    ${Publish_button}  ${MaxTime}
    Click Element    ${Publish_Cancel_button}
    Wait Until Element Is Visible    ${Publish Procedure}   ${MaxTime}
    sleep    2s
    Page Should Not Contain Element    ${Publish_Label}
    Page Should Contain Element    ${Publish Procedure}

Delete the added PPE
    Wait Until Element Is Visible    ${Delete_PPE}    ${MaxTime}
    ${elements}=    Get WebElements    ${Delete_PPE}
    log    ${elements}
    ${count}=       Get Length         ${elements}
    FOR    ${i}    IN RANGE    ${count}
    Click Element    ${Delete_PPE}
    END
    Wait Until Element Is Visible    ${No_PPE_Message}    ${MaxTime}
    Element Should Be Visible        ${No_PPE_Message}

Verify no PPE are displayed when creating new procedure
    Wait Until Element Is Visible    ${Choose_button}    ${MaxTime}
    Wait Until Element Is Visible    ${No_PPE_Message}    ${MaxTime}
    Element Should Be Visible        ${No_PPE_Message}

Verify functionality of cross icon on instructions
    Wait Until Element Is Visible    ${close_instructions}    ${MaxTime}
    Click Element    ${close_instructions}
    Wait Until Element Is Not Visible    ${close_instructions}    ${MaxTime}
    Page Should Not Contain Element    ${close_instructions}
    Page Should Not Contain Element    ${Instruction_Editor}

User searches for predefined symptom
#    ${PT_Search_Input}  Replace String  ${PT_EntryName}    replace     ${Preventive_Troubleshooting_Title2}
    Click Element   ${PT_SearchBox}
    Input Text   ${PT_SearchBox}    ${Preventive_Troubleshooting_Title2}

Collapse General details section
    Wait Until Element Is Visible    ${details_collapse_btn}    ${MaxTime}
    Click Element    ${details_collapse_btn}
    Wait Until Element Is Not Visible    ${Step_Plus_button}    ${MaxTime}
    Page Should Not Contain Element    ${Step_Plus_button}

Verify that the matching troubleshooting entries are displayed
    Wait Until Element Is Visible    ${SearchedEntry}
    Page Should Contain    ${Preventive_Troubleshooting_Title2}
    Click Element    ${ArrowKey}
    Wait Until Element Is Visible    ${PT_PossibleInput}   ${MaxTime}
    Page Should Contain    ${PT_POSSIBLE_CAUSE_INPUT}


Verify The User Is Able To Delete The Troubleshooting Entry Without Refreshing The Page
    [Documentation]    To Verify The User Is Able To Delete The Troubleshooting Entry Without Refreshing The Page
    Wait For The Element And Click    ${DELETE_PREVENTIVE_TROUBLESHOOT_ENTRY_ICON}
    Wait Until Page Contains    Troubleshooting deleted successfully
    Capture Page Screenshot    
    
    Wait For The Element And Click    ${DELETE_PREVENTIVE_TROUBLESHOOT_ENTRY_ICON}
    Wait Until Page Contains    Troubleshooting deleted successfully
    Wait Until Page Does Not Contain Element    ${PT_PossibleInput}
    
Add new step from collapsed details section
    Wait Until Element Is Visible    ${details_collapse_btn}    ${MaxTime}
    Click Element    ${details_collapse_btn}
    Wait Until Element Is Visible    ${details_collapse_btn}    ${MaxTime}
    Page Should Contain Element    ${Step_Plus_button}

User Click On Preview Option
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${SearchedProcedure}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Page Contains Element    ${Preview_Title}    ${MaxTime}


Verify That User Lands On Preview Page
     [Arguments]    ${ProcedureText}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${Preview_Title}    ${MaxTime}
    ${PreviewTitle}=    Get Text    ${Preview_Title}
    ${parts}=    Split String    ${PreviewTitle}    (
    ${before_bracket}=    Set Variable    ${parts}[0]
    ${trimmed}=    Strip String    ${before_bracket}
    Log    Preview Title before bracket: ${trimmed}
    Should Be Equal As Strings    ${ProcedureText}    ${trimmed}
    Click Element    ${InstructionLibrary_Icon}
    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}

User Click On Preventive TroubleShoot Icon
    [Arguments]    ${CALLED_FROM_CHANGE_LOGS}=False
    Run Keyword If    not ${CALLED_FROM_CHANGE_LOGS}    Wait For The Element And Click    ${PROCEDURE_PREVIEW_THREE_DOTS}
    Wait Until Element Is Visible    ${Troubleshoot_Icon}     ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Troubleshoot_Icon}
    Wait Until Element Is Visible    ${Modal_Header}

Verify added Preventive Troubleshooting are visible in Preview mode
    Sleep    3s
    Wait Until Element Is Visible    ${PT_IssueBox}     ${MaxTime}
    Page Should Contain    ${Preventive_Troubleshooting_Title}
    Press Keys    None     ESC
    Click Element    ${InstructionLibrary_Icon}

User Click On User Input Icon
    Wait For The Element And Click    ${User_Input_Icon}
    Wait Until Element Is Visible    ${Modal_Header}

Verify added User Inputs is visible in Preview mode
#    Wait For The Element And Click    ${PROCEDURE_PREVIEW_BOM}
#    Verify Pagination in BOM page of Job orders
#    Wait For The Element And Click    ${PROCEDURE_PREVIEW_BOT}
#    Verify Pagination in BOM page of Job orders
    Wait For The Page To Load
    Page Should Contain    ${User_Input_Title}
    Press Keys    None     ESC
    Click Element    ${InstructionLibrary_Icon}


Navigate to Procedures page
    Wait Until Element Is Not Visible    //div[@class='container overlay ng-star-inserted']   ${MaxTime}
    Wait Until Element Is Visible    ${Procedure_menu}    ${maxTime}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Page Does Not Contain Element    ${LoadingBar}    ${MaxTime}
    Click Element    ${Procedure_menu}
    Wait Until Element Is Visible    ${Procedure_heading}    ${maxTime}
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}


Verify that New User Input Block Gets Added
    Page Should Contain Element    ${UserInput_Block2}
    Get Element Count

Verify The Current Logged In Author
    [Documentation]    To Verify The Current Logged In Author
    [Arguments]    ${Flag}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_PROCEDURE_NAME}
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Run Keyword If    '${Flag}'=='AccessNewProcedure'    Element Should Be Visible    ${FIRST_RECORD}
    Run Keyword If    '${Flag}'=='NoAccessNewProcedure'    Wait Until Element Is Visible    ${NO_PROCEDURE_RECORD}
    Run Keyword If    '${Flag}'=='NoAccessNewProcedure'    Element Should Be Visible       ${NO_PROCEDURE_RECORD}


#    [Documentation]    To Verify The Current Logged In Author
#    [Arguments]    ${Flag}
#    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_PROCEDURE_NAME}
#
#    Run Keyword If    '${Flag}'=='AccessNewProcedure'    Element Should Be Visible    ${FIRST_RECORD}
#    Run Keyword If    '${Flag}'=='NoAccessNewProcedure'    Element Should Be Visible    ${NO_PROCEDURE_RECORD}

Search The Procedure On Procedure List Page
    [Documentation]    To Search The Procedure On Procedure List Page
    [Arguments]    ${CUSTOM_PROCEDURE_NAME}
    IF    '${CUSTOM_PROCEDURE_NAME}'!='False'
        Scroll Element And Enter Value    ${INPUT_SEARCH}    ${CUSTOM_PROCEDURE_NAME}
    ELSE
        Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_PROCEDURE_NAME}
    END
    Wait For The Page To Load


Navigate To Procedure Details Page
    [Documentation]    To Navigate To Procedure Details Page
    [Arguments]    ${CUSTOM_PROCEDURE_NAME}=False
    Search The Procedure On Procedure List Page    ${CUSTOM_PROCEDURE_NAME}
    Wait Until Element Is Visible    ${FIRST_PROCEDURE}
    IF    '${CUSTOM_PROCEDURE_NAME}'!='False'
        Element Should Contain    ${FIRST_PROCEDURE}    ${CUSTOM_PROCEDURE_NAME}
    ELSE
        Element Should Contain    ${FIRST_PROCEDURE}    ${TD_PROCEDURE_NAME}
    END
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${FIRST_PROCEDURE}
    Wait For The Page To Load
    Wait Until Page Does Not Contain Element    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}    ${Max_limit}


Click On Edit Button On Procedure Details Page
    [Documentation]    To Click On Edit Button On Procedure Details Page
    Wait For The Element And Click    ${EDIT_PROCEDURE}
    Wait For The Page To Load

Verify The User Is Able To Remove Added PPE
    [Documentation]    To Verify The User Is Able To Remove Added PPE
    Wait For The Element And Click    ${EDIT_PROCEDURE}
    Wait For The Page To Load

#
#Click On Procedure Publish Button
#    [Documentation]    To Click On Procedure Publish Button
#    Wait Until Element Is Enabled    ${PUBLISH_PROCEDURE}  ${MaxTime}
#    Click Element    ${PUBLISH_PROCEDURE}
#    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}

Verify The Newly Created Procedure
    [Documentation]    To Verify The Newly Created Procedure
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_PROCEDURE_NAME}
    Wait Until Element Is Visible    ${FIRST_PROCEDURE}
    ${PROCEDURE_SEARCHED}=    Get Text    ${FIRST_PROCEDURE}
    Check The Strings Are Equal    ${PROCEDURE_SEARCHED}   Pro-${UniqueNumberTest}

Validate The Correct Steps Count
    [Documentation]    To Validate The Correct Steps Count
    ${STEPS_COUNT}=    Get Text    ${STEPS_IN_PROCEDURES_PREVIEW}
    @{SAVED_PROCEDURE_STEP_INSTRUCTIONS__FROM_STOREFRONT}=    Get Values In List For Validation    ${SAVED_PROCEDURE_STEP_INSTRUCTIONS}    1    ${STEPS_COUNT}
    Lists Should Be Equal    ${SAVED_PROCEDURE_STEP_INSTRUCTIONS__FROM_STOREFRONT}    ${STEP_INSTRUCTIONS_LIST}
    Set Test Variable    ${SAVED_PROCEDURE_STEP_INSTRUCTIONS__FROM_STOREFRONT}
    Check The Strings Are Equal    ${STEPS_COUNT}    4


Validate The Steps Are Visible and Scrollable
    [Documentation]    To Validate The Steps Are Visible and Scrollable
    FOR    ${ITEM}    IN    @{SAVED_PROCEDURE_STEP_INSTRUCTIONS__FROM_STOREFRONT}
        ${LOCATOR}=    Replace String    ${STEP_INSTRUCTION_EDITOR}    PROCEDURE_INSTRUCTION    ${ITEM}
        Wait Until Element Is Visible    ${LOCATOR}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
        Repeat Keyword    10x    Press Keys    None    ARROW_DOWN
    END
    Capture Page Screenshot



Get The First Procedure Details
    [Documentation]    To Get The First Procedure Details
    Wait Until Element Is Visible    ${FIRST_PROCEDURE}    ${Max_limit}
    ${TD_PROCEDURE_NAME}=    Get Text    ${FIRST_PROCEDURE}
    Set Test Variable    ${TD_PROCEDURE_NAME}

    ${TD_PROCEDURE_VERSION}=    Get Text    ${FIRST_PROCEDURE_VERSION}
    ${TEMP}    Strip String    ${TD_PROCEDURE_VERSION}
    ${TEMP}    Split String    ${TEMP}    ${SPACE}

    Set Test Variable    ${TD_PROCEDURE_VERSION}    ${TEMP[1]}

Verify The Procedure Name And Version On Preview Page
    [Documentation]    To Verify The Procedure Name And Version On Preview Page
    ${TEMP}=    Get Procedure Name Version    ${TD_PROCEDURE_NAME}    ${TD_PROCEDURE_VERSION}
    ${PROCEDURE_NAME_VERSION}=    Replace String    ${PROCEDURE_NAME_REVIEW_PAGE}    NAME_VERSION    ${TEMP}
    Wait Until Element Is Visible    ${PROCEDURE_NAME_VERSION}

Click On Procedure Link In Breadcrumb
    [Documentation]    To Click On Procedure Link In Breadcrumb
    Wait For The Element And Click    ${LINK_PROCEDURE_PAGE}
    Wait For The Page To Load


Verify User Lands On The Procedure List Page
    [Documentation]    To Verify User Lands On The Procedure List Page
    Wait Until Location Is    ${PROCEDURE_LIST_PAGE}    ${Max_limit}

Delete The New Added Block In User Input
    [Documentation]    To Delete The New Added Block In User Input
    Wait Until Element Is Visible    ${DELETE_BLOCK_FROM_USER_INPUT}
    Click Element    ${DELETE_BLOCK_FROM_USER_INPUT}
    Click Element    ${Save}


Verify The User Input Block Is Deleted
    [Documentation]    To Verify The User Input Block Is Deleted
    Wait For The Element And Click    ${FIRST_STEP}
    Wait For The Element And Click    ${User_Input_tab}
    Wait Until Element Is Visible    ${Save}
    Element Should Not Be Visible    ${DELETE_BLOCK_FROM_USER_INPUT}
    Page Should Not Contain Element    ${DELETE_BLOCK_FROM_USER_INPUT}

Verify The Cancel Button Functionality In The Step Instruction
    [Documentation]    To Verify The Cancel Button Functionality In The Step Instruction
    Element Should Be Visible    ${Instruction_Editor}

    Wait For The Element And Click    ${CLOSE_STEP_INSTRUCTION}
    Element Should Not Be Visible    ${Instruction_Editor}

    Wait For The Element And Click    ${Instruction_Icon}
    Wait Until Keyword Succeeds    5x    1s    Element Should Be Visible    ${Instruction_Editor}

Verify That User Is Able To See Attachments In Grid View
    [Documentation]    To Verify That User Is Able To See Attachments In Grid View
    Wait For The Element And Click    ${GRID_ICON}
    Wait Until Element Is Visible    ${GRID_VIEW_IMAGE_ATTACHMENT}    ${Max_limit}
    Scroll Element Into View    ${GRID_VIEW_VIDEO_ATTACHMENT}
    Wait Until Element Is Visible    ${GRID_VIEW_VIDEO_ATTACHMENT}

Select The Novice Only Checkbox
    [Documentation]    To Select The Novice Only Checkbox
    Select Checkbox    ${NOVICE_CHECKBOX}
    # To let the checkbox select
    Sleep    3s

Verify The Novice Only Checkbox Should be Selected On Procedure Review Page
    [Documentation]    To Verify The Novice Only Checkbox Should be Selected On Procedure Review Page
    Wait For The Page To Load
    Checkbox Should Be Selected    ${NOVICE_CHECKBOX}
    Element Should Be Disabled    ${NOVICE_CHECKBOX}

Create Steps Group
    [Documentation]    To Create Steps Group
#    Wait Until Keyword Succeeds   5x    1s    Click Element    ${FIRST_STEP}
#    Element Should Be Focused    ${FIRST_STEP}
    ${CLASS_LIST}=    Get Element Attribute    ${FIRST_STEP_SELECTED}    class
    ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}
    ${CHECK}=    Run Keyword And Return Status    List Should Contain Value    ${CLASS_LIST}    selected
    Run Keyword If    not ${CHECK}    Click Element    ${FIRST_STEP}
    Open Context Menu    ${FIRST_STEP}
    Wait Until Element Is Visible    ${STEPS_ADDED_IN_GROUP}
    Wait For The Element And Click    ${CREATE_STEPS_GROUP}
    Press Keys    None    ENTER


Verify The UI Of Add New Procedure Page
    [Documentation]    To Verify The UI Of Add New Procedure Page
    Wait Until Element Is Visible    ${Name_input}    ${MaxTime}
    Wait Until Element Is Visible    ${Material_Number}
    Wait Until Element Is Visible    ${DOCUMENT_ID_INPUT}
    Wait Until Element Is Visible    ${Choose_button}
    Wait Until Element Is Visible    ${Step_Plus_button}
    Click Element     ${Step_Plus_button}
    Click Element    ${Preventive_Troubleshooting_tab}
    Wait Until Page Contains Element    ${Add_Preventive_Troubleshoot}
    Wait Until Page Contains Element    ${Options_Tab}



Verify The Create Steps Group Created
    [Documentation]    To Verify The Create Steps Group Crated
    Wait Until Element Is Visible    ${FIRST_STEPS_GROUP}    ${Max_limit}
    Element Should Not Be Visible    ${STEP_ADDED_IN_GROUP}
    Wait For The Element And Click    ${EXPAND_STEPS}
    Wait Until Element Is Visible    ${STEP_ADDED_IN_GROUP}
    
    #Removed PPE
    Page Should Not Contain Element    ${ADDED_PPE_DELETE_ICON}




Edit The Step Group Name
    [Documentation]    To Edit The Step Group Name
    Mouse Over    ${FIRST_STEPS_GROUP}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${EDIT_STEP_GROUP_ICON}
    ${TEMP}=    Generate Random String
    Set Test Variable    ${TD_STEP_GROUP_NAME}    GroupName-${TEMP}
    Scroll Element And Enter Value    ${INPUT_GROUP_NAME}    ${TD_STEP_GROUP_NAME}

Validate The Correct Step Group Name Is Updated
    [Documentation]    To Validate The Correct Step Group Name Is Updated
    ${GROUP_NAME_FROM_STOREFRONT}=    Replace String    ${UPDATED_STEP_GROUP}    GROUP_NAME    ${TD_STEP_GROUP_NAME}
    Wait Until Element Is Visible    ${GROUP_NAME_FROM_STOREFRONT}


Ungroup The Step Group
    [Documentation]    To Ungroup The Step Group

    # To Select the step and ungroup
    ${CLASS_LIST}=    Get Element Attribute    ${FIRST_STEPS_GROUP}    class
    ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}
    ${CHECK}=    Run Keyword And Return Status    List Should Contain Value    ${CLASS_LIST}    selected
    IF    not ${CHECK}
        Press Keys    None    CONTROL
        Wait For The Element And Click    ${FIRST_STEPS_GROUP}
        Press Keys    None    CONTROL+NULL
    END
    Sleep    2s
    Open Context Menu    ${FIRST_STEPS_GROUP}
    Wait For The Element And Click    ${OPTION_UNGROUP_STEPS}

Verify The Steps Are Ungrouped
    [Documentation]    To Verify The Steps Are Ungrouped
    Element Should Not Be Visible    ${FIRST_STEPS_GROUP}
    Element Should Not Be Visible    ${EXPAND_STEPS}
    Wait Until Element Is Visible    ${FIRST_STEP}

Verify The Multiple Steps Group Created
    [Documentation]    To Verify The Multiple Steps Group Created
    ${COUNT}=    Get Element Count    ${TOTAL_STEP_GROUPS}
    Should Be Equal As Numbers    ${COUNT}    3

User Add Step To Procedure In Expanded Instruction Box
    [Documentation]    To User Add Step To Procedure In Expanded Instruction Box
    Click Element    ${Step_Plus_button}
    Wait For The Element And Click    ${EXPAND_INSTRUCTION_ICON}
    ${TD_INSTRUCTION_ADDED_IN_EXPANDED_INSTRUCTION_BOX}=    Generate Random Statement
    Set Test Variable    ${TD_INSTRUCTION_ADDED_IN_EXPANDED_INSTRUCTION_BOX}
    Scroll Element And Enter Value    ${EXPANDED_INSTRUCTION_EDITOR}    ${TD_INSTRUCTION_ADDED_IN_EXPANDED_INSTRUCTION_BOX}
    Wait For The Element And Click    ${SAVE_INSTRUCTION_BUTTON}

Verify The Instruction Is Saved On The Procedure Review
    [Documentation]    To Verify The Instruction Is Saved On The Procedure Review
    ${TEMP}=    Get Text    ${SAVED_INSTRUCTION}
    Should Be Equal As Strings    ${TEMP}    ${TD_INSTRUCTION_ADDED_IN_EXPANDED_INSTRUCTION_BOX}

Ensure Procedures List Page Is Open
    [Documentation]    To Ensure Procedures List Page Is Open
    ${status}=    Run Keyword And Return Status    Navigate To Procedures List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    Navigate To Procedures List Page


Navigate To Procedures List Page
    [Documentation]    To Navigate To Procedures List Page
    
#    #check if the user is on the correct page
#    ${CURRENT _PAGE}=    Get Location
#    Return From Keyword If    '${CURRENT}'=='${PROCEDURE_LIST_PAGE}'
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds   10x   1s    Mouse Over    ${DASHBOARD_LINK}
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${PROCEDURE_TAB}
    Wait For The Element And Click    ${PROCEDURE_TAB}
    TRY
        Wait Until Element Is Visible    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}    ${Max_limit}
        Mouse Over    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}
    EXCEPT
        Mouse Over    ${BELL_ICON_ON_LIST_PAGE}
    END

Verify The User Is Not Able To Publish The Procedure Without Release Notes
    [Documentation]    To Verify The User Is Not Able To Publish The Procedure Without Release Notes
    Element Should Be Disabled    ${Publish_button}
    Input Text    ${Release_Note}    Added a thing or two
    Element Should Be Enabled    ${Publish_button}

Enter Instruction To The Step And Change Language
    [Documentation]    To Enter Instruction To The Step And Change Language
    Scroll Element And Enter Value    ${Instruction_Editor}    This is the step instruction.
    ${TARGET_LANGUAGE}    ${TARGET_INSTRUCTION}    Get Instruction Language
    Set Test Variable    ${TARGET_LANGUAGE}
    Set Test Variable    ${TARGET_INSTRUCTION}
    Wait For The Element And Click    ${INSTRUCTION_LANGUAGE_SELECT}
    Input Text    ${INPUT_INSTRUCTION_LANGUAGE}    ${TARGET_LANGUAGE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${INSTRUCTION_LANGUAGE_OPTION}    ${TARGET_LANGUAGE}
    Wait For The Element And Click    ${INSTRUCTION_LANGUAGE_OPTION}
    Wait Until Element Is Enabled    ${Instruction_Editor}
    Wait Until Keyword Succeeds    5x    1s    Element Should Not Contain    ${Instruction_Editor}    This is the step instruction.

Verify The Text Language has Not Been Changed
    [Documentation]    To Verify The Text Language has Not Been Changed
    Element Should Contain    ${Instruction_Editor}    This is the step instruction.


Enter Instruction To The Step And Access Toolkit
    [Documentation]    To Enter Instruction To The Step And Access Toolkit

    # Check Bolder
    Click Element    ${Instruction_Editor}
    Press Keys    ${Instruction_Editor}    CTRL+a
    Click Element    ${INSTRUCTION_BOLD_BUTTON}
    Sleep    2s
    ${inner_html}=    Get Element Attribute    ${Instruction_Editor}    innerHTML
    Should Contain    ${inner_html}    <strong>


    # Check Italic
    Click Element    ${Instruction_Editor}
    Press Keys    ${Instruction_Editor}    CTRL+a
    Click Element    ${INSTRUCTION_ITALIC_BUTTON}
    Sleep    2s
    ${inner_html}=    Get Element Attribute    ${Instruction_Editor}    innerHTML
    Should Contain    ${inner_html}    <em>


    # Check Underline
    Click Element    ${Instruction_Editor}
    Press Keys    ${Instruction_Editor}    CTRL+a
    Click Element    ${INSTRUCTION_UNDERLINE_BUTTON}
    Sleep    2s
    ${inner_html}=    Get Element Attribute    ${Instruction_Editor}    innerHTML
    Should Contain    ${inner_html}    <u>

    #Order list
    Click Element    ${Instruction_Editor}
    Press Keys    ${Instruction_Editor}    CTRL+a
    Click Element    ${INSTRUCTION_ORDERED_BUTTON}
    Sleep    2s
    ${data_list}=    Get Element Attribute    ${INSTRUCTION_EDITOR_LIST}    data-list
    Should Be Equal    ${data_list}    ordered


    #Unordered list
    Click Element    ${INSTRUCTION_EDITOR_LIST}
    Press Keys    ${INSTRUCTION_EDITOR_LIST}    CTRL+a
    Click Element    ${INSTRUCTION_UNORDERED_BUTTON}
    Sleep    2s
    ${data_list}=    Get Element Attribute    ${INSTRUCTION_EDITOR_LIST}     data-list
    Should Be Equal    ${data_list}    bullet


    #Unchecked list
    Click Element    ${INSTRUCTION_EDITOR_LIST}
    Press Keys    ${INSTRUCTION_EDITOR_LIST}    CTRL+a
    Click Element    ${INSTRUCTION_UNCHECKED_BUTTON}
    Sleep    2s
    ${data_list}=    Get Element Attribute    ${INSTRUCTION_EDITOR_LIST}     data-list
    Should Be Equal    ${data_list}    unchecked

Verify The Migration Data
    [Documentation]    To Verify The Migration Data
    ${MIGRATION_DATA}=    Read Migration Data File    ${TF_MIGRATION_DATA}
    FOR    ${DATA_RECORD}    IN    @{MIGRATION_DATA}
        Navigate To Procedure Details Page    ${DATA_RECORD[0]}
        Verify The Procedure Step Count    ${DATA_RECORD}
        Click On Procedure Link In Breadcrumb
        Verify User Lands On The Procedure List Page
    END

Verify The Procedure Step Count
    [Documentation]    To Verify The Procedure Step Count
    [Arguments]    ${DATA_RECORD}
    Wait Until Element Is Visible    ${PROCEDURE_NAME_DETAILS_PAGE}    ${Max_limit}
    Element Should Contain    ${PROCEDURE_NAME_DETAILS_PAGE}    ${DATA_RECORD[0]}
    Wait Until Element Is Visible    ${STEPS_IN_PROCEDURES_PREVIEW}    ${Max_limit}
    Element Should Contain    ${STEPS_IN_PROCEDURES_PREVIEW}    ${DATA_RECORD[1]}

Verify The Approval Managers And Co-Author Are Correctly Displayed
    [Documentation]    To Verify The Approval Managers And Co-Author Are Correctly Displayed
    ${APPROVAL_MANAGERS_LIST}    Evaluate    [item.split(" ")[-1] for item in ${APPROVAL_MANAGERS_LIST}]
    Set Test Variable    ${APPROVAL_MANAGERS_LIST}
    FOR    ${MANAGER}    IN    @{APPROVAL_MANAGERS_LIST}
        ${MANAGER}=    Split String    ${MANAGER}    ${SPACE}
        ${LOCATOR}=    Replace String    ${SAVED_MANAGER}    ITEM  ${MANAGER[-1]}
        Wait Until Element Is Visible    ${LOCATOR}
    END

    ${COAUTHORS_LIST}    Evaluate    [item.split(" ")[-1] for item in ${COAUTHORS_LIST}]
    Set Test Variable    ${COAUTHORS_LIST}
    FOR    ${COAUTHOR}    IN    @{COAUTHORS_LIST}
        ${COAUTHOR}=    Split String    ${COAUTHOR}    ${SPACE}
        ${LOCATOR}=    Replace String    ${SAVED_COAUTHOR}    ITEM  ${COAUTHOR[-1]}
        Wait Until Element Is Visible    ${LOCATOR}
    END


Add The Approval Managers And Co-Author
    [Documentation]    To Add The Approval Managers And Co-Author
    Click Element    ${APPROVAL_MANAGERS_SELECT}
    Wait Until Element Is Visible    ${FIRST_MANAGER}
    ${MANAGERS_END_LIMIT}=    Get Element Count    ${ALL_MANAGERS}
    ${APPROVAL_MANAGERS_LIST}=    Get Values In List For Validation    ${MANAGERS_OPTION}    1    ${MANAGERS_END_LIMIT}
    ${APPROVAL_MANAGERS_LIST}=    Get Random Records From List    ${APPROVAL_MANAGERS_LIST}    2
    Set Test Variable    ${APPROVAL_MANAGERS_LIST}
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

    Click Element    ${COAUTHORS_SELECT}
    Wait Until Element Is Visible    ${FIRST_COAUTHOR}        ${Max_limit}
    ${COAUTHORS_END_LIMIT}=    Get Element Count    ${ALL_COAUTHORS}
    ${COAUTHORS_LIST}=    Get Values In List For Validation    ${COAUTHORS_OPTION}    1    ${COAUTHORS_END_LIMIT}
    ${COAUTHORS_LIST}=    Get Random Records From List    ${COAUTHORS_LIST}    2
    Set Test Variable    ${COAUTHORS_LIST}
    Press Keys    ${COAUTHORS_SELECT}    ESC

    Click Element    ${APPROVAL_MANAGERS_SELECT}
    FOR    ${MANAGER}    IN    @{APPROVAL_MANAGERS_LIST}
        ${MANAGER}=    Split String    ${MANAGER}    ${SPACE}
        Scroll Element And Enter Value     ${MANAGER_INPUT}    ${MANAGER[-1]}
        Sleep       2s
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_MANAGER}    ${MANAGER[-1]}
        Wait For The Element And Click    ${FIRST_MANAGER}
    END
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

    Click Element    ${COAUTHORS_SELECT}
    FOR    ${COAUTHOR}    IN    @{COAUTHORS_LIST}
        ${COAUTHOR}=    Split String    ${COAUTHOR}    ${SPACE}
        Scroll Element And Enter Value    ${COAUTHOR_INPUT}    ${COAUTHOR[-1]}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_COAUTHOR}    ${COAUTHOR[-1]}
        Wait For The Element And Click    ${FIRST_COAUTHOR}
    END
    Press Keys    ${COAUTHORS_SELECT}    ESC


Add The Approval Managers
    [Documentation]    To Add The Approval Managers
    Click Element    ${APPROVAL_MANAGERS_SELECT}
    Wait Until Element Is Visible    ${FIRST_MANAGER}
    ${MANAGERS_END_LIMIT}=    Get Element Count    ${ALL_MANAGERS}
    ${APPROVAL_MANAGERS_LIST}=    Get Values In List For Validation    ${MANAGERS_OPTION}    1    ${MANAGERS_END_LIMIT}
    ${APPROVAL_MANAGERS_LIST}=    Get Random Records From List    ${APPROVAL_MANAGERS_LIST}    2
    Set Test Variable    ${APPROVAL_MANAGERS_LIST}
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC
    Click Element    ${APPROVAL_MANAGERS_SELECT}
    FOR    ${MANAGER}    IN    @{APPROVAL_MANAGERS_LIST}
        Scroll Element And Enter Value     ${Approval_search}    ${MANAGER}
        Wait For The Element And Click    ${FIRST_MANAGER}
    END
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

Get The Details of First Approval Manager
    Click Element    ${APPROVAL_MANAGERS_SELECT}
    Wait Until Element Is Visible    ${FIRST_MANAGER}
    ${MANAGER_EMAIL_1}=    Get Text    ${FIRST_MANAGER_EMAIL}
    Log    ${MANAGER_EMAIL_1}
    Set Global Variable    ${MANAGER_EMAIL_1}
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

Get The Details of All Approver Managers
   [Documentation]    Fetches and stores emails of all approver managers from dropdown (uses built-in scroll).
   Execute JavaScript    window.scrollTo(0, document.body.scrollHeight);
   Sleep    0.5s
   Click Element    ${APPROVAL_MANAGERS_SELECT}
   Wait Until Element Is Visible    (//span[@class="dropdown-option"])[1]    timeout=10s
   FOR    ${index}    IN RANGE    1    3
       ${email_locator}=    Set Variable    ((//span[@class="dropdown-option"])[${index}]//span)[2]
       Wait Until Keyword Succeeds    3x    2s    Element Should Be Visible    ${email_locator}
       Scroll Element Into View    ${email_locator}    # <= SeleniumLibrary builtin
       Sleep    0.2s
       ${email}=    Get Text    ${email_locator}
       Set Global Variable    ${MANAGER_EMAIL_${index}}    ${email}
   END
   Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC
Deselect The Approval Managers And Co-Author
    [Documentation]    To Deselect The Approval Managers And Co-Author
    Click Element    ${CHANGE_LINK}
    Wait For The Element And Click    ${APPROVAL_MANAGERS_SELECT}
    FOR    ${MANAGER}    IN    @{APPROVAL_MANAGERS_LIST}
        Scroll Element And Enter Value    ${MANAGER_INPUT}    ${MANAGER}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_MANAGER}    ${MANAGER}
        Wait For The Element And Click    ${FIRST_MANAGER}
    END
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

    Click Element    ${COAUTHORS_SELECT}
    FOR    ${COAUTHOR}    IN    @{COAUTHORS_LIST}
        Scroll Element And Enter Value    ${COAUTHOR_INPUT}    ${COAUTHOR}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_COAUTHOR}    ${COAUTHOR}
        Wait For The Element And Click    ${FIRST_COAUTHOR}
    END
    Press Keys    ${COAUTHORS_SELECT}    ESC

Verify The User Is Able to Rearrange The steps
    [Documentation]    To Verify The User Is Able to Rearrange The steps
    Click Element    ${EXPAND_STEPS}
    Click Element    ${SECOND_GROUP_EXPAND_STEPS}
    Drag And Drop    ${FIRST_STEP}    ${SECOND_STEP}

Verify That Input Fields Are Dynamically Displayed
    [Documentation]    To Verify That Input Fields Are Dynamically Displayed
    Click Element    ${User_Input_tab}
    Wait Until Page Contains Element     ${Block_Name}    ${maxTime}
    ${TYPE_SELECTION_LIST}=    Create List    Radio    Text    Dropdown    Checklist    Number

    FOR    ${TYPE}    IN    @{TYPE_SELECTION_LIST}
        Verify The Input Options Displayed    ${TYPE}
    END

Verify The Input Options Displayed
    [Documentation]    To Verify The Input Options Displayed
    [Arguments]    ${INPUT_TYPE}
    Click Element    ${User_Input_Type}
    Input Text    ${USER_INPUT_SEARCH}    ${INPUT_TYPE}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_INPUT_TYPE}/span    ${INPUT_TYPE}
    Click Element    ${FIRST_INPUT_TYPE}
    Click Element    ${BLOCK_LABEL}
    Repeat Keyword    2x    Press Keys    None    ARROW_DOWN
    IF    '${INPUT_TYPE}'=='Radio'
        Wait Until Element Is Visible    ${OPTIONS_INPUT_FIELD}
        Wait Until Element Is Visible    ${OPTION_DELETE_BUTTON}
        Wait Until Element Is Visible    ${RADIO_OPTION_ADD_BUTTON}
    ELSE IF    '${INPUT_TYPE}'=='Text'
        Wait Until Element Is Visible    ${VALIDATION_DROPDOWN}
        Element Should Not Be Visible    ${INPUT_MAX_VALUE}
    ELSE IF    '${INPUT_TYPE}'=='Dropdown'
        Wait Until Element Is Visible    ${OPTIONS_LABEL}
        Wait Until Element Is Visible    ${OPTIONS_INPUT_FIELD}
        Element Should Not Be Visible    ${INPUT_MAX_VALUE}

    ELSE IF    '${INPUT_TYPE}'=='Checklist'
       Element Should Not Be Visible    ${OPTIONS_LABEL}
       Wait Until Element Is Visible    ${OPTIONS_INPUT_FIELD}
       Element Should Be Visible    ${OPTION_ADD_BUTTON}
       Element Should Be Visible    ${OPTION_DELETE_BUTTON}

    ELSE IF    '${INPUT_TYPE}'=='Number'
        Wait Until Element Is Visible    ${VALIDATION_DROPDOWN}
#        Wait Until Element Is Visible    ${INPUT_MIN_VALUE}
#        Wait Until Element Is Visible    ${INPUT_MAX_VALUE}

    END

Click On The Step
    [Documentation]    To Click On The Step
    [Arguments]    ${STEP_INDEX}
    ${LOCATOR}=  Replace String    ${ADDED_PROCEDURE_STEP}    INDEX    ${STEP_INDEX}
    Wait For The Element And Click    ${LOCATOR}


Delete The Step From Step Group
    [Documentation]    To Delete The Step From Step Group
    Wait For The Element And Click    ${EXPAND_STEPS}
    Click Element    ${STEP_ADDED_IN_GROUP}
    Open Context Menu    ${STEP_ADDED_IN_GROUP}
    Click Element    ${DELETE_STEP_ADDED_IN_GROUP}
    Wait For The Element And Click    ${DELETE_STEP_POPUP}
    Wait Until Element Is Not Visible    ${FIRST_STEP}

Delete The Step
    Click Element    ${DeleteStep}
    Wait For The Element And Click    ${DELETE_STEP_POPUP}
    Wait Until Element Is Not Visible    ${FIRST_STEP}

Save Validation Data
    [Documentation]    To Save Validation Data
    &{data}=    Create Dictionary
    ...    TD_PROCEDURE_NAME=${TD_PROCEDURE_NAME}
    ...    STEP_INSTRUCTIONS_LIST=${STEP_INSTRUCTIONS_LIST}
    ...    PT_PossibleCause=${PT_POSSIBLE_CAUSE_INPUT}
    ...    PT_CorrectiveAction=${PT_CorrectiveAction_Input}
    ...    PT_PreventiveAction=${PT_PreventiveAction_Input}
    ...    Preventive_Troubleshooting_Title=${Preventive_Troubleshooting_Title}
    ...    OPTIONS_DICT=${OPTIONS_DICT}
    ...    OPTIONS_VALIDATION_DICT=${OPTIONS_VALIDATION_DICT}
    ...    BOT_ADDED_TO_STEP=${BOT_ADDED_TO_STEP}
    ...    BOM_ADDED_TO_STEP=${BOM_ADDED_TO_STEP}
    ...    CYCLE_TIME=${CYCLE_TIME}
    ...    USER_INPUT_DATA=${USER_INPUT_DATA}
    ...    TD_MATERIAL_NUMBER=${TD_MATERIAL_NUMBER}


    ${json}=    Convert Json To String    ${data}
    Create File    validation_data.json    ${json}



Verify The Pagination On The Jobs List Page
    [Documentation]    To Verify The Pagination On The Jobs List Page
    Verify The Pagination On Custom Page    ${JOB_LIST_PAGE_SIZE_SELECT}    False    ${PAGINATION_NEXT_PAGE}


Get The Updated Procedure Name And Version
    [Documentation]    To Get The Updated Procedure Name And Version
    @{UPDATED_PROCEDURE_NAME_AND_VERSION}=    Create List
    FOR    ${PROCEDURE}    IN    @{UPDATED_PROCEDURE_LIST}
        ${YIELD}=    Get Custom Procedure Details    ${PROCEDURE}
        Append To List    ${UPDATED_PROCEDURE_NAME_AND_VERSION}    ${YIELD}
    END
    Set Test Variable    ${UPDATED_PROCEDURE_NAME_AND_VERSION}


Get Custom Procedure Details
    [Documentation]    To Get Custom Procedure Details
    [Arguments]    ${PROCEDURE_NAME}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${PROCEDURE_NAME}
    Wait For The Page To Load
    Wait Until Element Is Visible    ${FIRST_PROCEDURE}
    Element Should Contain    ${FIRST_PROCEDURE}    ${PROCEDURE_NAME}

    ${PROCEDURE_VERSION}=    Get Text    ${FIRST_PROCEDURE_VERSION}
    ${TEMP}    Strip String    ${PROCEDURE_VERSION}
    ${TEMP}    Split String    ${TEMP}    ${SPACE}

    @{RETURN_LIST}=    Create List    ${PROCEDURE_NAME}    ${TEMP[1]}
    RETURN    ${RETURN_LIST}

Select The SignOff Manager
    [Documentation]    To Select The SignOff Manager
    Wait For The Element And Click    ${SIGNOFF_MANAGER_SELECT}
    Scroll Element And Enter Value    ${SIGNOFF_MANAGER_INPUT}    ${AUTHOR1_NAME}
    Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SIGNOFF_MANAGER}    ${AUTHOR1_NAME}
    Wait For The Element And Click    ${FIRST_SIGNOFF_MANAGER}
    Press Keys    None    ESC

Create Procedure Records
    [Documentation]    To Create Procedure Records
    [Arguments]    ${COUNT}=2    ${SIGNOFF}=REQUIRED    ${LIST_NAME}=ADD_PROCEDURE_TO_TRAINING_LIST    ${NUMBER_OF_STEPS}=1
    Navigate To Procedures List Page
    FOR    ${IT}    IN RANGE    ${COUNT}
        User Clicks on Add Button On Procedures List Page
        User Lands on Add New Procedure Page
        User Adds General Details
        Run Keyword If    '${IT}'=='0' and '${SIGNOFF}'=='REQUIRED'  Select The SignOff Manager
        Add The Cycle Time To The Procedure
        User Add Step To Procedure    ${NUMBER_OF_STEPS}
        Add The Cycle Time To The Procedure
        User Publishes The Procedure
        User Adds Release Notes
        Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=${LIST_NAME}
    END


Create Procedure Records With With One Procedure Having Multiple Steps
    [Documentation]    To Create Procedure Records With With One Procedure Having Multiple Steps
    Create Procedure Records    COUNT=1    SIGNOFF=NOT_REQUIRED    NUMBER_OF_STEPS=3
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    User Add Step To Procedure
    User Publishes The Procedure
    User Adds Release Notes
    Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST

Create Procedure Records For Approval SignOff
    [Documentation]    To Create Procedure Records for approval sign off
    [Arguments]    ${COUNT}=2    ${SIGNOFF}=REQUIRED    ${LIST_NAME}=ADD_PROCEDURE_TO_TRAINING_LIST
    Navigate To Procedures List Page
    FOR    ${IT}    IN RANGE    ${COUNT}
        User Clicks on Add Button On Procedures List Page
        User Lands on Add New Procedure Page
        User Adds General Details Without Co-Author
        Add The Cycle Time To The Procedure
        Run Keyword If    '${IT}'=='0' and '${SIGNOFF}'=='REQUIRED'  Select The SignOff Manager
        User Add Step To Procedure    1
        User Publishes The Procedure
        User Adds Release Notes
        Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=${LIST_NAME}
    END    

Create Saved Procedure For Change Logs
    [Documentation]    To Create Procedure Records
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Lands on Add New Procedure Page
    User Adds General Details
    User Add Step To Procedure
    User Saves Procedure as Draft
    Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST

Create Procedure Records With Multiple SignOff Managers
    [Documentation]    To Create Procedure Records
    [Arguments]    ${SIGNOFF_MANAGERS}    ${COUNT}=2    ${SIGNOFF}=REQUIRED
    Navigate To Procedures List Page
    FOR    ${IT}    IN RANGE    ${COUNT}
        User Clicks on Add Button On Procedures List Page
        User Lands on Add New Procedure Page
        User Adds General Details
        Run Keyword If    '${IT}'=='0' and '${SIGNOFF}'=='REQUIRED'  Select Multiple SignOff Manager    ${SIGNOFF_MANAGERS}
        Add The Cycle Time To The Procedure    0    0    10
        User Add Step To Procedure    1
        User Publishes The Procedure
        User Adds Release Notes
        Add Item To List    ITEM=${TD_PROCEDURE_NAME}   VAR_NAME=ADD_PROCEDURE_TO_TRAINING_LIST
    END

Publish A Procedure
    [Documentation]    Entire flow to Publish a New Procedure
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Approval Managers
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    Then Verify that Procedure is Published

Delete A Procedure
    Press Keys    //body    ESC
    ${logged_in_user}=    Get Text    ${user_name}
    IF    '${logged_in_user}'!='${AUTHOR1_NAME}'
        Logout from Mentor
        And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    END
    Navigate to Procedures page
    ${exists}=    Run Keyword And Return Status    Variable Should Exist    ${TD_PROCEDURE_NAME}
    IF    ${exists}
        Search For Recently Created Procedure
        ${kebab_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${procedure_kebab_menu_icon}
        IF    ${kebab_exists}
        Wait Until Element Is Visible    ${procedure_kebab_menu_icon}    timeout=5s
        Click Element    ${procedure_kebab_menu_icon}
        Wait Until Element Is Visible    ${procedure_delete_option}    timeout=10s
        Sleep    2s
        Click Element    ${procedure_delete_option}
        Wait Until Element Is Visible    ${confirm_button}    timeout=5s
        Sleep    2s
        Click Element    ${confirm_button}
        wait for the page to load
        END
    END

Delete A Procedure For Sign Off
    Press Keys    //body    ESC
    ${logged_in_username}=    Get Text    ${user_name}
    IF    '${logged_in_username}'!='${AUTHOR1_NAME}'
        Logout from Mentor
        And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    END
    Navigate to Procedures page
    ${exists}=    Run Keyword And Return Status    Variable Should Exist    ${ADD_PROCEDURE_TO_TRAINING_LIST}
    IF    ${exists}
        IF    ${ADD_PROCEDURE_TO_TRAINING_LIST}
            Search For A Particular Procedure    PROCEDURE_NUMBER=0
            Sleep    3s
            Wait Until Element Is Visible    ${procedure_kebab_menu_icon}    timeout=5s
            Click Element    ${procedure_kebab_menu_icon}
            Wait Until Element Is Visible    ${procedure_delete_option}    timeout=10s
            Click Element    ${procedure_delete_option}
            Wait Until Element Is Visible    ${confirm_button}    timeout=5s
            Click Element    ${confirm_button}
            wait for the page to load
        END
    END


Verify User Can Add Multiple Sign-off Managers
    Wait Until Element Is Visible    ${Sign-off_Manager}
    Click Element    ${Sign-off_Manager}
    Wait Until Element Is Visible    ${FIRST_MANAGER}
    ${MANAGERS_END_LIMIT}=    Get Element Count    ${ALL_MANAGERS}
    ${APPROVAL_MANAGERS_LIST}=    Get Values In List For Validation    ${MANAGERS_OPTION}    1    ${MANAGERS_END_LIMIT}
    ${IS_LIMIT_GT_3}=    Evaluate    ${MANAGERS_END_LIMIT} > 3
    IF    ${IS_LIMIT_GT_3}
        ${MAXIMUM_LIMIT}=    Set Variable    3
    ELSE
        ${MAXIMUM_LIMIT}=    Set Variable    ${MANAGERS_END_LIMIT}
    END
    ${APPROVAL_MANAGERS_LIST}=    Get Random Records From List    ${APPROVAL_MANAGERS_LIST}    ${MAXIMUM_LIMIT}
    Set Test Variable    ${APPROVAL_MANAGERS_LIST}
    Press Keys    ${APPROVAL_MANAGERS_SELECT}    ESC

    Click Element    ${Sign-off_Manager}
    ${APPROVAL_MANAGERS_LIST}    Evaluate    [item.split(" ")[-1] for item in ${APPROVAL_MANAGERS_LIST}]
    FOR    ${MANAGER}    IN    @{APPROVAL_MANAGERS_LIST}
        Scroll Element And Enter Value     ${Sign-off_Manager_search}    ${MANAGER}
        Wait For The Element And Click    ${FIRST_MANAGER}
    END
    Press Keys    ${Sign-off_Manager}    ESC

Verify That Procedure In Approval Pending State
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Run Keyword And Ignore Error     Page Should Contain Element    ${Status_Indicator}
    ${State}=   Get Text    ${Status_Indicator}
    Should Be Equal As Strings    ${State}     Approval Pending

Publish A procedure With Approval Managers
    [Documentation]    Entire flow to Publish a New Procedure with Approval Managers
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Approval Managers
    And Get The Details of All Approver Managers
    # And User adds PPE to the procedure
    And User Add Step To Procedure
    # And User adds Preventive Troubleshooting to Step
#    And User add Options to Step
    # And User Adds User Input to Step
    # And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved

Select Multiple SignOff Manager
    [Documentation]    To Select The SignOff Manager
    [Arguments]    ${MANAGERS_LIST}
    FOR    ${USER}    IN    @{MANAGERS_LIST}
        Wait For The Element And Click    ${SIGNOFF_MANAGER_SELECT}
        Scroll Element And Enter Value    ${SIGNOFF_MANAGER_INPUT}    ${USER}
        Wait Until Keyword Succeeds    5x    1s    Element Should Contain    ${FIRST_SIGNOFF_MANAGER}    ${USER}
        Wait For The Element And Click    ${FIRST_SIGNOFF_MANAGER}
        Press Keys    None    ESC
    END

Search and Verify a BOM in Procedures Page
    [Arguments]    ${bom_search_text}
    ${BOM_LOCATOR}=    Replace String   ${BOM_SEARCH_CHECK}  replace    ${bom_search_text}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${BOM_Search_bar}
    Input Text   ${BOM_Search_bar}    ${bom_search_text}
    Sleep    2s
    Wait Until Element Is Visible    ${BOM_LOCATOR}
    Set Test Variable    ${BOM_LOCATOR}

Empty The List Page Via All Records Checkbox
    [Documentation]    To Empty The List Page Via All Records Checkbox
    ${COUNT}=    Get Current Record Count On Page
    ${COUNT}=    Evaluate    int(int(${COUNT})/10)-1

    FOR    ${IT}    IN RANGE    ${COUNT}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${ALL_RECORDS_CHECKBOX_ON_LIST_PAGE}
        Delete Selected Records
        Wait For The Page To Load
    END


Verify Image Zoom
    [Arguments]    ${IMAGE_LOCATOR}    ${ZOOM_IN_LOCATOR}    ${ZOOM_OUT_LOCATOR}

    # 1. Get initial scale
    ${TEMP}=    Get Element Attribute    ${IMAGE_LOCATOR}    style
    Should Be True    "${TEMP}" == "${NORMAL_IMAGE_ATTR}"

    # 2. Zoom In
    Click Element    ${ZOOM_IN_LOCATOR}
    Sleep    1s

    ${TEMP}=    Get Element Attribute    ${IMAGE_LOCATOR}    style
    Should Be True    "${TEMP}" == "${ZOOMED_IN_IMAGE_ATTR}"    Zoom in verification failed

    # 3. Zoom Out
    Click Element    ${ZOOM_OUT_LOCATOR}
    Sleep    1s
    
    ${TEMP}=    Get Element Attribute    ${IMAGE_LOCATOR}    style
    Should Be True    "${TEMP}" == "${NORMAL_IMAGE_ATTR}"    Zoom out verification failed
    

Expand The Attachments Window
    [Documentation]    To Expand The Attachments Window
    Wait For The Element And Click    ${EXPAND_ATTACHMENTS_PROCEDURE_DETAILS_PAGE}
    Wait For The Page To Load


Verify Image Zoom In -Zoom Out
    [Documentation]    To Verify Image Zoom In -Zoom Out
    Verify Image Zoom    ${EXPANDED_WINDOW_ATTACHED_IMAGE}    ${EXPANDED_WINDOW_ATTACHMENT_ZOOMIN_BUTTON}    ${EXPANDED_WINDOW_ATTACHMENT_ZOOMOUT_BUTTON}


Verify that Arrow icons should be visible on Attachment Preview screen
    [Documentation]    To Verify that Arrow icons should be visible on Attachment Preview screen

    #verify the arrow button functionality on details
    
    #Right Navigation
    Wait Until Element Is Visible    ${DETAILS_PAGE_RIGHT_NAVIGATION_BUTTON}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${DETAILS_PAGE_RIGHT_NAVIGATION_BUTTON}
    Wait For The Page To Load
    
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${DETAILS_PAGE_RIGHT_NAVIGATION_BUTTON}
    Wait For The Page To Load

    Page Should Not Contain Element    ${DETAILS_PAGE_RIGHT_NAVIGATION_BUTTON}
    
    #Left Navigation
    Wait Until Element Is Visible    ${DETAILS_PAGE_LEFT_NAVIGATION_BUTTON}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${DETAILS_PAGE_LEFT_NAVIGATION_BUTTON}
    Wait For The Page To Load
    
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${DETAILS_PAGE_LEFT_NAVIGATION_BUTTON}
    Wait For The Page To Load

    Page Should Not Contain Element   ${DETAILS_PAGE_LEFT_NAVIGATION_BUTTON}

    #Verify navigation on expanded window
    Expand The Attachments Window

    #Right Navigation
    Wait Until Element Is Visible    ${EXPANDED_WINDOW_RIGHT_NAVIGATION_BUTTON}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${EXPANDED_WINDOW_RIGHT_NAVIGATION_BUTTON}
    Wait For The Page To Load

    Wait Until Keyword Succeeds    5x    1s    Click Element    ${EXPANDED_WINDOW_RIGHT_NAVIGATION_BUTTON}
    Wait For The Page To Load


    ${TEMP}=    Get Element Attribute    ${EXPANDED_WINDOW_RIGHT_NAVIGATION_BUTTON}/..    class
    Should Contain    ${TEMP}    disabled


    #Left Navigation
    Wait Until Element Is Visible    ${EXPANDED_WINDOW_LEFT_NAVIGATION_BUTTON}    ${Max_limit}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${EXPANDED_WINDOW_LEFT_NAVIGATION_BUTTON}
    Wait For The Page To Load

    Wait Until Keyword Succeeds    5x    1s    Click Element    ${EXPANDED_WINDOW_LEFT_NAVIGATION_BUTTON}
    Wait For The Page To Load


    ${TEMP}=    Get Element Attribute    ${EXPANDED_WINDOW_LEFT_NAVIGATION_BUTTON}/..    class
    Should Contain    ${TEMP}    disabled
    Press Keys    None    ESC



Verify The Column Resize Functionality
    [Documentation]    To Resize Column Width


    # Locator for the column's resize handle
    ${WIDTH_BEFORE}=    Get CSS Property    ${AUTHOR_SCREEN_FIRST_COLUMN}    width


    # Expand the column width by dragging to the right (e.g., +100 pixels)
    Drag And Drop By Offset    ${AUTHOR_SCREEN_FIRST_RESIZER_ELEMENT}    100    0
    Sleep    1s

    # Contract the column width by dragging to the left (e.g., -80 pixels)
    Drag And Drop By Offset    ${AUTHOR_SCREEN_FIRST_RESIZER_ELEMENT}    -110    0
    Sleep    1s

    ${WIDTH_AFTER}=    Get CSS Property    ${AUTHOR_SCREEN_FIRST_COLUMN}    width
    Should Not Be Equal As Strings    ${WIDTH_AFTER}     ${WIDTH_BEFORE}
    
    #Reverting changes
    Drag And Drop By Offset    ${AUTHOR_SCREEN_FIRST_RESIZER_ELEMENT}    10    0
    Sleep    1s

    ${FINAL_WIDTH}=    Get CSS Property    ${AUTHOR_SCREEN_FIRST_COLUMN}    width
    Set Test Variable    ${FINAL_WIDTH}


Verify The Column Width Persists In Fresh Login
    [Documentation]    To Verify The Column Width Persists In Fresh Login
    
    Wait Until Element Is Visible    ${AUTHOR_SCREEN_FIRST_COLUMN}    
    ${WIDTH_CURRENT}=    Get CSS Property    ${AUTHOR_SCREEN_FIRST_COLUMN}    width
    
    Should Be Equal As Strings    ${WIDTH_CURRENT}    ${FINAL_WIDTH}


Open Columnizer Flyout Window
    [Documentation]    To Open Columnizer Flyout Window
    Wait For The Element And Click    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_ICON}
    Sleep    5s

Close Columnizer Flyout Window
    [Documentation]    To Close Columnizer Flyout Window
    Wait For The Element And Click    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_CLOSE_BUTTON}

    
Configure The Visibility Of The Columns On Procedure List Page
    [Documentation]    To Configure The Visibility Of The Columns On Procedure List Page
    [Arguments]    ${ACTION}
    Run Keyword And Ignore Error    Click On The Dashboard In Left Navigation
    Run Keyword And Ignore Error    Navigate To Procedures List Page
    Open Columnizer Flyout Window
    IF    '${ACTION}'=='Un Hide'

        #Un Hide column 1
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}    class
        ${CLASS_LIST}=    Split String    ${CLASS}    ${SPACE}
        Run Keyword If    not 'mdc-checkbox--selected' in ${CLASS_LIST}    Click Element    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}
        sleep    5s
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}    class
        Should Contain    ${CLASS}    mdc-checkbox--selected
        
        #Un Hide column 2
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}    class
        ${CLASS_LIST}=    Split String    ${CLASS}    ${SPACE}
        Run Keyword If    not 'mdc-checkbox--selected' in ${CLASS_LIST}    Click Element    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}
        sleep    5s
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}    class
        Should Contain    ${CLASS}    mdc-checkbox--selected

    ELSE IF     '${ACTION}'=='Hide'

        #Un Hide column 1
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}    class
        ${CLASS_LIST}=    Split String    ${CLASS}    ${SPACE}
        Run Keyword If    'mdc-checkbox--selected' in ${CLASS_LIST}    Click Element    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}
        sleep    5s    #Dom to load properly with updated class
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_STATUS_CHECKBOX}    class
        Should Not Contain    ${CLASS}    mdc-checkbox--selected

        #Un Hide column 2
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}    class
        ${CLASS_LIST}=    Split String    ${CLASS}    ${SPACE}
        Run Keyword If    'mdc-checkbox--selected' in ${CLASS_LIST}    Click Element    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}
        sleep    5s
        ${CLASS}=    Get Element Attribute    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_DOCUMENT_ID_CHECKBOX}    class
        Should Not Contain    ${CLASS}    mdc-checkbox--selected

    END
    Close Columnizer Flyout Window

Verify The Columns On Procedure Page Are
    [Documentation]    To Verify The Columns On Procedure Page Are
    [Arguments]    ${VISIBILITY}
    
    #Extract The table headers
    ${MAX_LIMIT}=    Get Element Count    ${AUTHOR_SCREEN_DISPLAYED_TABLE_HEADERS}   
    ${TABLE_HEADER_LIST}=    Get Values In List For Validation    (${AUTHOR_SCREEN_DISPLAYED_TABLE_HEADERS})[INDEX]    1    ${MAX_LIMIT}
    
    IF    '${VISIBILITY}'=='Hidden'

        List Should Not Contain Value    ${TABLE_HEADER_LIST}    Status
        List Should Not Contain Value    ${TABLE_HEADER_LIST}    Document Id
        Length Should Be    ${TABLE_HEADER_LIST}    6

    ELSE IF    '${VISIBILITY}'=='Shown'

        List Should Contain Value    ${TABLE_HEADER_LIST}    Status
        List Should Contain Value    ${TABLE_HEADER_LIST}    Document Id
        Length Should Be    ${TABLE_HEADER_LIST}    8

    END       

Verify The User Can't Hide All The Fields
    [Documentation]    To Verify The User Can't Hide All The Fields
    Click On The Dashboard In Left Navigation
    Navigate To Procedures List Page
    Open Columnizer Flyout Window
    
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_PROCEDURE_NAME_CHECKBOX}
    Element Should Be Disabled    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_PROCEDURE_NAME_CHECKBOX}
    Run Keyword And Ignore Error    Click Element    ${AUTHOR_SCREEN_COLUMNIZER_FLYOUT_PROCEDURE_NAME_CHECKBOX}

    Close Columnizer Flyout Window
    
    #Extract The table headers
    ${MAX_LIMIT}=    Get Element Count    ${AUTHOR_SCREEN_DISPLAYED_TABLE_HEADERS}   
    ${TABLE_HEADER_LIST}=    Get Values In List For Validation    (${AUTHOR_SCREEN_DISPLAYED_TABLE_HEADERS})[INDEX]    1    ${MAX_LIMIT}
    
    List Should Contain Value    ${TABLE_HEADER_LIST}    Procedure Name


Verify The Column Field Names Are Center Aligned
    [Documentation]    To Verify The Column Field Names Are Center Aligned
    
    @{elements}=    Get WebElements    //div[contains(@class,'mat-sort-header-content')]

    # Loop through each element to verify text alignment is 'center'
    FOR    ${element}    IN    @{elements}
#       ${text_align}=    Execute JavaScript    return window.getComputedStyle("//div[contains(@class,'mat-sort-header-content')]").getPropertyValue('');    
#        Should Be Equal As Strings    ${text_align}    center
#       Should Be Equal As Strings    ${text_align}    center
#        get css
        ${text_align}=    Get Property    (//div[contains(@class,'mat-sort-header-content')])    text-align
       Log    Text alignment for column is: ${text_align}
    END


Create The Folder On The Author Screen
    [Documentation]    To Create The Folder On The Author Screen
    Wait Until Element Is Not Visible    ${LoadingBar}  ${MaxTime}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${PROCEDURE_OPTION}
    IF    not ${status}
        Wait Until Keyword Succeeds    10s    2s    Click Element    ${ADD_BUTTON_ON_PROCEDURE_LIST_PAGE}
    END
    Wait For The Element And Click    ${FOLDER_OPTION}


    #Enter Folder details
    ${TD_FOLDER_NAME}=    Generate Random String   
    Set Test Variable    ${TD_FOLDER_NAME}
    Scroll Element And Enter Value    ${FOLDER_NAME_INPUT}    ${TD_FOLDER_NAME}
    Wait For The Element And Click    ${CREATE_FOLDER_BUTTON}
    Wait For The Page To Load

Search Folder On Author Screen
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_FOLDER_NAME}
    Wait For The Page To Load

Delete Folder From More Option
    [Documentation]    To Delete Folder From More Option
    Click Element By JS    ${THREE_DOTS_ICON_PROCEDURE_LIST}
    Click Element By JS    ${DELETE_PROCEDURE_MORE_DROPDOWN}
    Capture Page Screenshot
    Wait For The Element And Click    ${DELETE_POPUP_BUTTON}
    Capture Page Screenshot
    Wait For The Page To Load
    Reload Page

Navigate Inside The Folder On The Author Screen
    [Documentation]    To Navigate Inside The Folder On The Author Screen

    Search Folder On Author Screen
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${FIRST_FOLDER}
    Wait For The Page To Load


Verify The Columnizer For All Persona
    [Documentation]    To Verify The Columnizer For All Persona
    
    ${PERSONA_LIST}=    Create List    ${QA_MANAGER_EMAIL}    ${EXPERT_OPERATOR_EMAIL}    ${SUPERVISOR_EMAIL}    ${OPERATOR1_EMAIL}    ${SITE_ADMIN_EMAIL}    
    FOR    ${PERSONA}    IN    @{PERSONA_LIST}
        Login Again As Persona    ${PERSONA}
        Configure The Visibility Of The Columns On Procedure List Page    Hide
        Verify The Columns On Procedure Page Are     Hidden
        Configure The Visibility Of The Columns On Procedure List Page    Un Hide
        Verify The Columns On Procedure Page Are     Shown
    END
        


Delete The Procedure/Folder From The List Page
    [Documentation]    To Delete The Procedure/Folder From The List Page
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ALL_RECORDS_CHECKBOX_ON_LIST_PAGE}
    Capture Page Screenshot
    Delete Selected Records
    Capture Page Screenshot
    Wait For The Page To Load

    #reload page
    Reload Page
    Wait For The Page To Load

    
    
Duplicate The Created Procedure
    [Documentation]    To Duplicate The Created Procedure
    [Arguments]    ${SKIP_DUPLICATE_VALIDATION}=True
    Click Element By JS    ${AUTHOR_SCREEN_PROCEDURE_ACTIONS_THREE_DOTS}
    Click Element By JS    ${AUTHOR_SCREEN_PROCEDURE_PROCEDURE_DUPLICATE_OPTION}
    Wait For The Element And Click    ${AUTHOR_SCREEN_PROCEDURE_DUPLICATE_POPUP_CONFIRM_BUTTON}
    Wait For The Page To Load
    Capture Page Screenshot
    Return From Keyword If    '${SKIP_DUPLICATE_VALIDATION}'=='True'
    ${PROCEDURE_COUNT_IN_FOLDER}=    Get Current Record Count On Page
    Should Be Equal    ${PROCEDURE_COUNT_IN_FOLDER}    2

Verify Notification Screen Disappears As Soon As User Clicks Anywhere On The Screen
    [Documentation]    To Verify Notification Screen Disappears As Soon As User Clicks Anywhere On The Screen
    Wait For The Element And Click    ${AUTHOR_SCREEN_PROCEDURE_NOTIFICATION_ICON}
    Wait Until Element Is Visible    ${AUTHOR_SCREEN_PROCEDURE_NOTIFICATION_FLYOUT_HEADER}
    Capture Page Screenshot

    Click Element By JS    ${AUTHOR_SCREEN_HEADER_PROCEDURE_NAME}
    Wait Until Element Is Not Visible    ${AUTHOR_SCREEN_PROCEDURE_NOTIFICATION_FLYOUT_HEADER}
    Capture Page Screenshot
=======

Duplicate The Procedure
    Wait Until Element Is Visible    ${ProcedureActionIcon}     ${MaxTime}
    Wait Until Keyword Succeeds    10s    2s    Click Element       ${ProcedureActionIcon}
    Click Element       ${DuplicateProcedure}
    Wait Until Keyword Succeeds    10s    2s    Click Element       ${ConfirmDuplicate}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ButtonSpinner}    ${MaxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible   ${DuplicateInProgressText}   ${MaxTime}
    Element Text Should Be      ${DuplicateInProgressText}       Procedure is being duplicated. Please Wait...
    Wait Until Element Is Not Visible    ${DuplicateInProgressText}    ${MaxTime}

Verify Procedure Is Being Duplicated
     [Arguments]        ${ProcedureStatus}
     Wait For The Page To Load
     Wait Until Element Is Visible    ${StatusTag}
     ${ProcedureStatusTag}=  Get Text    ${StatusTag}
     Should Contain    ${ProcedureStatusTag}       ${ProcedureStatus}

