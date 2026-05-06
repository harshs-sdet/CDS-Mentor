*** Settings ***
Library    SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Library     csvLibrary
Library   ../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Workspace/Workspace.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${Env}_env.yaml


Suite Setup     Run Keywords     Login To Mentor Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
...              AND             Navigate To Workspace List Page

Test Teardown   Run Keywords     Login Again As Site Admin
...              AND             Navigate To Workspace List Page
Suite Teardown    Close All Browsers


*** Test Cases ***
Verify that User is able to add Workspace by clicking on ' Create New' button
    [Tags]   CZ-6210    CZ-6211    CZ-6213    sanity
    When Save The Records Count Before Actions On Page
    And Click On Create Button On Workspace List Page
    And Verify The User Is Not Able Create Empty Workspace    #Validation for bug
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Verify The Records Count Is Changed By    +1
    Then Verify The New Created Workspace

Verify that content of deleted workspace are not visible to the user.
    [Tags]   CZ-6223    CZ-6222   CZ-6226    F      
    When Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Save The Records Count Before Actions On Page
    And Verify The New Created Workspace
    And Delete The Workspace
    Then Verify The Records Count Is Changed By    -1

Verify that User is able to Edit the workspace
    [Tags]   CZ-6216    sanity    F
    When Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Navigate To Workspace Details Page
    And Click On Edit Button On Workspace Details Page
    And Update The Workspace Detail
    And Click On Save Button On New Workspace Window
    And Navigate To Workspace Details Page
    Then Validate The Updated Workspace Details

Verify the pagination on workspace page
    [Tags]  CZ-6228   
    Then Verify The Pagination

Verify user is able to add WI/Procedures on selecting tags from side window upon clicking Apply
    [Tags]   CZ-6215   CZ-6235   CZ-6238   CZ-6244   CZ-6229    sanity
    When Save The Records Count Before Actions On Page
    And Verify The Work Instruction Column Is Removed From The Workspace Management Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Select The Tags On New Workspace Page
    And Validate The Tags Of The Procedures    Before Saving
#    And Add The Selected Procedures To Workspace    Pre-Selected
    And Click On Create Button On Enter New Workspace Details Page
    And Verify The Records Count Is Changed By    +1
    And Navigate To Workspace Details Page
    Then Validate The Tags Of The Procedures    After Saving

Verify that User is able to associate the Workspace to a Site
    [Tags]   CZ-6218
    And Navigate To Workspace Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Logout From Mentor
    And Login To Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Navigate To Site Details Page
    And Navigate To Workspace Tab Under Site Details
    Then Verify The Workspace Is Associated To The Site
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify the functionality of Add button
    [Tags]   CZ-6224   CZ-6227   CZ-6234   CZ-6237    sanity    F
    When Save The Records Count Before Actions On Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Add The Selected Procedures To Workspace
    And Click On Create Button On Enter New Workspace Details Page
    And Verify The Records Count Is Changed By    +1
    And Navigate To Workspace Details Page
#    Then Verify The Correct Numbers Of Procedures Added

Verify that user is able to delete multiple workspaces at a time
    [Tags]   CZ-6240    sanity
    When Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Cancel the Delete Process
    And Click On Cancel Button On New Site Window
    Then Verify The Records Count Is Changed By


Verify the functionality of Cancel button on Create New Workspace Page
    [Tags]   CZ-6212   CZ-6217   
    When Click On Create Button On Workspace List Page
    And Click On Cancel Button On New Workspace Window
    And Verify User Lands On The Workspace List Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Navigate To Workspace Details Page
    And Click On Edit Button On Workspace Details Page
    And Click On Cancel Button On New Workspace Window
    And Verify User Lands On The Workspace List Page
    And Navigate To Workspace Details Page
    Then Validate The Updated Workspace Details

#Verify that the site name should be visible in select site dropdown window
#    [Tags]   CZ-6221
#    [Documentation]     [Requirement Change] Workspace creation privileges will be with Site Admin and Author so Obsolete Test case
#    When Logout From Mentor
#    And Login To Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
#    And Search For The Site Admin  ${SITE_ADMIN_EMAIL}
#    And Capture The Site Name
#    And Logout From Mentor
#    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
#    And Navigate To Workspace List Page
#    And Click On Create Button On Workspace List Page
#    Then Verify Site Name Is Displayed In The Dropdown

Verify that Sites of one org should not be visible on another org
    [Tags]   CZ-6230    F     
    [Documentation]     Change in the Requirements, need to update the test case
    When Logout From Mentor
    And Login To Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Done Button On New Site Window
    And Verify The New Created Site
    And Logout From Mentor
    And Login To Application    ${OrgAdmin2}    ${OrgAdminPass2}
    And Navigate To Site List Page
    Then Verify The New Created Site Should Not Be Visible

