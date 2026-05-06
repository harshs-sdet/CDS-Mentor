*** Settings ***
Library    SeleniumLibrary
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../Common/Common.resource
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Variables   ../../../../../locators/ui/web/Mentor/Workspace.yaml
Resource    ../Login/Login.resource

*** Variables ***
${WORKSPACE_LIST_PAGE}    ${Url}/workspaces
${TF_NewWorkspacePageActionData}    ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}PageActionData${/}NewWorkspacePageActionData.csv
${TD_WORKSPACE_DESC_201_LENGTH}    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
${TD_WORKSPACE_DESC_200_LENGTH}    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa


*** Keywords ***
Click On Workspace Management Button
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Page Contains Element    ${ManageWorkspace}     ${MaxTime}
    Click Element    ${ManageWorkspace}

Click On Create Button On Workspace List Page
    [Documentation]    To Click On Create Button On Workspace List Page
    Wait For The Element And Click    ${CREATE_NEW_WORKSPACE}


Verify The Work Instruction Column Is Removed From The Workspace Management Page
    [Documentation]    To Verify The Work Instruction Column Is Removed From The Workspace Management Page
    Page Should Not Contain Element    ${WI_COLUMN_ON_WORKSPACE_LIST_PAGE}
    Capture Page Screenshot




Click On Create Button On Enter New Workspace Details Page
    [Documentation]    To Click On Create Button On Enter New Workspace Details Page
    Wait For The Element And Click    ${DETAILS_PAGE_CREATE_BUTTON}

    #Wait Until page is fully loaded
    Wait For The Page To Load

    #homepage validation
    Wait Until Location Is    ${WORKSPACE_LIST_PAGE}    ${Max_limit}
    Run Keyword And Ignore Error    Click Element   //div[contains(@class,"toast-message")]
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${ZERO_RECORDS}    ${Max_limit}


Enter The Mandatory Details
    Wait Until Page Contains Element    ${WorkspaceNameInput}       ${MaxTime}
    Input Text    ${WorkspaceNameInput}    ${WorkspaceName}

Enter The Optional Details
    Wait Until Page Contains Element    ${WorkspaceDescriptionInput}       ${MaxTime}
    Input Text    ${WorkspaceDescriptionInput}    ${WorkspaceDescription}

Select WORKSPACE
    Click Element    ${WORKSPACESelection}

Search the WorkInstructions/procedures Using Tags
    [Arguments]     ${Bool}     ${TagName}
    IF    ${Bool} == "True"
        Input Text    ${SearchTag}    ${TagName}
        Click Element    ${SuggestedTags}
    END

Click on Add Button
    Click Element    ${AddWorkspaceButton}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

Add WorkInstructions
    Wait Until Page Contains Element    ${Count}        ${MaxTime}

Add Procedures
Click On Save
Verify Workspace Has been Created

#New

Navigate To Workspace List Page
    [Documentation]    To Navigate To Workspace List Page
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${if_workspace_tab_open}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${WORKSPACE_TAB}    5s
    IF    '${if_workspace_tab_open}'=='True'
        Click Element    ${WORKSPACE_TAB}
        Return From Keyword
    ELSE
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADMINISTRATION_LINK}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${WORKSPACE_TAB}
    END    
    Wait For The Page To Load
    Wait Until Element Is Visible    ${CREATE_NEW_WORKSPACE}    ${Max_limit}
    Mouse Over    ${CREATE_NEW_WORKSPACE}

Enter The Duplicate Workspace Name
    Input Text    ${INPUT_WORKSPACE_NAME}    ${TD_WORKSPACE_NAME}

Create The Workspace
    Wait For The Element And Click    ${DETAILS_PAGE_CREATE_BUTTON}

Verify The Toaster Message
    Wait Until Page Contains    Workspace already exists

Select The Site From The Dropdown
    Click Element    ${SITE_DROPDOWN}
    TRY
        Select Newly Created Site
    EXCEPT
