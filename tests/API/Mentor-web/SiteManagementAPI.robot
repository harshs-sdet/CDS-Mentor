*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Library     Random
Resource        ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Variables        ../../../config/Mentor/API/${ENV}_env.yaml
Library     ../../../src/api/Mentor/CommonUtils.py
Resource    ../../../pageobjects/keywords/api/Common/Common.resource
*** Test Cases ***
Check Sites Listing Page with sites API
    Append To File    ${CSV_FILE}       SiteManagement\n
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    Log    ${json}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success

Check Create New Site using create API status
    AuthorScreen.Generate Unique Number
    ${random_digit}=    Generate Unique Digit
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}
#    ${json}=    Set Variable    ${response.json()}
    ${innerdata}=    Set Variable   ${response.json()['data']['data'][0]}
    ${org_id}=        Get From Dictionary   ${innerdata}     organizationId

    Log    ORG ID = ${org_id}

    ${ENDPOINT}=   Set Variable    api/mentor/site/create
    &{address}=    Create Dictionary
    ...    addressLine1=${UniqueNumberTest}
    ...    addressLine2=Corner Lane
    ...    city=San Francisco
    ...    country=United States
    ...    postalCode=123932
    ...    state=Alabama

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number= 938293${random_digit}

    @{workspace}=    Create List

    &{data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${data}

    ${siteresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}       expected_status=anything
    Capture API Response Time     ${siteresponse}     ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${siteresponse.status_code}    200
    Log    ${siteresponse.json()}
    ${message}=    Get From Dictionary    ${siteresponse.json()}    message
    Should Contain    ${message}    Success

Check Delete Site API status
    AuthorScreen.Generate Unique Number
    ${random_digit}=    Generate Unique Digit
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}

    ${ENDPOINT}=   Set Variable    api/mentor/site/create
    &{address}=    Create Dictionary
    ...    addressLine1=${UniqueNumberTest}
    ...    addressLine2=Corner Lane
    ...    city=San Francisco
    ...    country=United States
    ...    postalCode=123932
    ...    state=Alabama

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number= 938293${random_digit}

    @{workspace}=    Create List

    &{data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${data}

    ${siteresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}       expected_status=anything
    Capture API Response Time    ${siteresponse}     ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${siteresponse.status_code}    200
    ${response_json}=    To JSON    ${siteresponse.content}
    ${site_key}=         Get From Dictionary    ${response_json['data']}    key
    Log                  ${site_key}
    ${ENDPOINT}=   Set Variable    api/mentor/site/${site_key}
    ${delete_response}=    DELETE On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${delete_response}   ${ENDPOINT}
    Status Should Be    200    ${delete_response}

#Check Bulk Delete Site API status
#    [Tags]  A
#    AuthorScreen.Generate Unique Number
#    ${random_digit}=    Generate Unique Digit
#    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
#    Create The Session     ${headers}
#    ${ENDPOINT}=   Set Variable    api/mentor/site?
#    ${RequestPayload}=    Set Variable    page=1&pageSize=10
#    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
#    Status Should Be    200    ${response}
#    Log    ${response.json()}
#    ${Site_ids}=    Create List
#    FOR    ${i}    IN RANGE    3
#        ${ENDPOINT}=   Set Variable    api/mentor/site/create
#        &{address}=    Create Dictionary
#        ...    addressLine1=${UniqueNumberTest}
#        ...    addressLine2=Corner Lane
#        ...    city=San Francisco
#        ...    country=United States
#        ...    postalCode=123932
#        ...    state=Alabama
#
#        &{contact}=    Create Dictionary
#        ...    countryCode=1
#        ...    number= 938293${random_digit}
#
#        @{workspace}=    Create List
#
#        &{data}=    Create Dictionary
#        ...    name=Site-${UniqueNumberTest}
#        ...    address=${address}
#        ...    contact=${contact}
#        ...    email=site${UniqueNumberTest}@mailinator.com
#        ...    description=This is for testing purpose
#        ...    workspace=${workspace}
#
#        Log    ${data}
#
#        ${siteresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}       expected_status=anything
#        Should Be Equal As Integers    ${siteresponse.status_code}    200
#        ${response_json}=    To JSON    ${siteresponse.content}
#        ${site_key}=         Get From Dictionary    ${response_json['data']}    key
#        Log                  ${site_key}
#        Append To List    ${Site_ids}    ${site_key}
#    END
#    Log    ${Site_ids}
#    ${ENDPOINT}=   Set Variable    api/mentor/site/bulkDelete
#    &{Site_IDS_delete}=     Create Dictionary
#    ...     siteIds=${Site_ids}
#    ${delete_response}=    POST On Session    Mentor    ${ENDPOINT}     json=${Site_IDS_delete}     expected_status=anything
#    Status Should Be    200    ${delete_response}
#    Log    ${delete_response.json()}
#    ${message}=    Get From Dictionary    ${delete_response.json()}    message
#    Should Contain    ${message}    Success

Check Search Site API Status
    AuthorScreen.Generate Unique Number
    ${random_digit}=    Generate Unique Digit
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}

    ${ENDPOINT}=   Set Variable    api/mentor/site?
    &{RequestPayload}=    Create Dictionary    page=1    pageSize=10
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${RequestPayload}
    Capture API Response Time       ${response}     ${ENDPOINT}    params=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}

    ${ENDPOINT}=   Set Variable    api/mentor/site/create
    &{address}=    Create Dictionary
    ...    addressLine1=${UniqueNumberTest}
    ...    addressLine2=Corner Lane
    ...    city=San Francisco
    ...    country=United States
    ...    postalCode=123932
    ...    state=Alabama

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number=938293${random_digit}

    @{workspace}=    Create List

    &{data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${data}

    ${siteresponse}=    POST On Session    Mentor    ${ENDPOINT}    json=${data}        expected_status=anything
    Capture API Response Time       ${siteresponse}     ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${siteresponse.status_code}    200
    ${json}=    Set Variable    ${siteresponse.json()}
    Log    ${json}

    ${data}=        Get From Dictionary    ${json}    data
    ${site_key}=    Get From Dictionary    ${data}    key

    ${ENDPOINT}=   Set Variable    api/mentor/site?
    &{SearchPayload}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    search=Site-${UniqueNumberTest}
    ...    sortBy=createdOn
    ...    sortOrder=desc

    ${search_response}=     GET On Session    Mentor    ${ENDPOINT}    params=${SearchPayload}
    Capture API Response Time       ${search_response}     ${ENDPOINT}    params=${SearchPayload}
    Status Should Be    200    ${search_response}

    ${searchjson}=    Set Variable    ${search_response.json()}
    Log    ${searchjson}

    ${outer_data}=        Get From Dictionary    ${searchjson}    data
    @{search_results}=    Get From Dictionary    ${outer_data}    data
    ${first_item}=        Get From List    ${search_results}    0
    ${searched_site_key}=   Get From Dictionary    ${first_item}    key
    Should Be Equal    ${site_key}    ${searched_site_key}

    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success

Check Edit site API status
    AuthorScreen.Generate Unique Number
    ${random_digit}=    Generate Unique Digit
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}
#    ${json}=    Set Variable    ${response.json()}

    ${ENDPOINT}=   Set Variable    api/mentor/site/create
    &{address}=    Create Dictionary
    ...    addressLine1=${UniqueNumberTest}
    ...    addressLine2=Corner Lane
    ...    city=San Francisco
    ...    country=United States
    ...    postalCode=123932
    ...    state=Alabama

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number= 938293${random_digit}

    @{workspace}=    Create List

    &{data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${data}

    ${siteresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time    ${siteresponse}     ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${siteresponse.status_code}    200
    Log    ${siteresponse.json()}
    ${message}=    Get From Dictionary    ${siteresponse.json()}    message
    Should Contain    ${message}    Success
    ${json}=    Set Variable    ${siteresponse.json()}
    ${site_key}=         Get From Dictionary    ${json['data']}    key
    ${ENDPOINT}=    Set Variable    api/mentor/site/${site_key}

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number= 938293${random_digit}

    @{workspace}=    Create List

    ${Edited_Site_Data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${Edited_Site_Data}
    ${edited_site_response}=    PUT On Session      Mentor      ${ENDPOINT}     json=${Edited_Site_Data}    expected_status=anything
    Capture API Response Time    ${edited_site_response}     ${ENDPOINT}     json=${Edited_Site_Data}
    Should Be Equal As Integers    ${edited_site_response.status_code}    200
    Log    ${edited_site_response.json()}
    ${message}=    Get From Dictionary    ${siteresponse.json()}    message
    Should Contain    ${message}    Success

Check View Site API Status
    AuthorScreen.Generate Unique Number
    ${random_digit}=    Generate Unique Digit
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time    ${response}     ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}
#    ${json}=    Set Variable    ${response.json()}

    ${ENDPOINT}=   Set Variable    api/mentor/site/create
    &{address}=    Create Dictionary
    ...    addressLine1=${UniqueNumberTest}
    ...    addressLine2=Corner Lane
    ...    city=San Francisco
    ...    country=United States
    ...    postalCode=123932
    ...    state=Alabama

    &{contact}=    Create Dictionary
    ...    countryCode=1
    ...    number= 938293${random_digit}

    @{workspace}=    Create List

    &{data}=    Create Dictionary
    ...    name=Site-${UniqueNumberTest}
    ...    address=${address}
    ...    contact=${contact}
    ...    email=site${UniqueNumberTest}@mailinator.com
    ...    description=This is for testing purpose
    ...    workspace=${workspace}

    Log    ${data}

    ${siteresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}   expected_status=anything
    Capture API Response Time     ${siteresponse}     ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${siteresponse.status_code}    200
    Log    ${siteresponse.json()}
    ${message}=    Get From Dictionary    ${siteresponse.json()}    message
    Should Contain    ${message}    Success
    ${json}=    Set Variable    ${siteresponse.json()}
    ${site_key}=         Get From Dictionary    ${json['data']}    key
    ${ENDPOINT}=    Set Variable    api/mentor/site/${site_key}
    ${view_siteresponse}=       GET On Session      Mentor      ${ENDPOINT}
    Capture API Response Time       ${view_siteresponse}     ${ENDPOINT}
    Should Be Equal As Integers    ${view_siteresponse.status_code}    200
    Log    ${view_siteresponse.json()}
    ${message}=     Get From Dictionary    ${view_siteresponse.json()}    message
    Should Contain    ${message}    Success

Check sort API Status on Sites screen.
    [Tags]    CZ-6185
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_OrgAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=name&sortOrder=asc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time      ${response}     ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}
    ${message}=     Get From Dictionary    ${response.json()}    message
    Should Contain    ${message}    Success
