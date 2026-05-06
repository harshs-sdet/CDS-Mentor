*** Settings ***
Library    SeleniumLibrary
Variables    ../../../../../../config/Mentor/${ENV}_env.yaml
Variables    ../../../../../locators/ui/web/Mentor/Login.yaml
Variables    ../../../../../locators/ui/web/Mentor/AuthorScreen.yaml
Library    String
Resource    ../Common/Common.resource
Resource    Login.resource

*** Variables ***
${WIDTH}                    1366
${HEIGHT}                   768
${tc_csv_filePath}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}PageActionData${/}loginPageActionData.csv
${testSuite}      ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}ApplicationTestData${/}TestSuiteData.csv

*** Keywords ***
Login Resource
    [Documentation]  To login to cloud application.
    [Arguments]     ${page_scenario_key}
    #Read values from csv    ${csv_filePath}
    GetTestDataVariables   ${tc_csv_filePath}     ${page_scenario_key}    #   ${login_df}      ${page_scenario_key}
    Login To Mentor Application     ${td_Email}    ${td_Password}

Launch Mentor Application
    [Arguments]    ${browser_alias}=None

    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
#    Call Method    ${options}   add_argument    headless
    Call Method    ${options}   add_argument    window-size\=1920,1080
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-gpu
#    Call Method    ${options}    add_experimental_option    detach    ${True}

    Log    alias=${browser_alias}
    Open Browser    ${Url}    chrome    options=${options}    alias=${browser_alias}
    Maximize Browser Window


Verify Base Sign In Page
    [Arguments]     ${Email}
    Wait Until Element Is Visible    ${EmailField}    ${MaxTime}
    Input Text    ${EmailField}    ${Email}
    Select Checkbox    ${Eula}
    Wait Until Element Is Visible    ${EULALink}    ${MaxTime}
    Wait Until Element Is Visible    ${EulaText}    ${MaxTime}

Click On Sign In
    Click Element    ${SignIn_Button}

Verify Main Sign In page
    [Arguments]     ${Email}     ${UserPassword}
    Wait Until Element Is Visible    ${CompanyLogo}    ${MaxTime}
    Element Should Be Visible    ${password}
    Input Text    ${EmailField}    ${Email}
    Input Text    ${password}    ${UserPassword}
    Double Click Element    ${SignIn_Button}
    Wait For The Page To Load


Click On Forgot Password
    [Arguments]     ${Email}
    Wait Until Element Is Visible    ${CompanyLogo}     ${MaxTime}
    Click Element    ${forgotPassword}
    Wait Until Element Is Visible    ${ContinueButton}     ${MaxTime}
    Input Text    ${EmailField}    ${Email}
    Click Element    ${ContinueButton}
    Wait Until Element Is Visible    ${SendVerificationCode}    ${MaxTime}
    Click Element    ${SendVerificationCode}
    Wait Until Element Is Visible    ${VerifyCode}   ${MaxTime}

Validate The Email Triggered To The User
    [Documentation]    To Validate The Email Triggered To The User
    [Arguments]    ${Email}    ${EMAIL_CONTENT}    ${PARTICULAR_EMAIL}=1
    Navigate To Inbox To Get The Data    ${Email}
    ${PARTICULAR_EMAIL_IN_INBOX}=    Replace String    ${PARTICULAR_EMAIL_IN_INBOX}    TEXT    ${PARTICULAR_EMAIL}
    Wait For The Element And Click    (${PARTICULAR_EMAIL_IN_INBOX})
    Wait Until Element Is Not Visible    (${PARTICULAR_EMAIL_IN_INBOX})
    #validation
    ${EMAIL_CONTENT_LIST}=    Split String    ${EMAIL_CONTENT}    ,
    Wait Until Page Contains Element    ${EMAIL_CONTENT_IFRAME}    ${Max_limit}
    Select Frame    ${EMAIL_CONTENT_IFRAME}
    Wait For The Element And Click    ${EMAIL_IMAGE_RECEIVED}
    Repeat Keyword    5x    Press Keys    ${EMAIL_IMAGE_RECEIVED}    ARROW_DOWN
    FOR    ${EMAIL_TEXT}    IN    @{EMAIL_CONTENT_LIST}
        Wait Until Page Contains    ${EMAIL_TEXT}    timeout=30s
    END
    #close tab
    Close The Current Tab
    
