*** Settings ***
Library    SeleniumLibrary
Library     String
Library    Collections
Library    OperatingSystem
Library    BuiltIn
Library    CSVLibrary
Library    RequestsLibrary
Library    DateTime
Library   ../../../../../../src/utilities/Common-utils/csvLibrary.py
Library   ../../../../../../src/utilities/Common-utils/CommonUtils.py
Variables   ../../../../../locators/ui/web/Mentor/Common.yaml
Variables   ../../../../../locators/ui/web/Mentor/BOM_BOT.yaml
Variables   ../../../../../../config/Mentor/${env}_env.yaml
Resource    ../Common/Common.resource

*** Variables ***
${Upload_File_Path}         ${CURDIR}${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor
@{expected_BOM_headers_list}    Fixture/Gauge #    Image    Name    Description    Quantity    UoM    Created on    Actions
${DOWNLOAD_DIR}    ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}..${/}testdata${/}ui${/}web${/}Mentor${/}custom_downloads
${BROWSER}         Chrome
@{expected_export_download}    Fixture/Gauge #    Name    Image    Description    Quantity    UoM    Created on
@{expected_BOT_headers_list}    Tool #    Image    Tool Name    Description    Quantity    UoM    Created on    Actions
@{expected_COM_headers_list}    Manuf. Part #    Component Description    Additional Description    Created on    Actions

*** Keywords ***
BOM/BOT Teardown
    ${elapsed}=     Set Variable    0
    ${INTERVAL}=     Set Variable    0
    ${Max_tries}=    Set Variable    10
    WHILE    ${elapsed} < ${Max_tries}
        ${clickable}=    Run Keyword And Return Status    Click Element    ${User_profile}
        # Sleep    ${INTERVAL}
        ${elapsed}=    Evaluate    ${elapsed} + ${INTERVAL}
        Press Keys    None    ESC
        Run Keyword If    ${clickable}    Exit For Loop
    END
    Press Keys    None    ESC



User Navigate to the Particular Parts Page
    [Arguments]    ${BILL_OF_ITEM}=BOM
    [Documentation]    To User Navigate to the any Bill of item page (BOM/BOT/COM)
    IF    '${BILL_OF_ITEM}'=='BOM'
        ${BILL_OF_ITEM_OPTION}=    Replace String    ${PARTS_OPTION_BOM_BOT_COM}    replace    Bill of Materials
    ELSE IF    '${BILL_OF_ITEM}'=='BOT'
        ${BILL_OF_ITEM_OPTION}=    Replace String    ${PARTS_OPTION_BOM_BOT_COM}    replace    Bill of Tools
    ELSE
        ${BILL_OF_ITEM_OPTION}=    Replace String    ${PARTS_OPTION_BOM_BOT_COM}    replace    Components
    END
    Wait For The Page To Load
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    ${Max_limit}
    Wait Until Keyword Succeeds    10x    2s    Mouse Over    ${DASHBOARD_LINK}
    ${IF_PARTS_AND_TOOLS_OPTION_VISIBLE}=     Run Keyword And Return Status    Wait Until Element Is Visible    ${PARTS_AND_TOOLS_OPTION}    5s
    IF    '${IF_PARTS_AND_TOOLS_OPTION_VISIBLE}'=='True'
        Wait Until Element Is Visible    ${BILL_OF_ITEM_OPTION}    ${Max_limit}
        Click Element    ${BILL_OF_ITEM_OPTION}
    ELSE
        Wait Until Element Is Visible    ${ADMINISTRATION_OPTION}    ${Max_limit}
        Click Element    ${ADMINISTRATION_OPTION}
        Wait Until Element Is Visible    ${PARTS_AND_TOOLS_OPTION}    ${Max_limit}
        Click Element    ${PARTS_AND_TOOLS_OPTION}
        Wait Until Element Is Visible    ${BILL_OF_ITEM_OPTION}    ${Max_limit}
        Click Element    ${BILL_OF_ITEM_OPTION}
    END
    wait for the page to load

Click On Bulk Upload
    Wait Until Element Is Visible    ${bulk_upload_button}    timeout=10s
    Click Element    ${bulk_upload_button}

Click On File Upload Button
    Wait Until Element Is Visible    ${upload_csv_file}    timeout=10s
    Click Element    ${upload_csv_file}

Upload The File In BOM BOT
    [Arguments]     ${FileName}
    Wait Until Element Is Enabled    ${BOM_BOT_Attachment_File_Input}     ${MaxTime}
    ${Normalize_Path_Upload_Pdf}    Normalize Path    ${Upload_File_Path}${/}${FileName}
    Choose File    ${BOM_BOT_Attachment_File_Input}    ${Normalize_Path_Upload_Pdf}