#        ${site_index}=    Generate Random Number Between Range As String    3    10
        ${site_index}=  Set Variable    3
        ${locator}=    Replace String    ${SITE_OPTION_INDEX}    INDEX    ${site_index}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
        ${TD_WORKSPACE_SITE}=    Get Text    ${locator}
        Set Test Variable    ${TD_WORKSPACE_SITE}
        Wait For The Element And Click    ${locator}
    END

Enter The Workspace Detail
    [Documentation]    To Enter The WORKSPACE Detail
    #WORKSPACE Name
    ${TD_WORKSPACE_NAME}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_NAME}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_NAME}    ${TD_WORKSPACE_NAME}


    #Description
    ${TD_WORKSPACE_DESC}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_DESC}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_DESCRIPTION}   ${TD_WORKSPACE_DESC}

    #Site
    Click Element    ${SITE_DROPDOWN}
    TRY
        Select Newly Created Site
    EXCEPT
#        ${site_index}=    Generate Random Number Between Range As String    3    10
        ${site_index}=  Set Variable    3
        ${locator}=    Replace String    ${SITE_OPTION_INDEX}    INDEX    ${site_index}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
        ${TD_WORKSPACE_SITE}=    Get Text    ${locator}
        Set Test Variable    ${TD_WORKSPACE_SITE}
        Wait For The Element And Click    ${locator}
    END

Verify The User Is Not Able Create Empty Workspace
    [Documentation]    To Verify The User Is Not Able Create Empty Workspace

    #Description
    ${TD_WORKSPACE_DESC}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_DESC}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_DESCRIPTION}   ${TD_WORKSPACE_DESC}

    #Site
    Click Element    ${SITE_DROPDOWN}
    TRY
        Select Newly Created Site
    EXCEPT
#        ${site_index}=    Generate Random Number Between Range As String    3    10
        ${site_index}=  Set Variable    3
        ${locator}=    Replace String    ${SITE_OPTION_INDEX}    INDEX    ${site_index}
        Wait Until Page Contains Element    ${locator}    ${Max_limit}
        ${TD_WORKSPACE_SITE}=    Get Text    ${locator}
        Set Test Variable    ${TD_WORKSPACE_SITE}
        Wait For The Element And Click    ${locator}
    END

    Wait For The Element And Click    ${DETAILS_PAGE_CREATE_BUTTON}
    Wait Until Page Contains    Please enter valid information for Name
    Capture Page Screenshot

Verify The Input Field Validation On New Workspace Page
    [Documentation]    To Verify The Input Field Validation On New Workspace Page
    Wait For The Element And Click   ${DETAILS_PAGE_CREATE_BUTTON}
    Wait Until Element Is Visible    ${WORKSPACE_NAME_VALIDATION_TOASTER}

    #Enter Name
    ${TD_WORKSPACE_NAME}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_NAME}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_NAME}    ${TD_WORKSPACE_NAME}


    Wait For The Element And Click   ${DETAILS_PAGE_CREATE_BUTTON}
    Wait Until Element Is Visible    ${WORKSPACE_SITE_VALIDATION_TOASTER}

    #Select Site
    Select Custom Site On Workspace Details Page    ${TD_SITE_NAME}

    #Description
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_DESCRIPTION}   ${TD_WORKSPACE_DESC_201_LENGTH}

Validate The Workspace Description
    [Documentation]    To Validate The Workspace Description
    ${TEMP}=    Get Element Attribute    ${INPUT_WORKSPACE_DESCRIPTION}    value
    Should Be Equal    ${TEMP}    ${TD_WORKSPACE_DESC_200_LENGTH}

Select Newly Created Site 
    [Documentation]    To Select Newly Created Site
    Scroll Element And Enter Value    ${SEARCH_EXISTING_SITE}    ${TD_SITE_NAME}
    ${locator}=    Replace String    ${EXISTING_SITE_OPTION}    SITE    ${TD_SITE_NAME}
    Wait For The Element And Click    ${locator}


