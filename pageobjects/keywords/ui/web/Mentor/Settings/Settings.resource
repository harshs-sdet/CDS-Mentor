*** Settings ***
Library    SeleniumLibrary
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../Common/Common.resource
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/Settings.yaml
Resource    ../Login/Login.resource

*** Variables ***
${SETTINGS_LIST_PAGE}    ${Url}/settings


*** Keywords ***
Navigate To Settings Page
    [Documentation]    To Navigate To Settings Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
    ${IF_LEFT_NAVIGATION_SETTINGS_TAB_OPEN}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LEFT_NAVIGATION_SETTINGS_TAB}    5s
    IF    '${IF_LEFT_NAVIGATION_SETTINGS_TAB_OPEN}'=='True'
        Click Element    ${LEFT_NAVIGATION_SETTINGS_TAB}
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADMINISTRATION_LINK}
        Repeat Keyword   3x    Press Keys    None    ARROW_DOWN
        Wait For The Element And Click    ${LEFT_NAVIGATION_SETTINGS_TAB}
    END    
    Wait For The Page To Load
    Wait Until Element Is Visible    ${DISPLAY_NAME_LABEL}    ${Max_limit}
#    Mouse Over    ${DISPLAY_NAME_LABEL}
    

Switch To Jobs Tab In Settings Page    
    [Documentation]    To Switch To Jobs Tab In Settings Page
    Wait For The Element And Click    ${JOB_SETTINGS_TAB}
    Wait For The Page To Load

Switch To Site Tab In Settings Page
    [Documentation]    To Switch To Site Tab In Settings Page
    Wait For The Element And Click    ${SITE_SETTINGS_TAB}
    Wait For The Page To Load

Click On The Save Button On Settings Page
    [Documentation]    To Click On The Save Button On Settings Page
    Wait For The Element And Click    ${SETTINGS_SAVE_BUTTON}
    Wait For The Page To Load

Click On The Cancel Button On Settings Page
    [Documentation]    To Click On The Cancel Button On Settings Page
    Wait For The Element And Click    ${SETTINGS_CANCEL_BUTTON}
    Wait For The Page To Load
    Capture Page Screenshot
    
Rename The Job Fields
    [Documentation]    To Rename The Job Fields    
    Scroll Element And Enter Value    ${JOB_NAME_INPUT_SETTINGS}    Job Name Updated


Rename The Procedure Fields
    [Documentation]    To Rename The Procedure Fields
    Scroll Element And Enter Value    ${PROCEDURE_NAME_INPUT}    Procedure Name Updated

Verify The Job Field Name Settings
    [Documentation]    To Verify The Job Field Name Settings
    [Arguments]    ${VALIDATION_PARAMETER}

    Navigate To Job Management Page
    Wait Until Element Is Visible    ${JOB_ORDER_HEADER_JOB_NAME}
    IF    '${VALIDATION_PARAMETER}'=='Applied'
        Element Should Contain    ${JOB_ORDER_HEADER_JOB_NAME}    Job Name Updated
    ELSE
        Element Should Not Contain    ${JOB_ORDER_HEADER_JOB_NAME}    Job Name Updated
    END

    Get The First Job Details
    Navigate To Job Details Page


    IF    '${VALIDATION_PARAMETER}'=='Applied'
        Wait Until Element Is Visible    ${UPDATED_JOB_NAME_LABEL}
        Wait Until Element Is Visible    ${UPDATED_JOB_NAME_INPUT}
    ELSE
        Wait Until Element Is Not Visible    ${UPDATED_JOB_NAME_LABEL}
        Wait Until Element Is Not Visible    ${UPDATED_JOB_NAME_INPUT}
    END