Bulk Upload For Parts And Tools
    [Arguments]    ${filename}
    Upload The File In BOM BOT    ${filename}
    Wait Until Element Is Visible    ${PREVIEW_FILE_UPLOAD}    timeout=10s
    Wait Until Element Is Visible    ${FILE_CLOSE_BUTTON}    timeout=10s
    Wait Until Element Is Visible    ${UPLOAD_BUTTON}    timeout=10s
    Click Element    ${UPLOAD_BUTTON}

Bulk Upload For BOT
    Upload The File In BOM BOT    BOM_BULK_UPLOAD.csv
    Wait Until Element Is Visible    ${PREVIEW_FILE_UPLOAD}    timeout=10s
    Wait Until Element Is Visible    ${FILE_CLOSE_BUTTON}    timeout=10s
    Wait Until Element Is Visible    ${UPLOAD_BUTTON}    timeout=10s
    Click Element    ${UPLOAD_BUTTON}
    Verify Toast Message    Operation is in progress    BOM upload in progress
    Verify Toast Message    Operation is Successful    BOM uploaded successfully

Verify Toast Message
    [Arguments]    ${verification_title}    ${verification_message}
    Wait Until Element Is Visible    ${ToasterMessage}    ${MaxTime}
    ${title}=    Get Text    ${toastTitle}
    Should Be Equal    ${title}    ${verification_title}
    ${message}=    Get Text    ${toastMessage}
    Should Be Equal    ${message}    ${verification_message}
    Capture Page Screenshot

Generate Unique Number
    ${UniqueNumbertest}=    Generate Random String
    Set Global Variable     ${UniqueNumbertest}

User cancels a BOM
    Wait Until Element Is Visible    ${BOM_CANCEL_BUTTON}
    Click Element    ${BOM_CANCEL_BUTTON}

User submits a BOI
    Wait Until Element Is Visible    ${BOM_CREATE_BUTTON}
    Click Element    ${BOM_CREATE_BUTTON}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${arrowBack}     ${MaxTime}

User adds details for BOM/BOT/COM
    [Arguments]    ${BILL_OF_ITEM}    ${FILE_NAME}=NO_FILE
    Generate Unique Number
    Validate The Mandatory Fields In BOM
    IF    '${BILL_OF_ITEM}'=='BOM'
        ${GENERATED_BOI_NAME}=    Set Variable    BOM-${UniqueNumbertest}
        ${GENERATED_BOI_DESCRIPTION}=    Set Variable    This is a BOM
    ELSE IF    '${BILL_OF_ITEM}'=='BOT'
        ${GENERATED_BOI_NAME}=    Set Variable    BOT-${UniqueNumbertest}
        ${GENERATED_BOI_DESCRIPTION}=    Set Variable    This is a BOT
    ELSE
        ${GENERATED_BOI_NAME}=    Set Variable    COM-${UniqueNumbertest}
        ${GENERATED_BOI_DESCRIPTION}=    Set Variable    This is a COM
    END
    Input Text    ${BOM_NAME_INPUT}    ${GENERATED_BOI_NAME}
    Wait Until Element Is Visible    ${BOM_FIXTURE_INPUT}
    Input Text    ${BOM_FIXTURE_INPUT}    FIXTURE-${UniqueNumbertest}
    # Scroll Element Into View    ${BOM_DESCRIPTION_INPUT}
    Wait Until Element Is Visible    ${BOM_DESCRIPTION_INPUT}
    Input Text    ${BOM_DESCRIPTION_INPUT}    ${GENERATED_BOI_DESCRIPTION}
    Run Keyword If    '${FILE_NAME}'!='NO_FILE'  Upload The File In BOM BOT    ${FILE_NAME}
    Wait Until Element Is Visible    ${BOM_SIZE_INPUT}
#    IF    '${BILL_OF_ITEM}'!='COM'
#        Input Text    ${BOM_SIZE_INPUT}    Abc
#        ${Size_value}=    Get Element Attribute    ${BOM_SIZE_INPUT}    value
#        Should Be Empty    ${Size_value}
#    END
    Input Text    ${BOM_SIZE_INPUT}    123
    ${Size_value}=    Get Element Attribute    ${BOM_SIZE_INPUT}    value
    Should Not Be Empty    ${Size_value}

    ${TD_BOI_NAME}=    Set Variable    ${GENERATED_BOI_NAME}
    ${TD_BOI_FIXTURE_NAME}=    Set Variable    FIXTURE-${UniqueNumbertest}
    ${TD_BOI_DESCRIPTION}=    Set Variable    ${GENERATED_BOI_DESCRIPTION}
    Set Test Variable    ${TD_BOI_NAME}
    Set Test Variable    ${TD_BOI_FIXTURE_NAME}
    Set Test Variable    ${TD_BOI_DESCRIPTION}
    Add Item To List In BOI    ITEM=${TD_BOI_NAME}   VAR_NAME=PARTS_AND_TOOLS_LIST

