*** Settings ***
Library     SeleniumLibrary
Library    EmailListener.py
Library    OperatingSystem
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/JobManagement/JobManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/SiteManagement/SiteManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource


Suite Setup     Run Keywords     Login With Personas For Suite Setup
...             AND             Switch Browser    Author
...             AND             Navigate to Job Management Page
...             AND             AuthorScreen.Generate Unique Number
...             AND             Load Validation Data

Test Teardown    Run Keywords    Reset Personas State
...             AND             Switch Browser    Author
...             AND             Navigate to Job Management Page
Suite Teardown    Close All Browsers

*** Test Cases ***

Verify That On Click Job, User Navigates To Job Management Page
    [Tags]    CZ-6366
    Then Verify User Is On Job Management Page

Verify The UI Of New Job Order Screens
    [Tags]    CZ-6391 
    Log    This testcase might fail as material input field is not auto focus
    When Click On Add New Button    CHECK_AUTO_FOCUS=True
    And User Is Able To Enter Serial Number
    And User Is Able To Enter Material Number
    And Enter The Job Name
    And User Clicks On Cancel Button

Verify That on Click Cancel, User Navigates Back to Job Listing Page
    [Tags]    CZ-6010    sanity
    When Click On Add New Button
    And User Is Able To Enter Serial Number
    And User Clicks On Cancel Button To End Job Creation Process
    And Verify That on Click Cancel, User Navigates Back to Job Listing Page
    And Click On Add New Button
    And User Is Able To Enter Serial Number
    And User Is Able To Enter Material Number
    And User Clicks On Cancel Button To End Job Creation Process
    And Verify That on Click Cancel, User Navigates Back to Job Listing Page
    And Click On Add New Button
    And User Is Able To Enter Serial Number
    And User Is Able To Enter Material Number
    And Enter The Job Name
    And User Clicks On Cancel Button
    Then Verify That on Click Cancel, User Navigates Back to Job Listing Page

Verify "Delete" button Functionality in job order page
    [Tags]    CZ-6388
    When Save The Records Count Before Actions On Page
    And Delete One Record From Job List Page
    Then Verify The Records Count Is Changed By    -1

Verify Error Handling for Invalid Search in job order
    [Tags]    CZ-6379
    Then Search invalid Job and verify

Verify Error handling for Invalid Serial number and Material number
    [Tags]    CZ-6397
    When Verify Invalid Serial number
    Then Verify Invalid Material number

Verify Form Reset Behavior After Cancel
    [Tags]    CZ-6399
    Then verify serial number and material number changes are not saved on clicking cancel

Verify that when an Operator opens or creates a job, the General Details screen is displayed first
    [Setup]    Load Validation Data
    [Tags]    CZ-7310    CZ-6400
    When Switch Browser    Operator
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Verify The Procedures Associated With The Material Number Are Displayed At the Operators End In Job Creation
    And Click On Create Job Button
    And Click newly created sample job
    And Verify input fields are disabled after job creation
    And Verify entered details are visible on Job Orders page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Select The User Input
    And Navigate to Job Management Page
#    Then Delete The Job Created

Verify due date selection, warning message and cancel button functionality
    [Tags]    CZ-6404
    When Click On Add New Button
    And Enter sample serial number and material number
    And Select due date and verify
    And Enter sample job name
    And Click On Next/Done Button
    And Verify warning message on clicking create without adding procedures
    Then verify on clicking cancel on procedure page, user lands on job orders page

Verify invalid due date selection
    [Tags]    CZ-6407
    When Click On Add New Button
    And Enter sample serial number and material number
    Then Verify invalid due date

Verify Handling of Browser Refresh During Job Creation
    [Tags]    CZ-6408
    When Click On Add New Button
    And Enter sample serial number and material number
    Then Verify unsaved job data cleared on refresh

Verify the Pause Button Functionality
    [Tags]    CZ-6421    CZ-6413
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Select The User Input
    And Pause Job Execution
    And Verify Pause job functionality
    And Navigate to Job Management Page
    Then Delete The Job Created


Verify that User is not able to select the due date from back date
    [Tags]    CZ-6013    CZ-6374
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Verify The User Is Not Able To Select The Due Date From Back Date
    And Select Procedure To Job
    And Click On Create Job Button
    Then Click newly created sample job


