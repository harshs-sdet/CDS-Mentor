*** Settings ***
Library    SeleniumLibrary
Library    String
Variables   ../../../../../../config/Mentor/${ENV}_env.yaml
Variables   ../../../../../locators/ui/web/Mentor/Teams.yaml
Variables   ../../../../../locators/ui/web/Mentor/Login.yaml
Resource    ../../../../../keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../../../keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../../../locators/ui/web/Mentor/Procedure.yaml

*** Variables ***
${UserName}     DG

*** Keywords ***
Click on Add Work Instruction Button
    Wait Until Element Is Visible    ${Add_WI_Button}    ${MaxTime}
    Click Element    ${Add_WI_Button}

Fill the WI Details
    ${UniqueNumbertest}=    Generate Random String    4    [NUMBERS]
    Set Global Variable      ${UniqueNumbertest}
    Wait Until Element Is Visible    ${Instruction_Name}    ${MaxTime}
    Click Element    ${Instruction_Name}
    Input Text    ${Instruction_Name}    Test-${UniqueNumberTest}
    Click Element    ${Instruction_Description}
    Input Text    ${Instruction_Description}    For Testing Purpose
    Click Element    ${Product_Brand_Name}
    Input Text    ${Product_Brand_Name}    Tata

Click on Next button to Add Procedure
    Execute Javascript  window.scrollTo(0,document.body.scrollHeight)
    Scroll Element Into View    ${NextWI_button}
    Wait Until Element Is Enabled    ${NextWI_button}
    Click Element    ${NextWI_button}
    Wait Until Element Is Enabled    ${ProcedureName}   ${MaxTime}

Add Procedure Details
    Click Element    ${ProcedureName}
    Input Text    ${ProcedureName}    Procedure-${UniqueNumberTest}

Add Hours in cycle time
    Click Element    ${cycletime_hour}
    Input Text    ${cycletime_hour}    1

Add Minutes in cycle time
    Click Element    ${cycletime_minute}
    Input Text    ${cycletime_minute}    7

Add Seconds in cycle time
    Click Element    ${cycletime_second}
    Input Text    ${cycletime_second}    4

Add Document Id in Procedure Details
    Click Element    ${DOCUMENT_ID_INPUT}
    Input Text    ${DOCUMENT_ID_INPUT}    SC6578
    Scroll Element Into View    ${Sign_off_manager}
#    Click Element    ${Sign_off_manager}
#    Wait Until Element Is Visible    ${Sign_off_manager}   10s
#    Select From List By Index    ${Sign_off_manager}    2
    Scroll Element Into View    ${NextWI_button}
    Click Element    (${NextWI_button})[2]

 Add Standard PPE for the WI
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Scroll Element Into View    ${Submit_button}
    Click Element    (${PPE_Checkbox})[1]
    Click Element    (${PPE_Checkbox})[2]

Add Custom PPE for the WI
    Click Element    ${Custom_PPE}
    Sleep    3s
    Click Element    (${PPE_Checkbox})[1]
    Click Element    (${PPE_Checkbox})[2]
    Click Element    ${Submit_button}

Verify that WI has been created
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${Studio_button}