Add Item To List In BOI
    [Documentation]    To Add Item To List
    [Arguments]    ${ITEM}=${TD_BOI_NAME}   ${VAR_NAME}=BOI_LIST
     ${list}=    Get Variable Value    ${${VAR_NAME}}
     TRY
         IF    '${list}'=='None'
             ${list}=    Create List
         END
     EXCEPT
         Log    List Already Created
     END
    Append To List    ${list}    ${ITEM}
    Set Test Variable    ${${VAR_NAME}}    ${list}

Validate The Mandatory Fields In BOM
    Wait Until Element Is Visible    ${BOM_NAME_INPUT}
    Scroll Element Into View    ${BOM_DESCRIPTION_INPUT}
    Wait Until Element Is Visible    ${BOM_DESCRIPTION_INPUT}
    Click Element    ${BOM_NAME_INPUT}
    Click Element    ${BOM_DESCRIPTION_INPUT}
    ${Error}=    Get Text    ${NAME_ERROR}
    Should Be Equal    ${Error}    Name is required
    
Verify The BOI
    ${BOMTitle}=    Replace String   ${BOMNameInTable}  replace    ${TD_BOI_NAME}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${BOM_Search_box}
    Input Text   ${BOM_Search_box}    ${TD_BOI_NAME}
    Wait Until Element Is Visible     ${BOMTitle}   ${MaxTime}

Verify The BOM is Not Created
    ${BOMTitle}=    Replace String   ${BOMNameInTable}  replace    ${TD_BOI_NAME}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${BOM_Search_box}
    Input Text   ${BOM_Search_box}    ${TD_BOI_NAME}
    Wait Until Element Is Not Visible     ${BOMTitle}   ${MaxTime}

Delete A BOI
    ${LOCATOR}=    Replace String    ${BOM_Delete_button}    replace    ${TD_BOI_NAME}
    Wait Until Keyword Succeeds    10x    1s    Click Element    ${LOCATOR}
    Wait Until Element Is Visible    ${BOM_Confirm_delete_button}
    Click Element    ${BOM_Confirm_delete_button}

Navigate to Add BOM/BOT/COM Page
    Wait Until Element Is Visible    ${ADD_BOM_BUTTON}
    Click Element    ${ADD_BOM_BUTTON}

