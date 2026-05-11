*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    FakerLibrary
Library    BuiltIn
Library    Collections
Library    OperatingSystem
Resource    ../Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../Common/Common.resource
Variables      ../../../../../locators/ui/web/Mentor/ProductionPlant.yaml
Resource    ../Workspace/Workspace.resource
Resource    ../SiteManagement/SiteManagement.resource
Resource    ../UserManagement/UserManagement2.resource
Resource    ../UserManagement/Teams.resource

*** Keywords ***
User Navigates to Production Plant Screen
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxLimit}
    Click Element    ${PlantTab}
    Wait Until Element Is Visible    ${AddNewPlant}         ${maxTime}

 User Clicks On Add Plant Button
    ${status}=      Run keyword and return status     Element Should Be Visible    ${AddNewPlant}
    IF    ${status} == 'True'
        Click Element    ${AddNewPlant}
    ELSE
            Wait until element is Not Visible   ${toastContainer}     ${maxTime}
            Click Element    ${AddNewPlant}
    END
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible    ${PlantNameInput}      ${MaxLimit}

Select Country Or State For The Plant
    [Arguments]    ${dropdown_locator}
    Click Element    ${dropdown_locator}
    ${country_index}=    Generate Random Number Between Range As String    3    4
    ${locator}=    Replace String    ${COUNTRY_OPTION}    INDEX    ${country_index}
    Wait Until Page Contains Element    ${locator}    ${Max_limit}
#    ${TD_SITE_COUNTRY}=    Get Text    ${locator}
#    Set Test Variable    ${TD_SITE_COUNTRY}
    Wait Until Keyword Succeeds     10x        1s      Click Element    ${locator}

 User Enters All Plant Details
    ${dictionary}=    Generate Random Data For Plant Creation
    Input Text    ${PlantNameInput}    ${dictionary['name']}
    Input Text    ${PlantAddress1Input}    ${dictionary['address1']}
    Input Text    ${PlantAddress2Input}    ${dictionary['address2']}
    Input Text    ${EmailInput}    ${dictionary['email']}
    Input Text    ${PhoneInput}      ${dictionary['phone']}
    Input Text    ${PostalCodeInput}         ${dictionary['postal_code']}
    Select Country Or State For The Plant     ${CountryInput}
    Select Country Or State For The Plant    ${StateInput}
    Input Text    ${CityInput}     ${dictionary['city']}


#     ${PlantDetails}=       Create List    ${dictionary['name']}    ${dictionary['address1']}    ${dictionary['country']}    ${dictionary['state']}    ${dictionary['postal_code']}    ${dictionary['city']}    ${dictionary['phone']}
    Set Test Variable    ${dictionary}

Verify The Details of The Latest Plant Created Are Displayed Correctly
     ${PlantDetails}=    Get Element Count    ${LatestPlantEntry}
     ${PlantCodeLatestPlant}=        Replace String    ${LatestPlantEntryDetails}    INDEX    2
     ${GeneartedPlantCode}=    Get Text    ${PlantCodeLatestPlant}
     Should Not Be Empty    ${GeneartedPlantCode}
     Log    The generated plant code is ${GeneartedPlantCode}
#####NAME
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   3
     ${text}=    Get Text    ${locator}
     Should Be Equal       ${text}    ${dictionary['name']}

     #### ADDRESS, COUNTRY, STATE, POSTAL CODE, CITY
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   4
     ${text}=    Get Text    ${locator}
     Should Contain        ${text}     ${dictionary['postal_code']}
     Should Contain        ${text}     ${dictionary['address2']}
     Should Contain        ${text}      ${dictionary['address1']}

     #### Phone number
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   5
     ${text}=    Get Text    ${locator}
     ${text}=    Split String    ${text}    ${SPACE}
     Should Be Equal       ${text}[1]        ${dictionary['phone']}
     #### EMAIL
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   6
     ${text}=    Get Text    ${locator}
     Should Be Equal       ${text}       ${dictionary['email']}

