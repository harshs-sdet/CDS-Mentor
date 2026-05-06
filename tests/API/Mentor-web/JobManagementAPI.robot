*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Resource        ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Variables        ../../../config/Mentor/API/${ENV}_env.yaml
Library     ../../../src/api/Mentor/CommonUtils.py
Resource    ../../../pageobjects/keywords/api/Common/Common.resource

*** Variables ***
#${CSV_FILE}      ${CURDIR}/../../../../testdata/API/Web/Mentor/api_logs.csv

*** Test Cases ***
Check Reports API on Job Management Page
    [Tags]  A
    Create File    ${CSV_FILE}    ${EMPTY}
    Append To File    ${CSV_FILE}       JobManagement\n
    ${headers}=  Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/jobExecutionReport/report
    ${report_params}=   Create Dictionary
    ...  fromDate=1756665000
    ...  toDate=1758565799
    ${start}=    Get Time    epoch
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     json=${report_params}
#    Log    API Response Time: ${response_time}  seconds    console=yes
    Capture API Response Time     ${response}    ${ENDPOINT}     json=${report_params}
    ${response_time}=    Set Variable    ${response.elapsed.total_seconds()}
    Log    ${response.json()}
    ${stats}=    Get From Dictionary    ${response.json()["data"]["chartResponse"]}    jobOrderStatusStatistics
    ${total}=    Get From Dictionary    ${stats}    total
    ${sum_status}=    Evaluate    ${stats["completed"]} + ${stats["inProgress"]} + ${stats["notStarted"]} + ${stats["failed"]} + ${stats["paused"]}
    Should Be Equal As Integers    ${sum_status}    ${total}

    ${CTstats}=    Get From Dictionary    ${response.json()["data"]["chartResponse"]}    completionTimeStatistics
    ${CTtotal}=    Get From Dictionary    ${CTstats}    total
    ${CT_sum_status}=    Evaluate    ${CTstats["onTime"]} + ${CTstats["late"]}
    Should Be Equal As Integers    ${CT_sum_status}    ${CTtotal}

    ${SRstats}=    Get From Dictionary    ${response.json()["data"]["chartResponse"]}    successRateStatistics
    ${fpy}=        Get From Dictionary    ${SRstats}    fpy
    ${failed}=     Get From Dictionary    ${SRstats}    failedJobs
    ${CTstats}=    Get From Dictionary    ${response.json()["data"]["chartResponse"]}    completionTimeStatistics
    ${completed}=      Get From Dictionary    ${CTstats}    total
    ${total}=    Evaluate    ${failed}+${completed}
#    ${calc_fpy}=   Evaluate    round((${completed} / ${total}) * 100, 2)
#    Should Be Equal As Numbers    ${fpy}    ${calc_fpy}

Check list API on Job Management Page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable     api/mentor/joborders/list?
    ${RequestPayload}=    Set Variable      page=1&pageSize=10&sortBy=updatedOn&sortOrder=desc&filters\[createdOn\]\[0\]\[0\]=1756665000&filters\[createdOn\]\[0\]\[1\]=1758565799
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time       ${response}    ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}
    Log    ${response.json()}

Check list API on searched job on Job Management Page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable     api/mentor/joborders/list?
    ${RequestPayload}=    Set Variable      page=1&pageSize=10&search=JOB&sortBy=updatedOn&sortOrder=desc&filters\[createdOn\]\[0\]\[0\]=1756665000&filters\[createdOn\]\[0\]\[1\]=1758565799
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${RequestPayload}
    Status Should Be  200    ${response}
    Log    ${response.json()}

Check list API Status on Select Procedure Window on Create Job Page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=modified_at&sortOrder=desc&isPreviousVersionPublished=true
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}    ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}

Check v2 API Status on Create Job Page
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${RequestPayload}=    Set Variable    page=1&pageSize=100
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}    ${ENDPOINT}    data=${RequestPayload}
    Status Should Be    200    ${response}
    Log    ${response.json()}