User verifies the ADD BOM/BOT/COM UI
    [Arguments]    ${BILL_OF_ITEM}
    IF    '${BILL_OF_ITEM}'=='BOM'
        Wait Until Element Is Visible    ${BOM_TYPE_INPUT}    timeout=10s
        ${BILL_OF_ITEM_BREADCRUMB}=    Replace String    ${PARTS_AND_TOOLS_BREADCRUMB}    replace    BOM
    ELSE IF    '${BILL_OF_ITEM}'=='BOT'
        Wait Until Element Is Visible    ${BOM_TYPE_INPUT}    timeout=10s
        ${BILL_OF_ITEM_BREADCRUMB}=    Replace String    ${PARTS_AND_TOOLS_BREADCRUMB}    replace    Tools
    ELSE
        # ${BILL_OF_ITEM_HEADER}=    Replace String    ${BOM_BOT_COM_HEADER}    replace    Components
        ${BILL_OF_ITEM_BREADCRUMB}=    Replace String    ${PARTS_AND_TOOLS_BREADCRUMB}    replace    COM
    END
    Wait Until Element Is Visible    ${BOM_NAME_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_SIZE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_DESCRIPTION_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BOM_FIXTURE_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${BILL_OF_ITEM_BREADCRUMB}    timeout=10s
    Wait Until Element Is Visible    ${BOM_UNIT_INPUT}    timeout=10s

Search a BOM
    [Arguments]    ${bom_search_text}
    ${BOMTitle}=    Replace String   ${BOMNameInTable}  replace    ${bom_search_text}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${BOM_Search_box}
    Input Text   ${BOM_Search_box}    ${bom_search_text}
    Wait Until Element Is Visible     ${BOMTitle}   timeout=20s

Verify the UI for BOM/BOT/COM
    [Arguments]    ${BILL_OF_ITEM}
    IF    '${BILL_OF_ITEM}'=='BOM'
        ${BILL_OF_ITEM_HEADER}=    Replace String    ${BOM_BOT_COM_HEADER}    replace    Bill of Materials
        ${expected_headers_list}=    Set Variable    @{expected_BOM_headers_list}
    ELSE IF    '${BILL_OF_ITEM}'=='BOT'
        ${BILL_OF_ITEM_HEADER}=    Replace String    ${BOM_BOT_COM_HEADER}    replace    Bill of Tools
        ${expected_headers_list}=    Set Variable    @{expected_BOT_headers_list}
    ELSE
        ${BILL_OF_ITEM_HEADER}=    Replace String    ${BOM_BOT_COM_HEADER}    replace    Components
        ${expected_headers_list}=    Set Variable    @{expected_COM_headers_list}
    END
    Wait Until Element Is Visible    ${BILL_OF_ITEM_HEADER}    timeout=10s
    Wait Until Element Is Visible    ${BOM_Search_box}    timeout=10s
    Wait Until Element Is Visible    ${ADD_BOM_BUTTON}    timeout=10s
    @{headerWebElements}=    Get Webelements    ${BOM_list_table_header}
    @{listOfBOIHeader}=    Create List
    FOR    ${i}    IN    @{headerWebElements}
        ${header_text}=    Get Text    ${i}
        Append To List    ${listOfBOIHeader}    ${header_text}
    END
    Log    ${listOfBOIHeader}
#    Lists Should Be Equal    ${expected_headers_list}    ${listOfBOIHeader}
    Wait Until Element Is Visible     ${BOM_Pagination}    timeout=10s
    Wait Until Element Is Visible    ${BOM_table}
    Wait Until Element Is Visible     ${BOM_pagination_range}    ${MaxTime}
    Wait Until Element Is Visible    ${bulk_upload_button}    ${MaxTime}

Add BOM/BOT in New Procedure
    [Arguments]    ${PART}
    When User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details Without Co-Author
    And User adds PPE to the procedure
    And User Add Step To Procedure
    And Add Parts&Tools To Step in BOM/BOT page    ${PART}
    And User Publishes the Procedure
    And User Adds Release Notes
    And Verify that the Procedure is saved 

Add BOM to Step
    Wait For The Element And Click    ${PARTS_TOOLS_TAB}
    Wait For The Element And Click    ${STEP_BOM_TAB}
    Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
    Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
    Search and verify a BOM in Procedures Page    ${TD_BOI_DESCRIPTION}
    Search and verify a BOM in Procedures Page    ${TD_BOI_NAME}
    # Wait Until Element Is Visible    ${Searched_BOM}
    Click Element    ${Searched_BOM}
    Click Element    ${ADD_PARTS&TOOLS_TO_STEP}

Add Parts&Tools To Step in BOM/BOT page
      [Documentation]    To Add Parts&Tools To Step in BOM/BOT page
      [Arguments]    ${BILL_OF_ITEM}
      Wait For The Element And Click    ${PARTS_TOOLS_TAB}
      IF    '${BILL_OF_ITEM}'=='BOM'
            Wait For The Element And Click    ${STEP_BOM_TAB}
            Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
            Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
            Search and verify a BOM in Procedures Page    ${TD_BOI_DESCRIPTION}
            Search and verify a BOM in Procedures Page    ${TD_BOI_NAME}
            # Wait Until Element Is Visible    ${Searched_BOM}
            Click Element    ${Searched_BOM}
            Click Element    ${ADD_PARTS&TOOLS_TO_STEP}
      ELSE IF    '${BILL_OF_ITEM}'=='BOT'
            Wait For The Element And Click    ${STEP_BOT_TAB}
            Repeat Keyword    3x    Press Keys    None    ARROW_DOWN
            Wait For The Element And Click    ${STEP_TOOLS_ADD_NEW_BUTTON}
            Search and verify a BOM in Procedures Page    ${TD_BOI_DESCRIPTION}
            Search and verify a BOM in Procedures Page    ${TD_BOI_NAME}
            # Wait Until Element Is Visible    ${Searched_BOM}
            Click Element    ${Searched_BOM}
            Click Element    ${ADD_PARTS&TOOLS_TO_STEP}
      END


Download Sample CSV
    Wait Until Element Is Visible    ${sample_file_download}    timeout=10s
    Click Element    ${sample_file_download}

Verify CSV Headers
   [Arguments]    ${csv_path}
   [Documentation]    Verifies that the CSV file contains the expected headers.
   ${file_content}=    OperatingSystem.Get File    ${csv_path}
   ${lines}=           String.Split String    ${file_content}    \n
   ${headers_line}=    Collections.Get From List    ${lines}    0
   ${headers}=         String.Split String    ${headers_line}    ,
   ${headers}=         Evaluate    [h.strip() for h in ${headers}]
   ${EXPECTED_HEADERS}=    Create List
   ...    supplyChainNumber
   ...    name
   ...    description
   ...    quantity
   ...    unit
   ...    image
   ...    col1
   ...    col2
   ...    col3
   Collections.Lists Should Be Equal    ${headers}    ${EXPECTED_HEADERS}
 

Get Latest CSV From Downloads
   ${user_profile}=    Get Environment Variable    USERPROFILE
   ${downloads_dir}=   OperatingSystem.Join Path    ${user_profile}    Downloads
   ${files}=           OperatingSystem.List Files In Directory    ${downloads_dir}    pattern=*.csv
   Run Keyword If    ${files} == []    Fail    No CSV files found in Downloads folder.
   ${latest_file}=    Evaluate    max(${files}, key=lambda f: __import__('os').path.getmtime(__import__('os').path.join(r'''${downloads_dir}''', f)))
   ${latest_path}=    OperatingSystem.Join Path    ${downloads_dir}    ${latest_file}
   RETURN    ${latest_path}

Verify CSV Flow
    ${csv_path}=    Get Latest CSV From Downloads   
    Verify CSV Headers    ${csv_path}

Verify Add BOM Page
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LoadingBar}    ${MaxTime}
    Wait Until Element Is Visible    ${add_bom}          #timeout=10s
    Wait Until Element Is Visible    ${search_bar_field}          #timeout=10s
    Wait Until Element Is Visible    ${close_icon}          #timeout=10s
    Page Should Contain Element   ${code_checkbox}          
    Page Should Contain Element    ${add_bom_headers}        #timeout=10s
    Page Should Contain Element    ${next_page}              #timeout=10s
    Page Should Contain Element    ${rows_per_page}          #timeout=10s
    Page Should Contain Element    ${pagination_dropdown}    #timeout=10s
    Page Should Contain Element    ${add_button_parts}             #timeout=10s
    Page Should Contain Element    ${cancel_button}             #timeout=10s

