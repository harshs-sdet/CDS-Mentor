*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    DateTime
Variables        ../../../config/Mentor/API/${ENV}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/api/Common/Common.resource

*** Variables ***
${start}=    Get Time    epoch

*** Test Cases ***
Verify the Workspace list API: /api/mentor/workspace
    Append To File    ${CSV_FILE}       Workspace\n
    ${header}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${header}
    ${ENDPOINT}=    Set Variable    /api/mentor/workspace    
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=    GET On Session    Mentor     ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}    ${ENDPOINT}    params=${param}
    Status Should Be     200    ${response}


Verify The Sites Are Visible In Response
    [Tags]      A
    ${header}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${header}
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
#############################################################
Verify the Create Workspace APIs using Tags
    #To check tags are visible
    ${header}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${header}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/tags
    ${param}=    Create Dictionary
    ...    pageSize=1000
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}

# Create Tags
    AuthorScreen.Generate Unique Number
    ${ENDPOINT}=   Set Variable    /api/mentor/tags
    ${param}=    Create Dictionary
    ...    isSelected=true
    ...    tagId=
    ...    name=Tag-${UniqueNumberTest}
    ...    organizationId=
    ${response}=    POST On Session    Mentor    ${ENDPOINT}    params=${param}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    201    ${response}
    ${tagId}=    Set Variable    ${response.json()['data']['tagId']}
    ${message}=    Set Variable    ${response.json()['message']}
    Should Be Equal    Success     ${message}
    Set Global Variable     ${tagId}
#Associate Tag to a Procedure

#apply Tag to workspace
    ${ENDPOINT}=   Set Variable    /api/mentor/workinstructions/getWorkInstructions

    ${param}=    Create Dictionary
    ...    tags[]=${tagId}
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${totalProcedures}=    Set Variable    ${response.json()['data']['total']}
    ${totalProcedures}=      Convert To String      ${totalProcedures}
    Should Be Equal    ${totalProcedures}    0
    ${message}=    Set Variable    ${response.json()['message']}
    Should Be Equal    Work Instructions not yet created     ${message}

#List of tags associated Procedures
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/list
    ${param}=    Create Dictionary
    ...    sortBy=modifiedOn
    ...    sortOrder=desc
    ...    tags[]=${tagId}
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${totalProcedures}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalProcedures}=      Convert To String      ${totalProcedures}
    Should Be Equal    ${totalProcedures}    0
    ${message}=    Set Variable    ${response.json()['message']}
    Should Be Equal    Success     ${message}

Verify the Create Workspace APIs By Adding Procedures Manually
    AuthorScreen.Generate Unique Number
    ${header}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${header}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/list
    ${param}=    Create Dictionary
    ...    page=1
    ...    pageSize=1000
    ...    sortBy=modifiedOn
    ...    sortOrder=desc
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${param}
    Status Should Be    200    ${response}
    ${message}=    Set Variable    ${response.json()['message']}
    Should Be Equal    Success     ${message}
    ${proceduresIds}=    Create List
    FOR    ${index}    IN RANGE    0    3
        ${procedure}=    Set Variable    ${response.json()['data']['data'][${index}]['procedureId']}
        Append To List    ${proceduresIds}    ${procedure}
    END
    ${exclusions}=  Create List
    ${inclusionsWI}=    Create List
    ${inclusions}=  Create List     ${SiteId}
    ${sites}=    Create Dictionary
    ...     exclusions=${exclusions}
    ...     inclusions=${inclusions}
    ${WI}=    Create Dictionary
    ...     exclusions=${exclusions}
    ...     inclusions=${inclusionsWI}
    ${tags}=    Create List
    ${libraryProcedures}=   Create Dictionary
    ...     exclusions=${exclusions}
    ...     inclusions=${proceduresIds}
    ${ENDPOINT}=   Set Variable      /api/mentor/workspace/create
    ${payload}=    Create Dictionary
    ...    name=Workspace-${UniqueNumbertest}
    ...    sites=${sites}
    ...    description=
    ...    tags=${tags}
    ...    workInstructions=${WI}
    ...    libraryProcedures=${libraryProcedures}
    Log     ${payload}
    ${response}=    POST On Session    Mentor    ${ENDPOINT}    json=${payload}     expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${payload}
    Status Should Be    200    ${response}


Verify the Creation of Empty Workspace
    [Tags]    A
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${exclusions}=  Create List
    ${inclusionsWI}=    Create List
    ${inclusions}=  Create List     ${SiteId}
    ${sites}=    Create Dictionary
    ...     exclusions=${exclusions}
    ...     inclusions=${inclusions}
    ${WI}=    Create Dictionary
    ...     exclusions=${exclusions}
    ...     inclusions=${inclusionsWI}
    ${tags}=    Create List
    ${ENDPOINT}=   Set Variable      /api/mentor/workspace/create
    ${payload}=    Create Dictionary
    ...    name=Workspace-${UniqueNumbertest}
    ...    sites=${sites}
    ...    description=
    ...    tags=${tags}
    ...    workInstructions=${WI}
    ...    libraryProcedures=${WI}
    Log     ${payload}
    ${response}=    POST On Session    Mentor    ${ENDPOINT}    json=${payload}     expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${payload}
    Status Should Be    200    ${response}