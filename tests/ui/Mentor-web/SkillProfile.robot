#*** Settings ***
#Library     SeleniumLibrary
#Library    EmailListener.py
#Library    OperatingSystem
#Resource    ../../../pageobjects/keywords/ui/web/Mentor/SkillManagement/SkillProfile.resource
#Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
#Variables   ../../../config/Mentor/${env}_env.yaml
#Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
#Library   ../../../src/utilities/Common-utils/CommonUtils.py
#
#
#Suite Setup     Run Keywords     Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
#...              AND             Navigate To Skill Profile List Page
#
#Test Teardown   Run Keyword    Ensure Skill Profile List Page Is Open
#
#Suite Teardown    Close Browser
#
#*** Test Cases ***
