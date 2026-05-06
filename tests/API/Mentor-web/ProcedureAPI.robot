*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Resource        ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Variables        ../../../config/Mentor/API/UAT_env.yaml
Library     ../../../src/api/Mentor/CommonUtils.py
Resource    ../../../pageobjects/keywords/api/Common/Common.resource
*** Variables ***

${FilePath}       ${CURDIR}/../../../testdata/API/Web/Mentor/maxresdefault.jpg
${ImageName}    maxresdefault.jpg


*** Test Cases ***
#########################################################################################################
#Token API
#    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
#    Create Session    Mentor     https://uatcdsmentor.b2clogin.com/uatcdsmentor.onmicrosoft.com/b2c_1a_signup-signin/oauth2/v2.0    headers=${headers}
#    ${params}=    Create Dictionary
#    ...    client-request-id=019b2b41-3e0e-71c0-8d5b-c3064dc995c3
#    ${ENDPOINT}=   Set Variable    token
#    ${response}=      POST On Session    Mentor    ${ENDPOINT}        params=${params}    expected_status=anything
#    Status Should Be  200    ${response}
#    ${AUTH_TOKEN}=  Get From Dictionary    ${response}    access_token



Check listWithFolders API Status [/api/mentor/procedures/library/listWithFolders]
    [Tags]      AB
    Append To File    ${CSV_FILE}       AuthorScreen\n
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=modifiedOn
    ...    sortOrder=desc
    ...    folderId=
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/listWithFolders

    ${response}=      GET On Session    Mentor    ${ENDPOINT}        params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}        params=${params}
    Status Should Be  200    ${response}

    ${message}=   Set Variable  ${response.json()['message']}
    Should Contain    ${message}    Success
    ${innerData}=   Set Variable  ${response.json()['data']['data']}

    FOR    ${item}    IN    @{innerData}
        ${entity}=    Get From Dictionary    ${item}    entity
        ${entityType}=    Get From Dictionary    ${item}    entityType

        Run Keyword If    '${entityType}'=='folder'    Validate Folder    ${entity}
    END

    #Check Procedure Preview
#    END    FOR    ${item}    IN    @{innerData}
#        ${entity}=    Get From Dictionary    ${item}    entity
#        ${entityType}=    Get From Dictionary    ${item}    entityType
#
#        Run Keyword If    '${entityType}'=='procedure'    Validate Folder    ${entity}
#        Exit For Loop If    '${entityType}'=='procedure'
#    END




Check listWithFolders API Status with Search [/api/mentor/procedures/library/listWithFolders]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=modifiedOn
    ...    procedureName=demo
    ...    sortOrder=desc
    ...    folderId=
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/listWithFolders
    ${response}=      GET On Session    Mentor    ${ENDPOINT}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}     params=${params}
    Status Should Be  200    ${response}

Check listWithFolders API Status with Folder ID [/api/mentor/procedures/library/listWithFolders]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    AuthorScreen.Generate Unique Number
    ${ENDPOINT}=   Set Variable    /api/mentor/folder/create
    ${data}=    Create Dictionary    title=Folder-${UniqueNumberTest}    description=this is for testing purpose
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Log    ${response}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=modifiedOn
    ...    procedureName=Folder-${UniqueNumberTest}
    ...    sortOrder=desc
    ...    folderId=
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/library/listWithFolders
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}

Check getPath API [/api/mentor/folder/getPath]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${params}=    Create Dictionary
    ...    type=Folder
    ${ENDPOINT}=   Set Variable    /api/mentor/folder/getPath/${FolderID}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}

Check getAllTasks API Status [/api/mentor/tasks/v2/getAllTasks/]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/tasks/v2/getAllTasks/7d84ffe5-024f-4066-8752-714dcf7e784c/ab72c1b5-4cf6-463e-8e55-9492677affc2
    ${RequestPayload}=    Set Variable    db29cf2d-97a0-48df-bea4-3edec79ab163
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}

    ${json}=    Set Variable    ${response.json()}
    Log    ${json}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${procedureId}=    Get From Dictionary    ${json['data']}    procedureId
    Should Not Be Empty    ${procedureId}

Check procedureCreate API [/api/mentor/user/v2]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/user/v2?page=1&pageSize=1000&filters[status][]=active&filters[personaDetails.appScopes.PROCEDURE][]=CREATE
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

Check create API [/api/mentor/configurations/ppe/procedures/create]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/configurations/ppe/procedures/create
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

Check configurations/PPE API Status [/api/mentor/configurations/ppe/]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/configurations/ppe/aa059bb6-b0ea-4697-8ccb-989e9f9f6d4b
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

