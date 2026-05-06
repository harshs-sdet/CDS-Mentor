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

Check getAll [Skills] API
    Append To File    ${CSV_FILE}       Skills\n
    ${headers}    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/getAll
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=    GET On Session   Mentor     ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${TotalSkills}=     Set Variable    ${response.json()['data']['totalDocuments']}
    Log    ${TotalSkills}
    Check The Pagination    ${response.json()}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/getAll
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=100
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=    GET On Session   Mentor     ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${TotalSkills}=     Set Variable    ${response.json()['data']['totalDocuments']}
    Log    ${TotalSkills}
    Check The Pagination    ${response.json()}

Create Skill API [Empty Skill]
    AuthorScreen.Generate Unique Number
    ${headers}    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    /api/mentor/Skill/create
    ${skillName}=    Set Variable    Skill-${UniqueNumbertest}
    Set Global Variable    ${skillName}
    ${requestPayload}=    Create Dictionary
    ...    skillName=${skillName}
    ...    skillDescription=new skill
    ...    assessmentFrequency=daily
    ...    trainingsCount=0
    ${response}=    POST On Session   Mentor     ${ENDPOINT}    json=${requestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${groupId}=     Set Variable    ${response.json()['data']['groupId']}
    Set Global Variable    ${groupId}
    # Search Skill
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/getAll
    ${params}=    Create Dictionary
    ...    page=1
    ...    pageSize=10
    ...    search=${skillName}
    ...    sortBy=createdOn
    ...    sortOrder=desc
    ${response}=    GET On Session   Mentor     ${ENDPOINT}    params=${params}
    Capture API Response Time     ${response}   ${ENDPOINT}    params=${params}
    Status Should Be    200    ${response}
    ${count}=     Set Variable    ${response.json()['data']['totalDocuments']}
    ${num_type}=     Evaluate    type(${count}).__name__
    Log    ${num_type}
    Should Be Equal As Integers   ${count}    1

Check Delete Skill API [Single/Multiple]
    ${headers}    Get Default Headers    ${AUTH_TOKEN}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable    /api/mentor/Skill/delete
    ${group}=    Create List    ${groupId}
    ${requestPayload}=    Create Dictionary
    ...    groupIds=${group}
    ${response}=    POST On Session   Mentor     ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success

Check Create Skills API with Procedures With Incorrect Target Level
    AuthorScreen.Generate Unique Number
    ${headers}=     Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}    headers=${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/Training/getAll?
    ${response}=    GET On Session   Mentor     ${ENDPOINT}
    Capture API Response Time     ${response}  ${ENDPOINT}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${json}=        Convert String To Json    ${response.text}
    @{groupIds}=    Get Value From Json       ${json}    $.data.data[*].groupId
    Log Many        @{groupIds}

    ${skillName}=    Set Variable    Skill-${UniqueNumbertest}
    Set Global Variable    ${skillName}

    @{groupContents}=    Create List

    ${level}=    Set Variable    1
    ${entry}=    Set Variable    0


    FOR    ${gid}    IN    @{groupIds}
        &{content}=    Create Dictionary
        ...    contentId=${gid}
        ...    objectType=Training
        ...    level=${level}
        ...    targetLevel=${level}
        ...    entryLevel=${entry}

        Append To List    ${groupContents}    ${content}

        ${level}=    Evaluate    ${level} + 1
        ${entry}=    Evaluate    ${entry} + 1
    END
    ${count}=    Get Length    ${groupIds}
    ${requestPayload}=    Create Dictionary
    ...    skillName=${skillName}
    ...    skillDescription=new skill
    ...    assessmentFrequency=FREQUENCY.DAILY
    ...    groupContents=${groupContents}
    ...    trainingsCount=${count}
    Log    ${requestPayload}
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/create
    ${response}=    POST On Session   Mentor     ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}    json=${requestPayload}
    Status Should Be    400    ${response}
    ${message}=    Set Variable    ${response.json()['message']}
    Should Contain    ${message}    incorrect

