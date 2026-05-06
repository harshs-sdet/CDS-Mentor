*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Library    BuiltIn
Resource        ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Variables        ../../../config/Mentor/API/${ENV}_env.yaml
Library     ../../../src/api/Mentor/CommonUtils.py
Resource    ../../../pageobjects/keywords/api/Common/Common.resource
*** Test Cases ***
Check getAll API on Training listing page
    Append To File    ${CSV_FILE}       Training\n
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    /api/mentor/Training/getAll
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=    GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${TotalTrainings}=     Set Variable    ${response.json()['data']['totalDocuments']}
    Check The Pagination    ${response.json()}
    Log    ${response.json()}

Check create Training API Status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/create
    ${trainingTitle}=    Set Variable    Training-${UniqueNumberTest}
    Set Global Variable    ${trainingTitle}
    ${data}=    Create Dictionary    trainingName=${trainingTitle}    trainingDescription=This is for sample Training
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    ${groupId}=    Set Variable    ${response.json()['data']['groupId']}
    Set Global Variable    ${groupId}
    Log    ${groupId}

Check getAll API Status for searched training on Trainings page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    https://mentor-uat3.cdsvisual.net/api/mentor/Training/getAll
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    search=${trainingTitle}
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${ResultedtrainingName}=    Set Variable    ${response.json()['data']['data'][0]['trainingName']}
    Should Be Equal    ${trainingTitle}    ${ResultedtrainingName}
    Log    ${response.json()}

Check View Training API
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/getAll
    ${params}=    Create Dictionary
    ...    trainingId=${groupId}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${ResultedtrainingName}=    Set Variable    ${response.json()['data']['data'][0]['trainingName']}
    Should Be Equal    ${trainingTitle}    ${ResultedtrainingName}
    Log    ${response.json()}
    #Edit Training
    ${ENDPOINT}=   Set Variable    api/mentor/Training/getAll
    ${params}=    Create Dictionary
    ...    trainingId=${groupId}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${ResultedtrainingName}=    Set Variable    ${response.json()['data']['data'][0]['trainingName']}
    Should Be Equal    ${trainingTitle}    ${ResultedtrainingName}
    Log    ${response.json()}

Check delete API on Training's page
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/create
    ${data}=    Create Dictionary    trainingName=Training-${UniqueNumberTest}    trainingDescription=This is for sample Training
    ${create_response}=    POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${create_response}    ${ENDPOINT}    json=${data}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}

    ${json}=    Set Variable    ${create_response.json()}
    ${trainingId}=    Get From Dictionary    ${json['data']}    groupId
    Log    Training ID: ${trainingId}

    ${groupIds}=    Create List    ${trainingId}
    ${delete_data}=    Create Dictionary    groupIds=${groupIds}
    ${delete_response}=    POST On Session    Mentor    api/mentor/Training/delete    json=${delete_data}
    Capture API Response Time     ${delete_response}   api/mentor/Training/delete    json=${delete_data}
    Status Should Be    200    ${delete_response}
    Log    ${delete_response.json()}

Check list API Status on Select Procedure Window on Create Training Page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list
    ${RequestPayload}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=modified_at
    ...    sortOrder=desc
    ...    isPreviousVersionPublished=true
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}
    ${totalDocuments}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalPages}=    Set Variable    ${response.json()['data']['totalPages']}
    Log    ${totalDocuments}     
    Log    ${totalPages}


Check create Training API with No Procedures
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/create
    ${trainingName}=    Set Variable    Training-${UniqueNumberTest}
    Set Global Variable    ${trainingName}
    ${data}=    Create Dictionary    trainingName=${trainingName}    trainingDescription=This is for sample Training
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200