Verify that Workspace of one org should not be visible on another org
    [Tags]   CZ-6230     
    [Documentation]     Change in the Requirements, need to update the test case
    And Navigate To Workspace Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Logout From Mentor
    And Login To Application    ${SiteAdmin}    ${SiteAdminPass}
    And Navigate To Workspace List Page
    Then Verify The New Created Workspace Should Not Be Visible
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify that the field validation message appears when a mandatory field is not filled
    [Tags]   CZ-6232   CZ-6231    F    
    When Save The Records Count Before Actions On Page
    And Click On Create Button On Workspace List Page
    And Verify The Input Field Validation On New Workspace Page
    And Click On Create Button On Enter New Workspace Details Page
    And Navigate To Workspace Details Page
    Then Validate The Workspace Description

Verify the UI of Workspace Management Page when a Workspace is added
    [Tags]   CZ-6214   CZ-6236    
    When Verify The Table Column Labels On Workspace List Page
    And Save The Records Count Before Actions On Page
    And Get The First Workspace Details
    And Navigate To Workspace Details Page
    And Verify The Workspace Name is Displayed In The Breadcrumbs
    And Click On Workspace Link In Breadcrumb
    Then Verify User Lands On The Workspace List Page


Verify the pagination on ADD Procedures Pop-up window.
    [Tags]  CZ-6233    F   
    When Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}     ${SITE_ADMIN_PASS}
    And Navigate To Workspace List Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    Then Verify The Pagination On Add Procedures Window


Verify that applying a tag displays the associated procedure in the Procedure tab of the "Select Work Instructions and Procedures" window, and removing the tag removes the associated procedure from the tab
    [Tags]    CZ-6308    
    When Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Select The Tags On New Workspace Page
    And Validate The Tags Of The Procedures    Before Saving
#    And Add The Selected Procedures To Workspace    Pre-Selected
    Then Verify The Procedures Are Removed When Removing The Tag

Verify the functionality of filter button.
    [Tags]    CZ-6225    CZ-6314        
    When Click On Filter Button
    And Select The Filters On Workspaces List Page
    And Apply The Filters
    And Verify The Filters Are Applied
    And Validate The Correct Filtered Workspaces Shown
    And Click On Filter Button
    And Clear All Filters And Apply Changes
    Then Verify All The Filters Removed

Verify that workspaces of one sites should not be Visible at Another Site
    [Tags]      CZ-7515    sanity    F
    [Documentation]     Change in the Requirements, need to update the test case
    And Navigate To Workspace Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Logout From Mentor
    And Login To Application    ${SiteAdminSite2}    ${SiteAdminSite2Pass}
    And Navigate To Workspace List Page
    Then Verify The New Created Workspace Should Not Be Visible
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}

Verify that User of non-associated sites should not be able to access the Procedure of Another Site Workspace.
    [Tags]    CZ-6220     CZ-6309    F    
    When Logout From Mentor
    And Login To Application    ${AuthorA}    ${AuthorAPass}
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    And Verify that Procedure is Published
    And Logout From Mentor
    And Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    Then Verify The Current Logged In Author     NoAccessNewProcedure

Verify that only User of associated sites should be able to access the Workspace.
    [Tags]    CZ-6219    CZ-6205    sanity    F
    When Logout From Mentor
    And Login To Application    ${Author3}    ${Author3Pass}
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    And Verify that Procedure is Published
    And Logout From Mentor
    And Login To Application    ${Author4}    ${Author4Pass}
    Then Verify The Current Logged In Author     AccessNewProcedure

Verify that any changes made in the WI or Procedures of a workspace are reflected in the assigned user's screen
    [Tags]    CZ-6245    F    
    When Logout From Mentor
    And Login To Application    ${Author3}    ${Author3Pass}
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    And Verify that Procedure is Published
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And User Adds General Details
    And User Publishes the Procedure   True
    And User Adds Release Notes
    And Verify that the Procedure is saved
    And Verify that Procedure is Published
    And Logout From Mentor
    And Login To Application    ${Author4}    ${Author4Pass}
    Then Verify The Current Logged In Author     AccessNewProcedure


Verify that any changes made in the count of added WI or Procedures of a workspace are reflected in the assigned user's screen
    [Tags]    CZ-6246    sanity    F
    When Logout From Mentor
    And Login To Application    ${Author3}    ${Author3Pass}
    And Save The Records Count Before Actions On Page
    And Logout From Mentor
    And Login To Application    ${Author4}    ${Author4Pass}
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    And Verify that Procedure is Published
    And Logout From Mentor
    And Login To Application    ${Author3}    ${Author3Pass}
    Then Verify The Records Count Is Changed By    +1

Verify That User Is Not Able to Create Workspace Having Duplicate Name
    [Tags]    CZ-7498    
    And Navigate To Workspace Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Click On Create Button On Workspace List Page
    And Enter The Duplicate Workspace Name
    And Select The Site From The Dropdown
    And Create The Workspace
    Then Verify The Toaster Message