*** Settings ***
Library     SeleniumLibrary
Variables    EmailListener.py
Library     OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Trainings/Training.resource
Variables   ../../../src/utilities/Common-utils/ChainedActions.py

Suite Setup     Run Keywords     Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
...             AND             Set Selenium Speed    0.1

Test Teardown   Run Keyword    Ensure Procedures List Page Is Open
Suite Teardown    Close All Browsers

*** Test Cases ***


Verify that added general details of procedure are correctly visible to user in Preview.
    [Tags]    CZ-6752    CZ-6767    CZ-6526    CZ-7257    CZ-6718    CZ-6719    CZ-6720    sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details        VERIFY_DUPLICATE_MAT_NUM=True
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Verify The Notification Received    NOTIFICATION_CONTEXT=New Version ${TD_VERSION} Is Published,${TD_PROCEDURE_NAME},Procedure Published
    And Click On The Notification Received
    Then Validate The Procedures Details In Preview        VERIFY_DUPLICATE_MAT_NUM=True


Verify the Search functionality on Preventive Troubleshooting Page
    [Tags]  CZ-6785
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User Adds Another Entry For Preventive TroubleShooting Entry
    And User searches for predefined symptom
    Then Verify that the matching troubleshooting entries are displayed
    And Verify The User Is Able To Delete The Troubleshooting Entry Without Refreshing The Page

Verify added User Inputs are visible in Preview mode
    [Tags]   CZ-6758   CZ-6760   CZ-6508
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step   BOM
    And Add Parts&Tools To Step   BOT
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Saves Procedure as Draft
    ${ProcedureArgument}=    And Verify that the Procedure is saved
    And User Click On Preview Option
    And User Click On User Input Icon
    Then Verify added User Inputs is visible in Preview mode


Verify that user is able to Preview a procedure.
    [Tags]   CZ-6770    CZ-6751  Regression
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Saves Procedure as Draft

    ${ProcedureArgument}=    And Verify that the Procedure is saved

    And User Click On Preview Option
    Then Verify That User Lands On Preview Page    ${ProcedureArgument}

Verify added Preventive Troubleshooting are visible in Preview mode
    [Tags]   CZ-6759    sanity
    When Verify Duplicate Columns Not Displayed On The Procedure List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Saves Procedure as Draft
    And Verify that Draft state Procedure has been created
    And User Click On Preview Option
    And User Click On Preventive TroubleShoot Icon
    Then Verify added Preventive Troubleshooting are visible in Preview mode
    And Search The Procedure On Procedure List Page    ${TD_PROCEDURE_NAME}
    And Duplicate The Created Procedure

Verify that User is able to add draft version of procedure by clicking on 'Add New' button
    [Tags]   CZ-6507    CZ-6551
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Saves Procedure as Draft
    And Verify that the Procedure is saved
    Then Verify that Draft state Procedure has been created


Verify that user is able to publish the procedure after adding steps in the procedure
    [Tags]  CZ-6509
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved
    Then Verify that Procedure is Published

Verify that an Author can add a new Option in a procedure step
    [Tags]  CZ-6538
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User add Options to Step
    Then Verify that user is able to see the added option to step

Verify that the Author can define a troubleshooting entry with all necessary fields
    [Tags]  CZ-6565     CZ-6576
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    Then Verify that Author is able to define a troubleshooting entry with all necessary fields

Verify that user is able to remove the added PPE
    [Tags]  CZ-6522     CZ-6513
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And Verify that Added PPE becomes visible on General Details tab    @{PPE_ADDED_TO_PROCEDURE}
    And User clicks on delete icon  @{PPE_ADDED_TO_PROCEDURE}
    Then Verify that added PPE's gets removed from the UI

Verify that user is able to add attachments to the step
    [Tags]  CZ-6514   CZ-6515    CZ-6582    sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Image attachments to the procedure
    And User adds Video attachments to the procedure
    And User adds PDF attachments to the procedure
    And Verify that user is able to see icons of attachments
    And User clicks on cross icon
    Then Verify that added attachments get removed from the UI

Verify the functionality of Cancel button on the Add New Procedure Page
    [Tags]  CZ-6511
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User add Options to Step
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And User clicks on Cancel Button
    Then Verify that no procedure is created after clicking on the cancel button

Verify that UI of User Inputs page
    [Tags]  CZ-6553
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    Then Verify the UI of User Input Page

Verify the functionality of "Add Block" button
    [Tags]  CZ-6554
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    Then User Click Add Block and Verify that New User Input Block Gets Added



Verify that user can add any number of options using "+Add options"
    [Tags]  CZ-6557
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    And User Add details for User Input
    Then Click On Add Option Hyperlink and Verify User can Add Any Number Of Options using "+Add options"

Verify that user cannot create a user input form without filling the mandatory field
    [Tags]  CZ-6559
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    And User Skips Mandatory field
    Then Verify that User cannot proceed with missing mandatory field

Verify that user can Preview the block by clicking on Preview button
    [Tags]  CZ-6561     CZ-6560
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Adds User Input to Step
    Then User is able to Save and Preview the User Input

