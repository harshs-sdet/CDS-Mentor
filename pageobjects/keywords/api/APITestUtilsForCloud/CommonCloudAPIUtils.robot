*** Settings ***
Library  SeleniumLibrary
Library  String
# Library     ../../../../../Utilities/UncheckAllCheckboxes.py
Library    XML
Library   RequestsLibrary
Library          JSONLibrary
Library    Collections
Variables  ../../../locators/UI/Web/Dashboard_Locators.yaml
Variables  ../../../../Config/Default.yaml
Variables   ../../../../TestData/ui/web/Default.yaml
Library     ../../../../src/utilities/CommonUtils.py

*** Keywords ***

Fetch API Token From UI
    [Documentation]     This method will fetch the API tokens from UI.
    ${accessToken} =    Execute JavaScript    return sessionStorage.getItem("msal.idtoken");
    RETURN    ${accessToken}

Get Scan Info From Dashboard
    [Documentation]  Method to fetch the Total number of scans for a catsite from api in Dashboard.
    [Arguments]     ${accessToken}  ${fromDate}  ${toDate}  ${status}
     Create Session    API_TESTING_Trial    ${URL.url}
     &{headers}=       Create Dictionary       Authorization=Bearer ${accessToken}
     ${fromDate}      Replace String    ${fromDate}    /    -
     ${toDate}      Replace String    ${toDate}    /    -
     ${body}=     Create Dictionary      fromDate=${fromDate}    toDate=${toDate}  catSiteStatus=${status}
     ${response}     POST On Session    API_TESTING_Trial     ${APIsForCloud.scanInfoDashboard}    json=${body}   headers=${headers}
     Capture API Response Time     ${response}   ${start}
     ${responseinJson}   Set Variable    ${response.json()}
     @{data}     Get Value From Json    ${responseinJson}    data[0].id
     ${data}    Catenate    @{data}
     IF    '${data}' == '${EMPTY}'
            Log    Scan Info is not available for the given CatSite Status and the Date Range.
            ${scanInfoFromDashboard}  Set Variable  ${None}
     ELSE
            @{name}      Get Value From Json    ${responseinJson}    data[0].name
            ${name}    Catenate    @{name}
            @{active}      Get Value From Json    ${responseinJson}    data[0].active
            ${active}    Catenate    @{active}
            @{location}      Get Value From Json    ${responseinJson}    data[0].location
            ${location}    Catenate    @{location}
            @{rig}      Get Value From Json    ${responseinJson}    data[0].rigs
            ${rig}    Catenate    @{rig}
            @{totalScans}      Get Value From Json    ${responseinJson}    data[0].totalScans
            ${totalScans}    Catenate    @{totalScans}
            @{latitude}      Get Value From Json    ${responseinJson}    data[0].latitude
            ${latitude}    Catenate    @{latitude}
            @{longitude}      Get Value From Json    ${responseinJson}    data[0].longitude
            ${longitude}    Catenate    @{longitude}
            ${scanInfoFromDashboard}    Create Dictionary   name=${name}    active=${active}    location=${location}    rig=${rig}  totalScans=${totalScans}    latitude=${latitude}    longitude=${longitude}
     END
     RETURN    ${scanInfoFromDashboard}

Verify Presence Of CatSite Loc
        [Documentation]  Method to verify the presence of CatSite Name in the Map.
        [Arguments]     ${scandetails}
        IF  ${scandetails.active} and '${scandetails.name}'!='${None}'
            ${imgCatsiteName}=  Run Keyword And Return Status    Page Should Contain Element  Xpath=//*[@aria-label='${scandetails.name}']
            Run keyword if  ${imgCatsiteName}==False  fail   Cat Site Location Pin is Not present in the Map.
        ELSE
            ${CatsiteAvail}=  Run Keyword And Return Status    Page Should Contain Element  Xpath=${Dashboard_Scan_Not_Available}  30s
            Run keyword if  ${CatsiteAvail}==False  fail  Cat Site Location Pin is Not present in the Map.

        END


Get Total Scans
        [Documentation]     Method to get total number of scans from Dashboard.
        [Arguments]     ${accessToken}  ${fromDate}  ${toDate}  ${status}
        Create Session    API_TESTING_Trial    ${URL.url}
        &{headers}=       Create Dictionary       Authorization=Bearer ${accessToken}
        ${fromDate}      Replace String    ${fromDate}    /    -
        ${toDate}      Replace String    ${toDate}    /    -
        ${body}=     Create Dictionary      fromDate=${fromDate}    toDate=${toDate}  catSiteStatus=${status}
        ${response}     POST On Session    API_TESTING_Trial     ${APIsForCloud.scanInfoDashboard}     json=${body}   headers=${headers}
        Capture API Response Time     ${response}   ${start}
        ${responseinJson}   Set Variable    ${response.json()}
        @{data}     Get Value From Json    ${responseinJson}    data
        @{data1}     Get Value From Json    ${responseinJson}    data[0].id
        ${data1}    Catenate    @{data1}
        IF    '${data1}' != '${EMPTY}'
            ${len}      Get Length    ${data}
            @{list}  Create List
            FOR    ${index}    IN RANGE    ${len}
                @{totalScans}      Get Value From Json    ${responseinJson}    data[${index}].totalScans
                ${totalScans}     Catenate    @{totalScans}
                Append To List    ${list}    ${totalScans}
            END
        ELSE
               Log    Scan Info is not available for the given CatSite Status and the Date Range.
               ${list}     Set Variable        ${EMPTY}
        END
        RETURN     ${list}