Check create Job API Status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=modified_at&sortOrder=desc&isPreviousVersionPublished=true
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}     ${ENDPOINT}    data=${RequestPayload}
    ${proclist_json}=    Set Variable    ${response.json()}
    Log    ${proclist_json}
    ${outer_data}=    Get From Dictionary    ${proclist_json}    data
    ${procedures_list}=    Get From Dictionary    ${outer_data}    data

    ${procedureIds}=    Create List
    FOR    ${index}    IN RANGE    0    3
        ${proc}=    Get From Dictionary    ${procedures_list[${index}]}    procedureId
        Append To List    ${procedureIds}    ${proc}
    END
    ${ProcedureList}=   Create List     ${procedureIds}[0]      ${procedureIds}[1]      ${procedureIds}[2]
    Set Global Variable     ${ProcedureList}
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${RequestPayload}=    Set Variable    page=1&pageSize=100
    ${start}=    Get Time    epoch
    ${usersresponse}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${usersresponse}    ${ENDPOINT}    data=${RequestPayload}
    ${userlist_json}=    Set Variable    ${usersresponse.json()}
    ${outer_data}=    Get From Dictionary    ${userlist_json}    data
    ${users_list}=    Get From Dictionary    ${outer_data}    data


    ${assignee}=    Get From Dictionary   ${users_list[2]}    userId
    Log     ${assignee}
    ${dueDate}=    Get Current Date    increment=+1d    result_format=%Y-%m-%dT%H:%M:%S.000Z
    Log    ${dueDate}
    ${JobName}=    Set Variable    JOB-${UniqueNumberTest}
    ${SerialNumber}=    Create List    SERIAL-${UniqueNumberTest}
    ${SerialJobId}=    Set Variable     SERIAL-${UniqueNumberTest}
    Set Global Variable    ${JobName}
    Set Global Variable    ${SerialJobId}
    ${Job_params}=      Create Dictionary
    ...  jobType=serial
    ...  jobId=${SerialJobId}
    ...  jobName=${JobName}
    ...  material=MATERIAL-${UniqueNumberTest}
    ...  purchaseOrderNumber=${UniqueNumberTest}
    ...  assignee=${assignee}
    ...  procedures=${ProcedureList}
    ...  dueDate=${dueDate}
    ...  estimatedTime=0
    ...  serialIds=${SerialNumber}
    ...  quantity=1
    ${ENDPOINT}=   Set Variable    api/mentor/joborders/create
    ${start}=    Get Time    epoch
    ${create_response}=    POST On Session    Mentor    ${ENDPOINT}     json=${Job_params}
    Capture API Response Time     ${create_response}   ${ENDPOINT}    json=${Job_params}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}
    ${message}=    Set Variable    ${create_response.json()['message']}
    ${JobId}=    Set Variable    ${create_response.json()['data']['_id']}
    Should Contain    ${message}    Success
    Set Global Variable    ${JobId}

Check View Job API
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}      Set Variable      /api/mentor/joborders/${JobId}
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    ${ProceduresList}    Set Variable    ${response.json()['data']['procedures']}
    ${NameOfJOb}    Set Variable    ${response.json()['data']['jobName']}
    Should Be Equal As Strings    ${NameOfJOb}     ${JobName}
    Lists Should Be Equal    ${ProcedureList}    ${ProceduresList}    ignore_order=True
    ${ENDPOINT}      Set Variable      /api/mentor/joborders/procedures/${JobId}
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    @{JobProcedures}=    Get Response Details       ${response.json()}    
    Lists Should Be Equal    ${ProcedureList}    ${JobProcedures}    ignore_order=True

Check executedJob API
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}      Set Variable      /api/mentor/joborders/executedJob
    ${requestPayload}=    Create Dictionary
    ...    jobStatus=IN_PROGRESS
    ${start}=    Get Time    epoch
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be  400    ${response}

    Should Contain    ${response.json()['errorMessage']}    \"key\" is required
    ${requestPayload}=    Create Dictionary
    ...    key=${JobId}
    ...    jobStatus=IN_PROGRESS
    ${start}=    Get Time    epoch
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be  400    ${response}

    Should Contain    ${response.json()['errorMessage']}    \"jobId\" is required
    ${requestPayload}=    Create Dictionary
    ...    key=${JobId}
    ...    jobId=${SerialJobId}
    ...    jobStatus=IN_PROGRESS
    ${start}=    Get Time    epoch
    ${response}=      POST On Session    Mentor    ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be  200    ${response}
    Should Contain    ${response.json()['message']}    Success