Select Custom Site On Workspace Details Page  
    [Documentation]    To Select Custom Site On Workspace Details Page
    [Arguments]    ${SITE_NAME}
    Click Element    ${SITE_DROPDOWN}
    Scroll Element And Enter Value    ${SEARCH_EXISTING_SITE}    ${SITE_NAME}
    ${locator}=    Replace String    ${EXISTING_SITE_OPTION}    SITE    ${SITE_NAME}
    Wait For The Element And Click    ${locator}


Update The Workspace Detail
    [Documentation]    To Update The Workspace Detail
    #WORKSPACE Name
    ${TD_WORKSPACE_NAME}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_NAME}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_NAME}    ${TD_WORKSPACE_NAME}

    #Description
    ${TD_WORKSPACE_DESC}=    Generate Random String
    Set Test Variable    ${TD_WORKSPACE_DESC}
    Scroll Element And Enter Value    ${INPUT_WORKSPACE_DESCRIPTION}   ${TD_WORKSPACE_DESC}

Click On Save Button On New Workspace Window
    [Documentation]    To Click On Save Button On New Workspace Window
    Wait For The Element And Click    ${WORKSPACE_DETAIL_SAVE_BUTTON}
    
Verify The New Created Workspace
    [Documentation]    To Verify The New Created Workspace
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_WORKSPACE_NAME}
    Wait Until Element Is Visible    ${SEARCHED_WORKSPACE_ON_WORKSPACE_LIST}
    ${WORKSPACE_SEARCHED_STOREFRONT}=    Get Text    ${SEARCHED_WORKSPACE_ON_WORKSPACE_LIST}
    Should Be Equal As Strings    ${WORKSPACE_SEARCHED_STOREFRONT}    ${TD_WORKSPACE_NAME}

Verify The New Created Workspace Should Not Be Visible
    [Documentation]    To Verify The New Created Workspace Should Not Be Visible
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_WORKSPACE_NAME}
    Press Keys    ${INPUT_SEARCH}    ENTER
    Sleep    2s
    Wait Until Element Is Visible   ${ZERO_RECORDS}    ${MaxTime}
    Sleep    2s
    Element Should Be Visible    ${ZERO_RECORDS}

Delete The Workspace
    [Documentation]    To Delete and verify The Deleted Workspace
    Retry Until Element Clickable    ${DELETE_ICON}
    Wait For The Element And Click    ${DELETE_POPUP}
    Wait For The Page To Load
#    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_WORKSPACE_NAME}
#    Wait Until Element Is Visible    ${NO_WORKSPACE_FOUND}    ${Max_limit}
#
#    #Other Skill records after deleting a Workspace
#    Clear Element Text    ${INPUT_SEARCH}
#    Reload Page
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LoadingBar}    ${MaxTime}
    Clear The Search Input Box


Click On Edit Button On Workspace Details Page
    [Documentation]    To Click On Edit Button On Workspace Details Page
    Wait For The Element And Click    ${EDIT_WORKSPACE}
    Wait For The Page To Load


Validate The Updated Workspace Details
    [Documentation]    To Validate The Updated Workspace Details

    #Workspace Name
    ${WORKSPACE_NAME_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_WORKSPACE_NAME}    value
    Check The Strings Are Equal    ${WORKSPACE_NAME_FROM_STOREFRONT}    ${TD_WORKSPACE_NAME}

    #Description
    ${WORKSPACE_DESC_FROM_STOREFRONT}=    Get Element Attribute    ${INPUT_WORKSPACE_DESCRIPTION}    value
    Check The Strings Are Equal    ${WORKSPACE_DESC_FROM_STOREFRONT}    ${TD_WORKSPACE_DESC}


