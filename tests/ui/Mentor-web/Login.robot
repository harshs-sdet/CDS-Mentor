*** Settings ***
Library    SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${Env}_env.yaml

Suite Teardown    Close All Browsers
*** Test Cases ***
Verify That User Be Able To Login
    [Tags]  CZ-A
    When Launch Mentor application
    And Verify Base Sign In Page     ${AUTHOR1_EMAIL}
    And Click On Sign In
    Then Verify Main Sign In page   ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    And Verify User Is Able To Navigate To Home Page

Verify that User Is Able To Reset Password
    [Tags]  CZ-6737    CZ-6748
    When Launch Mentor application
    And Verify Base Sign In Page     ${AUTHOR1_EMAIL}
    And Click On SIgn In
    And Click On Forgot Password    ${AUTHOR1_EMAIL}
    And Navigate To Inbox To Get The Data     ${AUTHOR1_EMAIL}
    And Copy The Code Received
    And Enter The Code Received
    And Reset The Password      ${NewPassword}
    Then Verify User Is Able To Navigate To Home Page

#Verify That User Is Able To Cancel The Reset Password Flow
#    [Tags]  CZ-C
#    When Launch Mentor application
#    And Verify Base Sign In Page     ${AUTHOR1_EMAIL}
#    And Click On SIgn In
#    And Click On Forgot Password    ${AUTHOR1_EMAIL}
#    And Click On Cancel
#    Then Verify User Navigate To Main SignIn Screen