Check delete Job API Status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=modified_at&sortOrder=desc&isPreviousVersionPublished=true
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    data=${requestPayload}
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
    ${ProcedureList}=   Create List     ${procedureIds}[0]      ${procedureIds}[1]      ${procedureIds}[2]

    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${RequestPayload}=    Set Variable    page=1&pageSize=100
    ${start}=    Get Time    epoch
    ${usersresponse}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${usersresponse}   ${ENDPOINT}    data=${requestPayload}
    ${userlist_json}=    Set Variable    ${usersresponse.json()}
    ${outer_data}=    Get From Dictionary    ${userlist_json}    data
    ${users_list}=    Get From Dictionary    ${outer_data}    data

    ${assignee}=    Get From Dictionary   ${users_list[2]}    userId
    Log     ${assignee}
    ${dueDate}=    Get Current Date    increment=+1d    result_format=%Y-%m-%dT%H:%M:%S.000Z
    Log    ${dueDate}
    ${SerialNumberSerialized}=    Create List       SERIAL-${UniqueNumberTest}
    ${Job_params}=      Create Dictionary
    ...  jobType=serial
    ...  jobId=SERIAL-${UniqueNumberTest}
    ...  jobName=JOB-${UniqueNumberTest}
    ...  material=MATERIAL-${UniqueNumberTest}
    ...  purchaseOrderNumber=${UniqueNumberTest}
    ...  assignee=${assignee}
    ...  procedures=${ProcedureList}
    ...  dueDate=${dueDate}
    ...  estimatedTime=0
    ...  quantity=1
    ...  serialIds=${SerialNumberSerialized}
    ${start}=    Get Time    epoch
    ${create_response}=    POST On Session    Mentor    api/mentor/joborders/create    json=${Job_params}
    Capture API Response Time     ${create_response}   api/mentor/joborders/create    json=${Job_params}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}
    ${data}=    Get From Dictionary    ${create_response.json()}    data
    ${jobID}=   Get From Dictionary    ${data}    _id
    Log    Job ID
    ${ENDPOINT}=   Set Variable    api/mentor/joborders/${jobID}
    ${start}=    Get Time    epoch
    ${response}=      DELETE On Session   Mentor    ${ENDPOINT}
    Capture API Response Time     ${response}   ${ENDPOINT}
    Status Should Be  200    ${response}
    Should Contain    ${response.json()["message"]}    Success

Check Edit Job API Status
    AuthorScreen.Generate Unique Number
    ${headers}=    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=   Set Variable    api/mentor/procedures/library/list?
    ${RequestPayload}=    Set Variable    page=1&pageSize=10&sortBy=modified_at&sortOrder=desc&isPreviousVersionPublished=true
    ${start}=    Get Time    epoch
    ${response}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${response}    ${ENDPOINT}    data=${RequestPayload}
    ${proclist_json}=    Set Variable    ${response.json()}
    Log    ${proclist_json}
    ${outer_data}=    Get From Dictionary    ${proclist_json}    data
    ${procedures_list}=    Get From Dictionary    ${outer_data}    data

    ${procedureIds}=    Create List
    FOR    ${index}    IN RANGE    0    1
        ${proc}=    Get From Dictionary    ${procedures_list[${index}]}    procedureId
        Append To List    ${procedureIds}    ${proc}
    END
    Log     ${procedureIds}
    ${ProcedureList}=   Create List     ${procedureIds}[0]

    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${RequestPayload}=    Set Variable    page=1&pageSize=100
    ${start}=    Get Time    epoch
    ${usersresponse}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    Capture API Response Time     ${usersresponse}   ${ENDPOINT}    data=${RequestPayload}
    ${userlist_json}=    Set Variable    ${usersresponse.json()}
    ${outer_data}=    Get From Dictionary    ${userlist_json}    data
    ${users_list}=    Get From Dictionary    ${outer_data}    data

    ${assignee}=    Get From Dictionary   ${users_list[2]}    userId
    Log     ${assignee}
    ${dueDate}=    Get Current Date    increment=+1d    result_format=%Y-%m-%dT%H:%M:%S.000Z
    Log    ${dueDate}
    ${SerialNumberSerialized}=    Create List       SERIAL-${UniqueNumberTest}
    ${Job_params}=      Create Dictionary
    ...  jobType=serial
    ...  jobId=SERIAL-${UniqueNumberTest}
    ...  jobName=JOB-${UniqueNumberTest}
    ...  material=MATERIAL-${UniqueNumberTest}
    ...  purchaseOrderNumber=${UniqueNumberTest}
    ...  assignee=${assignee}
    ...  procedures=${ProcedureList}
    ...  dueDate=${dueDate}
    ...  estimatedTime=0
    ...  quantity=1
    ...  serialIds=${SerialNumberSerialized}
    ${start}=    Get Time    epoch
    ${create_response}=    POST On Session    Mentor    api/mentor/joborders/create    json=${Job_params}
    Capture API Response Time     ${create_response}   api/mentor/joborders/create    json=${Job_params}
    Status Should Be    200    ${create_response}
    Log    ${create_response.json()}
    