CatSite And Rig Details
        [Documentation]     Method to get all the CatSite Rig Details .
        [Arguments]    ${accessToken}     ${catSiteName}
        Create Session    API_TESTING_Trial    https://vhss-cus-dev2.centralus.cloudapp.azure.com
        ${catsiteRigDetails}    Create Dictionary
        &{headers}=       Create Dictionary       Authorization=Bearer ${accessToken}
        ${body}=     Create Dictionary
        ${response}     POST On Session    API_TESTING_Trial    ${APIsForCloud.catSiteDetails}    json=${body}   headers=${headers}
        Capture API Response Time     ${response}   ${start}
        @{responseinJson1}   Set Variable    ${response.json()}
        ${responseinJson}   Set Variable    ${response.json()}
        ${responseinJson1}       Catenate        @{responseinJson1}
        @{data}     Get Value From Json    ${responseinJson}    data
        @{statuscode}     Get Value From Json    ${responseinJson}    statusCode
        ${statuscode}       Catenate        @{statuscode}
        IF  '${responseinJson1}' != '${EMPTY}'
            IF  '${statuscode}' == '200'
                ${cnt}=    Get length    @{data}
                FOR    ${counter}    IN RANGE  ${cnt}
                    @{catSiteName1}      Get Value From Json    ${responseinJson}    data[${counter}].catSiteName
                    ${catSiteName1}       Catenate       @{catSiteName1}
                    ${catSiteName1}=  Convert To Uppercase  ${catSiteName1}
                    ${catSiteName}=  Convert To Uppercase  ${catSiteName}
                    IF  '${catSiteName1}' == '${catSiteName}'
                        @{catSiteNameID1}      Get Value From Json    ${responseinJson}    data[${counter}].catSiteId
                        ${catSiteNameID1}       Catenate       @{catSiteNameID1}
                        Set To Dictionary  ${catsiteRigDetails}  ${catSiteName1} 	${catSiteNameID1}
                        @{rig}       Get Value From Json    ${responseinJson}    data[${counter}].rigDetail
                        ${len}      Get Length    @{rig}
                        FOR    ${element}    IN RANGE  0  ${len}
                        ${rig_name}      Get Value From Json    ${responseinJson}    data[${counter}].rigDetail[${element}].name
                        ${rig_name}       Catenate       @{rig_name}
                        ${rig_id}       Get Value From Json     ${responseinJson}    data[${counter}].rigDetail[${element}].Id
                        ${rig_id}       Catenate       @{rig_id}
                        Set To Dictionary  ${catsiteRigDetails}  ${rig_name}	${rig_id}
                        END
                    END
                END
            END
        ELSE
        Log    CatSite and Rig Details are not available for the given Date Range
        ${catsiteRigDetails}    Set Variable    ${None}
        END

       RETURN    ${catsiteRigDetails}


Get Scan Summary Details
        [Documentation]     Method to get Reports - Scan Summary Details based on Daily and Date Range value selected.
        [Arguments]     ${accessToken}     ${fromDate}  ${toDate}  ${catSiteRigDetails}  ${catsite}     ${rig}
        ${catsite}      Convert to Uppercase  ${catsite}
        ${catsite_id}   get value from dict     ${catSiteRigDetails}  ${catsite}
        ${rig_id}   get value from dict     ${catSiteRigDetails}    ${rig}
        Create Session    API_TESTING_Trial    ${URL.url}
        @{RigIDs}    Create List
        Append To List  ${RigIDs}  ${rig_id}
        &{headers}=       Create Dictionary       Authorization=Bearer ${accessToken}
        ${fromDate}      Replace String    ${fromDate}    /    -
        ${toDate}      Replace String    ${toDate}    /    -
        ${body}=     Create Dictionary   catSiteId=${catsite_id}      fromDate=${fromDate}     rigIds=${RigIDs}     toDate=${toDate}
        ${response}     POST On Session    API_TESTING_Trial     ${APIsForCloud.scanSummary}     json=${body}   headers=${headers}
        Capture API Response Time     ${response}   ${start}
        @{responseinJson1}   Set Variable    ${response.json()}
        ${responseinJson}   Set Variable    ${response.json()}
        ${responseinJson1}       Catenate        @{responseinJson1}
        @{data}     Get Value From Json    ${responseinJson}    data
        #${data}       Catenate        @{data}
        ${cnt}  get data from json  @{data}
        @{statuscode}     Get Value From Json    ${responseinJson}    statusCode
        ${statuscode}       Catenate        @{statuscode}
        IF  '${responseinJson1}' != '${EMPTY}'
            ${sum}      Set Variable        ${0}
            IF  '${statuscode}' == '200'
                FOR    ${counter}    IN RANGE  ${cnt}
                ${totalScans}      Get Value From Json    ${responseinJson}    data[${counter}].noOfScans
                ${totalScans}       Catenate        @{totalScans}
                ${totalScans}       Convert to Integer  ${totalScans}
                ${sum}  Evaluate    ${sum}+${totalScans}
                END
            END
        ELSE
            Log    Scan Summary Details are not available for the given CatSite,Rig and Date Range.
        END
        RETURN         ${sum}


