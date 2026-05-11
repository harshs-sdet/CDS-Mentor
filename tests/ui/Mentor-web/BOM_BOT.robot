*** Settings ***
Library     SeleniumLibrary
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Login/Login.resource
Variables   ../../../config/Mentor/${env}_env.yaml
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Common/Common.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/UserManagement.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/UserManagement/Teams.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/Procedure/AuthorScreen.resource
Resource    ../../../pageobjects/keywords/ui/web/Mentor/BOM_BOT/BOM.resource

Suite Setup     Run Keywords    Login To Mentor Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
...             AND            Set Selenium Speed      0.1

#Test Teardown    Press Keys    //body    ESC
Test Teardown    Run Keyword    BOM/BOT Teardown
Suite Teardown      Close All Browsers
*** Variables ***
@{expected_sample_file_headers}    supplyChainNumber    name    description    quantity    unit    image    col1    col2    col3



*** Test Cases ***

Verify that user is able to add BOM by clicking on ADD button.
    [Tags]    CZ-7002    CZ-7006    sanity
    [Documentation]    Verify that user is able to add BOM by clicking on ADD button.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOM
    Then Add Parts&Tools To Step    BILL_OF_ITEM=BOT

Verify the UI of Add BOM Page.
    [Tags]    CZ-7003    CZ-7004
    [Documentation]    Verify the UI of Add BOM Page.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Navigate To Exact BOM/BOT Page    BOM
    And Click on Add New on Parts & Materials
    And Verify Add BOM Page
    Then Pop-up window closes upon clicking the cross icon.

Verify the functionality of Cancel button on Add BOM Page.
    [Tags]    CZ-7005
    [Documentation]    Verify the functionality of Cancel button on Add BOM Page.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Navigate To Exact BOM/BOT Page    BOM
    And Click on Add New on Parts & Materials
    Then Select Some Checkboxes and Click Cancel

Verify the pagination on Add BOM page.
    [Tags]    CZ-7012    CZ-7013    sanity    A
    [Documentation]    Verify the pagination on Add BOM page.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Navigate To Exact BOM/BOT Page    BOM
    And Click on Add New on Parts & Materials
    And Verify The Pagination on Add BOM Page
    And Select Some Checkboxes and Close
    Then Verify Pagination of BOM/BOT in procedure library

Verify the pagination on Add BOT page.
    [Tags]    CZ-7014    CZ-7015     A
    [Documentation]    Verify the pagination on Add BOM page.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Navigate To Exact BOM/BOT Page    BOT
    And Click on Add New on Parts & Materials
    And Verify The Pagination on Add BOM Page
    And Select Some Checkboxes and Close
    Then Verify Pagination of BOM/BOT in procedure library

Verify that User see the consolidated view of all the added BOM selected in the existing steps of that procedure.
    [Tags]    CZ-7016
    [Documentation]     Verify that User see the consolidated view of all the added BOM selected in the existing steps of that procedure.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOM
    Then Navigate To BOM In General Details And Verify BOM

Verify that User see the consolidated view of all the added BOT selected in the existing steps of that procedure.
    [Tags]    CZ-7017
    [Documentation]     Verify that User see the consolidated view of all the added BOM selected in the existing steps of that procedure.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOT
    Then Navigate To BOT In General Details And Verify BOT

Verify user is able to click on the BOM record on BOM page of General details to view details of the BOM.
    [Tags]    CZ-7018
    [Documentation]    Verify user is able to click on the BOM record on BOM page of General details to view details of the BOM.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOM
    And Navigate To BOM In General Details
    Then Click on any of the code for added BOMs and Verify

Verify user is able to click on the BOM record on BOM page of Step to view details of the BOM.
    [Tags]    CZ-7019    CZ-7021    sanity
    [Documentation]    Verify user is able to click on the BOM record on BOM page of Step to view details of the BOM
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOM
    And Click on any of the code for added BOMs and Verify
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOT
    Then Click on any of the code for added BOMs and Verify

Verify user is able to click on the BOT record on BOT page of General details to view details of the BOT.
    [Tags]    CZ-7020
    [Documentation]    Verify user is able to click on the BOT record on BOT page of General details to view details of the BOT.
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details
#    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BILL_OF_ITEM=BOT
    And Navigate To BOT In General Details
    Then Click on any of the code for added BOMs and Verify



Verify added BOM are displayed while executing Job
    [Tags]   CZ-7030    CZ-7024    CZ-7025    CZ-7026    CZ-7027    CZ-7028    CZ-7029    CZ-7031    CZ-7032    CZ-7033    CZ-7034    CZ-7035    CZ-7036    sanity
