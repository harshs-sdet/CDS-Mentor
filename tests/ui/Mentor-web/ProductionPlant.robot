*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Trainings/Training.resource
Library     ../../../../../../src/utilities/Common-utils/ChainedActions.py
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Settings/Settings.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/ProductionPlant/ProductionPlant.resource
Resource     ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource

Suite Setup     Run Keywords         Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
...             AND             Navigate To Settings Page
...             AND             User Navigates to Production Plant Screen

# Use conditional reset teardown to only perform a full relaunch/login when the screen is not in expected state
Test Teardown    Reset Production Plant Screen If Needed

#Test Teardown   Run Keyword    User Navigates to Production Plant Screen
Suite Teardown    Close All Browsers
*** Variables ***

${Message1}=      Production plant created successfully
${Message2}=     Production plants deleted successfully
${Message3}=     Production plant updated successfully
${Message4}=     Production plant deleted successfully

*** Test Cases ***
Verify creation of plant through site admin
    [Tags]    Regression    Sanity      01
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully         ${Message1}
    And Verify plant code is visible after creation of the plant

Verify Done remain disabled till all mandatory fields are filled
    [Tags]  Regression    Sanity      02
    And User Clicks On Add Plant Button
    Then Verify Done Remain Disabled Till All Mandatory Fields Are Filled

Verify Email is an Optional Field for Plant Creation and Edit
    [Tags]    Regression    Sanity      03
    And User Clicks On Add Plant Button
    Then Verify Done Remain Disabled Till All Mandatory Fields Are Filled
    And Verify Email Is An Optional Field For Plant Creation
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}

verify plant created will be on top
    [Tags]    Regression    Sanity      04
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    And User Clicks On Add Plant Button
    And User Enters All Plant Details
    And User Clicks On Done Button
    Then Verify The Details of The Latest Plant Created Are Displayed Correctly
    And User Deletes Multiple Plants Created
    Then Verify Operation Done Successfully     ${Message2}

Verify plant code is visible after creation of the plant
     [Tags]  Regression    Sanity      05
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Plant Code Is Visible After Creation Of The Plant

Verify Site Admin Is Able to Search Plant By Name, Code, Email, Phone Number
    [Tags]    Regression    Sanity      06
    And User Clicks On Add Plant Button
    And User Enters All Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}
    And User Searches and Verify Plant By All Fields

Verify Site Admin Is Able to Delete Plant
    [Tags]    Regression    Sanity      07
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}
    And User Deletes The Plant Created
    Then Verify Operation Done Successfully      ${Message4}

Verify Site Admin Is Able to Edit Plant Details
    [Tags]    Regression    Sanity      08
    And User Clicks On Add Plant Button
    And User Enters All Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}
    And User Edits The Plant Created
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message3}
    And Verify Edited Details Are Displayed Correctly

Verify two plants in different orgs can have same Plant Name
    [Tags]    Regression    Sanity      09
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And Replace The Plant Name
    And User Clicks On Done Button
    Then Verify Operation Done Successfully    ${Message1}
    And Observe the Plant Code Generated For The Plant
    And Login To Mentor Application    ${SITE_ADMIN_EMAIL_ORG2}    ${SITE_ADMIN_PASS_ORG2}
    And Navigate To Settings Page
    And User Navigates to Production Plant Screen
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And Enter The Plant Name
    And User Clicks On Done Button
    Then Verify Operation Done Successfully    ${Message1}
    And Observe the Plant Code Generated For The Plant
    And Logout from Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify Plant Created By Site Admin is Visible to Org Admin With in That Site
    [Tags]    Regression    Sanity      10
    And User Clicks On Add Plant Button
    And User Enters All Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully    ${Message1}
    And Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Search and Open The Element     ${TD_SITE_NAME}
    Then Verify Plant Created By Site Admin Is Visible To Org Admin With In That Site
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}

 Verify mapping of plants with the user - site admin
    And  Navigate To Users List Page
    And Search and Open The Element         ${AUTHOR1_EMAIL}
    And Navigate To Professional Details
    And Map Plant With User
    Then Verify Plant Mapped Successfully
    And Map Another Plant With User
    Then Verify Plant Mapped Successfully
    And Uncheck Mapped Plant
    Then Verify Plant Unmapped Successfully

#Verify two plants in Same org can not have same plant code and Plant Name
#    And User Clicks On Add Plant Button
#    And User Enters Mandatory Plant Details
#    And Replace The Plant Name
#    And User Clicks On Done Button
#    Then Verify Operation Done Successfully    ${Message1}
#    And Observe the Plant Code Generated For The Plant
#    And Login To Mentor Application    ${SiteAdminSite2}    ${SiteAdminSite2Pass}
#    And Navigate To Settings Page
#    And User Navigates to Production Plant Screen
#    And User Clicks On Add Plant Button
#    And User Enters Mandatory Plant Details
#    And Replace The Plant Name
#    And User Clicks On Done Button
##    Then Verify Operation Done Successfully    ${Message1}
#    And Observe the Plant Code Generated For The Plant
#    Then Verify Plant Codes Generated For Both Plants Are Same
#    And Logout from Mentor
#    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify creation of plants through org admin - new site
    When Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And User Creates New Site
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully     ${Message1}
    And Verify The Details of The Latest Plant Created Are Displayed Correctly
    And User Searches and Verify Plant By All Fields
    And Create a Site

Verify mapping of plants with the user - org admin
    When Login To Mentor Application     ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And  Navigate To Users List Page
    And Search User And Click On Edit Button
    And Navigate To Professional Details
    And Map Plant With User
    Then Verify Plant Mapped Successfully
    And Map Another Plant With User
    Then Verify Plant Mapped Successfully
    And Uncheck Mapped Plant
    Then Verify Plant Unmapped Successfully

Verify plant created for a site not visible on other site
    When Login To Mentor Application     ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And User Creates New Site - Site A
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully        ${Message1}
    And Search and Open The Site
    Then Verify Plant Created For Site A Not Visible On Site B
    And Verify The Plant code for both The Plants Created For Site A and Site B Can Not Be Same

Verify Plant Created By Org Admin is Visible to Site Admin in Settings screen
    [Tags]    Regression    Sanity      11
    When Login To Mentor Application     ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Search and Open The Element         ${TD_SITE_NAME}
    And User Clicks On Add Plant Button
    And User Enters Mandatory Plant Details
    And User Clicks On Done Button
    Then Verify Operation Done Successfully      ${Message1}
    And Login To Mentor Application     ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    And Navigate To Settings Page
    And User Navigates to Production Plant Screen
    Then Verify Plant Created By Org Admin Is Visible To Site Admin In Settings Screen

Verify mapping of plants with the user - Author
    When Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And  Navigate To Users List Page
    And Search User And Click On Edit Button
    And Navigate To Professional Details
    And Map Plant With User
    Then Verify Plant Mapped Successfully

Verify search in mapping screen
    When Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And  Navigate To Users List Page
    And Search User And Click On Edit Button
    And Navigate To Professional Details
    And Search Plant using Plant Name In Dropdown
    Then Verify Searched Plant Is Displayed In Dropdown
    And Search Plant using Plant Code In Dropdown
    Then Verify Searched Plant Is Displayed In Dropdown