Navigate To Workspace Details Page
    [Documentation]    To Navigate To Workspace Details Page
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${TD_WORKSPACE_NAME}
    Wait Until Element Is Visible    ${FIRST_WORKSPACE_ON_LIST_PAGE}
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${FIRST_WORKSPACE_ON_LIST_PAGE}
    Wait For The Page To Load
    Wait Until Page Does Not Contain Element    ${CREATE_NEW_WORKSPACE}    ${Max_limit}

Ensure Workspace List Page Is Open
    [Documentation]    To Ensure Workspace List Page Is Open

    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CREATE_NEW_WORKSPACE}    ${Max_limit}
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    Reload Page
    Wait For The Page To Load

    Sleep    2s
    ${status}=    Run Keyword And Return Status    Navigate To Workspace List Page
    Run Keyword If    ${status}    RETURN FROM KEYWORD

    # Final fallback: restart browser
    Close Browser
    Login To Mentor Application    ${OrgAdmin2}    ${OrgAdminPass2}
    Navigate To Workspace List Page


Click On Cancel Button On New Workspace Window
    [Documentation]    To Click On Cancel Button On New Workspace Window
    Wait For The Element And Click    ${CANCEL_BUTTON_ON_EDIT_WORKSPACE_PAGE}

Verify User Lands On The Workspace List Page
    [Documentation]    To Verify User Lands On The Workspace List Page
    Wait Until Location Is    ${WORKSPACE_LIST_PAGE}    ${Max_limit}

Get The First Workspace Details
    [Documentation]    To Get The First Workspace Details
    Wait Until Element Is Visible    ${FIRST_WORKSPACE_ON_LIST_PAGE}    ${Max_limit}
    ${TD_WORKSPACE_NAME}=    Get Text    ${FIRST_WORKSPACE_ON_LIST_PAGE}
    Set Test Variable    ${TD_WORKSPACE_NAME}

Get The Workspace Data From List page
    [Documentation]    To Get The Workspace Data, User should be logged in as Site admin to get all site workspaces
    Navigate To Workspace List Page
    Wait Until Element Is Visible    ${WORKSPACE_RECORD_LISTED_ON_LIST_PAGE}
    ${MAX_LIMIT}=    Get Element Count    ${WORKSPACE_RECORD_LISTED_ON_LIST_PAGE}
    ${EXTRACTED_WORKSPACE_LIST}=    Get Values In List For Validation    (${WORKSPACE_RECORD_LISTED_ON_LIST_PAGE})[INDEX]    1    ${MAX_LIMIT}
    Set Test Variable    ${EXTRACTED_WORKSPACE_LIST}

Verify The Workspace Name is Displayed In The Breadcrumbs
    [Documentation]    To Verify The Workspace Name is Displayed In The Breadcrumbs
    ${locator}=    Replace String    ${BREADCRUMBS_WORKSPACE}    WORKSPACE   ${TD_WORKSPACE_NAME}
    Wait Until Element Is Visible    ${locator}    ${Max_limit}


Click On Workspace Link In Breadcrumb
    [Documentation]    To Click On Workspace Link In Breadcrumb
    Wait For The Element And Click    ${LINK_WORKSPACE_PAGE}
    Wait For The Page To Load
    Wait Until Element Is Not Visible    ${LINK_WORKSPACE_PAGE}    ${Max_limit}

Select The Tags On New Workspace Page
    [Documentation]    To Select The Tags On New Workspace Page
    GetTestDataVariables    ${TF_NewWorkspacePageActionData}    Tags
    Wait For The Element And Click    ${VIEW_ALL_TAGS}
    Scroll Element And Enter Value    ${INPUT_SEARCH_TAG}    ${PAD_Tag}
    ${locator}=    Replace String    ${SEARCHED_TAG}    TAG    ${PAD_Tag}
    Wait For The Element And Click    ${locator}
    
    #Tags is selected
    Wait Until Element Is Visible    ${SEARCHED_TAG}
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${CLOSE_TAG_PANEL}



Validate The Tags Of The Procedures
    [Documentation]    To Validate The Tags Of The Procedures
    [Arguments]    ${flag}