Check tags API Status [api/mentor/procedures/library/tags]
    [Tags]    CZ-7545
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/tags?pageSize=1000
    ${response}=     GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

     ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${data}=    Get From Dictionary    ${json}    data
    FOR    ${item}    IN    @{data}
        Should Not Be Empty    ${item['tagId']}
        Log    ${item['tagId']}
    END
    #Apply tags
    ${tagId}=    Set Variable    ${data[0]['tagId']}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/listWithFolders?page=1&pageSize=100&sortBy=modifiedOn&sortOrder=desc&tags[]=${tagId}&folderId=
    ${response}=     GET On Session    Mentor    ${ENDPOINT}
    Status Should Be  200    ${response}
    
     ${innerData}=    Set Variable    ${response.json()["data"]["data"]}


    FOR    ${item}    IN    @{innerData}
        ${entity}=    Get From Dictionary    ${item}    entity
        ${entityType}=    Get From Dictionary    ${item}    entityType
        Run Keyword If    '${entityType}'=='procedure'    Validate The Tags Of The Procedures In API Response    ${entity}    ${tagId}
    END

Check create Folder API Status [/api/mentor/folder/create]#
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/folder/create
    ${data}=    Create Dictionary    title=Folder-${UniqueNumberTest}    description=this is for testing purpose
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200

Check general API Status [api/mentor/notifications/general]
    [Tags]    CZ-6732
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/notifications/general?page=1&pageSize=10&search=Completed
    ${response}=     GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}    ${ENDPOINT}
    Status Should Be  200    ${response}

    ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${data}=    Get From Dictionary    ${json}    data
    ${innerData}=   Get From Dictionary    ${json['data']}    data
    FOR    ${item}    IN    @{innerData}
        Should Be Equal As Strings    ${item['category']}    informational
    END

Check general API Status [api/mentor/notifications/general]
    [Tags]    CZ-6711
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/notifications/general?page=1&pageSize=10
    ${response}=     GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}    ${ENDPOINT}
    Status Should Be  200    ${response}

    ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${data}=    Get From Dictionary    ${json}    data
    ${innerData}=   Get From Dictionary    ${json['data']}    data
    FOR    ${item}    IN    @{innerData}
        Should Be Equal As Strings    ${item['category']}    informational
    END

Check mark as read API Status [api/mentor/notifications/mark-read/all]
    [Tags]    CZ-6712
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/notifications/mark-read/all
    ${response}=     POST On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}    ${ENDPOINT}
    Status Should Be  200    ${response}

    ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${data}=    Get From Dictionary    ${json}    data
    ${innerData}=   Get From Dictionary    ${json['data']}    data
    Should Be True    ${innerData['acknowledged']}


Check create Folder API Status with missing required field [/api/mentor/folder/create]
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/folder/create
    ${data}=    Create Dictionary    description=this is for testing purpose
    ${response}=    POST On Session    Mentor    ${ENDPOINT}    json=${data}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Log To Console    ${response}
    Should Be Equal As Integers    ${response.status_code}    403
    ${json}=    To Json    ${response.content}
    Should Contain    ${json["errorMessage"]}    add a valid value for title

Check the createProcedure API Status [/api/mentor/procedures/createProcedure]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/createProcedure
    ${payload}=    Create Dictionary
    ...    procedureName=Demo Procedure
    ...    isPrerequisite=false
    ...    workInstructionId=library
    ...    workInstructionType=2D
    ...    visibilityScope=GLOBAL
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    data=${payload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${payload}
    Status Should Be  201    ${response}

# Save Troubleshoot
Check save Troubleshoot API Status [/api/mentor/troubleShooting/save]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/troubleShooting/save
    ${payload}=    Create Dictionary
    ...    title=Fire
    ...    possibleCauses=Loosening of Wires
    ...    correctiveAction=Proper taping
    ...    preventiveAction=Proper taping
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    data=${payload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${payload}
    Status Should Be  200    ${response}

# getAll Troubleshoot
Check getAlltroubleshoot API [/api/mentor/troubleShooting/getAll]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/troubleShooting/getAll
    ${optionalParams}=    Create List    b7ce4e4a-bdee-43a0-8d1b-6c7a77cc13e5
    ${searchKey}=         Create Dictionary
    ${payload}=           Create Dictionary
    ...    optionalParams=${optionalParams}
    ...    searchKey=${searchKey}
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    data=${payload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${payload}
    Status Should Be  200    ${response}
#BOM API
Check bom API Status [/api/mentor/bom]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ${ENDPOINT}=   Set Variable    /api/mentor/bom
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}

Check bom Search API Status [/api/mentor/bom]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    search=parts
    ${ENDPOINT}=   Set Variable    /api/mentor/bom
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}     params=${params}
    Status Should Be  200    ${response}

Check bot API Status [/api/mentor/bot]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ${ENDPOINT}=   Set Variable    /api/mentor/bot
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}   params=${params}
    Status Should Be  200    ${response}

