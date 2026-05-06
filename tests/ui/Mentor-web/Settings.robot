*** Settings ***
Library    SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Library     csvLibrary
Library   ../../../src/utilities/Common-utils/CommonUtils.py
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Workspace/Workspace.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Settings/Settings.resource
Resource   ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${Env}_env.yaml


Suite Setup     Run Keywords     Login With Personas For Suite Setup
...              AND             Switch Browser    SiteAdmin
...              AND             Navigate To Settings Page

Test Setup      Run Keywords    Reset Personas State
...             AND             Switch Browser    SiteAdmin      
...             AND             Navigate To Settings Page
Suite Teardown    Close All Browsers


*** Test Cases ***

Verify that user can rename the field names of General Details page on Job creation screen via Settings page by Site Admin
    [Teardown]    Run Keywords    Reset The Job Settings    Job Name
    ...           AND             Verify The Dropdown Fields Are Not Scannable In Job Settings
    [Tags]    CZ-7312    sanity
    When Navigate To Settings Page
    And Switch To Jobs Tab In Settings Page
    And Rename The Job Fields
    And Click On The Save Button On Settings Page
    And Click On The Dashboard In Left Navigation
    And Navigate To Job Management Page
    Then Verify The Job Field Name Settings     Applied


Verify that user can rename the field names of General Details page on Procedure creation screen via Settings page by Site Admin
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Reset The Site Settings    PROCEDURE_NAME
    ...           AND             Verify The Dropdown Fields Are Not Scannable In Site Settings
    [Tags]    CZ-7311
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Rename The Procedure Fields
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The Procedure Field Name Settings     Applied


Verify that user can mark a field as mandatory or non-mandatory on Job Screen via Settings page by Site Admin
    [Tags]    CZ-7313    sanity
    When Navigate To Settings Page
    And Switch To Jobs Tab In Settings Page
    And Set The Job Fields Mandatory
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    And Navigate To Job Management Page
    Then Verify The Job Field Set     Mandatory
    And Switch Browser    SiteAdmin
    And Reset The Job Settings    Mandatory Field
    And Switch Browser    Author
    And Navigate To Job Management Page
    And Verify The Job Field Set     Not Mandatory

Verify that user can mark a field as mandatory or non-mandatory on Procedure Screen via Settings page by Site Admin
    [Tags]    CZ-7314
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Set The Procedure Fields Mandatory
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The Procedure Field Set     Mandatory
    And Switch Browser    SiteAdmin
    And Reset The Site Settings    Mandatory Field
    And Switch Browser    Author
    And Verify The Procedure Field Set     Not Mandatory


Verify that user can hide or unhide the fields on Job screen via Settings page by Site Admin
    [Tags]    CZ-7317    sanity
    When Hide/Unhide The Job Fields    Hide
    And Click On The Dashboard In Left Navigation
    And Switch Browser    Author
    And Navigate To Job Management Page
    Then Verify The Job Field Set     Hide
    And Switch Browser    SiteAdmin
    And Hide/Unhide The Job Fields    Un Hide
    And Switch Browser    Author
    And Navigate To Job Management Page
    And Verify The Job Field Set     Not Hide


Verify that user can hide or unhide the fields on Procedure screen via Settings page by Site Admin
    [Tags]    CZ-7318
    When Hide/Unhide The Procedure Fields    Hide
    And Switch Browser    Author
    Then Verify The Procedure Field Set     Hide
    And Switch Browser    SiteAdmin
    And Hide/Unhide The Procedure Fields    Un Hide
    And Switch Browser    Author
    And Verify The Procedure Field Set     Not Hide

Verify the functionality of Cancel button on Job Creation and Procedure creation settings page under Site Admin
    [Tags]    CZ-7319
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Rename The Procedure Fields
    And Click On The Cancel Button On Settings Page
    And Switch Browser    Author
    And Create Procedure Records    COUNT=1    SIGNOFF=NOT REQUIRED
    And Verify The Procedure Field Name Settings     Not Applied
    And Switch Browser    SiteAdmin
    And Navigate To Settings Page
    And Switch To Jobs Tab In Settings Page
    And Rename The Job Fields
    And Click On The Cancel Button On Settings Page
    And Switch Browser    Author
    Then Verify The Job Field Name Settings     Not Applied



Verify that Author user able to create new procedure by entering manually Document ID and material ID when selected as option "Free form" under Setting at site admin side.
    [Tags]    CZ-7331    sanity
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The New Procedure Page With Updated Settings    FORM_FILLING=FREE_FORM


Verify that Author user able to create new procedure by entering material ID when selected as option "Auto generated" under Setting at site admin side.
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Navigate To Settings Page
    ...           AND             Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    ...           AND             Click On The Save Button On Settings Page
    [Tags]    CZ-7332    CZ-7351    sanity
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=PREFIX
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The New Procedure Page With Updated Settings    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=PREFIX    BLANK_DOCUMENT_ID=True
    And Switch Browser    SiteAdmin
    And Navigate To Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    And Verify The New Procedure Page With Updated Settings    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=PREFIX    CHANGES_REVERTED=True    BLANK_DOCUMENT_ID=True