Navigate To Inbox To Get The Data
    [Arguments]     ${Email}
    Execute Javascript  window.open('https://www.mailinator.com', '_blank');
    ${Handle}=  Get Window Handles
    Set Global Variable    ${Handle}
    Switch Window   ${Handle}[1]
#    select window    ${Handle}[1]
    ${AuthorUsername}    Evaluate    "${Email}".split("@")[0]
    Set Global Variable    ${AuthorUsername}
    Wait Until Element Is Visible    ${Mailinator_SearchEmail}      ${MaxTime}
    Input Text    ${Mailinator_SearchEmail}    ${AuthorUsername}
    Click Button    ${GO_Button}


Close The Current Tab
    [Documentation]    To Close The Current Tab
    # Close current tab (Mailinator)
    Close Window

    # Switch back to parent
    Switch Window    ${Handle}[0]

Copy The Code Received
    Wait Until Element Is Visible    ${Verification_Email}      ${MaxTime}
    Click Element    ${Verification_Email}
    Select Frame    ${Frame}
    Wait Until Element Is Visible    ${VerifyEmail}   ${MaxTime}
    ${YourCode}=  Get Text   ${VerificationCode}
    ${Code}=    Evaluate   "${YourCode}".split(":")[1].strip()
    Set Global Variable    ${Code}
    Switch Window   ${Handle}[0]


Get The Temporary Creds Emailed
    [Documentation]    To Get The Temporary Creds Emailed
    Wait Until Element Is Visible    ${NEW_USER_EMAIL}      ${MaxTime}
    Click Element    ${NEW_USER_EMAIL}
    Select Frame    ${Frame}
    Wait Until Element Is Visible    ${TEMPORARY_PASSWORD}   ${MaxTime}
    ${TEMP_PASS}=  Get Text   ${TEMPORARY_PASSWORD}
    ${TEMP_PASS}=    Split String    ${TEMP_PASS}    :${SPACE}
    ${TEMP_PASS}=    Strip String    ${TEMP_PASS[1]}
    Set Test Variable    ${TEMP_PASS}


Enter The Code Received
#    Switch Window   ${Handle}[0]
#    Select window    ${Handle}[0]
    Input Text    ${VerificationCodeInput}      ${Code}
    Click Element    ${VerifyCode}
    Wait Until Element Is Visible    ${EmailVerified}    ${MaxTime}
    Click Element    ${ContinueButton}

Reset The Password
    [Arguments]     ${pass}
    Wait Until Element Is Visible    ${NewPasswordTextfield}    ${maxTime}
    Input Text    ${NewPasswordTextfield}    ${Pass}
    Input Text    ${ConfirmPasswordTextfield}    ${Pass}
    Click Element    ${ContinueButton}

Click On Cancel   
    Click Element    ${LoginCancelButton}
    Wait Until Element Is Visible    ${UseHereButton}   ${Time_120s}
    Click Element    ${UseHereButton}
    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    
Verify User Navigate To Main SignIn Screen
    Wait Until Element Is Visible    ${password}    ${MaxTime}
    Wait For The Page To Load

Login To Mentor Application
    [Arguments]     ${UserEmail}    ${UserPassword}    ${browser_alias}=None
    Launch Mentor application    ${browser_alias}
    Verify Base Sign In Page     ${UserEmail}
    Click On Sign In
    Verify Main Sign In page   ${UserEmail}    ${UserPassword}
#    Run Keyword And Ignore Error    Verify User Is Able To Navigate To Home Page

Logout from Mentor
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${User_profile}
    Wait Until Element Is Visible    ${txt_logout}   ${MaxTime}
    Click Element    ${txt_logout}
    Wait Until Element Is Visible    ${EmailField}   ${MaxTime}
    Page Should Contain Element    ${EmailField}

Login To Application
    [Arguments]     ${UserEmail}    ${UserPassword}
    Wait Until Element Is Visible    ${EmailField}   ${MaxTime}
    Verify Base Sign In Page     ${UserEmail}
    Click On Sign In
    Verify Main Sign In page   ${UserEmail}    ${UserPassword}


OrgAdmin Login
    [Arguments]     ${UserEmail}    ${UserPassword}
    Wait Until Element Is Visible    ${EmailField}   ${MaxTime}
    Verify Base Sign In Page     ${UserEmail}
    Click On Sign In
    Verify Main Sign In page   ${UserEmail}    ${UserPassword}
    Wait Until Keyword Succeeds    10s    2s    Location Should Be    ${Url}/users


#Close Browser
#    [Documentation]  To close Chrome browser.
#    SeleniumLibrary.Close All Browsers