Verify The Procedure Field Name Settings
    [Documentation]    To Verify The Procedure Field Name Settings
    [Arguments]    ${VALIDATION_PARAMETER}

    Navigate To Procedures List Page
    Wait Until Element Is Visible    ${AUTHOR_SCREEN_HEADER_PROCEDURE_NAME}
    IF    '${VALIDATION_PARAMETER}'=='Applied'
        Element Should Contain    ${AUTHOR_SCREEN_HEADER_PROCEDURE_NAME}    Procedure Name Updated
    ELSE
        Element Should Not Contain    ${AUTHOR_SCREEN_HEADER_PROCEDURE_NAME}    Procedure Name Updated
    END
        
    Get The First Procedure Details
    Navigate To Procedure Details Page
    Click On Edit Button On Procedure Details Page

    IF    '${VALIDATION_PARAMETER}'=='Applied'
        Wait Until Element Is Visible    ${UPDATED_PROCEDURE_NAME_LABEL}
        Wait Until Element Is Visible    ${UPDATED_PROCEDURE_NAME_INPUT}
    ELSE
        Wait Until Element Is Not Visible    ${UPDATED_PROCEDURE_NAME_LABEL}
        Wait Until Element Is Not Visible    ${UPDATED_PROCEDURE_NAME_INPUT}
    END



Reset The Job Settings
    [Documentation]    To Reset The Job Settings
    [Arguments]    ${RESET_PARAMETER}
    Navigate To Settings Page
    Switch To Jobs Tab In Settings Page
    
    IF    '${RESET_PARAMETER}'=='Job Name'
        Scroll Element And Enter Value    ${JOB_NAME_INPUT_SETTINGS}    Job Name

    ELSE IF    '${RESET_PARAMETER}'=='Mandatory Field'
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${VERSION_MANDATORY_CHECKBOX}
        ${STATUS}=        Run Keyword And Return Status    Checkbox Should Be Selected    ${VERSION_MANDATORY_CHECKBOX}
        Run Keyword If    ${STATUS}    Click Element    ${VERSION_MANDATORY_CHECKBOX_LABEL}
   END

    Click On The Save Button On Settings Page


Reset The Site Settings
    [Documentation]    To Reset The Site Settings
    [Arguments]    ${RESET_PARAMETER}
    Navigate To Settings Page
    Switch To Site Tab In Settings Page

    IF    '${RESET_PARAMETER}'=='PROCEDURE_NAME'
        Scroll Element And Enter Value    ${PROCEDURE_NAME_INPUT}    Procedure Name


    ELSE IF    '${RESET_PARAMETER}'=='Mandatory Field'
        Repeat Keyword    2x    Press Keys    None    ARROW_DOWN
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX}
        ${STATUS}=        Run Keyword And Return Status    Checkbox Should Be Selected    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX}
        Run Keyword If    ${STATUS}    Click Element    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX_LABEL}
        Sleep    5s
        Checkbox Should Not Be Selected    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX}
    END
    Click On The Save Button On Settings Page
    
Set The Job Fields Mandatory
    [Documentation]    To Set The Job Fields Mandatory
    
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${VERSION_MANDATORY_CHECKBOX}
    ${STATUS}=        Run Keyword And Return Status    Checkbox Should Not Be Selected    ${VERSION_MANDATORY_CHECKBOX}
    Run Keyword If    ${STATUS}    Click Element    ${VERSION_MANDATORY_CHECKBOX_LABEL}

Set The Procedure Fields Mandatory
    [Documentation]    To Set The Procedure Fields Mandatory
    
    Repeat Keyword    2x    Press Keys    None    ARROW_DOWN
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX}
    ${STATUS}=        Run Keyword And Return Status    Checkbox Should Not Be Selected    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX}
    Run Keyword If    ${STATUS}    Click Element    ${SIGNOFF_MANAGER_MANDATORY_CHECKBOX_LABEL}


Verify The Job Field Set 
    [Documentation]    ToVerify The Job Field Set 
    [Arguments]    ${RESET_PARAMETER}
    
    Create Sample Job With Mandatory Fields       CUSTOM_MATERIAL_NUMBER=RandomMatNumber
    IF    '${RESET_PARAMETER}'=='Mandatory'
        Wait For The Element And Click    ${JobNext_Done}
        Click On Create Job Button
        Wait Until Page Contains    Version is required

    ELSE IF    '${RESET_PARAMETER}'=='Not Mandatory'
        Wait For The Element And Click    ${JobNext_Done}
        Add The Procedure To Job
        Click On Create Job Button
        Wait For The Page To Load
        Verify User Lands On The Job Order Page

    ELSE IF    '${RESET_PARAMETER}'=='Hide'

        Page Should Not Contain Element    ${PRODUCTION_PLANT_INPUT}

    ELSE IF    '${RESET_PARAMETER}'=='Not Hide'

        Page Should Contain Element    ${PRODUCTION_PLANT_INPUT}

    END
    

