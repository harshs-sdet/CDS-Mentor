*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Library    DateTime
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Approvals/SignOffApproval.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/ChangeLogs/ChangeLogs.resource

Suite Setup     Run Keywords       Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
...             AND             Wait For The Page To Load 

Test Teardown    Run Keywords    Press Keys    //body    ESC
...             AND    Navigate To Procedures List Page from changeLogs page
...             AND     Wait Until Keyword Succeeds   10x    1s    Mouse Over    ${user_name}
Suite Teardown    Close All Browsers

*** Test Cases ***

Verify user is able to view change logs for any particular day
    [Tags]    CZ-7049    CZ-7048    CZ-7050    CZ-7056    sanity
    [Documentation]    Verify the UI of change log screen
    When Create Procedure Records    1    SIGNOFF=NO
    And Navigate to Change Log page
    And Search For A Particular Procedure    0
    And Verify the UI of Change Log Page
    And Navigate to the first Change Logs Procedure
    And Verify the UI of Procedure Change Log Page
    Then Export the Change Logs    

Verify user is able to search for procedure in change logs
    [Tags]    CZ-7059    CZ-7060    CZ-7066    CZ-7068    sanity
    [Documentation]    Verify user is able to search for procedure in change logs
    When Create Procedure Records    1    SIGNOFF=NO
    And Append Release Number
    And Update the details of a Procedure for Change Logs   
    And Append Release Number
    And Navigate to Change Log page
    And Search For A Particular Procedure    0
    And Verify The Pagination    PARTICULAR_PAGE_SIZE=3
    And Capture Page Screenshot
    And Verify The Pagination
    And Navigate to the first Change Logs Procedure
    And Verify Restore Button is Disabled
    Then Verify Release Numbers Are Present

Verify user is able to change the version from preview screen
    [Tags]    CZ-7058    CZ-7064    CZ-7071    CZ-7072
    [Documentation]    Verify user is able to change the version from preview screen
    When Create Procedure Records    1    SIGNOFF=NO
    And Append Release Number
    And Update the details of a Procedure for Change Logs   
    And Append Release Number
    And Navigate to Change Log page
    And Search For A Particular Procedure    0
    And Navigate to the first Change Logs Procedure
    And Click the Preview Button
    And Compare Release Numbers With Versions
    And Change Version using Dropdown
    And Navigate to Show Detailed View Tab and Verify Tabs
    Then Verify Activity Column Texts        

Verify user is able to view the User contributions for a procedure under change logs
    [Tags]    CZ-7055
    [Documentation]    Verify user is able to view the User contributions for a procedure under change logs
    When Create Saved Procedure For Change Logs
    And Logout from Mentor
    AND Login To Application     ${AUTHOR2_EMAIL}     ${AUTHOR2_PASS}
    And Navigate to Procedures page
    And Search For A Particular Procedure    0
    And Navigate to the First Procedure    
    And Click On Edit Button On Procedure Details Page
    And User Add Step To Procedure
    And User Publishes the Updated Procedure  
    And User Adds Release Notes
    And Navigate to Change Log page
    And Search For A Particular Procedure    0
    And Navigate to the first Change Logs Procedure
    Then Verify User Contributions In Change Logs

Verify changes done in Video uploaded is displayed in Change logs
    [Tags]    CZ-7086    CZ-7087    CZ-7090    CZ-7089    sanity
    [Documentation]    Verify All the details are displayed in preview of procedure opened from Change logs
    When Create Procedure Records    1    SIGNOFF=NO
    And Complete the details of a Procedure for Change Logs
    And Search For Recently Created Procedure
    And Get The First Procedure Details
    And Navigate to Change Log page
    And wait for the page to load
    Sleep    5s
    And Search For Recently Created Procedure
    And wait for the page to load
    Sleep    3s
    And Navigate to the first Change Logs Procedure
    And Sleep    5s
    And Click the Preview Button
    And Sleep    8s
    And Verify The Procedure Name And Version On Preview Page
    And Validate The Procedures Details In Preview
    And Verify The Added PPE's In Change Logs Preview
    And Validate BOM/BOT In Procedure Preview mode
    And User Click On Preventive TroubleShoot Icon    CALLED_FROM_CHANGE_LOGS=True
    Then Verify the Existence In Detailed View Page 
    