Pop-up window closes upon clicking the cross icon.        
    Click Element    ${close_icon}
    Element Should Not Be Visible    ${add_bom}
 

Select Some Checkboxes and Click Cancel
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
    ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
    @{BOM_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_BOM_TO_STEP}    2    ${MAX_LIMIT}
    Wait Until Element Is Visible    ${cancel_button_bom}    timeout=10s
    Wait Until Element Is Enabled    ${cancel_button_bom}    timeout=10s
    Wait Until Keyword Succeeds    5x    1s    Click Element By JS    ${cancel_button_bom}
    Page Should Contain    records added in the steps will be shown here.

Select Some Checkboxes and Close
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${All_TOOLS_RECORD}
    ${MAX_LIMIT}=    Get Element Count      ${CHECKBOX_COUNT}
    ${MAX_LIMIT}=    Evaluate    ${MAX_LIMIT} + 1
    @{BOM_ADDED_TO_STEP}=    Get Values In List For Validation    ${ADDED_BOM_TO_STEP}    2    ${MAX_LIMIT}
    Wait Until Element Is Visible    ${ADD_PARTS&TOOLS_TO_STEP}    timeout=10s
    Wait Until Element Is Enabled    ${ADD_PARTS&TOOLS_TO_STEP}    timeout=10s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ADD_PARTS&TOOLS_TO_STEP}

Verify The Pagination on Add BOM Page
    Select The Page Size    ${JOB_LIST_PAGE_SIZE_SELECT}
    ${count}=   Get Current Record Count On Page    ${INSIDE_RECORDS_COUNT}
    IF    ${count} < ${PAGE_SIZE}
        Element Should Be Disabled    ${INSIDE_PAGINATION_NEXT_PAGE}
    ELSE
         ${NO_OF_PAGES}=    Evaluate     math.ceil(${count} / int(${PAGE_SIZE}))    math
        FOR    ${i}    IN RANGE    1    ${NO_OF_PAGES}+1
            Exit For Loop If    ${i}==${NO_OF_PAGES}
            Wait Until Element Is Enabled    ${INSIDE_PAGINATION_NEXT_PAGE}    ${Max_limit}
            Scroll Dialog Until Element Clickable    ${INSIDE_PAGINATION_NEXT_PAGE}
            Click Element       ${INSIDE_PAGINATION_NEXT_PAGE}
            Wait For The Page To Load
        END
        Element Should Be Disabled    ${INSIDE_PAGINATION_NEXT_PAGE}
    END
    ${prev_stat}=    Run Keyword And Return Status    Element Should Be Enabled    ${add_bom_previous_page}
    IF    ${prev_stat}
        Click Element    ${add_bom_previous_page}
    END
    

Navigate To BOM In General Details And Verify BOM
    Navigate To BOM In General Details
    Verify BOM/BOT in General Details    ${BOM_ADDED_TO_STEP}   

Navigate To BOM In General Details     
    Wait Until Element Is Visible    ${general_details_button}    timeout=10s
    Click Element    ${general_details_button}
    Wait Until Element Is Visible    ${bom_section}    
    Click Element    ${bom_section}   

Navigate To BOT In General Details     
    Wait Until Element Is Visible    ${general_details_button}    timeout=10s
    Click Element    ${general_details_button}
    Wait Until Element Is Visible    ${bot_section}    
    Wait For The Element And Click    ${bot_section}

Verify BOM/BOT in General Details
    [Arguments]    ${VALIDATION_LIST}
    FOR    ${ITEM}    IN     @{VALIDATION_LIST}
        Wait Until Page Contains   ${ITEM}
    END     