Verify The Procedure Field Set 
    [Documentation]    To Verify The Procedure Field Set
    [Arguments]    ${RESET_PARAMETER}
    
    User Clicks on Add Button On Procedures List Page
    User Adds General Details

    IF    '${RESET_PARAMETER}'=='Mandatory'
        User Add Step To Procedure
        Wait Until Element Is Visible    ${Publish Procedure}
        Element Should Be Disabled    ${Publish Procedure}    
        
    ELSE IF   '${RESET_PARAMETER}'=='Not Mandatory'
        User Add Step To Procedure
        User Publishes The Procedure    IGNORE_VERSION=True
        User Adds Release Notes
        Wait For The Page To Load
        Verify User Lands On The Procedure List Page

    ELSE IF   '${RESET_PARAMETER}'=='Hide'
        Page Should Not Contain Element    ${HIDDEN_LANGUAGE_DROPDOWN}

    ELSE IF    '${RESET_PARAMETER}'=='Not Hide'
        
        Page Should Contain Element    ${HIDDEN_LANGUAGE_DROPDOWN}
    END
    

Hide/Unhide The Job Fields
    [Documentation]    To Hide The Job Fields
    [Arguments]    ${ACTION}

    Navigate To Settings Page
    Switch To Jobs Tab In Settings Page

    Wait Until Element Is Visible    ${PRODUCTION_PLANT_TOGGLE_BUTTON}
    ${CLASS_LIST}=    Get Element Attribute    ${PRODUCTION_PLANT_TOGGLE_BUTTON}    class
    ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}
    IF    '${ACTION}'=='Hide'
        Run Keyword If    'mdc-switch--selected' in ${CLASS_LIST}    Click Element    ${PRODUCTION_PLANT_TOGGLE_BUTTON}
    ELSE IF    '${ACTION}'=='Un Hide'
        Run Keyword If    'mdc-switch--unselected' in ${CLASS_LIST}    Click Element    ${PRODUCTION_PLANT_TOGGLE_BUTTON}
    END
    Click On The Save Button On Settings Page

Hide/Unhide The Procedure Fields
    [Documentation]    To Hide The Procedure Fields
    [Arguments]    ${ACTION}

    Navigate To Settings Page
    Switch To Site Tab In Settings Page

    Wait Until Element Is Visible    ${LANGUAGE_DROPDOWN_TOGGLE_BUTTON}
    ${CLASS_LIST}=    Get Element Attribute    ${LANGUAGE_DROPDOWN_TOGGLE_BUTTON}    class
    ${CLASS_LIST}=    Split String    ${CLASS_LIST}    ${SPACE}


    IF    '${ACTION}'=='Hide'
        Run Keyword If    'mdc-switch--selected' in ${CLASS_LIST}    Click Element    ${LANGUAGE_DROPDOWN_TOGGLE_BUTTON}
    ELSE IF    '${ACTION}'=='Un Hide'
        Run Keyword If    'mdc-switch--unselected' in ${CLASS_LIST}    Click Element    ${LANGUAGE_DROPDOWN_TOGGLE_BUTTON}
    END
    
    Click On The Save Button On Settings Page

Configure The Fields To Appear When Creating A New Procedure
    [Documentation]    To Configure The Fields To Appear When Creating A New Procedure
    [Arguments]    ${FORM_FILLING}    ${AUTO_GENERATE}=None    ${PREFIX/SUFFIX_VALUE}=MAT
    
    Repeat Keyword    5x    Press Keys    ${SETTINGS_DESCRIPTION_SITE_TAB}    ARROW_DOWN

    IF    '${FORM_FILLING}'=='FREE_FORM'
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SITE_SETTING_FREE_FORM_RADIO}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${SITE_SETTING_FREE_FORM_RADIO}

    ELSE IF    '${FORM_FILLING}'=='AUTO_GENERATE'
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SITE_SETTING_AUTO_GENERATE_RADIO}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${SITE_SETTING_AUTO_GENERATE_RADIO}
        IF    '${AUTO_GENERATE}'=='PREFIX'
            Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SITE_SETTING_AUTO_GENERATE_PREFIX_RADIO}
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${SITE_SETTING_AUTO_GENERATE_PREFIX_RADIO}
            Scroll Element And Enter Value    ${SETTINGS_DOCID_PREFIX_INPUT}    ${PREFIX/SUFFIX_VALUE}
        ELSE IF    '${AUTO_GENERATE}'=='SUFFIX'
            Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SITE_SETTING_AUTO_GENERATE_SUFFIX_RADIO}
            Wait Until Keyword Succeeds    5x    1s    Click Element    ${SITE_SETTING_AUTO_GENERATE_SUFFIX_RADIO}
            Scroll Element And Enter Value    ${SETTINGS_DOCID_SUFFIX_INPUT}    ${PREFIX/SUFFIX_VALUE}
        END
    END