#    Wait For The Element And Click    ${PROCEDURES_WINDOW_ON_NEW_WORKSPACE_SCREEN}
    @{TAGS_LIST}=    Create List
    ${NO_OF_PROCEDURES}=    Get Element Count    ${PROCEDURE_TAGS_TEXT}
#    IF    '${flag}'=='Before Saving'
#        Set Test Variable    ${PROCEDURES_COUNT_BEFORE_ADDING}    ${NO_OF_PROCEDURES}
#    ELSE IF    '${flag}'=='After Saving'
#        Check The Strings Are Equal    ${PROCEDURES_COUNT_BEFORE_ADDING}    ${NO_OF_PROCEDURES}
#    END
    ${TAGS_LIST}=    Get Values In List For Validation    (${PROCEDURE_TAGS_TEXT})[INDEX]    1    ${NO_OF_PROCEDURES}
    Validate The Extracted List Data    ${TAGS_LIST}    ${PAD_Tag}


Add The Selected Procedures To Workspace
    [Documentation]    To Add The Selected Procedures To Workspace
    [Arguments]    ${flag}=False
    Wait For The Element And Click    ${ADD_PROCEDURE_TO_WORKSPACE_BUTTON_ON_WORKSPACE_DETAILS_PAGE}
    IF    '${flag}'=='Pre-Selected'
        Wait For The Element And Click    ${ADD_PROCEDURES_UNDER_WORKSPACE_BUTTON}
        Wait For The Page To Load
        Return From Keyword
    END
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_ALL_PROCEDURES_TO_WORKSPACE_CHECKBOX}
    ${ADDED_PROCEDURES_IN_WORKSPACE_COUNT}=    Get Record Count In Pop-up Window    (//div[contains(@class,"mat-mdc-paginator-range-label")])[2]
    Set Test Variable    ${ADDED_PROCEDURES_IN_WORKSPACE_COUNT}
    Wait For The Element And Click    ${ADD_PROCEDURES_UNDER_WORKSPACE_BUTTON}
    Wait For The Page To Load

Verify The Correct Numbers Of Procedures Added
    [Documentation]    To Verify The Correct Numbers Of Procedures Added
    Wait For The Element And Click    ${PROCEDURES_WINDOW_ON_NEW_WORKSPACE_SCREEN}
    ${NO_OF_PROCEDURES}=    Get Element Count   //tr[contains(@class,"mat-mdc-row")]    #Get Text    ${TOTAL_ADDED_PROCEDURES}
    Check The Strings Are Equal    ${NO_OF_PROCEDURES}    ${ADDED_PROCEDURES_IN_WORKSPACE_COUNT}

Verify The Procedures Are Removed When Removing The Tag
    [Documentation]    To Verify The Procedures Are Removed When Removing The Tag
    Scroll Element Into View    ${REMOVE_PROCEDURE_TAG}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${REMOVE_PROCEDURE_TAG}
    Wait For The Page To Load
    Wait Until Element Is Visible     ${NO_PROCEDURES_ADDED}    ${Max_limit}

Verify The Table Column Labels On Workspace List Page
    [Documentation]    To Verify The Table Column Labels On Workspace List Page
    Wait Until Element Is Visible    ${LABEL_NAME}    ${Max_limit}
    ${name_label_text}=    Get Text    ${LABEL_NAME}
    Should Be Equal As Strings    ${name_LABEL_TEXT}      Name
    ${DESC_LABEL_TEXT}=    Get Text    ${LABEL_DESC}
    Should Be Equal As Strings    ${DESC_LABEL_TEXT}     Description
    ${TAG_LABEL_TEXT}=    Get Text    ${LABEL_TAGS}
    Should Be Equal As Strings    ${TAG_LABEL_TEXT}      Tags
#    ${WI_LABEL_TEXT}=    Get Text    ${LABEL_WI}
#    Should Be Equal As Strings    ${WI_LABEL_TEXT}      Work Instructions
    ${PROCEDURES_LABEL_TEXT}=    Get Text    ${LABEL_PROCEDURES}
    Should Be Equal As Strings    ${PROCEDURES_LABEL_TEXT}      Procedures
    ${SITE_LABEL_TEXT}=    Get Text    ${LABEL_SITE_Workspace}
    Should Be Equal As Strings    ${SITE_LABEL_TEXT}      Site/Company
    ${ACTION_LABEL_TEXT}=    Get Text    ${LABEL_ACTION_Workspace}
    Should Be Equal As Strings    ${ACTION_LABEL_TEXT}      Actions

Verify All The Sites Are Displayed In The Dropdown
    [Documentation]    To Verify All The Sites Are Displayed In The Dropdown
    Wait For The Element And Click    ${SITE_DROPDOWN}
    Sleep    2s
    ${END_LIMIT}=    Get Element Count    ${ALL_SITES_OPTION}
    @{ALL_SITES_ON_NEW_WORKSPACE}=    Get Values In List For Validation    ${SITE_OPTION}    3    ${END_LIMIT}
    Log Many    ${ALL_SITES}
    Log Many    ${ALL_SITES_ON_NEW_WORKSPACE}
    Lists Should Be Equal    ${ALL_SITES}    ${ALL_SITES_ON_NEW_WORKSPACE}
    FOR    ${ITEM}    IN    @{ALL_SITES_ON_NEW_WORKSPACE}
        List Should Contain Value    ${ALL_SITES}    ${ITEM}
    END

Verify The Pagination On Add Procedures Window
    [Documentation]    To Verify The Pagination On Add Procedures Window
    Wait For The Element And Click    ${ADD_PROCEDURE_TO_WORKSPACE_BUTTON_ON_WORKSPACE_DETAILS_PAGE}
#    Wait For The Element And Click    ${PROCEDURES_WINDOW_ON_ADD_PROCEDURES_SCREEN}
    Verify The Pagination On Custom Page     ${INSIDE_PAGE_SIZE_SELECT}    ${INSIDE_RECORDS_COUNT}    ${INSIDE_PAGINATION_NEXT_PAGE}


Validate The Correct Filtered Workspaces Shown
    [Documentation]    To Validate The Correct Filtered Workspaces Shown
    @{FILTERED_WORKSPACES}=    Get The Filtered Record Results Shown    ${TAGGED_WORKSPACE_FILTERED_RECORDS}
    FOR    ${ITEM}    IN    @{FILTERED_WORKSPACES}
        Should Contain Match    ${LIST_OF_FILTERS_APPLIED}    ${ITEM}*
    END


Select The Filters On Workspaces List Page
    [Documentation]    To Select The Filters On Workspaces List Page
    Set Selenium Speed    0.3s
    Click Element     ${WORKSPACE_FILTER}
    @{LIST_OF_FILTERS_APPLIED}=    Create List
    FOR     ${i}    IN RANGE    1    2
        ${i}=    Evaluate    str(${i})
        ${locator}=    Replace String    ${OPTION_TAGS_FILTER}    INDEX    ${i}
        Wait For The Element And Click    ${locator}
        ${FILTER_LISTED}=    Get Text    ${locator}
        ${FILTER_LISTED}=    Strip String    ${FILTER_LISTED}
        Append To List    ${LIST_OF_FILTERS_APPLIED}    ${FILTER_LISTED}
    END
    Set Test Variable    ${LIST_OF_FILTERS_APPLIED}
    Set Selenium Speed    0s


Validate The Procedures Of The Workspace
    [Documentation]    To Validate The Procedures Of The Workspace
    ${COUNT}=    Get Current Record Count On Page    
    Should Be Equal As Strings    ${COUNT}    1
    
Get Procedure To Associate With Workspace    
    [Documentation]    To Create Procedure To Associate With Workspace
    Click On The Dashboard In Left Navigation
    Navigate To Procedures List Page
    ${MAX_LIMIT}=    Get Element Count    ${PROCEDURES_LISTED_ON_LIST_PAGE} 
    
    ${ADD_PROCEDURE_TO_WORKSPACE_LIST}=    Get Values In List For Validation    (${PROCEDURES_LISTED_ON_LIST_PAGE})[INDEX]    1    ${MAX_LIMIT}
    Set Test Variable    ${ADD_PROCEDURE_TO_WORKSPACE_LIST}    ${ADD_PROCEDURE_TO_WORKSPACE_LIST[:5]}
    
    
Add The Procedures To Workspace
    [Documentation]    To Add The Procedures To Workspace
    Wait For The Element And Click    ${ADD_PROCEDURE_TO_WORKSPACE_BUTTON_ON_WORKSPACE_DETAILS_PAGE}

    FOR    ${PROCEDURE}    IN    @{ADD_PROCEDURE_TO_WORKSPACE_LIST}
        Scroll Element And Enter Value    (${INPUT_SEARCH})[2]    ${PROCEDURE}
        ${LOCATOR}=    Replace String    ${SEARCHED_PROCEDURE_IN_WORKSPACE}    PROCEDURENAME    ${PROCEDURE}
        Wait Until Keyword Succeeds    5x    1s    Click Element    ${LOCATOR}
    END
    
    Verify Search Button Functionality On Workspace Tab Add Workspace Window
    Wait For The Element And Click    ${DONE_BUTTON_IN_ADD_PROCEDURE_IN_WORKSPACE}

Verify Search Button Functionality On Workspace Tab Add Workspace Window
    [Documentation]    To Verify Search Button Functionality On Workspace Tab Add Workspace Window
    Clear Element Text     (${INPUT_SEARCH})[2]
    Press Keys     (${INPUT_SEARCH})[2]    ENTER
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
    ${BEFORE_SEARCH_ALL_RECORDS}=    Get Record Count In Pop-up Window    (${POP_UP_WINDOW_RECORDS_COUNT})[2]
    Scroll Element And Enter Value    (${INPUT_SEARCH})[2]    INVLD_VAL

    Repeat Keyword    25x    Press Keys    (${INPUT_SEARCH})[2]    BACKSPACE
    Press Keys     (${INPUT_SEARCH})[2]    ENTER
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}

    ${AFTER_SEARCH_ALL_RECORDS}=    Get Record Count In Pop-up Window    (${POP_UP_WINDOW_RECORDS_COUNT})[2]

    Should Be Equal    ${AFTER_SEARCH_ALL_RECORDS}    ${BEFORE_SEARCH_ALL_RECORDS}