Verify that "Delete Block" becomes enabled when user adds another block
    [Tags]  CZ-6563    CZ-6556  CZ-6552
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    And User Click Add Block and Verify that New User Input Block Gets Added
    And Verify that "Delete Block" becomes enabled
    Then User Clicks Delete Block button and Verify that User Input Block Gets Deleted

Verify that the procedure version is correctly updated based on the selected update type (Minor/Major)
    [Tags]  CZ-6528
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes the Procedure
    Then Verify That Version Gets Updated

Verify that the CRCO number field enforces a character limit
    [Tags]  CZ-6535     CZ-6536
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes the Procedure
    And User Enter Alphanumeric CRCO number
    Then Verify That User Gets A Validation Message for Exceeding character length

Verify that the Operator can submit a non-conformance report if an issue is not listed
    [Tags]  CZ-6570     CZ-6575
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    Then User Add Step To Procedure

Verify the delete icon functionality against every option
    [Tags]   CZ-6558
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Navigates to User Input Page
    And User Add details for User Input
    And User adds multiple options
    Then User Click on Delete icon and Verify the added options gets removed


Verify the functionality of Cross and Cancel button on Publish pop-up screen
    [Tags]    CZ-6534  CZ-6533 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Verify publish popup is closed on clicking cross icon
    Then Verify publish popup is closed on clicking cancel button

Verify that no PPE's are displayed in the PPE section while filing general details of the procedures.
    [Tags]    CZ-6518  CZ-6580
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Verify no PPE are displayed when creating new procedure
    And User adds PPE to the procedure
    Then Delete the added PPE

Verify the functionality of cross icon on instruction box
    [Tags]    CZ-6581 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    Then Verify functionality of cross icon on instructions

Verify new step is added on clicking '+' icon visible on closed general details section
    [Tags]    CZ-6588 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    Then Collapse General details section


Verify that data added within the steps is correctly visible to user.
    [Tags]    CZ-6754    CZ-6763    CZ-6510 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure    4
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    Then Validate The Correct Steps Count

Verify added PPE's are visible in Preview mode.
    [Tags]    CZ-6755 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add PPE To The Procedure And Save For Validation
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    Then Verify The Added PPE's In Procedure Preview

Verify added BOM/BOT are visible in Preview mode
    [Tags]    CZ-6756 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And Add Parts&Tools To Step   BOM
    And Add Parts&Tools To Step   BOT
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    Then Validate BOM/BOT In Procedure Preview mode

Verify that on the top of Preview page, version information and Procedure Name is correct
    [Tags]    CZ-6764    CZ-7228    CZ-7230    CZ-6765 
    When Get The First Procedure Details
    And Navigate To Procedure Details Page
    And Verify The Procedure Name And Version On Preview Page
    And Click On Procedure Link In Breadcrumb
    And Verify User Lands On The Procedure List Page
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure    True
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Validate The Procedures Details In Preview
    Then Validate The Updated Version Details On The Preview Page

Verify functionality of Delete Block button
    [Tags]    CZ-6590    CZ-6769 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Adds User Input to Step
    And User is able to Save and Preview the User Input
    And Delete The New Added Block In User Input
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify The User Input Block Is Deleted

Verify the functionality of Cancel button on Add instructions page.
    [Tags]    CZ-6585 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    Then Verify The Cancel Button Functionality In The Step Instruction

Verify that multiple Options can be added to a single step.
    [Tags]    CZ-6539    CZ-6757   CZ-6708 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Add Options To Step    3
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify The Options Of The Step

Verify that data added within the steps is correctly visible to user.
    [Tags]    CZ-6753    CZ-6762 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure    4
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Validate The Correct Steps Count
    Then Validate The Steps Are Visible and Scrollable

Verify that user is able to view added attachment in both Gallery and Grid view in Preview mode
    [Tags]  CZ-6761
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Image attachments to the procedure    VERIFY_CROSS_ICON=True
    And User adds Video attachments to the procedure
    And User adds PDF attachments to the procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Verify that user is able to see icons of attachments
    Then Verify That User Is Able To See Attachments In Grid View

Verify that novice only checkbox is marked as checked if a step is marked as Novice only.
    [Tags]  CZ-6766 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Select The Novice Only Checkbox
    And User Publishes The Procedure
    And User Adds Release Notes    VERIFY_CANCEL_BUTTON=True
    And User Publishes The Procedure    IGNORE_VERSION=True
    And User Adds Release Notes    
    And Navigate To Procedure Details Page
    Then Verify The Novice Only Checkbox Should be Selected On Procedure Review Page


Verify that user is able to group steps.
    [Tags]  CZ-6771    CZ-6774    CZ-6780 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure    REMOVE_PPE=True
    And User Add Step To Procedure
    And Create Steps Group
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify The Create Steps Group Created

Verify that user is able to edit the name of step group.
    [Tags]  CZ-6773     sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure    2
    And Create Steps Group
    And Edit The Step Group Name
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Validate The Correct Step Group Name Is Updated

Verify that user is able to make any number of step groups.
    [Tags]  CZ-6779 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Create Steps Group
    And User Add Step To Procedure
    And Create Steps Group
    And User Add Step To Procedure
    And Create Steps Group
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify The Multiple Steps Group Created