Get Scan Efficiency Detail
        [Documentation]     Method to get Reports - Scan Summary Details based on Daily and Date Range value selected.
        [Arguments]    ${AccessToken}      ${fromDate}     ${toDate}  ${catsiteDetails}   ${catsite}  ${rig}
        ${catsite}      Convert to Uppercase  ${catsite}
        ${catsite_id}   get value from dict     ${catsiteDetails}  ${catsite}
        ${rig_id}   get value from dict     ${catsiteDetails}    ${rig}
        Create Session    API_TESTING_Trial    ${URL.url}
        @{RigIDs}    Create List
        Append To List  ${RigIDs}  ${rig_id}
        &{headers}=       Create Dictionary       Authorization=Bearer ${accessToken}
        ${fromDate}      Replace String    ${fromDate}    /    -
        ${toDate}      Replace String    ${toDate}    /    -
        ${body}=     Create Dictionary   catSiteId=${catsite_id}      fromDate=${fromDate}     rigIds=${RigIDs}     toDate=${toDate}
        ${response}     POST On Session    API_TESTING_Trial     ${APIsForCloud.scanEfficiency}     json=${body}   headers=${headers}
        Capture API Response Time     ${response}   ${start}
        @{responseinJson1}   Set Variable    ${response.json()}
        ${responseinJson}   Set Variable    ${response.json()}
        ${responseinJson1}       Catenate        @{responseinJson1}
        @{data}     Get Value From Json    ${responseinJson}    data
        #${data}       Catenate        @{data}
        ${cnt}  get data from json  @{data}
        ${statuscode}     Get Value From Json    ${responseinJson}    statusCode
        ${statuscode}       Catenate        @{statuscode}
        IF  '${responseinJson1}' != '${EMPTY}'
            IF  '${statuscode}' == '200'
            @{vehicleIntakeTime}      Get Value From Json    ${responseinJson}    data.vehicleIntakeTime
            ${vehicleIntakeTime}    Catenate    @{vehicleIntakeTime}
            @{vehicleScanTime}      Get Value From Json    ${responseinJson}    data.vehicleScanTime
            ${vehicleScanTime}    Catenate    @{vehicleScanTime}
            @{resultGenerationTime}      Get Value From Json    ${responseinJson}    data.resultGenerationTime
            ${resultGenerationTime}    Catenate    @{resultGenerationTime}
            @{validateReportTime}      Get Value From Json    ${responseinJson}    data.validateReportTime
            ${validateReportTime}    Catenate    @{validateReportTime}
            @{activeTime}      Get Value From Json    ${responseinJson}    data.activeTime
            ${activeTime}    Catenate    @{activeTime}
            @{waitTime}      Get Value From Json    ${responseinJson}    data.waitTime
            ${waitTime}    Catenate    @{waitTime}
            @{totalTimeTakenForOrders}      Get Value From Json    ${responseinJson}    data.totalTimeTakenForOrders
            ${totalTimeTakenForOrders}    Catenate    @{totalTimeTakenForOrders}
            @{noOfOrders}      Get Value From Json    ${responseinJson}    data.noOfOrders
            ${noOfOrders}    Catenate    @{noOfOrders}
            ${scanEfficiencyDetails}    Create Dictionary   vehicleIntakeTime=${vehicleIntakeTime}    vehicleScanTime=${vehicleScanTime}    resultGenerationTime=${resultGenerationTime}    validateReportTime=${validateReportTime}  activeTime=${activeTime}    waitTime=${waitTime}    totalTimeTakenForOrders=${totalTimeTakenForOrders}  noOfOrders=${noOfOrders}
            END
            ELSE
                Log  Scan Efficiency Details are not available for the given CatSite,Rig and Date Range.
                ${scanEfficiencyDetails}  Set Variable  ${None}
        END
        RETURN     ${scanEfficiencyDetails}