Check create Training API with added Procedures
    [Tags]  A
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/create
    ${trainingName}=    Set Variable    Training-${UniqueNumberTest}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list
    ${RequestPayload}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=modified_at
    ...    sortOrder=desc
    ...    isPreviousVersionPublished=true
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    ${proclist_json}=    Set Variable    ${response.json()}
    Log    ${proclist_json}
    ${outer_data}=    Get From Dictionary    ${proclist_json}    data
    ${procedures_list}=    Get From Dictionary    ${outer_data}    data

    ${procedureIds}=    Create List
    FOR    ${index}    IN RANGE    0    3
        ${proc}=    Get From Dictionary    ${procedures_list[${index}]}    procedureId
        Append To List    ${procedureIds}    ${proc}
    END
    Log     ${procedureIds}

    ${content1}=    Create Dictionary
    ...  contentId=${procedureIds}[0]
    ...  objectType=Procedure
    ${content2}=    Create Dictionary
    ...  contentId=${procedureIds}[1]
    ...  objectType=Procedure
    ${content3}=    Create Dictionary
    ...  contentId=${procedureIds}[2]
    ...  objectType=Procedure
    ${groupContentsList}=   Create List     ${content1}     ${content2}     ${content3}

    ${training_data}=    Create Dictionary
    ...    trainingName=Training-${UniqueNumberTest}
    ...    trainingDescription=This is sample Training with procedures
    ...    groupContents=${groupContentsList}

    ${create_response}=    POST On Session    Mentor    api/mentor/Training/create    json=${training_data}
    Capture API Response Time     ${create_response}   api/mentor/Training/create    json=${training_data}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}
    ${groupId}=   Set Variable    ${create_response.json()['data']['groupId']}

    ${ENDPOINT}=   Set Variable    api/mentor/Training/getAll
    ${params}=    Create Dictionary
    ...    trainingId=${groupId}
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}    ${ENDPOINT}    params=${params}
    Status Should Be  200    ${response}
    ${ResultedtrainingName}=    Set Variable    ${response.json()['data']['data'][0]['trainingName']}
    Should Be Equal    ${trainingName}    ${ResultedtrainingName}

Check update training api status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/Training/create
    ${data}=    Create Dictionary    trainingName=Training-${UniqueNumberTest}    trainingDescription=This is for sample Training
    ${response}=     POST On Session    Mentor    ${ENDPOINT}    json=${data}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Log    ${response.json()}

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data
    ${trainingId}=  Get From Dictionary    ${data}    groupId
    ${ENDPOINT}=   Set Variable    api/mentor/Training/getAll?trainingId=${trainingId}
    ${view_response}=    GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${view_response}    ${ENDPOINT}
    Status Should Be    200    ${view_response}

    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=modified_at&sortOrder=desc&isPreviousVersionPublished=true
    ${proclist_response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${proclist_response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${proclist_response}

    ${proclist_json}=    Set Variable    ${proclist_response.json()}
    Log    ${proclist_json}
    ${outer_data}=    Get From Dictionary    ${proclist_json}    data
    ${procedures_list}=    Get From Dictionary    ${outer_data}    data

    ${procedureIds}=    Create List
    FOR    ${index}    IN RANGE    3    6
        ${proc}=    Get From Dictionary    ${procedures_list[${index}]}    procedureId
        Append To List    ${procedureIds}    ${proc}
    END
    Log     ${procedureIds}

    ${id1}=    Get From List    ${procedureIds}    0
    ${id2}=    Get From List    ${procedureIds}    1

    ${content1}=    Create Dictionary    contentId=${id1}    objectType=Procedure
    ${content2}=    Create Dictionary    contentId=${id2}    objectType=Procedure
    ${groupContentsList}=   Create List     ${content1}     ${content2}

    ${training_data}=    Create Dictionary
    ...    trainingName=Edited Training-${UniqueNumberTest}
    ...    trainingDescription=This is sample Training with procedures
    ...    groupContents=${groupContentsList}

    ${create_response}=    POST On Session    Mentor    url=api/mentor/training/update?trainingId=${trainingId}    json=${training_data}    expected_status=anything
    Capture API Response Time     ${create_response}   url=api/mentor/training/update?trainingId=${trainingId}    json=${training_data}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}