Verify The Mandatory Details of The Latest Plant Created Are Displayed Correctly
     ${PlantDetails}=    Get Element Count    ${LatestPlantEntry}
     ${PlantCodeLatestPlant}=        Replace String    ${LatestPlantEntryDetails}    INDEX    2
     ${GeneartedPlantCode}=    Get Text    ${PlantCodeLatestPlant}
     Should Not Be Empty    ${GeneartedPlantCode}
     Log    The generated plant code is ${GeneartedPlantCode}
#####NAME
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   3
     ${text}=    Get Text    ${locator}
     Should Be Equal       ${text}    ${dictionary['name']}

     #### ADDRESS, COUNTRY, STATE, POSTAL CODE, CITY
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   4
     ${text}=    Get Text    ${locator}
     Should Contain        ${text}     ${dictionary['postal_code']}
     Should Contain        ${text}      ${dictionary['address1']}

     #### Phone number
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   5
     ${text}=    Get Text    ${locator}
     ${text}=    Split String    ${text}    ${SPACE}
     Should Be Equal       ${text}[1]        ${dictionary['phone']}


Select Country/State
    [Arguments]    ${dropdown_locator}    ${value}
    Click Element    ${dropdown_locator}
    Wait Until Element Is Visible    ${DropdownSearch}
    Input Text  ${DropdownSearch}    ${value}
    ${status}=      Run Keyword and Return Status       Wait Until Page Contains Element    ${SelectValue}    ${Max_limit}
    IF    '${status}'=='False'
        ${dictionary}=    Generate Random Data For Plant Creation
        Select Country/State    ${CountryInput}    ${dictionary['country']}
        Select Country Or State For The Plant    ${StateInput}
        Input Text    ${CityInput}     ${dictionary['city']}
    END
    Wait Until Keyword Succeeds     10x        1s      Click Element    ${SelectValue}

User Enters Mandatory Plant Details
    ${dictionary}=    Generate Random Data For Plant Creation
    Input Text    ${PlantNameInput}    ${dictionary['name']}
    Input Text    ${PlantAddress1Input}       ${dictionary['address1']}
    Input Text    ${PhoneInput}       ${dictionary['phone']}
     Input Text    ${PostalCodeInput}      ${dictionary['postal_code']}
   Select Country Or State For The Plant  ${CountryInput}
   Select Country Or State For The Plant    ${StateInput}
    Input Text    ${CityInput}     ${dictionary['city']}
    Set Test Variable    ${dictionary}


User Clicks On Done Button
    Click Element    ${SaveButton}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${AddNewPlant}   ${MaxTime}

Verify Operation Done Successfully
    [Arguments]    ${ToastMessage}
    Wait Until Element Is Visible    ${OperationSuccessTitle}      ${MaxLimit}
    Element Should Contain    ${OperationSuccessMessage}     ${ToastMessage}

Verify plant code is visible after creation of the plant
    Wait Until Element Is Visible    ${PlantCodeHeader}      ${MaxLimit}
    Element Should Be Visible    ${PlantCodeValue}

Verify Done Remain Disabled Till All Mandatory Fields Are Filled
    ${dictionary}=    Generate Random Data For Plant Creation
    Element Should Be Disabled    ${SaveButton}
    Input Text    ${PlantNameInput}    ${dictionary['name']}
    Sleep    2s
    Element Should Be Disabled    ${SaveButton}
    Input Text    ${PlantAddress1Input}       ${dictionary['address1']}
    Element Should Be Disabled    ${SaveButton}
   Select Country Or State For The Plant    ${CountryInput}
   Element Should Be Disabled    ${SaveButton}
   Select Country Or State For The Plant    ${StateInput}
   Element Should Be Disabled    ${SaveButton}
    Input Text    ${PostalCodeInput}      ${dictionary['postal_code']}
    Element Should Be Disabled    ${SaveButton}
    Input Text    ${CityInput}     ${dictionary['city']}
    Element Should Be Disabled    ${SaveButton}
    Input Text    ${PhoneInput}       ${dictionary['phone']}
    Element Should Be Enabled    ${SaveButton}