Verify that User is getting delete confirmation pop up on deleting the job
    [Tags]    CZ-6016
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Save The Records Count Before Actions On Page
    And Delete The Job Created
    Then Verify The Records Count Is Changed By    -1

Verify that items per page are visible as per the selection from rows per page
    [Tags]    CZ-6022
    When Verify The Pagination On The Jobs List Page

Choose an option at the start of the job
    [Tags]    CZ-6547     CZ-6488
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Add Item To List
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Click On The Cancel Button On Welcome Screen
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Capture Page Screenshot
    And Verify That The UI Displays Option Choices Correctly In The Selection Dropdown
    And Click On Option Select Button From Header
    Then Close Popup


Verify that Status of Jobs are updated in real time
    [Tags]    CZ-6473    CZ-6549     CZ-6544    CZ-6545    CZ-6500    CZ-6489  CZ-6437  CZ-6423  CZ-6418    sanity
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Verify That The UI Displays Option Choices Correctly In The Selection Dropdown
    And Select The User Option In Job    Correct
    And Verify The Steps Based On The Option Selected    Correct Option
    And Mark The Step As Completed
    And Select The User Option In Job
    And Verify The Steps Based On The Option Selected    Incorrect Option
    And Reload Page
    And Verify The Steps Based On The Option Selected    Incorrect Option
    And Select The User Option In Job    Correct
    And Click On The Step In Job Execution    2
    And Verify Procedure Steps In Job Execution    2
    And Finish The Job/Training
#    And Search The Job On Job List Page
#    Then Verify The Job Status    Completed


Verify User Inputs Functionality
    [Tags]    CZ-6435    sanity
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Close Popup
    And Click On The Step In Job Execution    3
    And Verify The UI Of The User Input Pop-up
    And Select The User Input
    And Mark The Step As Completed
    And Click On The Step In Job Execution    1
    And Complete Job/Training execution
#    Then Verify The Job Status    Completed
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Close Popup
    And Verify The Cycle Time Is Reset To Default

Verify Procedure Steps Visibility
    [Tags]    CZ-6426    CZ-7229
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Close Popup
    Then Verify Procedure Steps In Job Execution

Verify that added PPE'S are correctly displayed to operator on welcome screen
    [Tags]    CZ-6522
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The UI Of Start Job Welcome Screen
    Then Verify The PPE's Of The Procedure Added In Job

Verify that when Operator access the welcome screen, a list of procedures and PPE equipment is visible which is required for that job.
    [Tags]    CZ-6520    sanity
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Save The Material Number
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Enter The Same Material Number
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job    True
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The Procedures Listed On Welcome Screen
    And Verify No PPE Is Added To The Job
    And Close The Pop-up Window
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page    ${PROCEDURE_LIST[0]}
    And Click On Edit Button On Procedure Details Page
    And Add PPE To The Procedure And Save For Validation
    And Click On Publish Button
    And User Adds Release Notes
    And Navigate To Procedure Details Page    ${PROCEDURE_LIST[1]}
    And Click On Edit Button On Procedure Details Page
    And User Adds PPE To The Procedure
    And Click On Publish Button
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The UI Of Start Job Welcome Screen
    And Verify The Procedures Listed On Welcome Screen
    And Verify The PPE's Of Both The Procedure Added In Job
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The UI Of Start Job Welcome Screen
    And Verify The Procedures Listed On Welcome Screen
    Then Verify The PPE's Of Both The Procedure Added In Job

Verify that user's input pop-up window opens before starting a new step.
    [Tags]    CZ-6555    CZ-6525    CZ-7306    CZ-6025    CZ-6386    sanity
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Adds User Input to Step    START_OF_STEP=True
    And User is able to Save and Preview the User Input
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Mark The Step As Completed
    And Verify The UI Of The User Input Pop-up
    And Select The User Input
    And Mark The Step As Completed
    And Complete Job/Training execution    SAVE_CYCLE_TIME=True
    And Remove All Filters On Job Listing Page
    Then Verify The Job Status    Completed    VERIFY_CYCLE_TIME=True