Verify The New Procedure Page With Updated Settings
    [Documentation]    To Verify The New Procedure Page With Updated Settings
    [Arguments]    ${FORM_FILLING}    ${AUTO_GENERATE}=None    ${CHANGES_REVERTED}=None    ${BLANK_DOCUMENT_ID}=False    ${BLANK_PREFIX_SUFFIX_VALUE}=False
    
    Navigate To Procedures List Page
    User Clicks on Add Button On Procedures List Page
    User Adds General Details  ${FORM_FILLING}    ${AUTO_GENERATE}    ${CHANGES_REVERTED}    ${BLANK_DOCUMENT_ID}    ${BLANK_PREFIX_SUFFIX_VALUE}
    User Add Step To Procedure
    User Publishes The Procedure
    User Adds Release Notes
    Wait For The Page To Load
    Verify User Lands On The Procedure List Page


Verify That The Document ID Is Auto-Generated When An Author Edits A Procedure
    [Documentation]    To verify That The Document ID Is Auto-Generated When An Author Edits A Procedure   
    [Arguments]    ${NOT_AUTOGENERATED}=False
    Wait Until Element Is Visible    ${DOCUMENT_ID_INPUT}

    Training.Generate Unique Number
    Input Text    ${Material_Number}    MAT-${UniqueNumberTest}

    
    IF    '${NOT_AUTOGENERATED}'=='True'
        Element Attribute Value Should Be   ${DOCUMENT_ID_INPUT}    value    ${TD_DOCUMENT_ID}
    ELSE
        Element Attribute Value Should Be   ${DOCUMENT_ID_INPUT}    value    ${TD_MATERIAL_NUMBER}-MAT
    END        

Verify The Dropdown Fields Are Not Scannable In Site Settings
    [Documentation]    To Verify The Dropdown Fields Are Not Scannable In Site Settings

    Reload Page
    Wait For The Page To Load

    Element Should Be Enabled    ${SETTINGS_PROCEDURE_NAME_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_DOCUMENT_ID_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_MATERIAL_ID_SCANNABLE_CHECKBOX}
    Element Should Be Disabled    ${SETTINGS_CO_AUTHOR_SCANNABLE_CHECKBOX}
    Element Should Be Disabled    ${SETTINGS_SIGNOFF_MANAGERS_SCANNABLE_CHECKBOX}
    Element Should Be Disabled    ${SETTINGS_APPROVAL_MANAGERS_SCANNABLE_CHECKBOX}
    Element Should Be Disabled    ${SETTINGS_TAGS_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_LANGUAGE_SCANNABLE_CHECKBOX}
    Element Should Be Disabled    ${SETTINGS_CYCLE_TIME_SCANNABLE_CHECKBOX}


Verify The Dropdown Fields Are Not Scannable In Job Settings
    [Documentation]    To Verify The Dropdown Fields Are Not Scannable In Job Settings

    Reload Page
    Wait For The Page To Load

    Element Should Be Enabled    ${SETTINGS_JOB_ID_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_JOB_NAME_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_JOB_MATERIAL_ID_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_PRODUCTION_PLANT_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_PO_NUMBER_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_BATCH_NUMBER_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_VERSION_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_SALES_ORDER_NUMBER_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_ORDER_TYPE_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_MRP_CONTROLLER_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_STORAGE_LOCATION_SCANNABLE_CHECKBOX}
    Element Should Be Enabled    ${SETTINGS_QUANTITY_TIME_SCANNABLE_CHECKBOX}

