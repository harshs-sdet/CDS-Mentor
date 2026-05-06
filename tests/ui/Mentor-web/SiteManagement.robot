*** Settings ***
Library    SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Library   ../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Workspace/Workspace.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Variables   ../../../config/Mentor/${Env}_env.yaml


Suite Setup     Run Keywords     Login To Mentor Application    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
...              AND             Navigate To Site List Page

Test Teardown   Run Keyword    Ensure Site List Page Is Open

Suite Teardown    Close All Browsers


*** Test Cases ***
Verify that Org admin is able to add new Site by clicking on 'Add New' button.
    [Tags]   CZ-6183   CZ-6184    sanity
    When Save The Records Count Before Actions On Page
    And Click On ADD New Button On Site List Page
    And Verify The User Is Not Able Create Empty Site
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
#    And Verify The Workspaces Tab On New Site Page
    And Click On Done Button On New Site Window
    And Verify The Records Count Is Changed By    +1
    Then Verify The New Created Site
    And Delete The Site

Verify that User is able to edit the site.
    [Tags]   CZ-6190    
    When Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
    And Click On Done Button On New Site Window
    And Navigate To Site Details Page
    And Click On Edit Button On Site Details Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
    And Click On Done Button On New Site Window
    And Navigate To Site Details Page
    Then Validate The Updated Site Details
    And Click On Site Link In Breadcrumb

Verify that user can delete individual sites from the Sites page.
    [Tags]   CZ-6189   CZ-6187    sanity
    [Documentation]    This test case will verify that user can delete a site from the site listing page and also verify that the count is getting updated after deletion of site. It will also verify that user can cancel the delete action and count is not getting updated.
    When Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
#    And Verify The Workspaces Tab On New Site Page
    And Click On Done Button On New Site Window
    And Save The Records Count Before Actions On Page
    And Verify The New Created Site
    And Delete The Site
    Then Verify The Records Count Is Changed By    -1

Verify the pagination on Site Creation Page.
    [Tags]  CZ-6194   
    Then Verify The Pagination

Verify the functionality of Cancel button on Add New Site Page.
    [Tags]   CZ-6186  CZ-6191    sanity    
    When Click On ADD New Button On Site List Page
    And Click On Cancel Button On New Site Window
    And Verify User Lands On The Site List Page
    And Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
    And Click On Done Button On New Site Window
    And Navigate To Site Details Page
    And Click On Edit Button On Site Details Page
    And Click On Cancel Button On New Site Window
    And Verify User Lands On The Site List Page
    And Navigate To Site Details Page
    Then Validate The Updated Site Details
    And Click On Site Link In Breadcrumb

Verify that User can delete multiple sites at a time.
    [Tags]   CZ-6188      
    When Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Cancel the Delete Process
    And Click On Cancel Button On New Site Window
    And Verify User Lands On The Site List Page
    Then Verify The Counts

Verify the functionality of Previous button on Workspace tab while creating a site.
    [Tags]   CZ-6195    sanity
    When Click On ADD New Button On Site List Page
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
#    And Verify The Workspaces Tab On New Site Page
    And Click On Previous Button
    And Click On Previous Button
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
    And Click On Done Button On New Site Window
    Then Verify The New Created Site

Verify Email Format Validation in the Add New Site
    [Tags]  CZ-6197   
    When Click On ADD New Button On Site List Page
    And Enter Invalid Email
    And Verify Invalid Error Message
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
    And Click On Done Button On New Site Window
    Then Verify Invalid Error Message
    And Navigate To Site List Page


Verify that Site name is visible in breadcrumbs on Site Management Page
    [Tags]  CZ-6198      
    When Get The First Site Details
    And Navigate To Site Details Page
    And Verify The Site Name is Displayed In The Breadcrumbs
    And Click On Site Link In Breadcrumb
    Then Verify User Lands On The Site List Page

Verify that user cannot add a workspace while creating a new Site
    [Tags]  CZ-6193    sanity
    When Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
#    And Verify The Workspaces Tab On New Site Page
    Then Verify The User Is Not Able To Add Workspaces
    And Click On Site Link In Breadcrumb
    And Verify User Lands On The Site List Page

Verify that user is able to delete a workspace from a Site.
    [Tags]    CZ-6196    CZ-6209     F   
    And Click On ADD New Button On Site List Page
    And Enter The Site Detail
    And Click On Next Button On New Site Window
    And Click On Next Button On Workspace Window
#    And Verify The Workspaces Tab On New Site Page
    And Click On Done Button On New Site Window
    And Verify The New Created Site
    And Navigate To Workspace Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Navigate To Site List Page
    And Navigate To Site Details Page
    And Navigate To Workspace Tab Under Site Details
#    And Verify The Workspaces Tab On New Site Page
    And Verify The Workspace Is Associated To The Site
    And Click On Edit Button On Site Details Page
    And Delete The Workspace From The Site
    And Navigate To Site Details Page
    And Navigate To Workspace Tab Under Site Details
    Then Verify The Workspace Is Deleted From The Site

Verify that on deleting workspace from workspace management, it is getting deleted from the mapped site
    [Tags]   CZ-6202    CZ-6203    sanity    F
    When Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    And Navigate To Workspace List Page
    And Click On Create Button On Workspace List Page
    And Enter The Workspace Detail
    And Click On Create Button On Enter New Workspace Details Page
    And Logout From Mentor
    And OrgAdmin Login    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Navigate To Site Details Page
    And Navigate To Workspace Tab Under Site Details
#    And Verify The Workspaces Tab On New Site Page
    And Verify The Workspace Is Associated To The Site
    And Logout From Mentor
    And Login To Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    And Navigate To Workspace List Page
    And Delete The Workspace
    And Verify The New Created Workspace Should Not Be Visible
    And Logout From Mentor
    And OrgAdmin Login    ${ORG_ADMIN_EMAIL}    ${ORG_ADMIN_PASS}
    And Navigate To Site List Page
    And Navigate To Site Details Page
    And Navigate To Workspace Tab Under Site Details
    Then Verify The Workspace Is Removed From The Mapped Site
    And Click On Site Link In Breadcrumb

Verify the sort functionality on Site Listing.
    [Tags]    CZ-7518    F
    Log    This testcase might fail due to CZ-6673
    Then Verify The Sorting Functionality On The Site List Page

Verify that On deleting one user, User is getting deleted from associated Site.
    Log    Bug: CZ-8091
    [Tags]    CZ-6204     CZ-6207     CZ-6208    F
    When Create And Activate User    USER_PERSONA_OF_NEW_USER=Mentor Site Admin
    And Login Again As Site Admin
    And Navigate To Teams Page
    And Click On Add New Button On Teams List Page
    And Create A Team With New User And Save Added Users Count    #update this
    And Verify New Team Is Created
    And Verify that Site Is Not Editable At User Group's Screen
    And Login Again As Org Admin
    And Navigate To Site List Page
    And Get The Users Count In The Site
    And Login Again As Site Admin
    And Navigate To Users List Page
    And Delete The New Created User
    And Navigate To Teams Page
    And Verify The User Is Deleted From The Team
    And Login Again As Org Admin
    And Navigate To Site List Page
    Then Verify The Users Count In Site Is Changed By    -1