Verify Email Is An Optional Field For Plant Creation
    Element Should Be Enabled    ${SaveButton}
    ${EnteredEmail}=   Get Text    ${EmailInput}
    Should Be Empty    ${EnteredEmail}

User Searches and Verify Plant By All Fields

    Log    ${dictionary}

    ${search_values}=    Create List
    ...    ${dictionary}[name]
    ...    ${dictionary}[phone]
    ...    ${dictionary}[email]

    FOR    ${value}    IN    @{search_values}

        Log    Searching for: ${value}

        Clear Element Text    ${SearchBox}
        Input Text    ${SearchBox}    ${value}
        Press Keys    ${SearchBox}    ENTER

        Wait Until Element Is Visible    ${ResultRows}    ${MaxLimit}

        ${rows}=    Get Element Count    ${ResultRows}
        Should Be True    ${rows} >= 1

        ${row_text}=    Get Text    ${ResultRows}
        ${row_text}=    Convert To Lowercase    ${row_text}
        ${expected}=    Convert To Lowercase    ${value}
        ${expected}=    Strip String    ${expected}    left    0

        Should Contain    ${row_text}    ${expected}

    END

Verify Plant Created By Site Admin Is Visible To Org Admin With In That Site
    Wait Until Element Is Visible    ${SearchBox}    ${MaxLimit}
    Input Text    ${SearchBox}    ${dictionary['name']}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Verify The Details of The Latest Plant Created Are Displayed Correctly

Reset Production Plant Screen If Needed
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxLimit}
    ${on_screen}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${AddNewPlant}    3s
    IF    '${on_screen}' == 'True'
        # If add-plant modal is open, close it to return to base screen
        ${modal_open}=    Run Keyword And Return Status    Element Should Be Visible    ${PlantNameInput}
        IF    '${modal_open}' == 'True'
            Run Keyword And Ignore Error    Click Element    ${CancelButton}
            Run Keyword And Ignore Error    Click Element    ${CrossIcon}
            Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${PlantNameInput}    5s
        END
        # Clear search box and ensure no loading
        Run Keyword And Ignore Error    Clear Element Text    ${SearchBox}
        Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxLimit}
    ELSE
        # Not on production plant screen -> do a full reset so next test starts clean
        Close All Browsers
        Launch Mentor Application
        Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
        Navigate To Settings Page
        User Navigates to Production Plant Screen
    END

User Deletes Multiple Plants Created
    Click Element   ${SecondPlant}
    Click Element    ${FirstPlant}
    Click Element   ${DeleteMultiplePlants}
    Wait Until Element Is Visible    ${ConfirmDelete}
    Click Element    ${ConfirmDelete}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

User Deletes The Plant Created
    Click Element   ${DeletePlant}
    Wait Until Element Is Visible    ${ConfirmDelete}
    Click Element    ${ConfirmDelete}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}

User Edits The Plant Created
    Click Element   ${EditPlant}
    Wait Until Element Is Visible    ${PlantNameInput}      ${MaxLimit}
    ${new_dictionary}=    Generate Random Data For Plant Creation
    Input Text    ${PlantNameInput}    ${new_dictionary['name']}
    Input Text    ${PlantAddress1Input}       ${new_dictionary['address1']}
    Input Text    ${PlantAddress2Input}       ${new_dictionary['address2']}
    Input Text    ${PhoneInput}       ${new_dictionary['phone']}
     Input Text    ${PostalCodeInput}      ${new_dictionary['postal_code']}
   Select Country Or State For The Plant  ${CountryInput}
   Select Country Or State For The Plant    ${StateInput}
    Input Text    ${CityInput}     ${new_dictionary['city']}
    Input Text    ${EmailInput}     ${new_dictionary['email']}
    Set Test Variable    ${new_dictionary}