#    Log    This testcase might fail due to the UI issue on the Parts & Tool screen on the Job details page
    [Documentation]    Verify user can click on Added BOM in Job orders page
    When Navigate to Procedures page
    And Create Procedure For BOM/BOT Jobs
    And Navigate To Job Management Page
    And Create Sample Job For Verifying BOM/BOT    ${TD_MATERIAL_NUMBER}
    And Select Due Date And Verify
    And Select Procedure To Job
    And Click On Create Job Button
    And Navigate To Job Details Page
    And Validate Parts&Tools Added In Job    BOM
    And Verify Pagination in BOM page of Job orders
    And Validate Parts&Tools Added In Job    BOT
    And Verify Pagination in BOM page of Job orders
    And Click On Start Job On Job Details Page
    And Start Job Execution
    And Navigate to Parts and Tools Page in Job Execution
    And Verify BOM/BOT in Job Execution Page    BOM
    And Verify the Pagination For BOM/BOT on Job Execution Page
    And Verify BOM/BOT in Job Execution Page    BOT
    And Verify the Pagination For BOM/BOT on Job Execution Page
    Then Click Close Icon On BOM/BOT in Job Execution

Verify that user is able to search the BOM on Add BOM Page
    [Tags]    CZ-7010
    [Documentation]    Verify that user is able to search the BOM on Add BOM Page
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOM
    AND Navigate to Add BOM/BOT/COM Page
    AND User adds details for BOM/BOT/COM    BOM    Image1_JPG.jpg
    AND User submits a BOI
    Logout from Mentor
    Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    AND Navigate To Procedures List Page
    THEN Add BOM/BOT in New Procedure    BOM

Verify that user is able to search the BOT on Add BOT Page
    [Tags]    CZ-7011
    [Documentation]    Verify that user is able to search the BOT on Add BOT Page
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOT
    AND Navigate to Add BOM/BOT/COM Page
    AND User adds details for BOM/BOT/COM    BOT    Image1_JPG.jpg
    AND User submits a BOI
    Logout from Mentor
    Login To Application    ${AUTHOR1_EMAIL}    ${AUTHOR1_PASS}
    AND Navigate To Procedures List Page
    THEN Add BOM/BOT in New Procedure    BOT

Verify user is able to Bulk upload BOM items
    [Tags]    CZ-7042
    [Documentation]    Verify user is able to Bulk upload BOM items
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOM
    AND Click On Bulk Upload
    AND Bulk Upload For Parts And Tools    BOM_BULK_UPLOAD.csv
    Sleep    1s
    THEN Verify Toast Message    Operation is Successful    BOM uploaded successfully

Verify user is able to Bulk upload COM items
    [Tags]    CZ-7487    A
    [Documentation]    Verify user is able to Bulk upload COM items
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    COM
    AND Click On Bulk Upload
    AND Bulk Upload For Parts And Tools    COM_BULK_UPLOAD.csv
#    Then Verify Toast Message    Operation is in progress     Operation is in progress
    Then Verify Toast Message    Operation is Successful    COM uploaded successfully

Verify that user is able to Add single BOM on Bill Of Material screen
    [Tags]    CZ-7248    CZ-7044    CZ-7046    CZ-7038
    [Documentation]    Verify search functionality on BOM page.
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOM
    AND Verify the UI for BOM/BOT/COM    BOM
    AND Navigate to Add BOM/BOT/COM Page
    AND User adds details for BOM/BOT/COM    BOM    Image1_JPG.jpg
    AND User submits a BOI
    AND Search a BOM    ${TD_BOI_NAME}
    AND Search a BOM    ${TD_BOI_FIXTURE_NAME}
    AND Search a BOM    ${TD_BOI_DESCRIPTION}
    AND Verify The BOI
    THEN Delete A BOI

Verify th functionality of Cancel button on Add New (BOM) page
    [Tags]    CZ-7253
    [Documentation]     Verify th functionality of Cancel button on Add New (BOM) page.
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    BOM
    AND User adds details for BOM/BOT/COM    BOM
    AND User cancels a BOM
    THEN Verify The BOM is Not Created

Verify user is able to download Sample template for BOM bulk upload
    [Tags]    CZ-7040   A
    [Documentation]    Verify user is able to download Sample template for BOM bulk upload
    Create Download Directory
    Open Browser With Custom Download Directory    ${URL}
    Sleep    3s
    Login As Site Admin into Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    When User Navigate to the Particular Parts Page    BOM
    AND Click On Bulk Upload
    AND Download Sample Files
    THEN Verify custom files exists    sample    .csv    ${expected_sample_file_headers}

Verify that user is able to export BOM
    [Tags]    CZ-7224    A
    [Documentation]    Verify that user is able to export BOM
    Create Download Directory
    Open Browser With Custom Download Directory    ${URL}
    Login As Site Admin into Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    When User Navigate to the Particular Parts Page    BOM
    AND Verify export of BOM for custom No Of BOM    2
    THEN Verify export for all BOM

