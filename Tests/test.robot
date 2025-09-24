*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/loginVariable.py
Variables    ../Variables/customerVariable.py
Library    ../Library/CustomerLibrary.py

*** Variables ***
${url}    https://marmelab.com/react-admin-demo/#/login

*** Test Cases ***
Test-0001
    [Documentation]    Test application
    Launch Browser    ${url}
    Wait Until Element Is Visible    ${usernameField}    10s
    Login    ${username}    ${password}
    Go To Create Customer
    Create User 
    Sleep    15s

*** Keywords ***
Launch Browser
    [Arguments]    ${loginPageUrl}
    Open Browser    ${loginPageUrl}    chrome

Login
    [Arguments]    ${usernameInput}    ${passwordInput}
    Input Text    ${usernameField}   ${usernameInput}
    Input Text    ${passwordField}    ${passwordInput}
    Click Button   ${sign_in_btn}

Go To Create Customer
    Click Element    ${navigate_to_customer}
    Wait Until Element Is Visible    ${create_customer_link}    10s
    Click Element    ${create_customer_link}

Go To Customer Page 
    Click Element    ${navigate_to_customer}
    Wait Until Element Is Visible    ${create_customer_link}    10s

Create User 
    ${users}    Get Users
    FOR    ${user}    IN    @{users}
        ${birthday}    Generate Birthday
        ${street}=    Set Variable    ${user['address']['street']}
        ${city}=    Set Variable    ${user['address']['city']}
        ${full_address}=    Set Variable    ${city} ${street}
        ${state}=    Set Variable    New York
        ${password}=    Set Variable    12345678
        Wait Until Element Is Visible    ${first_name_field}    10s
        Input Text    ${first_name_field}    ${user['name'].split(" ")[0]}
        Input Text    ${last_name_field}    ${user['name'].split(" ")[1]}
        Input Text    ${email_field}    ${user['email']}
        Input Text    ${birthday_field}   ${birthday}    
        Input Text    ${address_field}    ${full_address}
        Input Text    ${city_field}    ${city}
        Input Text    ${state_field}    ${state}
        Input Text    ${zip_code_field}    ${user['address']['zipcode']}
        Input Text    ${password_field}    ${password}
        Input Text    ${confirm_password_field}    ${password}
        Click Button    ${submit_btn}
        Sleep    2s
        #Go To Create Customer
        Verify User Added    ${user}
    END
   
Verify User Added
    [Arguments]    ${user}
    Go To Customer Page

    # Wait for the table to update after form submit
    Wait Until Element Is Not Visible    (//table//tbody//tr)[1]//td//div[(contains(@class, 'MuiAvatar-colorDefault') and text()) or img]

    # Then wait for the new user's avatar/text to appear
    Wait Until Element Is Visible        (//table//tbody//tr)[1]//td//div[contains(@class, 'MuiAvatar-colorDefault') and text() or img]

    # Get the full name from the second cell of the first row
    ${fetched_name}=    Get Text    ((//table//tbody//tr)[1]//td)[2]
    Log To Console    UI fetched name: ${fetched_name}

    Should Be Equal As Strings    ${fetched_name}    ${user['name']}