Verify Edited Details Are Displayed Correctly
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxLimit}
     ${PlantDetails}=    Get Element Count    ${LatestPlantEntry}
     ${PlantCodeLatestPlant}=        Replace String    ${LatestPlantEntryDetails}    INDEX    2
     ${GeneartedPlantCode}=    Get Text    ${PlantCodeLatestPlant}
     Should Not Be Empty    ${GeneartedPlantCode}
     Log    The generated plant code is ${GeneartedPlantCode}
#####NAME
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   3
     ${text}=    Get Text    ${locator}
     Should Be Equal       ${text}    ${new_dictionary['name']}
         #### Phone number
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   5
     ${text}=    Get Text    ${locator}
     ${text}=    Split String    ${text}    ${SPACE}
     Should Be Equal       ${text}[1]        ${new_dictionary['phone']}
     #### EMAIL
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   6
     ${text}=    Get Text    ${locator}
     Should Be Equal       ${text}       ${new_dictionary['email']}
      #### ADDRESS, COUNTRY, STATE, POSTAL CODE, CITY
     ${locator}=    Replace String    ${LatestPlantEntryDetails}    INDEX   4
     ${text}=    Get Text    ${locator}
     Should Contain        ${text}     ${new_dictionary['postal_code']}
     Should Contain        ${text}     ${new_dictionary['address2']}
     Should Contain        ${text}      ${new_dictionary['address1']}

Replace The Plant Name
    ${NewPlantName}=    Generate Plant Name
    Input Text    ${PlantNameInput}    ${NewPlantName}
    Set Test Variable    ${NewPlantName}

Enter The Plant Name
    Input Text    ${PlantNameInput}    ${NewPlantName}

Generate Plant Name
    ${PlantName}=    Generate Random String    8    [LETTERS]
    ${PlantName}=    Set Variable    Plant_${PlantName}
    [Return]    ${PlantName}

Observe the Plant Code Generated For The Plant
    ${PlantCodeLatestPlant}=        Replace String    ${LatestPlantEntryDetails}    INDEX    2
    ${GeneartedPlantCode}=    Get Text    ${PlantCodeLatestPlant}
    Should Not Be Empty    ${GeneartedPlantCode}
    Log    The generated plant code is ${GeneartedPlantCode}

#Search and Open The Site
#    Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxLimit}
#    Input Text    ${INPUT_SEARCH}    ${TD_SITE_NAME}
#    Sleep    1s
#    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
#    Click Element   ${SEARCH_RESULT_SITE}
#    Wait Until Element Is Visible    ${EDIT_SITE}      ${MaxTime}
#    Click Element       ${EDIT_SITE}
#    Wait Until Keyword Succeeds     10x     2s     Click Element    ${PlantTabSite}

Search and Open The Element
    [Arguments]    ${NAME}
    Set Selenium Speed   0.1s
    Wait Until Element Is Visible    ${INPUT_SEARCH}    ${MaxLimit}
    Input Text    ${INPUT_SEARCH}    ${NAME}
    Sleep    1s
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Click Element   ${SEARCH_RESULT}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Wait Until Element Is Visible    ${EditButton}      ${MaxTime}
    Click Element       ${EditButton}
    Wait Until Keyword Succeeds     10x     2s     Click Element    ${PlantTabSite}
    Wait Until Element Is Visible    ${AddNewPlant}         ${maxTime}
    Set Selenium Speed   0s

Verify Plant Created By Org Admin Is Visible To Site Admin In Settings Screen
    Wait Until Element Is Visible    ${SearchBox}    ${MaxLimit}
    Input Text    ${SearchBox}    ${dictionary['name']}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}    ${MaxTime}
    Verify The Mandatory Details of The Latest Plant Created Are Displayed Correctly