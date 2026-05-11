*** Settings ***
Library    SeleniumLibrary
Resource   ../Login/Login.resource
Variables   ../../../../../locators/ui/web/Mentor/Folder.yaml
Variables   ../../../config/Mentor/${env}_env.yaml

*** Keywords ***
Click on Create New Folder Icon
    Click Element    ${newFolderIcon}
    Wait Until Element Is Visible    ${folderNameField}     ${MaxTime}

Enter The Name For The Folder
    [Arguments]   ${FolderName}
    Set Global Variable    ${FolderName}
    Input Text    ${folderNameField}    ${FolderName}

Enter The Description
    [Arguments]     ${FolderDescription}
    Input Text    ${folderDescriptionField}    ${FolderDescription}

Click On Create
    Click Element    ${folderDialogAdd}

Verify Folder Is Successfully Created
    ${newFolder}   Replace String ${createdFolder}   replace     ${FolderName}
    Element Should Be Visible    ${newFolder}
    
Open The Folder
    [Arguments]     ${FolderName}
    ${newFolder}   Replace String ${createdFolder}   replace     ${FolderName}
    Click Element    ${newFolder}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${LoadingBar}      ${MaxTime}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${arrowBack}     ${MaxTime}

Select the Folder
    [Arguments]     ${FolderName}
    ${newFolder}   Replace String ${createdFolder}   replace     ${FolderName}
    Click Element    ${newFolder}

Click on Rename Icon
    Click Element    ${renameIcon}
    Wait Until Element Is Visible    ${folderDialogAdd}     ${MaxTime}

Update the Name and Description of Folder
    Click Element    ${folderNameField}
    Press Keys    None    Ctrl+A+BACKSPACE
    Enter The Name For The Folder     ${updatedName}
    Click Element    ${folderDescriptionField}
    Press Keys    None    Ctrl+A+BACKSPACE
    Enter The Description     ${updatedDesc}

Verify That Folder Details Are Updated
    ${modifiedFolder}   Replace String ${createdFolder}   replace     ${updatedName}
    Element Should Be Visible    ${modifiedFolder}

Click on Move Icon
    Wait Until Element Is Visible    ${moveIcon}      ${MaxTime}
    Click Element    ${moveIcon}
    
Click on Done
    Click Element    locator
    

Verify Folder should Be Visible To User