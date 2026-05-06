*** Settings ***
Library    SeleniumLibrary
Library     String
Library    Collections
Library    OperatingSystem
Library    BuiltIn
Library    csvLibrary
Library    RequestsLibrary
Library    DateTime
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Library     ../../../../src/api/Mentor/CommonUtils.py

*** Variables ***
${CSV_FILE}      ${CURDIR}/../../../../testdata/API/Web/Mentor/api_logs.csv

*** Keywords ***
Get Default Headers
    [Arguments]    ${auth_token}
    ${headers}=    Create Dictionary
    ...    authorization=${auth_token}
    ...    accept=application/json, text/plain, */*
    ...    accept-language=en-US,en;q=0.9
    RETURN    ${headers}

Extract Title From Response
    [Arguments]    ${json}
    ${title}=    Set Variable    ${json['form']['blocks']['Block 2']['inputFields'][0]['title']}
    RETURN    ${title}

Get Response Details
    [Arguments]    ${json}
    ${data}=    Get From Dictionary    ${json}    data
    ${ids}=     Create List
     FOR    ${item}    IN    @{data}
     ${id}=    Get From Dictionary    ${item}    procedureId
     Append To List    ${ids}    ${id}
     END
     RETURN        ${ids}

Check The Pagination
    [Arguments]     ${response}
    ${CurrentPage}=     Set Variable    ${response['data']['curentPage']}
    ${TotalPage}=     Set Variable    ${response['data']['totalPages']}
    ${hasNext}=    Find the Remaining Page Count   ${CurrentPage}    ${TotalPage}
    IF    ${hasNext}== True
        Should Be True    ${response['data']['hasNext']}
    END

Find the Remaining Page Count
    [Arguments]    ${CurrentPage}    ${TotalPage}
    ${remainingPages}=    Set Variable    false
    ${remaining}=    Evaluate    ${TotalPage}-${CurrentPage}
    IF    ${remaining} > 0
        ${remainingPages}=    Set Variable     True
    END
    RETURN     ${remainingPages}

Generate Unique Digit
    ${random_digit}=    Generate Random String    4    [NUMBERS]
    RETURN      ${random_digit}

Validate Folder
    [Arguments]    ${entity}
    ${folderId}=    Get From Dictionary    ${entity}    folderId
    ${title}=       Get From Dictionary    ${entity}    title
    Should Not Be Empty    ${folderId}
    Should Not Be Empty    ${title}

Get Procedure Id From Entity
    [Arguments]    ${entity}
    ${folderId}=    Get From Dictionary    ${entity}    folderId
    ${title}=       Get From Dictionary    ${entity}    title
    Should Not Be Empty    ${folderId}
    Should Not Be Empty    ${title}
    
Validate The Tags Of The Procedures In API Response
    [Arguments]    ${entity}    ${EXPECTED_TAGID}
    ${TAGID_LIST}=    Get From Dictionary    ${entity}    tags
    List Should Contain Value    ${TAGID_LIST}    ${EXPECTED_TAGID}

Create The Session
    [Arguments]     ${headers}
    Create Session   Mentor      ${BASE_URL}     headers=${headers}

GET On Request
    [Arguments]     ${ENDPOINT}       ${param}=False
    ${response}=    GET On Session      Mentor     ${ENDPOINT}       params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}       params=${param}
    Set Global Variable     ${response}

Verify The Status Response
    Status Should Be    200     ${response}
    RETURN      ${response.json()}

Verify The Response Of The Request
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalPage}=    Set Variable    ${response.json()['data']['totalPages']}
    ${currentPage}=    Set Variable    ${response.json()['data']['currentPage']}
    ${pageSize}=    Set Variable    ${response.json()['data']['pageSize']}

Verify The Response Message
    ${message}=    Set Variable    ${response.json()['data']['message']}
    Should Be Equal    ${message}    Documents fetched successfully

Get Response Value
    [Arguments]     ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['columnizer'][]}
    ${totalPage}=    Set Variable    ${response.json()['data']['columnizer']}
    ${currentPage}=    Set Variable    ${response.json()['data']['columnizer']}
    ${pageSize}=    Set Variable    ${response.json()['data']['columnizer']}
#    Verify The Response Data      ${response}     tableId

PUT On Request
    [Arguments]     ${ENDPOINT}     ${payload}
    PUT On Session      ${ENDPOINT}     json=${payload}
    Capture API Response Time     ${response}   ${ENDPOINT}     json=${payload}

#Verify The Response Data
#    [Arguments]     ${response}     tableId

Capture API Response Time
    [Arguments]  ${response}    ${endpoint}    ${payload}=False
#    ${end}=      Get Time    epoch
#    ${response_time}=    Evaluate    ${end} - ${start}
#    ${sec}=    Evaluate    round(${response_time}, 3)
#    ${ms}=     Evaluate    round(${response_time} * 1000, 2)
    Log    Postman-like time: ${response.elapsed.total_seconds()} sec    console=yes
    ${line}=    Catenate    SEPARATOR=,    ${endpoint}     ${payload}     ${response.elapsed.total_seconds()} sec
    Append To File    ${CSV_FILE}    ${line}\n
#    ${response_time}=    Set Variable    ${response.elapsed.total_seconds()}
#    Log    API Response Time: ${response_time} seconds    console=yes

Capture Start Time
    ${start}=    Get Time    epoch
Capture End Time
    ${end}=    Get Time    epoch
    ${response_time}=    Evaluate    ${end} - ${start}
    Log    API Response Time: ${response_time} seconds