Search For The Site Admin
    [Arguments]     ${SITE_ADMIN_EMAILID}
    Scroll Element And Enter Value    ${INPUT_SEARCH}    ${SITE_ADMIN_EMAILID}

Capture The Site Name
    Wait Until Element Is Visible     ${SiteElement}    ${MaxTime}
    Capture Page Screenshot
    ${SiteTitle}=   Get Text       ${SiteElement}
    Set Global Variable       ${SiteTitle}

Verify Site Name Is Displayed In The Dropdown
    Wait For The Element And Click    ${SITE_DROPDOWN}
    Capture Page Screenshot
    Sleep    2s
    ${END_LIMIT}=    Get Element Count    ${ALL_SITES_OPTION}
    ${limit}=   Convert To Integer      3
    Should Be Equal      ${END_LIMIT}       ${limit}
    ${ExtractedSite}=   Get Text    (${ALL_SITES_OPTION})[${END_LIMIT}]
    ${ExtractedSite}=   Strip String     ${ExtractedSite}
    Should Be Equal     ${ExtractedSite}        ${SiteTitle}

Clear The Search Input Box
    Wait Until Element Is Visible    ${INPUT_SEARCH}    timeout=10s
    Click Element    ${INPUT_SEARCH}
    Clear Element Text    ${INPUT_SEARCH}  
    Press Keys    ${Input_Search}    ENTER  
    