Verify that Job progress status is visible in donut chart
    [Tags]    CZ-6014    CZ-6368
    Log    Donut chart is not visible on the job listing page
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Verify UI of Status Indicators in job order page
    And Save The Status Indicators
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Add Item To List
    And Select Procedure To Job
    And Click On Create Job Button
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Verify The Job Count Changed By    NOT_STARTED_COUNT    +1
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Complete Job/Training execution
    Then Verify The Job Count Changed By    COMPLETED_COUNT    +1

Verify that user is able to edit the job
    [Tags]    CZ-6012   CZ-6786    sanity
    Log    This testcase might fail due to CZ-7631
    When Verify That User Navigates Back To Serial Order Input Window Upon Clicking The 'Change' Hyperlink
    And Save The Records Count Before Actions On Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Enter All Other Job Details
    And Select Procedure To Job
    And Click On Create Job Button
    And Verify The Records Count Is Changed By    +1
    And Verify The Correct Count Is Displayed In The Header
    And Create Procedure Records    COUNT=1    SIGNOFF=NOT_REQUIRED
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Edit Button On Job Details page
    And Enter All Other Job Details
    And Capture Page Screenshot
    And Empty List    PROCEDURE_LIST
    And Add Item To List
    And Select Procedure To Job    MULTIPLE_PROCEDURES=True
    And Click On Create Job Button
    And Navigate To Job Details Page
    Then Verify The Updated Job Details
    And Click On Edit Button On Procedure Details Page
    And Click On Next/Done Button
    And Remove Procedure From The Job

Verify that user is able to see the step group while executing the job.
    [Tags]    CZ-6784    sanity
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And Create Steps Group
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Verify The Step Group Is Visible In Job Execution
    Then Complete Job/Training execution

Verify that User is getting delete confirmation pop up when trying to delete multiple jobs in one go
    [Tags]    CZ-6017
    When Navigate To Job Management Page
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Delete Selected Records
    And Verify The Records Count Is Changed By    -2
    And Save The Records Count Before Actions On Page
    And Select The Multiple Records
    And Click On Cancel Button On Job Order Page
    And Verify User Lands On The Job Order Page
    Then Verify The Records Count Is Changed By

Verify that Taken time visible with the Job is the accumulated time of all the procedures (Default) or the estimated time entered by user
    [Tags]    CZ-6024    sanity
    Log    This testcase is expected to fail due to the default filters
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job    True
    And Click On Create Job Button
    And Navigate To Procedures List Page
    And Navigate To Procedure Details Page    ${PROCEDURE_LIST[0]}
    And Click On Edit Button On Procedure Details Page
    And Add PPE To The Procedure And Save For Validation
    And User Adds General Details
    And Click On Publish Button
    And User Adds Release Notes
    And Add Item To List    VAR_NAME=UPDATED_PROCEDURE_LIST
    And Navigate To Procedure Details Page    ${PROCEDURE_LIST[1]}
    And Add Item To List
    And Click On Edit Button On Procedure Details Page
    And User Adds PPE To The Procedure
    And User Adds General Details
    And Click On Publish Button
    And User Adds Release Notes
    And Add Item To List    VAR_NAME=UPDATED_PROCEDURE_LIST
    And Get The Updated Procedure Name And Version
    And Navigate To Job Management Page
    And Verify The Cumulative Cycle Time Of The Procedures In Job
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Verify The UI Of Start Job Welcome Screen
    And Verify The Updated Procedures, Versions, Author Listed On Welcome Screen
    And Verify The PPE's Of Both The Procedure Added In Job
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Complete Job/Training execution And Calculate Taken Time
    And Remove All Filters On Job Listing Page
    Then Verify The Taken Time

Verify that data is updated in donut chart when a new job is added.
    [Tags]    CZ-6474
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Verify UI of Status Indicators in job order page
    And Save The Status Indicators
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Add Item To List
    And Select Procedure To Job
    And Click On Create Job Button
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Verify The Job Count Changed By    NOT_STARTED_COUNT    +1
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Pause Job Execution
    And Close Browser
    And Login To Mentor Application    ${OPERATOR1_EMAIL}    ${OPERATOR1_PASS}
    And Navigate To Job Management Page
    And Verify The Job Count Changed By    PAUSED_COUNT    +1
    And Switch Browser    Author
    And Navigate To Job Management Page
#    And Remove All Filters On Job Listing Page
#    And Delete The Job Created
#    And Verify The Job Count Changed By    PAUSED_COUNT    -1
#    And Verify The Donut Chart Color Coding For Different Jobs
#    Then Verify The Total Jobs Count Is Displayed Properly