Navigate To BOT In General Details And Verify BOT
    Navigate To BOT In General Details
    Verify BOM/BOT in General Details    ${BOT_ADDED_TO_STEP}       

Click on any of the code for added BOMs and Verify
    Wait Until Keyword Succeeds    5x    1s    Wait Until Element Is Visible    ${first_bom_entry}    ${Max_limit}
    Click Element    ${first_bom_entry}
    Wait Until Element Is Visible    ${bom_name_detail}    timeout=10s
    Wait Until Element Is Visible    ${bom_quantity}    timeout=10s
    Wait Until Element Is Visible    ${bom_uom}    timeout=10s
    Wait Until Element Is Visible    ${bom_description}    timeout=10s
    Wait Until Element Is Visible    ${bom_image}    timeout=10s
    Wait Until Element Is Visible    ${bom_done}    timeout=10s
    Wait Until Element Is Visible    ${bom_close}    timeout=10s
    Click Element    ${bom_close}

Create Download Directory
    Remove Directory    ${DOWNLOAD_DIR}    recursive=True    # Clean up previous downloads if necessary
    Create Directory    ${DOWNLOAD_DIR}

Open Browser With Custom Download Directory
    [Arguments]    ${url}
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${DOWN_DIR}    Normalize Path    ${DOWNLOAD_DIR}
    ${prefs}=    Create Dictionary    download.default_directory=${DOWN_DIR}    download.prompt_for_download=False    directory_upgrade=True
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    # Call Method    ${chrome_options}    add_experimental_option    detach    ${TRUE}
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    window-size\=1920,1080
    Call Method    ${chrome_options}   add_argument    --no-sandbox
    Call Method    ${chrome_options}   add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}  add_argument  --disable-notifications
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    SeleniumLibrary.Open Browser     ${Url}         chrome         options=${chrome_options}
    # Maximize Browser Window
    Go To    ${url}

Download Sample Files
    Wait Until Element Is Visible    ${sample_file_download}
    Click Element    ${sample_file_download}
    Click Element    ${upload_file_close_button}

Verify custom files exists
    [Arguments]    ${file_name_start}    ${extension}    ${file_headers}=
    ${DOWN_DIR}    Normalize Path    ${DOWNLOAD_DIR}
    @{files}=    List Files In Directory    ${DOWN_DIR}
    ${matched_file_name}=    Evaluate    next((f for f in ${files} if f.startswith('${file_name_start}') and f.endswith('${extension}')), '')
    Should Not Be Empty    ${matched_file_name}    Error: No file found matching the criteria "${file_name_start}*.${extension}"
    ${full_file_path}=    Join Path    ${DOWN_DIR}    ${matched_file_name}
    ${csv_headers}    Get CSV Headers    ${full_file_path}
    Log    ${csv_headers}
    # IF    '${file_headers}'='OPTIONAL' Should Be Equal    ${csv_headers}    ${file_headers}
    Run Keyword If    ${file_headers}!=''  Should Be Equal    ${csv_headers}    ${file_headers}

Verify the count in files
    [Arguments]    ${file_name_start}    ${extension}    ${No_of_entries}
    [Documentation]    dont include the headers also in the no of entries
    ${DOWN_DIR}    Normalize Path    ${DOWNLOAD_DIR}
    @{files}=    List Files In Directory    ${DOWN_DIR}
    ${matched_file_name}=    Evaluate    next((f for f in ${files} if f.startswith('${file_name_start}') and f.endswith('${extension}')), '')
    Should Not Be Empty    ${matched_file_name}    Error: No file found matching the criteria "${file_name_start}*.${extension}"
    ${full_file_path}=    Join Path    ${DOWN_DIR}    ${matched_file_name}
    ${file_length}    Csv Length    ${full_file_path}
    ${data_count}=    Convert To Integer    ${file_length}
    ${data_count}=    Evaluate    ${file_length} - 1
    Should Be Equal    '${data_count}'    '${No_of_entries}'

Verify export of BOM for custom No Of BOM
    [Arguments]    ${no_of_bom}
    [Documentation]    Specify the No of BOM's to be created and exported
    FOR    ${counter}    IN RANGE    0    ${no_of_bom}
        Navigate to Add BOM/BOT/COM Page
        User adds details for BOM/BOT/COM    BOM    Image1_JPG.jpg
        User submits a BOI
        Verify The BOI  
    END
    Clear Element Text    ${BOM_Search_box}
    Press Keys    ${BOM_Search_box}    ENTER
    Wait Until Element Is Visible    ${bom_export_button}
    Element Should Be Disabled    ${bom_export_button}
    ${end_range}=    Convert To Integer    ${no_of_bom}
    ${end_range}=    Evaluate    ${end_range} + 2
    FOR    ${counter}    IN RANGE    2    ${end_range}
          ${counter_str}=    Convert To String    ${counter}
          ${LOCATOR}=    Replace String   ${BOM_CHECKBOX}  INDEX    ${counter_str}
          Select Checkbox    ${LOCATOR}
    END
    Wait Until Element Is Visible    ${bom_export_button}
    Element Should Be Enabled    ${bom_export_button}
    Click Element    ${bom_export_button}
    AND Verify custom files exists    BOM    .csv    ${expected_export_download}
    AND Verify the count in files    BOM    .csv    ${no_of_bom}