Check Create Skills API with Trainings
    [Tags]  A
    AuthorScreen.Generate Unique Number
    ${headers}=     Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}    headers=${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/Training/getAll?
    ${response}=    GET On Session   Mentor     ${ENDPOINT}
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${json}=        Convert String To Json    ${response.text}
    @{groupIds}=     Create List
    FOR    ${i}    IN RANGE    0    5
         ${groupId}=    Get Value From Json       ${json}    $.data.data[${i}].groupId
         Append To List    ${groupIds}  ${groupId}
    END

    Log Many        @{groupIds}

    ${skillName}=    Set Variable    Skill-${UniqueNumbertest}
    Set Global Variable    ${skillName}

    @{groupContents}=    Create List

    ${level}=    Set Variable    1
    ${entry}=    Set Variable    0

    ${ALL_TRAININGS_GROUPID}=    Create List

    FOR    ${gid}    IN    @{groupIds}
        ${gid}=    Set Variable    ${gid}[0]
        &{content}=    Create Dictionary
        ...    contentId=${gid}
        ...    objectType=Training
        ...    level=${level}
        ...    targetLevel=${level}
        ...    entryLevel=${entry}

        Append To List    ${ALL_TRAININGS_GROUPID}    ${content}

        ${level}=    Evaluate    ${level} + 1
        ${entry}=    Evaluate    ${entry} + 1
    END
#    ${groupIds}=    Evaluate    ${ALL_TRAININGS_GROUPID[:5]}
    ${count}=    Get Length    ${groupIds}
    Set Global Variable     ${count}

    ${requestPayload}=    Create Dictionary
    ...    skillName=${skillName}
    ...    skillDescription=new skill
    ...    assessmentFrequency=daily
    ...    groupContents=${ALL_TRAININGS_GROUPID}
    ...    trainingsCount=${count}
    Log    ${requestPayload}
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/create
    ${response}=    POST On Session   Mentor     ${ENDPOINT}    json=${requestPayload}    expected_status=anything
    Status Should Be    200    ${response}
    ${message}=     Set Variable    ${response.json()['message']}
    Should Contain   ${message}    Success
    ${SkillID}=  Set Variable   ${response.json()['data']['groupId']}
    Set Global Variable   ${SkillID}
    ${response}=     Set Variable    ${response.json()}
    ${skillId}=    Set Variable   ${response["data"]["groupId"]}
    #Get the user info
    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
    ${RequestPayload}=    Set Variable    page=1&pageSize=100
    ${usersresponse}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
    ${userlist_json}=    Set Variable    ${usersresponse.json()}
    ${outer_data}=    Get From Dictionary    ${userlist_json}    data
    ${users_list}=    Get From Dictionary    ${outer_data}    data


    ${assignee}=    Get From Dictionary   ${users_list[2]}    userId
    ${USERS_TO_BE_ASSIGNED_TO_SKILLS}=    Create Dictionary    userId=${assignee}
    ${USERS_LIST}=    Create List    ${USERS_TO_BE_ASSIGNED_TO_SKILLS}

    ${assignedLevel}=    Evaluate    int(1)


    ${EMPTY_GROUP_ID}=    Create List
    ${ASSIGN_SKILL_PARAMS}=      Create Dictionary
    ...  userGroupIds=${EMPTY_GROUP_ID}
    ...  individualUserIds=${USERS_LIST}
    ...  assignedId=${skillId}
    ...  assignedLevel=${assignedLevel}


    ${response}=    POST On Session    Mentor    api/mentor/Skill/updateOperatorTeam    json=${ASSIGN_SKILL_PARAMS}
    Status Should Be    200    ${response}
    ${message}=    Set Variable    ${response.json()['message']}
    Should Contain    ${message}    Success

Verify the Details of Created Skill
    ${headers}=     Get Default Headers    ${AUTH_TOKEN}
    Create Session    Mentor    ${BASE_URL}    headers=${headers}
    ${ENDPOINT}=    Set Variable    api/mentor/Skill/getAll
    ${params}=   Create Dictionary
    ...  skillId=${SkillID}
    ${response}=    GET On Session   Mentor     ${ENDPOINT}     data=${params}
    Status Should Be    200    ${response}
    ${SkillTitle}=  Set Variable   ${response.json()["data"]['data'][0]["skillName"]}
    ${CountTrainings}=  Set Variable   ${response.json()["data"]['data'][0]["trainingsCount"]}
    Should Be Equal   ${SkillTitle}     ${skillName}
    Should Be Equal    ${CountTrainings}     ${count}

#Verify the Update API
#    [Tags]   A
#    AuthorScreen.Generate Unique Number
#    ${headers}=     Get Default Headers    ${AUTH_TOKEN}
#    Create Session    Mentor    ${BASE_URL}    headers=${headers}
#    ${ENDPOINT}=    Set Variable    api/mentor/Skill/getAll
#    ${params}=   Create Dictionary
#    ...  skillId=${SkillID}
#    ${response}=    GET On Session   Mentor     ${ENDPOINT}     data=${params}
#    Status Should Be    200    ${response}
#########
#    ${level}=    Set Variable    1
#    ${entry}=    Set Variable    0
#
#    ${ALL_TRAININGS_GROUPID}=    Create List
#
#    FOR    ${gid}    IN    @{groupIds}
#        ${gid}=    Set Variable    ${gid}[0]
#        &{content}=    Create Dictionary
#        ...    contentId=${gid}
#        ...    objectType=Training
#        ...    level=${level}
#        ...    targetLevel=${level}
#        ...    entryLevel=${entry}
#
#        Append To List    ${ALL_TRAININGS_GROUPID}    ${content}
#
#        ${level}=    Evaluate    ${level} + 1
#        ${entry}=    Evaluate    ${entry} + 1
#    END
##    ${groupIds}=    Evaluate    ${ALL_TRAININGS_GROUPID[:5]}
#    ${count}=    Get Length    ${groupIds}
#    Set Global Variable     ${count}
#
#    ${requestPayload}=    Create Dictionary
#    ...    skillName=${skillName}
#    ...    skillDescription=new skill
#    ...    assessmentFrequency=daily
#    ...    groupContents=${ALL_TRAININGS_GROUPID}
#    ...    trainingsCount=${count}
#    Log    ${requestPayload}
#    ${ENDPOINT}=    Set Variable    api/mentor/Skill/create
#    ${response}=    POST On Session   Mentor     ${ENDPOINT}    json=${requestPayload}    expected_status=anything
#    Status Should Be    200    ${response}
#    ${message}=     Set Variable    ${response.json()['message']}
#    Should Contain   ${message}    Success
#    ${SkillID}=  Set Variable   ${response.json()['data']['groupId']}
#    Set Global Variable   ${SkillID}
#    ${response}=     Set Variable    ${response.json()}
#    ${skillId}=    Set Variable   ${response["data"]["groupId"]}
#    #Get the user info
#    ${ENDPOINT}=   Set Variable    api/mentor/user/v2?
#    ${RequestPayload}=    Set Variable    page=1&pageSize=100
#    ${usersresponse}=      GET On Session    Mentor    ${ENDPOINT}    data=${RequestPayload}
#    ${userlist_json}=    Set Variable    ${usersresponse.json()}
#    ${outer_data}=    Get From Dictionary    ${userlist_json}    data
#    ${users_list}=    Get From Dictionary    ${outer_data}    data
#
#
#    ${assignee}=    Get From Dictionary   ${users_list[2]}    userId
#    ${USERS_TO_BE_ASSIGNED_TO_SKILLS}=    Create Dictionary    userId=${assignee}
#    ${USERS_LIST}=    Create List    ${USERS_TO_BE_ASSIGNED_TO_SKILLS}
#
#    ${assignedLevel}=    Evaluate    int(1)
#
#
#    ${EMPTY_GROUP_ID}=    Create List
#    ${ASSIGN_SKILL_PARAMS}=      Create Dictionary
#    ...  userGroupIds=${EMPTY_GROUP_ID}
#    ...  individualUserIds=${USERS_LIST}
#    ...  assignedId=${skillId}
#    ...  assignedLevel=${assignedLevel}
#
#
#    ${response}=    POST On Session    Mentor    api/mentor/Skill/updateOperatorTeam    json=${ASSIGN_SKILL_PARAMS}
#    Status Should Be    200    ${response}
#    ${message}=    Set Variable    ${response.json()['message']}
#    Should Contain    ${message}    Success