Verify that user should be able to delete the procedure on click cross icon
    [Tags]    CZ-6015
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Save The Material Number
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Enter The Same Material Number
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Verify The User Is Able To Delete The Procedures From New Job Screen
    And Verify Pagination On The Add Procedures To Job Screen
    Then Verify the UI Layout of the Procedures Page

Verify that User is able to add the Job having duplicate serial number
    [Tags]    CZ-6028
#    When Verify The UI of The Job Order Page
    And Get The First Job Details
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}    CUSTOM_SERIAL_NUMBER=${TD_SERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    Then Verify The Job Having Duplicate Serial Number


Verify UI Elements on the 'Add New Job - BOM' Screen
    [Tags]    CZ-6401
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Validate Parts&Tools Added In Job    BOM
    Then Validate Parts&Tools Added In Job    BOT
    Then Validate Parts&Tools Added In Job    COM


Verify Handling of Invalid Characters in Input Fields
    [Tags]    CZ-6406
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields
    And Verify Invalid Input Fields Validation For New Job Form
    And Select Procedure To Job
    And Verify Estimated Time Display In Add Procedure Page
    And Click On Create Job Button
    Then Verify The Mandatory Fields Validation In Job Creation

Verify Step Status Update in Side panel under procedures
    [Tags]    CZ-6425
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job    MULTIPLE_PROCEDURES=True
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Verify The UI Of Job Execution Page
    #Currently NCR report is not working, please un comment once the NCR is working
#    Then Verify Step Status Update In Side Panel


Verify the Troubleshoot page loads correctly
    [Tags]    CZ-6455
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User adds Preventive Troubleshooting to Step
    And User Publishes The Procedure
    And User Adds Release Notes
    And Add Item To List
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Verify The UI Of The Troubleshoot Window
    #Currently NCR report is not working, please un comment once the NCR is working
#    Then Submit The NCR Report If the Issue Is Not Listed


Verify The Due Date Filter Functionality
    [Tags]    CZ-6370    CZ-6381    CZ-6383    CZ-6384
    Log    This testcase might fail due to CZ-7537
    When Verify The Due Date Filter Functionality
    And Verify The Completed Date Filter Functionality
    Then Verify The Material Number Filter Functionality


Verify The Status Filter Functionality
    [Tags]    CZ-6380
    Log    This testcase might fail due to CZ-7537
    [Setup]    Run Keywords    Click On Filter Button
    ...        AND             Clear All Filters And Apply Changes
    When Verify The Status Filter Functionality


Verify The Assigned To Filter Functionality
    [Tags]    CZ-6382
    When Click On Filter Button
    Then Verify The Assigned To Filter Functionality


Verify adding an image through file upload
    [Setup]    Create Procedure With Attachments
    [Tags]    CZ-6461    CZ-6470    CZ-7272
    When Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Assign Job To User From Details Page    USER=OPERATOR1_NAME
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Expand The Attachments Window
    And Verify Image Zoom In -Zoom Out
    And Close Popup
    Then Verify that Arrow icons should be visible on Attachment Preview screen


Verify the user input form behaviour when the procedure is reset during job execution
    [Tags]    CZ-7357    CZ-7471    CZ-6428    CZ-6505
    When Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Select The User Option In Job   CORRECTNESS=Correct
    And Click On The Step In Job Execution    3
    And Verify The UI Of The User Input Pop-up
    And Select The User Input
    And Mark The Step As Completed
    And Click On The Step In Job Execution    3
    And Close User Input Popup
    And Reset The Procedure Step
    And Click On The Step In Job Execution    1
    And Click On The Step In Job Execution    3
    Then Verify The User Input Value Is Reset


Verify If user has edited Material ID and then saves the procedure as draft, then operator should not be able to procedures using new Material Id unless it is not published.
    [Tags]    CZ-7428    CZ-7348
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And Add The Cycle Time To The Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Procedure Details Page
    And Click On Edit Button On Procedure Details Page
    And User Adds General Details
    And User Saves Procedure as Draft
    And Capture Page Screenshot
    And Switch Browser    Operator
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    Then Verify The Procedures Associated With The Material Number Are Displayed At the Operators End In Job Creation    VISIBILITY=Hide


Verify the job resumed by one operator can be resumed from the same steps by other operator
    [Tags]    CZ-7466    CZ-7538    CZ-7539    CZ-7540
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Add Step To Procedure
    And User Publishes The Procedure
    And User Adds Release Notes    
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Mark The Step As Completed
    And Pause Job Execution
    And Capture Page Screenshot
    And Navigate To Job List Page From Paused Screen
    And Login Again As Persona    ${OPERATOR2_EMAIL}
    And Navigate to Job Management Page
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Capture Page Screenshot
    And Start Job Execution
    And Verify The UI Of The Paused Job Screen And Resume Execution
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training
    And Capture Page Screenshot

Verify that user is able to reset the steps of a particular procedure added inside the job.
    [Setup]    Create Procedure Records    COUNT=4    SIGNOFF=NOT REQUIRED    LIST_NAME=ADD_PROCEDURE_TO_JOB_LIST
    [Tags]    CZ-7469
    When Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job    MULTIPLE_PROCEDURES=True    LIST_VAR_NAME=ADD_PROCEDURE_TO_JOB_LIST
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Get Procedures List In Job Execution Screen
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Click On The Reset Icon From Header
    And Reset The Job Execution Element    RESET_TYPE=STEP    PROCEDURE_NUMBER=3
    And Verify The Procedure Is Reset In Job Execution    PROCEDURE_NUMBER=3
    And Click On The Step In Job Execution    STEP_INDEX=3    IGNORE_STEP=True
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training


Verify that user is able to reset the procedures added in job while executing it
    [Setup]    Create Procedure Records    COUNT=3    SIGNOFF=NOT REQUIRED    LIST_NAME=ADD_PROCEDURE_TO_JOB_LIST
    [Tags]    CZ-7358
    When Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job    MULTIPLE_PROCEDURES=True    LIST_VAR_NAME=ADD_PROCEDURE_TO_JOB_LIST
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Get Procedures List In Job Execution Screen
    And Mark The Step As Completed
    And Mark The Step As Completed
    And Click On The Reset Icon From Header
    And Reset The Job Execution Element    RESET_TYPE=PROCEDURE    PROCEDURE_NUMBER=2
    And Verify The Procedure Is Reset In Job Execution    PROCEDURE_NUMBER=2
    And Click On The Step In Job Execution    STEP_INDEX=2    IGNORE_STEP=True
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training

Verify that user is able to reset the steps added in Step Group of a particular procedure added inside the job.
    [Tags]    CZ-7470
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure    2
    And Create Steps Group
    And Edit The Step Group Name
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    And Get Procedures List In Job Execution Screen
    And Mark The Step As Completed
    And Click On The Reset Icon From Header
    And Reset The Step Group Step In Job Execution    PROCEDURE_NUMBER=1
    And Verify The Step Group Procedure Step Is Reset IN Job Execution
    And Click On The Step In Job Execution    STEP_INDEX=1    IGNORE_STEP=True
    And Mark The Step As Completed
    And Mark The Step As Completed
    Then Finish The Job/Training


Verify that if created option is not added in any step then option pop-up should not appear.
    [Tags]    CZ-7477
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Adds General Details
    And User Add Step To Procedure
    And User add Options to Step    DO_NOT_ADD_OPTION_TO_STEP=True
    And User Publishes The Procedure
    And User Adds Release Notes
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure To Job
    And Click On Create Job Button
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    Then Verify That The UI Displays Option Choices Correctly In The Selection Dropdown    NO_OPTION_ADDED_TO_STEP=True

Verify that expert only toggle is working as expected on Expert Operator's end.
    [Tags]    CZ-7478    CZ-6564
    When Navigate To Procedures List Page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User Add Step To Procedure    4
    And Select The Novice Only Checkbox
    And User Publishes The Procedure
    And User Adds Release Notes
    And Login Again As Persona    ${EXPERT_OPERATOR_EMAIL}
    And Navigate To Job Management Page
    And Create Sample Job With Mandatory Fields    ${TD_MATERIAL_NUMBER}
    And Select Procedure And Create Job As Operator
    And Click newly created sample job
    And Click On Start Job On Job Details Page
    And Start Job execution
    Then Verify The Expert Operator Toggle Functionality
