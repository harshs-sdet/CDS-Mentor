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

*** Test Cases ***
Verify Site Admin is able to access BOM
    Append To File    ${CSV_FILE}       PartsTools\n
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   api/mentor/bom
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      sortBy=createdOn
    ...      sortOrder=desc
    GET On Request    ${ENDPOINT}       ${param}
    Verify The Status Response
    Verify The Response Of The Request

Verify Site Admin is able to access BOT
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   api/mentor/bot
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      sortBy=createdOn
    ...      sortOrder=desc
    GET On Request    ${ENDPOINT}       ${param}
    Verify The Status Response
    Verify The Response Of The Request

Verify Site Admin is able to access COM
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   api/mentor/com
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      sortBy=createdOn
    ...      sortOrder=desc
    GET On Request    ${ENDPOINT}       ${param}
    Verify The Status Response
    Verify The Response Of The Request

Verify user Is able to Add BOM
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   /api/mentor/bom/create
    ${name}=    Set Variable        BOMAPI-Test
    ${requestPayload}=   Create Dictionary
    ...     name=${name}
    ...     supplyChainNumber=SCN98
    ...     quantity=10
    ...     gageType=
    ...     unit=
    ...     description=
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     data=${requestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}     data=${requestPayload}
    Status Should Be    200
    #Search the Created BOM Item
    ${ENDPOINT}=    Set Variable   api/mentor/bom
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      search=${name}
    ...      sortBy=createdOn
    ...      sortOrder=desc
    ${response}=    GET On Session      Mentor      ${ENDPOINT}     params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}     params=${param}
    Status Should Be    200     ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalDoc}=    Convert To String    ${totalDoc}
    Should Be Equal    ${totalDoc}    1

Verify user Is able to Add BOT
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   /api/mentor/bot/create
    ${name}=    Set Variable        BOTAPI-Test
    ${requestPayload}=   Create Dictionary
    ...     name=BOTAPI-Test
    ...     supplyChainNumber=SCN987
    ...     quantity=10
    ...     gageType=
    ...     unit=
    ...     description=
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     data=${requestPayload}
    Capture API Response Time     ${response}   ${ENDPOINT}     data=${requestPayload}
    Status Should Be    200
    #Search the Created BOT Item
    ${ENDPOINT}=    Set Variable   api/mentor/bot
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      search=${name}
    ...      sortBy=createdOn
    ...      sortOrder=desc
    ${response}=    GET On Session      Mentor      ${ENDPOINT}     params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}     params=${param}
    Status Should Be    200     ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalDoc}=    Convert To String    ${totalDoc}
    Should Be Equal    ${totalDoc}    1

Verify user Is able to Add COM
    ${headers}=     Get Default Headers    ${AUTH_TOKEN_SiteAdm}
    Create The Session     ${headers}
    ${ENDPOINT}=    Set Variable   /api/mentor/com/create
    ${name}=    Set Variable        COMAPI-Test
    ${requestPayload}=   Create Dictionary
    ...     supplyChainNumber=SCN98
    ...     quantity=10
    ...     unit=
    ...     description=
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     data=${requestPayload}      expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}     data=${requestPayload}
    Status Should Be    400
    Remove From Dictionary    ${requestPayload}    supplyChainNumber=SCN98
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     data=${requestPayload}      expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}     data=${requestPayload}
    Status Should Be    400
    Set To Dictionary    ${requestPayload}    name=${name}    supplyChainNumber=SCN98
    ${response}=    POST On Session     Mentor      ${ENDPOINT}     data=${requestPayload}      expected_status=anything
    Capture API Response Time     ${response}   ${ENDPOINT}     data=${requestPayload}
    Status Should Be    200

    #Search the Created COM Item
    ${ENDPOINT}=    Set Variable   api/mentor/com
    ${param}=   Create Dictionary
    ...      page=1
    ...      pageSize=10
    ...      search=${name}
    ...      sortBy=createdOn
    ...      sortOrder=desc
    ${response}=    GET On Session      Mentor      ${ENDPOINT}     params=${param}
    Capture API Response Time     ${response}   ${ENDPOINT}     params=${param}
    Status Should Be    200     ${response}
    ${totalDoc}=    Set Variable    ${response.json()['data']['totalDocuments']}
    ${totalDoc}=    Convert To String    ${totalDoc}
    Should Be Equal    ${totalDoc}    1
