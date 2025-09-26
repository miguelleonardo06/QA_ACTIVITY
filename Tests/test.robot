*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/loginVariable.py
Variables    ../Variables/customerVariable.py
Library    ../Library/CustomerLibrary.py

*** Variables ***
${url}    https://marmelab.com/react-admin-demo/#/login
${first_name_field_value}=    None
${last_name_field_value}=    None
${email_field_value}=    None
${city_field_value}=    None
${zipcode_field_value}=    None

*** Test Cases ***
Test-0001
    [Documentation]    Add First 5 User
    Launch Browser    ${url}
    Wait Until Element Is Visible    ${usernameField}    10s
    Login    ${username}    ${password}
    Go To Create Customer
    Create User 

Test-0002
    [Documentation]   Verify Table Display
    Go To Customer Page
    Sleep    2s
    Check User Appear In Table

Test-0003
    [Documentation]   Update table row
    ${last_five_user}=    Last_Five_Users

    Update Last Five Customer    ${last_five_user}

Test-0004
      [Documentation]     Print All users in table
      Go To Customer Page
      Print All User In Table

*** Keywords ***
Launch Browser
    [Arguments]    ${loginPageUrl}
    Open Browser    ${loginPageUrl}    chrome

Login
    [Arguments]    ${usernameInput}    ${passwordInput}
    Wait Until Element Is Visible    ${usernameField}    5s
    Input Text    ${usernameField}   ${usernameInput}
    Input Text    ${passwordField}    ${passwordInput}
    Click Button   ${sign_in_btn}

Go To Customer Page
   Click Element    ${navigate_to_customer}
   Sleep    2s

Go To Create Customer
    Click Element    ${navigate_to_customer}
    Wait Until Element Is Visible    ${create_customer_link}    10s
    Click Element    ${create_customer_link}

Create User 
    ${users}    Get Users
    FOR    ${user}    IN    @{users}
        ${birthday}    Generate Birthday
        ${street}=    Set Variable    ${user['address']['street']}
        ${city}=    Set Variable    ${user['address']['city']}
        ${full_address}=    Set Variable    ${city} ${street}
        ${state}=    Set Variable    New York
        ${password}=    Set Variable    113137162535
        Wait Until Element Is Visible    ${first_name_field}    10s
        Input Text    ${first_name_field}    ${user['name'].split(" ")[0]}
        ${first_name_field_value}=   Get Element Attribute    ${first_name_field}    value

        Input Text    ${last_name_field}    ${user['name'].split(" ")[1]}
        ${last_name_field_value}=   Get Element Attribute    ${last_name_field}    value

        Input Text    ${email_field}    ${user['email']}
        ${email_field_value}=   Get Element Attribute    ${email_field}    value

        Input Text    ${birthday_field}   ${birthday}
        Input Text    ${address_field}    ${full_address}

        Input Text    ${city_field}    ${city}
        ${city_field_value}=    Get Element Attribute    ${city_field}    value

        Input Text    ${state_field}    ${state}

        Input Text    ${zip_code_field}    ${user['address']['zipcode']}
        ${zipcode_field_value}     Get Element Attribute    ${zip_code_field}    value
        
        Input Text    ${password_field}    ${password}
        Input Text    ${confirm_password_field}    ${password}

        Verify User Added    ${user}    ${first_name_field_value}    ${last_name_field_value}    ${email_field_value}    ${city_field_value}    ${zipcode_field_value}
        Click Button    ${submit_btn}

        Sleep    1s

        Go To Create Customer

    END
   
Verify User Added
    [Arguments]    ${user}    ${first_name_field_value}    ${last_name_field_value}    ${email_field_value}    ${city_field_value}    ${zipcode_field_value}
    ${full_name}=    Set Variable    ${first_name_field_value} ${last_name_field_value}

    Should Be Equal    ${user['name']}    ${full_name}
    Should Be Equal    ${user['email']}    ${email_field_value}
    Should Be Equal    ${user['address']['city']}    ${city_field_value}
    Should Be Equal    ${user['address']['zipcode']}    ${zipcode_field_value}
    Log To Console    NAME_VALUE_IS: ${full_name}
    Log To Console    EMAIL:${email_field_value}
    Log To Console    CITY: ${city_field_value}
    Log To Console    ZIP_CODE: ${zipcode_field_value}