Check bot Search API Status [/api/mentor/bot]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    search=mf
    ${ENDPOINT}=   Set Variable    /api/mentor/bot
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}   params=${params}
    Status Should Be  200    ${response}

Check com API Status [/api/mentor/com]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ${ENDPOINT}=   Set Variable    /api/mentor/com
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}   params=${params}
    Status Should Be  200    ${response}

Check com Search API Status [/api/mentor/com]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    search=mf
    ${ENDPOINT}=   Set Variable    /api/mentor/com
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}     params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}   params=${params}
    Status Should Be  200    ${response}

Check Export Concise PDF API [/api/mentor/procedures/export/concisePdf]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/export/concisePdf/${ProcedureId}
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

Export Detailed PDF API [/api/mentor/procedures/export/pdf/]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/export/pdf/${ProcedureId}
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

# Duplicate Procedure
Check clone API [/api/mentor/procedures/clone]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/clone
    ${data}=    Create Dictionary
    ...    procedureId=${procedureID}
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200

Check create Duplicate Folder API Status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/folder/create
    ${data}=    Create Dictionary    title=Folder-${UniqueNumberTest}    description=this is for testing purpose
    ${response1}=    POST On Session    Mentor    ${ENDPOINT}    json=${data}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response1.status_code}    200
    ${response2}=    POST On Session    Mentor    ${ENDPOINT}    json=${data}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response2.status_code}    400
    ${json}=    To Json    ${response2.content}
    Should Contain    ${json["errorMessage"]}    A folder with same name already exists

#Check deleteProcedure API [/api/mentor/procedures/deleteProcedure]
#    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
#    Create Session    Mentor    ${BASE_URL}    headers=${headers}
#    ${ENDPOINT}=   Set Variable    /api/mentor/procedures/deleteProcedure/${ProcedureToDelete}
#    ${response}=     DELETE Request      Mentor    ${ENDPOINT}
#    Should Be Equal As Integers    ${response.status_code}    202
#    ${deleteId}=    Set Variable    ${response.json()['data']}
#    ${message}=    Set Variable    ${response.json()['message']}
#    Should Be Equal    ${deleteId}    ${ProcedureToDelete}
#    Should Be Equal    ${message}    Procedure successfully deleted

#Change Log
Check details API [/api/mentor/changelog/v2]
    [Tags]    CZ-6751
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}
    ${ENDPOINT}=   Set Variable    /api/mentor/changelog/v2/${detailsProcedureId}/${WI_ID}/details
    ${response}=     GET On Session    Mentor    ${ENDPOINT}    headers=${headers}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

New Version Publish [/api/mentor/version/procedure/new/]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/version/procedure/new/9a8d618d-d34f-4914-8e78-8c2179e98e29
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    #data=${payload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}

Check files API [/v2/files]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    ${abs_path}=    Normalize Path    ${FILEPATH}
    Log To Console    ${abs_path}
    &{files}=    Create Dictionary    file=@${abs_path}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable       /v2/files
    ${payload}=    Create Dictionary
    ...    org=73f7170e-b71c-470f-918f-b3e8186884f5
    ...    model=d25f03d1-acec-4b91-97d4-4cd653a0633c
    ...    name=maxresdefault.jpg
    ...    type=image/png
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    data=${payload}    files=${files}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${payload}
    Status Should Be  200    ${response}

Check getProcedure API [/mentor/procedures/getProcedure]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${params}=    Create Dictionary
    ...    translate=false
    ${ENDPOINT}=   Set Variable    /mentor/procedures/getProcedure/${procedureID}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}        params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}        params=${params}
    Status Should Be  200    ${response}