Login Again As Org Admin
    [Documentation]    Login Again As Org Admin
    Close All Browsers
    Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    Wait For The Page To Load
    
Login Again As Persona
    [Documentation]    Login Again As Org Admin
    [Arguments]    ${PERSONA_TO_BE_LOGGED_IN}
    Login To Mentor Application    ${PERSONA_TO_BE_LOGGED_IN}    ${GENERIC_PASSWORD}
    Wait For The Page To Load
    
Login Again As Author
    [Documentation]    Login Again As Author
    [Arguments]    ${KEEP_OTHER_BROWSERS_ALIVE}=False
    Run Keyword If    not ${KEEP_OTHER_BROWSERS_ALIVE}    Close All Browsers
    ${status}=    Run Keyword And Return Status    Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}    browser_alias=Author
    IF    '${status}'=='False'
        Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}    browser_alias=Author
    END
    Wait For The Page To Load

Login Again As Operator
    [Documentation]    Login Again As Operator
    [Arguments]    ${KEEP_OTHER_BROWSERS_ALIVE}=False
    Run Keyword If    not ${KEEP_OTHER_BROWSERS_ALIVE}    Close All Browsers
    Login To Mentor Application    ${OPERATOR1_EMAIL}    ${OPERATOR1_PASS}    browser_alias=Operator
    Wait For The Page To Load


Login Again As Site Admin
    [Documentation]    Login Again As Site Admin
    [Arguments]    ${KEEP_OTHER_BROWSERS_ALIVE}=False
    Run Keyword If    not ${KEEP_OTHER_BROWSERS_ALIVE}    Close All Browsers
    ${status}=    Run Keyword And Return Status    Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}    browser_alias=SiteAdmin
    IF    '${status}'=='False'
        Close Browser
        Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}    browser_alias=SiteAdmin
    END
    Wait Until Element Is Not Visible    ${LoadingBar}    ${Max_limit}
    Wait For The Page To Load

Copy The Temporary Password Received
    Wait Until Element Is Visible    ${ActivateMail}      ${MaxTime}
    Wait Until Element Is Enabled    ${ActivateMail}    ${MaxTime}
    Click Element    ${ActivateMail}
    Select Frame    ${Frame}
    Wait Until Element Is Visible    ${WelcomeImage}   ${MaxTime}
    ${Temp_Passsswrd}=  Get Text   ${TemporaryPassword}
    ${TEMP_PASS}=    Evaluate   "${Temp_Passsswrd}".split(":")[1].strip()
    Set Test Variable    ${TEMP_PASS}


Enter the Temporary Password
    Switch Window    ${Handle}[0]
    Logout from Mentor
    Verify Base Sign In Page    ${TD_USER_EMAIL}
    Click On Sign In
    Verify Main Sign In page    ${TD_USER_EMAIL}    ${TEMP_PASS}

#Reset The Password
#    [Arguments]     ${pass}
#    Wait Until Element Is Visible    ${NewPasswordTextfield}    ${maxTime}
#    Input Text    ${NewPasswordTextfield}    ${Pass}
#    Input Text    ${ConfirmPasswordTextfield}    ${Pass}
#    Click Element    ${ContinueButton}


Login With Personas For Suite Setup
    [Documentation]    To Login With Personas For Suite Setup

    Login Again As Site Admin    KEEP_OTHER_BROWSERS_ALIVE=True
    Login Again As Author    KEEP_OTHER_BROWSERS_ALIVE=True
    Login Again As Operator    KEEP_OTHER_BROWSERS_ALIVE=True

Ensure Logged In
    [Arguments]    ${role}
    ${url_location}=    Get Location
    ${status}=    Run Keyword And Return Status    Should Be Equal As Strings    ${Url}    ${url_location}
    IF    ${status}
        Verify Base Sign In Page     ${role}
        Click On Sign In
        Verify Main Sign In page   ${role}    ${GENERIC_PASSWORD}
    END

Reset Personas State
    Switch Browser    SiteAdmin
    Ensure Logged In    ${SITE_ADMIN_EMAIL}
    Go To    ${Url}/procedure
    Reload Page


    Switch Browser    Author
    Ensure Logged In    ${AUTHOR1_EMAIL}
    Go To    ${Url}/procedure
    Reload Page

    Switch Browser    Operator
    Ensure Logged In    ${OPERATOR1_EMAIL}
    Go To    ${Url}/procedure
    Reload Page