*** Settings ***
Documentation    Creating and using custom keywords — the core of Robot Framework reusability.
Library          String
Library          Collections
Resource         ../../resources/common.resource


*** Variables ***
${ADMIN_ROLE}    admin
${USER_ROLE}     user


*** Keywords ***
Create User Dict
    [Documentation]    Build a user dictionary with required fields
    [Arguments]    ${name}    ${email}    ${role}=${USER_ROLE}
    &{user}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    role=${role}
    ...    active=${TRUE}
    RETURN    ${user}

Validate User Has Required Fields
    [Documentation]    Assert that a user dict contains all expected keys
    [Arguments]    ${user}
    Dictionary Should Contain Key    ${user}    name
    Dictionary Should Contain Key    ${user}    email
    Dictionary Should Contain Key    ${user}    role
    Dictionary Should Contain Key    ${user}    active

User Should Have Role
    [Documentation]    Verify user has the expected role
    [Arguments]    ${user}    ${expected_role}
    Should Be Equal    ${user}[role]    ${expected_role}

Generate Email
    [Documentation]    Create an email from a name (lowercase, dots)
    [Arguments]    ${name}
    ${lower}=    Convert To Lower Case    ${name}
    ${email}=    Replace String    ${lower}    ${SPACE}    .
    ${email}=    Set Variable    ${email}@example.com
    RETURN    ${email}

Create Multiple Users
    [Documentation]    Create a list of user dicts from name list
    [Arguments]    @{names}
    @{users}=    Create List
    FOR    ${name}    IN    @{names}
        ${email}=    Generate Email    ${name}
        ${user}=    Create User Dict    ${name}    ${email}
        Append To List    ${users}    ${user}
    END
    RETURN    ${users}

Log User Summary
    [Documentation]    Log a formatted summary of a user
    [Arguments]    ${user}
    Log    User: ${user}[name] (${user}[email]) - Role: ${user}[role] - Active: ${user}[active]


*** Test Cases ***
Create And Validate A User
    [Documentation]    Basic keyword composition
    [Tags]    smoke    regression
    ${user}=    Create User Dict    Steve    steve@example.com
    Validate User Has Required Fields    ${user}
    User Should Have Role    ${user}    user
    Should Be Equal    ${user}[name]    Steve

Create An Admin User
    [Documentation]    Use optional arguments to override defaults
    [Tags]    smoke    regression
    ${admin}=    Create User Dict    Admin User    admin@example.com    role=${ADMIN_ROLE}
    Validate User Has Required Fields    ${admin}
    User Should Have Role    ${admin}    admin

Generate Email From Name
    [Documentation]    Test the email generation keyword
    [Tags]    regression
    ${email}=    Generate Email    John Smith
    Should Be Equal    ${email}    john.smith@example.com

    ${email2}=    Generate Email    Alice
    Should Be Equal    ${email2}    alice@example.com

Create Batch Of Users
    [Documentation]    Keywords that return collections
    [Tags]    regression
    ${users}=    Create Multiple Users    Alice    Bob    Charlie
    Length Should Be    ${users}    3
    ${first}=    Get From List    ${users}    0
    Should Be Equal    ${first}[name]    Alice
    Should Be Equal    ${first}[email]    alice@example.com

Use Keywords From Resource File
    [Documentation]    Use shared keywords defined in common.resource
    [Tags]    smoke    regression
    ${timestamp}=    Get Current Timestamp
    Should Not Be Empty    ${timestamp}
    Log    Timestamp: ${timestamp}

    ${safe}=    Sanitize String    Hello <script>alert('xss')</script> World
    Should Not Contain    ${safe}    <script>

Keyword With Logging
    [Documentation]    Keywords can log for debugging
    [Tags]    regression
    ${user}=    Create User Dict    Debug User    debug@example.com
    Log User Summary    ${user}
    Validate User Has Required Fields    ${user}

Embedded Arguments In Keyword Names
    [Documentation]    Robot Framework supports embedded arguments in keyword names
    [Tags]    regression
    User "Steve" should have email "steve@example.com"
    User "Alice" should have email "alice@example.com"


*** Keywords ***
User "${name}" should have email "${expected_email}"
    [Documentation]    Embedded argument keyword — reads like natural language
    ${email}=    Generate Email    ${name}
    Should Be Equal    ${email}    ${expected_email}
