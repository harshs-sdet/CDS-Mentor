*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    DateTime
Variables        ../../../config/Mentor/API/UAT_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/api/Common/Common.resource

*** Variables ***
${start}=    Get Time    epoch

*** Test Cases ***
Check Users Listing Page with v2 API
    Append To File    ${CSV_FILE}       UserManagement\n
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/persona/get
    ${response}=    GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message

    Should Contain    ${message}    Success
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Contain    ${message}    Success

Check Filter API Status
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ...    filters\[role\]\[\]=2bbf99f7-182a-40ef-9445-d4f286be71c0
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    Log    ${json}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success

Load Site API
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/site
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=30
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalDoc}=    Convert To String    ${totalDoc}
    Should Be Equal    ${totalDoc}    1

Check Create New User using Users API status
    [Tags]    CZ-6285
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    ${user_data}=   Get From Dictionary    ${json['data']}    data

    ${first_user}=  Get From List    ${user_data}    0
    ${site_ids}=    Get From Dictionary    ${first_user}    sites
    ${site_id}=     Get From List    ${site_ids}    0
    ${org_id}=        Get From Dictionary   ${first_user}     organizationId

    Log    Site ID = ${site_id}

    ${ENDPOINT}=   Set Variable    api/mentor/user/users
    ${sites}=    Create List    ${site_id}
    ${workspaces}=    Create List
    &{privilages}=    Create Dictionary
    &{exclusions}=    Create Dictionary    workspaces=${workspaces}    privilages=${privilages}
    &{userMetadata}=    Create Dictionary    language=en    timezone=Eastern Standard Time
    ${NewUserEmail}=    Set Variable    user${UniqueNumberTest}@mailinator.com
    Set Global Variable    ${NewUserEmail}
    &{data}=    Create Dictionary
    ...    firstName=User-${UniqueNumberTest}
    ...    lastName=API
    ...    email=${NewUserEmail}
    ...    sites=${sites}
    ...    personaId=2bbf99f7-182a-40ef-9445-d4f286be71c0
    ...    isActive=${True}
    ...    userMetadata=${userMetadata}
    ...    exclusions=${exclusions}
    ...    organizationId=${org_id}

    Log    ${data}

    ${userresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${userresponse}    ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${userresponse.status_code}    201
    Log    ${userresponse.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${userId}=    Set Variable    ${userresponse.json()['data']['id']}
    Set Global Variable    ${userId}
    ${userEmail}=    Set Variable    ${userresponse.json()['data']['email']}
    Should Be Equal    ${userEmail}    ${NewUserEmail}

View User API: api/mentor/user/users
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/users/${userId}
    ${userresponse}=     GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${userresponse}   ${ENDPOINT}
    Status Should Be    200    ${userresponse}
    ${userEmail}=    Set Variable    ${userresponse.json()['data']['email']}
    Should Be Equal    ${userEmail}    ${NewUserEmail}

Check Search Users with v2 API
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ...    search=${NewUserEmail}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}     ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Contain    ${message}    Success

Check delete User API status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    ${user_data}=   Get From Dictionary    ${json['data']}    data

    ${first_user}=    Get From List         ${user_data}      0
    ${site_ids}=      Get From Dictionary   ${first_user}     sites
    ${site_id}=       Get From List         ${site_ids}       0
    ${org_id}=        Get From Dictionary   ${first_user}     organizationId

    Log    Site ID = ${site_id}

    ${ENDPOINT}=   Set Variable    api/mentor/user/users
    ${sites}=    Create List    ${site_id}
    ${workspaces}=    Create List
    &{privilages}=    Create Dictionary
    &{exclusions}=    Create Dictionary    workspaces=${workspaces}    privilages=${privilages}
    &{userMetadata}=    Create Dictionary    language=en    timezone=Eastern Standard Time

    &{data}=    Create Dictionary
    ...    firstName=User-${UniqueNumberTest}
    ...    lastName=API
    ...    email=user${UniqueNumberTest}@mailinator.com
    ...    sites=${sites}
    ...    personaId=2bbf99f7-182a-40ef-9445-d4f286be71c0
    ...    isActive=${True}
    ...    userMetadata=${userMetadata}
    ...    exclusions=${exclusions}
    ...    organizationId=${org_id}

    Log    ${data}

    ${userresponse}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${userresponse}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${userresponse.status_code}    201
    Log    ${userresponse.json()}
    ${userjson}=    Set Variable    ${userresponse.json()}
    ${created_user}=    Get From Dictionary    ${userjson}    data
    Log    ${created_user}
    ${user_id}=     Get From Dictionary    ${created_user}    id
    Log    Created User ID: ${user_id}
    ${ENDPOINT}=   Set Variable    api/mentor/user/users/${user_id}
    ${response}=      DELETE On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

######################################################################################################

Team Listing API: /api/mentor/usergroup
    [Tags]    A
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable      /api/mentor/usergroup
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=name
    ...    sortOrder=desc
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${message}=    Set Variable    ${response.json()['data']['message']}
    Should Be Equal    ${message}    Documents fetched successfully

Create Teams: /api/mentor/usergroup/create
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}

    ##Fetch Sites

    ${ENDPOINT}=   Set Variable    api/mentor/site
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=30
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalDoc}=    Convert To String    ${totalDoc}
    Should Be Equal    ${totalDoc}    1
    ${SiteId}=    Set Variable    ${response.json()['data']['data'][0]['key']}
    Set Global Variable    ${SiteId}

    ## List All Site Associated Users
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=30
    ...    sortOrder=desc
    ...    filters[sites][]=${SiteId}
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${UserIds}=    Create List
    FOR    ${index}    IN RANGE    0    3
        ${user}=    Set Variable    ${response.json()['data']['data'][${index}]['userId']}
        Append To List    ${UserIds}    ${user}
    END

    ## Adding users to teams
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=30
    ...    sortOrder=desc
    ...    filters[sites][]=${SiteId}
    ...    filters[id][]=${UserIds}[0]
    ...    filters[id][]=${UserIds}[1]
    ...    filters[id][]=${UserIds}[2]
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}

    ### Create Team
    ${ENDPOINT}=    Set Variable    /api/mentor/usergroup/create
    ${RequestPayload}=    Create Dictionary
    ...    name=Team-${UniqueNumbertest}
    ...    description=First Team created through API
    ...    site=${SiteId}
    ...    users=${UserIds}
    ${response}=    POST On Session    Mentor    ${ENDPOINT}     data=${RequestPayload}   expected_status=anything
    Capture API Response Time     ${response}    ${ENDPOINT}     data=${RequestPayload}
    Status Should Be    200    ${response}
    ${message}=    Set Variable    ${response.json()['data']['message']}
    Should Be Equal    ${message}    Document upserted successfully.
    ${UserGroupId}=    Set Variable    ${response.json()['data']['data']['key']}

    ## View User Group
    ${ENDPOINT}=   Set Variable    api/mentor/usergroup/${UserGroupId}
    ${response}=    GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be     200    ${response}
    ${UserGroupName}=    Set Variable    ${response.json()['data']['name']}
    Should Be Equal    ${UserGroupName}        Team-${UniqueNumbertest}