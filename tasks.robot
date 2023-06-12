*** Settings ***
Documentation       Robot to solve the first challenge at rpachallenge.com,
...                 which consists of filling a form that randomly rearranges
...                 itself for ten times, with data taken from a provided
...                 Microsoft Excel file.

Library             RPA.Browser.Selenium
Library             RPA.Excel.Files
Library             RPA.HTTP


*** Tasks ***
Complete the challenge
    Start the challenge
    Fill the forms
    Collect the results


*** Keywords ***
Start the challenge
    Open Available Browser    http://rpachallenge.com/    headless=${True}
    Download
    ...    https://rpachallenge.com/assets/downloadFiles/challenge.xlsx
    ...    overwrite=True
    Click Button    Start
    # Click Button    xpath:/html/body/app-root/div[2]/app-rpa1/div/div[1]/div[6]/button

Fill the forms
    ${people}=    Get the list of people from the Excel file
    FOR    ${person}    IN    @{people}
        FIll and submit the form    ${person}
    END

Get the list of people from the Excel file
    Open Workbook    challenge.xlsx
    ${table}=    Read Worksheet As Table    header=True
    Close Workbook
    RETURN    ${table}

FIll and submit the form
    [Arguments]    ${person}
    Input Text    css:input[ng-reflect-name="labelFirstName"]    ${person}[First Name]
    Input Text    css:input[ng-reflect-name="labelLastName"]    ${person}[Last Name]
    Input Text    css:input[ng-reflect-name="labelCompanyName"]    ${person}[Company Name]
    Input Text    css:input[ng-reflect-name="labelRole"]    ${person}[Role in Company]
    Input Text    css:input[ng-reflect-name="labelAddress"]    ${person}[Address]
    Input Text    css:input[ng-reflect-name="labelEmail"]    ${person}[Email]
    Input Text    css:input[ng-reflect-name="labelPhone"]    ${person}[Phone Number]
    Click Button    Submit

Set value by xpath
    [Arguments]    ${xpath}    ${value}
    ${result}=
    ...    Execute Javascript
    ...    document.evaluate('${xpath}',document.body,null,9,null).singleNodeValue.value='$(value)';
    ...    RETURN    ${result}

Collect the results
    Capture Element Screenshot    css:div.congratulations