Verify user is able to download Sample template for BOT bulk upload
    [Tags]    CZ-7041     A
    [Documentation]    Verify user is able to download Sample template for BOM bulk upload
    Create Download Directory
    Open Browser With Custom Download Directory    ${URL}
    Login As Site Admin into Application    ${SITE_ADMIN_EMAIL}    ${SITE_ADMIN_PASS}
    When User Navigate to the Particular Parts Page    BOT
    AND Click On Bulk Upload
    AND Download Sample Files
    THEN Verify custom files exists    sample    .csv    ${expected_sample_file_headers}

Verify user is able to Bulk upload BOT items
    [Tags]    CZ-7043
    [Documentation]    Verify user is able to Bulk upload BOM items
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOT
    AND Click On Bulk Upload
    AND Bulk Upload For Parts And Tools    BOT_BULK_UPLOAD.csv
    Sleep    3s
    THEN Verify Toast Message    Operation is Successful    BOT uploaded successfully

Verify that user is able to Add single BOT on Bill Of Tools screen
    [Tags]    CZ-7249    CZ-7039    CZ-7047    sanity
    [Documentation]    Verify that user is able to Add single BOT on Bill Of Tools screen
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOT
    AND Verify the UI for BOM/BOT/COM    BOT
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    BOT
    AND User adds details for BOM/BOT/COM    BOT    Image1_JPG.jpg
    AND User submits a BOI
    AND Verify The BOI
    THEN Delete A BOI

Verify that user is able to associate component with BOM entry by clicking on Add button
    [Tags]    CZ-7251    CZ-7250     A
    [Documentation]    Verify that user is able to associate component with BOM entry by clicking on Add button.
    [Setup]    Login Again As Site Admin
    When User Creates a COM
    AND User Navigate to the Particular Parts Page    BOT
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    BOT
    AND User adds details for BOM/BOT/COM    BOT    Image1_JPG.jpg
    AND Associate COM to BOT
    AND User submits a BOI
    THEN Verify The BOI

Verify th functionality of Cancel button on Add New (BOT) page
    [Tags]    CZ-7252    sanity
    [Documentation]     Verify th functionality of Cancel button on Add New (BOT) page.
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOT
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    BOT
    AND User adds details for BOM/BOT/COM    BOT
    AND User cancels a BOM
    THEN Verify The BOM is Not Created

Verify th functionality of Cancel button on Add New (COM) page
    [Tags]    CZ-7254
    [Documentation]     Verify th functionality of Cancel button on Add New (COM) page.
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    COM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    COM
    AND User adds details for BOM/BOT/COM    COM
    AND User cancels a BOM
    THEN Verify The BOM is Not Created

Verify search functionality on BOT page
    [Tags]    CZ-7045    sanity
    [Documentation]    Verify search functionality on BOT page.
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOT
    AND Navigate to Add BOM/BOT/COM Page
    AND User adds details for BOM/BOT/COM    BOT    Image1_JPG.jpg
    AND User submits a BOI
    AND Search a BOM    ${TD_BOI_NAME}
    AND Search a BOM    ${TD_BOI_FIXTURE_NAME}
    AND Search a BOM    ${TD_BOI_DESCRIPTION}
    THEN Verify The BOI

Verify that user is able to Add single COM on Components screen
    [Tags]    CZ-7258
    [Documentation]    Verify that user is able to Add single COM on Components screen
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    COM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    COM
    AND User verifies ADD COM fields
    AND User submits a BOI
    THEN Verify Toast Message    COM    A COM requires a supply chain number before creating.

Verify that Created Tools Not Visible Across the Sites
    [Tags]    CZ-7488
    [Documentation]    Verify that Created Tools Not Visible Across the Sites
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    COM
    AND Verify the UI for BOM/BOT/COM    COM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    COM
    AND User adds details for BOM/BOT/COM    COM    Image1_JPG.jpg
    AND User submits a BOI
    AND Verify The BOI
    And Logout from Mentor
    And Login To Application    ${SiteAdminSite2}    ${SiteAdminSite2Pass}
    And User Navigate to the Particular Parts Page    COM
    Then Verify Tool Should Not Be Visible      ${TD_BOI_NAME}

Verify that Created Tools Not Visible Across the Org
    [Tags]    CZ-7489    sanity
    [Documentation]    Verify that Created Tools Not Visible Across the Org
    [Setup]    Login Again As Site Admin
    When User Navigate to the Particular Parts Page    BOM
    AND Verify the UI for BOM/BOT/COM    BOM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    BOM
    AND User adds details for BOM/BOT/COM    BOM    Image1_JPG.jpg
    AND User submits a BOI
    AND Verify The BOI
    And Logout from Mentor
    And Login To Application    ${SiteAdmin}    ${SiteAdminPass}
    And User Navigate to the Particular Parts Page    BOM
    Then Verify Tool Should Not Be Visible      ${TD_BOI_NAME}