# Translate API
Check translate API Status [/api/mentor/languages/translate]
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${text}=    Create List    This is for testing purpose
    ${ENDPOINT}=    Set Variable    /api/mentor/languages/translate
    ${payload}=    Create Dictionary
    ...    sourceLanguage=en
    ...    targetLanguage=fr
    ...    text=${text}
    ${response}=    POST On Session    Mentor    ${ENDPOINT}    json=${payload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${payload}
    Status Should Be    200    ${response}
    ${translatedText}=    Set Variable    ${response.json()['data']}
    Should Contain    ${translatedText}    C’est à des fins de test

Check generate API [User Input]
    [Tags]   A
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/dynamicForms/generate?blockId=&formId=
#Nested Dictionary
    ${cycletime}=     Convert To Integer    1
    ${validationRule}=    Create Dictionary
    ...    type=startsWith
#    ...    value=Testing

    ${inputField}=    Create Dictionary
    ...    title=Enter the Room temperature
    ...    hint=
    ...    type=number
    ...    required=${False}
    ...    attachmentsRequired=${False}
    ...    checklistAllRequired=${False}
    ...    validationRule=${validationRule}

    ${inputFields}=    Create List    ${inputField}

    ${inputBlock}=    Create Dictionary
#    ...    blockName=Block 2
    ...    showAtStart=${False}
    ...    inputFields=${inputFields}

    ${inputBlocks}=    Create List    ${inputBlock}

    ${iStepUserGroup}=    Create Dictionary
    ...    id=
    ...    name=
    ...    rules=
    ...    description=
    ...    inputBlocks=${inputBlocks}
    ...    cycleTime=${cycletime}

    ${procedureIds}=    Create List
    ...    ${EMPTY}

    ${workInstructionIds}=    Create List
    ...    ${EMPTY}

    ${final_payload}=    Create Dictionary
    ...    iStepUserGroup=${iStepUserGroup}
    ...    procedureIds=${procedureIds}
    ...    workInstructionIds=${workInstructionIds}

    Log    ${final_payload}

    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${final_payload}     expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${final_payload}
    Status Should Be  201    ${response}
    ${title}=    Extract Title From Response        ${response.json()}
    Should Contain    ${title}    Enter the Room temperature



Check list API Status on Procedure Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/approvals/v2/list?page=1&pageSize=10&sortBy=requestedOn&sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success
    ${data}=    Get From Dictionary    ${json}    data
    ${innerData}=   Get From Dictionary    ${json['data']}    data
    FOR    ${item}    IN    @{innerData}
        ${status}=    Get From Dictionary    ${item}    approvalStatus
        Log    ${status}
        Should Be True    '${status}' == 'approved' or '${status}' == 'rejected'
    END

Check list API Status for Approved procedure on Procedure Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable     /api/mentor/approvals/v2/list?page=1&pageSize=10&sortBy=requestedOn&sortOrder=desc&filters\[approverStatus\]\[\]=approved
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    Log    ${response.json()}

Check list API Status for Rejected procedure on Procedure Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/approvals/v2/list?page=1&pageSize=10&sortBy=requestedOn&sortOrder=desc&filters[approverStatus][]=rejected
    ${response}=    GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be    200    ${response}
    Log    ${response.json()}

Check list API Status for searched procedure on Procedure Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/approvals/v2/list?page=1&pageSize=10&search=procedure&sortBy=requestedOn&sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    Log    ${response.json()}
    ${json}=    Set Variable    ${response.json()}
    ${message}=    Get From Dictionary    ${json}    message
    Should Contain    ${message}    Success

Check signOffs API Status on Sign-Off Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/executedTraining/signOffs?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=updatedOn&sortOrder=desc&groupBy=versionId
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}
    Log    ${response.json()}

Check list API Status for searched procedure on Procedure Approval page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/executedTraining/signOffs?page=1&pageSize=10&search=bolt&sortBy=updatedOn&sortOrder=desc&groupBy=versionId
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&search=bolt&sortBy=updatedOn&sortOrder=desc&groupBy=versionId
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}

Verify The Reponse of Preferences API
    [Tags]      A
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/user/preferences
    GET On Request      ${ENDPOINT} 
    ${response}=    Verify The Status Response
    ${message}=    Set Variable    ${response['message']}
    Should Be Equal    ${message}    Documents fetched successfully
    @{FieldList}=    Create List
#    ${i}=   Set Variable    0
       FOR    @{item}    IN    ${response['data']['columnizer']}
       Log  ${item}
            Append To List    ${FieldList}    ${item['field']}
#            ${i}  Evaluate    ${i}+1
       END

    Log      @{FieldList}

#    ${FieldList}=   Create List     ${response['data']['columnizer']}
#    Log     ${FieldList}
   ## PUT Preference API
   ${ENDPOINT}=    Set Variable    api/mentor/user/preferences
   
   ${payload}=   Set Variable       []
   PUT On Request      ${ENDPOINT}     ${payload}
   ${response}=    Verify The Status Response
   Capture API Response Time     ${response}   ${ENDPOINT}     ${payload}


ChangeLog API
    [Tags]  A
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable      api/mentor/changelog/v2/list
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${Message}=   Set Variable  ${response.json()['message']}
    Should Be Equal    ${Message}    Success

ChangeLog API with Search
    [Tags]  A
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable      api/mentor/changelog/v2/list
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    search=version
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${Message}=   Set Variable  ${response.json()['message']}
    Should Be Equal    ${Message}    Success
     