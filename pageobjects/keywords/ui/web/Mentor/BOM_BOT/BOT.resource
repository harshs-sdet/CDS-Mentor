*** Settings ***
Library    SeleniumLibrary
Library     String
Library    Collections
Library    OperatingSystem
Library    BuiltIn
Library    csvLibrary
Library    RequestsLibrary
Library    DateTime
Library   ../../../../../../src/utilities/Common-utils/csvLibrary.py
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../locators/ui/web/Mentor/Common.yaml
Variables   ../../../../../locators/ui/web/Mentor/BOM_BOT.yaml
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Resource    ../Common/Common.resource

*** Variables ***
${Upload_File_Path}         ${CURDIR}${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor
@{expected_BOM_headers_list}    Fixture/Gauge #    Image    Name    Description    Quantity    UoM    Created on    Actions
${DOWNLOAD_DIR}    ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}custom_downloads
${BROWSER}         Chrome

*** Keywords ***
Navigate to Add BOT Page
    Wait Until Element Is Visible    ${ADD_BOT_BUTTON}
    Click Element    ${ADD_BOT_BUTTON}

User verifies the ADD BOM UI
    Wait Until Element Is Visible    ${BOM_NAME_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_SIZE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_DESCRIPTION_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_TYPE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_TYPE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_FIXTURE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_ADD_BREADCRUMB_LINK}    timeout=10s