Verify the UI of Add New Procedure Screen.
    [Tags]  CZ-6506  CZ-7092  CZ-6577 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    Then Verify The UI Of Add New Procedure Page

Verify that user is able to add instructions.
    [Tags]  CZ-6578 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure In Expanded Instruction Box
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    Then Verify The Instruction Is Saved On The Procedure Review


Verify that the Author can edit an existing troubleshooting entry.
    [Tags]   CZ-6566     CZ-6574
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And Update The Preventive Troubleshooting To Step
    And User Publishes The Procedure    True
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Validate The Updated Preventive Troubleshooting To Step


Verify that the Author can delete an existing troubleshooting entry.
    [Tags]   CZ-6567
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And Delete The Preventive Troubleshooting to Step
    And User Publishes The Procedure    True
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    Then Verify The Preventive Troubleshooting Entry Deleted

Verify the system behavior when the Release Note field is left empty
    [Tags]    CZ-6527 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And Verify The User Is Not Able To Publish The Procedure Without Release Notes


Verify that user is able to change the language of instructions box from side bar.
    [Tags]    CZ-6579     sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Enter Instruction To The Step And Change Language
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    Then Verify The Text Language has Not Been Changed

Verify that user is able to access the toolkit while writing instructions for the step.
    [Tags]    CZ-6584 
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    Then Enter Instruction To The Step And Access Toolkit

Verify that input fields are dynamically displayed based on checkbox selection in the form module.
    [Tags]    CZ-6519
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    Then Verify That Input Fields Are Dynamically Displayed



Verify that the approval managers and co-authors are correctly displayed in the Publish screen.
    [Tags]    CZ-6529    CZ-6516
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Approval Managers And Co-Author
    And User Add Step To Procedure
    And User Publishes The Procedure
    Then Verify The Approval Managers And Co-Author Are Correctly Displayed
    And User Adds Release Notes
    And Navigate To Procedure Details Page    
    And Click On Edit Button On Procedure Details Page
    And User Adds General Details
    And User Publishes The Procedure
    And User Adds Release Notes    VALIDATE_PENDING_APPROVAL_ERROR_MESSAGE=True



Verify that users can modify the list of approval managers and co-authors before publishing.
    [Tags]    CZ-6531    sanity
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Approval Managers And Co-Author
    And User Add Step To Procedure
    And User Publishes The Procedure
    And Verify The Approval Managers And Co-Author Are Correctly Displayed
    And Deselect The Approval Managers And Co-Author
    And Add The Approval Managers And Co-Author
    And User Publishes The Procedure
    Then Verify The Approval Managers And Co-Author Are Correctly Displayed

Verify that user is able to delete a steps
    [Tags]    CZ-6776
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    Then Delete The Step

Verify that user is able to delete steps from a step group.
    [Tags]    CZ-6782
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And Create Steps Group
    Then Delete The Step From Step Group


Verify user is able to zoom/in-zoom/out images in preview mode
    [Setup]    Create Procedure With Attachments
    [Tags]    CZ-7225    CZ-7270
    When Navigate To Procedure Details Page
    And Expand The Attachments Window
    And Verify Image Zoom In -Zoom Out
    And Close Popup
    Then Verify that Arrow icons should be visible on Attachment Preview screen


Verify that User is Able to Duplicate the Draft Procedure
    [Tags]  CZ-7495
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Saves Procedure as Draft
    And Duplicate The Created Procedure
    Then Verify Procedure Is Being Duplicated       Draft

Verify the user is able to delete folder from more option
    [Tags]    CZ-7461
    When Create The Folder On The Author Screen
    And Save The Records Count Before Actions On Page
    And Search Folder On Author Screen
    And Delete Folder From More Option
    Then Verify The Records Count Is Changed By    -1

Verify that User Is Able To Duplicate The Published Procedure
    [Tags]  CZ-7494
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Duplicate The Created Procedure
    Then Verify Procedure Is Being Duplicated       Draft


Verify the user is able to delete the folder from the list page
    [Tags]    CZ-7462
    When Create The Folder On The Author Screen
    And Navigate Inside The Folder On The Author Screen
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedures List Page
    And Search Folder On Author Screen
    And Delete The Procedure/Folder From The List Page
    And Search The Procedure On Procedure List Page   ${TD_PROCEDURE_NAME}
    And Page Should Not Contain    No Procedure Found
    And Capture Page Screenshot


Verify The Duplicated procedure should be created inside the folder if it is duplicated there.
    [Tags]    CZ-7493    sanity
    When Create The Folder On The Author Screen
    And Navigate Inside The Folder On The Author Screen
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate Inside The Folder On The Author Screen
    And Duplicate The Created Procedure
    And Navigate To Procedures List Page
    And Search The Procedure On Procedure List Page    ${TD_PROCEDURE_NAME}
    ${DUPLICATED_PROCEDURE_COUNT}=    Get Current Record Count On Page    
    And Should Be True    ${DUPLICATED_PROCEDURE_COUNT}    0
    And Capture Page Screenshot