Verify export for all BOM
    Create Download Directory
    ${LOCATOR}=    Replace String   ${BOM_CHECKBOX}  INDEX    1
    Select Checkbox    ${LOCATOR}
    Wait Until Element Is Visible    ${bom_export_button}
    Element Should Be Enabled    ${bom_export_button}
    Click Element    ${bom_export_button}
    ${text}=    Get Text    ${BOM_Header}
    ${matches} =    Get Regexp Matches    ${text}    \\d+
    ${bom_number_str} =    Set Variable    ${matches}[0]
    ${bom_number_int} =    Convert To Integer    ${bom_number_str}
    AND Verify custom files exists    BOM    .csv    ${expected_export_download}
    AND Verify the count in files    BOM    .csv    ${bom_number_int}

Create Procedure For BOM/BOT Jobs
    When Navigate to Procedures page
    And User Clicks on Add Button On Procedures List Page
    And User Lands on Add New Procedure Page
    And User Adds General Details Without Co-Author
    And User Add Step To Procedure
    And Add Parts&Tools To Step    BOM
    And Add Parts&Tools To Step    BOT
    And User Publishes the Procedure
    And User Adds Release Notes

Create Sample Job For Verifying BOM/BOT
    [Arguments]    ${CUSTOM_MATERIAL_NUMBER}=False    ${CUSTOM_SERIAL_NUMBER}=False
    Wait Until Element Is Not Visible    ${LoadingBar}   ${MaxTime}
    Wait Until Element Is Visible    ${AddJob}   ${MaxTime}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${AddJob}
    Wait Until Element Is Visible    ${INPUT_JOB_ID}   ${MaxTime}
    IF    '${CUSTOM_SERIAL_NUMBER}'!='False'
        Input Text    ${INPUT_JOB_ID}    ${CUSTOM_SERIAL_NUMBER}
    ELSE
        ${TD_SERIAL_NUMBER}=    Generate Random String
        Set Test Variable    ${TD_SERIAL_NUMBER}
        Input Text    ${INPUT_JOB_ID}    ${TD_SERIAL_NUMBER}
    END
    Wait Until Element Is Visible    ${MaterialNo}   ${MaxTime}
    IF    '${CUSTOM_MATERIAL_NUMBER}'!='False'
        Input Text    ${MaterialNo}    ${CUSTOM_MATERIAL_NUMBER}
    ELSE
        Input Text    ${MaterialNo}    ${TD_MATERIAL_NUMBER}
    END
    #Click Element    ${DoneButton}
    Wait Until Element Is Visible    ${JobName}    ${maxTime}
    Input Text    ${JobName}    ${TestJobName}

Verify Pagination in BOM page of Job orders
    Scroll Element Into View    ${BOM_PAGE_SIZE_SELECT} 
    Verify The Pagination On Custom Page    ${BOM_PAGE_SIZE_SELECT}    ${BOM_RECORD_COUNT}    ${PAGINATION_NEXT_PAGE}

Navigate to Parts and Tools Page in Job Execution 
    Wait Until Element Is Visible    ${select_parts_and_tools_in_job_execution}    timeout=10s
    Click Element    ${select_parts_and_tools_in_job_execution}

Verify BOM/BOT in Job Execution Page
    [Arguments]    ${BILL_OF_ITEM}
      IF    '${BILL_OF_ITEM}'=='BOM'
          Wait For The Element And Click    ${bom_in_job_execution}
          Wait Until Element Is Visible    ${ALL_BOM_ADDED_IN_JOB}
          ${MAX_LIMIT}=    Get Element Count    ${ALL_BOM_ADDED_IN_JOB}
          @{BILL_OF_MATERIAL_IN_JOB}=    Get Values In List For Validation    ${BOM_ADDED_IN_JOB}    1    ${MAX_LIMIT}
          ${BILL_OF_MATERIAL_IN_JOB}=    Evaluate    [val[:15] for val in @{BILL_OF_MATERIAL_IN_JOB} ]
          Lists Should Be Equal    ${BOM_ADDED_TO_STEP}    ${BILL_OF_MATERIAL_IN_JOB}
          Get First BOM Item Data
          Validate The BOM Details In Modal
      ELSE IF    '${BILL_OF_ITEM}'=='BOT'
          Wait For The Element And Click    ${bot_in_job_execution}
          Wait Until Element Is Visible    ${ALL_BOT_ADDED_IN_JOB}
          ${MAX_LIMIT}=    Get Element Count    ${ALL_BOT_ADDED_IN_JOB}
          @{BILL_OF_TOOLS_IN_JOB}=    Get Values In List For Validation    ${BOT_ADDED_IN_JOB}    1    ${MAX_LIMIT}
          ${BILL_OF_TOOLS_IN_JOB}=    Evaluate    [val[:15] for val in @{BILL_OF_TOOLS_IN_JOB} ]
          Lists Should Be Equal    ${BOT_ADDED_TO_STEP}    ${BILL_OF_TOOLS_IN_JOB}
          Get First BOT Item Data
          Validate The BOT Details In Modal
      END