Check User Appear In Table
    # Wait until the image avatar disappears (if used as a placeholder)
    Wait Until Element Is Not Visible    xpath=(//table//tbody//tr)[1]//td//div/img    15s
    # Wait until the real avatar with text appears
    Wait Until Element Is Visible    xpath=(//table//tbody//tr)[1]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]    15s

    ${users}=    Get Users

    FOR    ${row}    IN RANGE    1    6    # 1 to 5 inclusive
        ${user_index}=    Evaluate    5 - ${row}    # 4,3,2,1,0
        ${user}=    Set Variable    ${users}[${user_index}]
        
        Click Element    xpath=(//table//tbody//tr)[${row}]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]
        Wait Until Element Is Visible    ${first_name_field}    5s
        ${first_name_field_value}=    Get Element Attribute    ${first_name_field}    value
        Should Be Equal    ${first_name_field_value}    ${user['name'].split(" ")[0]}
        Log To Console    FIRST_NAME: ${first_name_field_value}

        ${last_name_field_value}=    Get Element Attribute    ${last_name_field}    value
        Should Be Equal    ${last_name_field_value}    ${user['name'].split(" ")[1]}
        Log To Console    LAST_NAME: ${last_name_field_value}

        ${email_field_value}=    Get Element Attribute    ${email_field}    value
        Should Be Equal    ${email_field_value}    ${user['email']}
        Log To Console    Email: ${email_field_value}

        ${city_field_value}=    Get Element Attribute    ${city_field}    value
        Should Be Equal    ${city_field_value}    ${user['address']['city']}
        Log To Console    City: ${city_field_value}

        ${zipcode_field_value}=    Get Element Attribute    ${zip_code_field}    value
        Should Be Equal    ${zipcode_field_value}    ${user['address']['zipcode']}
        Log To Console    Zipcode: ${zipcode_field_value}
        
        Go To Customer Page
    END

Update Last Five Customer
    [Arguments]    ${last_five_user}

    FOR    ${offset}    IN RANGE    0    5
        ${row}=          Evaluate    ${offset} + 6
        ${user_index}=   Set Variable    ${offset}
        ${user}=         Set Variable    ${last_five_user}[${user_index}]

        ${street}=    Set Variable    ${user['address']['street']}
        ${city}=    Set Variable    ${user['address']['city']}
        ${full_address}=    Set Variable    ${city} ${street}
        ${state}=    Set Variable    New York
        ${birthday}    Generate Birthday

        Sleep    2s

        Click Element                    xpath=(//table//tbody//tr)[${row}]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]

        Wait Until Element Is Visible    ${first_name_field}

        Press Keys    ${first_name_field}    CTRL+a    BACKSPACE
        Input Text                       ${first_name_field}    ${user['name'].split(" ")[0]}

        Press Keys    ${last_name_field}    CTRL+a    BACKSPACE
        Input Text                       ${last_name_field}     ${user['name'].split(" ")[1]}

        Input Text    ${birthday_field}    ${birthday}

        Press Keys    ${email_field}    CTRL+a    BACKSPACE
        Input Text    ${email_field}         ${user['email']}       

        Press Keys    ${address_field}    CTRL+a    BACKSPACE
        Input Text    ${address_field}       ${full_address}

        Press Keys    ${city_field}    CTRL+a    BACKSPACE
        Input Text    ${city_field}          ${user['address']['city']}

        Press Keys    ${state_field}    CTRL+a    BACKSPACE
        Input Text    ${state_field}    ${state}

        Press Keys    ${zip_code_field}    CTRL+a    BACKSPACE
        Input Text    ${zip_code_field}      ${user['address']['zipcode']}

        Click Button    ${submit_btn}

       Sleep    1s

    END

Print All User In Table
     Wait Until Element Is Visible    xpath=//table//tbody//tr

      ${row_count}=    Get Element Count    xpath=//table//tbody/tr

        FOR    ${row_index}    IN RANGE    1    ${row_count + 1}
        Log To Console    ===== User ${row_index} =====

        ${name}=               Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[1]
        ${last_seen}=          Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[2]
        ${orders}=             Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[3]
        ${total_spent}=        Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[4]
        ${latest_purchase}=    Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[5]
        ${news}=               Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[6]
        ${segment}=            Get Text    xpath=(//table//tbody/tr)[${row_index}]/td[7]

        Log To Console    Name: ${name}
        Log To Console    Last Seen: ${last_seen}
        Log To Console    Orders: ${orders}
        Log To Console    Total Spent: $${total_spent}
        Log To Console    Latest Purchase: ${latest_purchase}
        Log To Console    News: ${news}
        Log To Console    Segment: ${segment}
    END
    








    
    