Verify that Document ID gets auto generated on Procedure's general details page on entering material ID at authors end when selected as option "Auto generated" under Setting at site admin side.
    [Tags]    CZ-7333
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Navigate To Settings Page
    ...           AND             Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    ...           AND             Click On The Save Button On Settings Page
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=SUFFIX
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The New Procedure Page With Updated Settings    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=SUFFIX    BLANK_DOCUMENT_ID=True
    And Switch Browser    SiteAdmin
    And Navigate To Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    And Verify The New Procedure Page With Updated Settings    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=SUFFIX    CHANGES_REVERTED=True    BLANK_DOCUMENT_ID=True

Verify that a Document ID is auto-generated when an author edits a procedure that was originally created with a blank Document ID, provided that Site Admin settings are configured to “Auto generated.
    [Tags]    CZ-7334
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Navigate To Settings Page
    ...           AND             Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    ...           AND             Click On The Save Button On Settings Page
    When Switch Browser    Author
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details    BLANK_DOCUMENT_ID=True
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Switch Browser    SiteAdmin
    And Navigate To Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=SUFFIX
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify That The Document ID Is Auto-Generated When An Author Edits A Procedure


Verify No hyphen (-) is displayed in the document Id when site Setting configured as auto generate with empty suffix/prefix value in Settings.
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Navigate To Settings Page
    ...           AND             Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    ...           AND             Click On The Save Button On Settings Page
    [Tags]    CZ-7356    sanity
    When Navigate To Settings Page
    And Switch To Site Tab In Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=PREFIX    PREFIX/SUFFIX_VALUE=${EMPTY}
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    Then Verify The New Procedure Page With Updated Settings    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=PREFIX    BLANK_DOCUMENT_ID=True    BLANK_PREFIX_SUFFIX_VALUE=True


Verify that a Document ID is not auto-generated when an author edits a procedure that was originally created with a Document ID, provided that Site Admin settings are configured to “Auto generated.
    [Tags]    CZ-7355
    [Teardown]    Run Keywords    Switch Browser    SiteAdmin
    ...           AND             Navigate To Settings Page
    ...           AND             Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=FREE_FORM
    ...           AND             Click On The Save Button On Settings Page
    When Switch Browser    Author
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Switch Browser    SiteAdmin
    And Navigate To Settings Page
    And Configure The Fields To Appear When Creating A New Procedure    FORM_FILLING=AUTO_GENERATE    AUTO_GENERATE=SUFFIX
    And Click On The Save Button On Settings Page
    And Switch Browser    Author
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify That The Document ID Is Auto-Generated When An Author Edits A Procedure    NOT_AUTOGENERATED=True

Verify that user can expand or contract the length of column accordingly
    [Tags]    CZ-7340    sanity
    When Switch Browser    Author
    And Verify The Column Resize Functionality
    And Switch Browser    Author
    Then Verify The Column Width Persists In Fresh Login


Verify that user can hide or unhide the columns on Procedure Library page.
    [Teardown]    Run Keywords    Configure The Visibility Of The Columns On Procedure List Page    Un Hide
    ...           AND             Verify The Columns On Procedure Page Are     Shown
    [Tags]    CZ-7341
    When Configure The Visibility Of The Columns On Procedure List Page    Hide
    And Verify The Columns On Procedure Page Are     Hidden


Verify that User is not allowed to hide all the mentioned field
    [Tags]    CZ-7343    sanity
    When Verify The User Can't Hide All The Fields


Verify that Preferences are saved and user Specific
    [Teardown]    Run Keywords    Switch Browser    Author
    ...           AND             Configure The Visibility Of The Columns On Procedure List Page    Un Hide
    ...           AND             Verify The Columns On Procedure Page Are     Shown
    [Tags]    CZ-7352
    When Configure The Visibility Of The Columns On Procedure List Page    Hide
    And Verify The Columns On Procedure Page Are     Hidden
    And Login Again As Persona    ${AUTHOR2_EMAIL}
    Then Verify The Columns On Procedure Page Are     Shown


Verify the columnizer inside the folder
    [Teardown]    Run Keywords    Switch Browser    Author
    ...           AND             Configure The Visibility Of The Columns On Procedure List Page    Un Hide
    ...           AND             Verify The Columns On Procedure Page Are     Shown
    [Tags]    CZ-7353    sanity
    When Click On The Dashboard In Left Navigation
    And Navigate To Procedures List Page
    And Create The Folder On The Author Screen
    And Configure The Visibility Of The Columns On Procedure List Page    Hide
    And Navigate Inside The Folder On The Author Screen
    And Verify The Columns On Procedure Page Are     Hidden
    And Navigate To Procedures List Page
    And Configure The Visibility Of The Columns On Procedure List Page    Un Hide
    Then Verify The Columns On Procedure Page Are     Shown

Verify that the columnizer is available for all the Personas
    [Tags]    CZ-7354
    When Verify The Columnizer For All Persona