Verify the Pagination For BOM/BOT on Job Execution Page
    Verify The Pagination On Custom Page    ${JOB_LIST_PAGE_SIZE_SELECT}    ${BOM_RECORD_COUNT}    ${PAGINATION_NEXT_PAGE}

Verify Pagination of BOM/BOT in procedure library
    Verify The Pagination On Custom Page    ${BOM_PAGE_SIZE_SELECT}    ${BOM_RECORD_COUNT}    ${PAGINATION_NEXT_PAGE}            

Click Close Icon On BOM/BOT in Job Execution
    Wait Until Element Is Visible    ${close_icon}          timeout=10s
    Click Element    ${close_icon}

User Creates a COM
    User Navigate to the Particular Parts Page    COM
    AND Navigate to Add BOM/BOT/COM Page
    AND User verifies the ADD BOM/BOT/COM UI    COM
    AND User adds details for BOM/BOT/COM    COM    Image1_JPG.jpg
    AND User submits a BOI
    AND Verify The BOI

Associate COM to BOT
    Wait Until Element Is Visible    ${ADD_COM_BUTTON}
    Click Element    ${ADD_COM_BUTTON}
    Wait Until Element Is Visible    ${BOM_Search_bar}
    Click Element    ${BOM_Search_bar}
    ${COM}=    Get From List    ${PARTS_AND_TOOLS_LIST}    0
    Input Text    ${BOM_Search_bar}    ${COM}
    ${LOCATOR}=    Replace String   ${BOM_CHECKBOX}  INDEX    2
    Select Checkbox    ${LOCATOR}
    Wait Until Element Is Visible    ${DONE_COM_BUTTON}
    Click Element    ${DONE_COM_BUTTON}

Login As Site Admin into Application
    [Arguments]     ${UserEmail}    ${UserPassword}
    Wait Until Element Is Visible    ${EmailField}   ${MaxTime}
    Verify Base Sign In Page     ${UserEmail}
    Click On Sign In
    Verify Main Sign In page   ${UserEmail}    ${UserPassword}
    Verify User Is Able To Navigate To Home Page

User verifies ADD COM fields
    Validate The Mandatory Fields In BOM
    Generate Unique Number
    Wait Until Element Is Visible    ${BOM_NAME_INPUT}
    Click Element    ${BOM_NAME_INPUT}
    Press Keys    ${BOM_NAME_INPUT}    SPACE
    Wait Until Element Is Visible    ${BOM_DESCRIPTION_INPUT}
    Click Element    ${BOM_DESCRIPTION_INPUT}
    Sleep    2s
    ${Error}=    Get Text    ${NAME_ERROR}
    Should Be Equal    ${Error}    Spaces are not allowed.
    Input Text    ${BOM_NAME_INPUT}    COM-${UniqueNumbertest}
    Click Element    ${BOM_FIXTURE_INPUT}
    Press Keys    ${BOM_FIXTURE_INPUT}    SPACE
    Wait Until Element Is Visible    ${BOM_NAME_INPUT}
    Click Element    ${BOM_NAME_INPUT}
    Sleep    2s
    ${Error}=    Get Text    ${NAME_ERROR}
    Should Be Equal    ${Error}    Spaces are not allowed.

    Verify the wrong image type    BOT_BULK_UPLOAD.csv

Verify the wrong image type
    [Arguments]    ${wrong_type_file}
    Upload The File In BOM BOT    ${wrong_type_file}
    ${actual_message} =  Handle Alert   ACCEPT
    Log    ${actual_message}
    Should Contain    ${actual_message}    Invalid file types

Verify Tool Should Not Be Visible
    [Arguments]    ${bom_search_text}
    ${BOMTitle}=    Replace String   ${BOMNameInTable}  replace    ${bom_search_text}
    Wait Until Keyword Succeeds    10s    2s    Click Element   ${BOM_Search_box}
    Input Text   ${BOM_Search_box}    ${bom_search_text}
    Sleep    2s
    Wait Until Element Is Visible     //td[contains(text(),"record")]   timeout=20s
    Capture Page Screenshot
    