Verify All the details are displayed in preview of procedure opened from Change logs
    [Tags]    CZ-7078    CZ-7079    CZ-7080    CZ-7081
    [Documentation]    Verify All the details are displayed in preview of procedure opened from Change logs
    When Create Procedure Records    1    SIGNOFF=NO
    And Complete the details of a Procedure for Change Logs
    And Search For Recently Created Procedure
    And Get The First Procedure Details
    And Navigate to Change Log page
    And wait for the page to load
    Sleep    5s
    And Search For Recently Created Procedure
    And wait for the page to load
    Sleep    3s
    And Navigate to the first Change Logs Procedure
    And Sleep    5s
    And Click the Preview Button
    And Sleep    8s
    And Verify The Procedure Name And Version On Preview Page
    Then Verify the Existence In Detailed View Page    

Verify changes done to Options is displayed in Change logs
    [Tags]    CZ-7082    CZ-7083    CZ-7084    CZ-7085
    [Documentation]    Verify All the details are displayed in preview of procedure opened from Change logs
    When Create Procedure Records    1    SIGNOFF=NO
    And Complete the details of a Procedure for Change Logs
    And Search For Recently Created Procedure
    And Get The First Procedure Details
    And Navigate to Change Log page
    And wait for the page to load
    Sleep    5s
    And Search For Recently Created Procedure
    And wait for the page to load
    Sleep    3s
    And Navigate to the first Change Logs Procedure
    And Sleep    5s
    And Click the Preview Button
    And Sleep    8s
    And Verify The Procedure Name And Version On Preview Page
    Then Verify the Existence In Detailed View Page    

Verify user is able to preview the procedure from change logs screen
    [Tags]    CZ-7057    CZ-7061    CZ-7073    CZ-7074    sanity
    [Documentation]    Verify user is able to Restore the previous version of procedure from change logs of a procedure
    WHEN Create Procedure Records    1    SIGNOFF=NO
    AND Set details of initial version procedure details
    AND Update the details of a Procedure for Change Logs
    AND Set details of initial latest procedure details
    AND Navigate to Change Log page
    AND Search For A Particular Procedure    0
    wait for the page to load
    AND Navigate to the first Change Logs Procedure
    AND Verify the cancel button in restore
    THEN Verify the restore procedure for different versions


Verify previous version of procedure is Active on restoring the previous version from change logs of procedure
    [Tags]    CZ-7062    CZ-7069    CZ-7075    sanity
    [Documentation]    Verify previous version of procedure is Active on restoring the previous version from change logs of procedure
    WHEN Create Procedure Records    1    SIGNOFF=NO
    AND Set details of initial version procedure details
    AND Update the details of a Procedure for Change Logs
    AND Set details of initial latest procedure details
    AND Navigate to Change Log page
    AND Search For A Particular Procedure    0
    AND Navigate to the first Change Logs Procedure
    AND Verify the restore procedure for different versions
    AND Navigate To Procedures List Page from changeLogs page
    AND Verify the procedure version and contents for restored version    ${original_version_in_string}    ${steps_count_in_string}
    AND Navigate to Change Log page
    AND Search For A Particular Procedure    0
    AND Navigate to the first Change Logs Procedure
    AND Restore the procedure to latest version
    AND Navigate To Procedures List Page from changeLogs page
    AND Verify the procedure version and contents for restored version    ${updated_version_in_string}    ${updated_steps_count_in_string}
    AND Navigate to Change Log page
    AND Search For A Particular Procedure    0
    AND Navigate to the first Change Logs Procedure
    THEN Close the preview screen

Verify That Restore Button Is Not Visible To Operator
    [Setup]    Login Again As Author
    [Tags]  CZ-7076
    When Create Procedure Records    1    SIGNOFF=NO
    And Append Release Number
    And Update the details of a Procedure for Change Logs
    And Append Release Number
    And Logout from Mentor
    And Login To Application     ${OPERATOR1_EMAIL}     ${OPERATOR1_PASS}
    And Navigate to Change Log page
    And Verify That Restore Button Is Not Visible
    And Navigate to the first Change Logs Procedure
    And Click the Preview Button
    Then Verify That Restore Button Is Not Visible


#    OptionQuestion: ((//div[contains(@class,'option-item')])[1]//span[@class="key"])[1]
#OptionAnswer: ((//div[contains(@class,'option-item')])[1]//span[@class="key"])[2]



