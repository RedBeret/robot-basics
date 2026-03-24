*** Settings ***
Documentation    Variable types, scoping, and dynamic assignment in Robot Framework.
Library          OperatingSystem
Library          Collections


*** Variables ***
# Scalar variables
${BASE_URL}          https://jsonplaceholder.typicode.com
${TIMEOUT}           30
${PROJECT_NAME}      Robot Basics

# List variable
@{VALID_STATUSES}    200    201    204

# Dictionary variable
&{DEFAULT_HEADERS}   Content-Type=application/json    Accept=application/json

# Constant-style naming (uppercase = suite-level constants)
${MAX_RETRIES}       3


*** Test Cases ***
Scalar Variables
    [Documentation]    Basic scalar variable usage
    [Tags]    smoke    regression
    Log    Project: ${PROJECT_NAME}
    Log    Base URL: ${BASE_URL}
    Should Be Equal    ${PROJECT_NAME}    Robot Basics
    Should Be Equal As Integers    ${TIMEOUT}    30

List Variables
    [Documentation]    Working with list variables
    [Tags]    regression
    Log Many    @{VALID_STATUSES}
    Length Should Be    ${VALID_STATUSES}    3

    # Access by index
    Should Be Equal    ${VALID_STATUSES}[0]    200
    Should Be Equal    ${VALID_STATUSES}[2]    204

    # Create and modify lists
    @{colors}=    Create List    red    green    blue
    Append To List    ${colors}    yellow
    Length Should Be    ${colors}    4

Dictionary Variables
    [Documentation]    Working with dictionary variables
    [Tags]    regression
    Log    Content-Type: ${DEFAULT_HEADERS}[Content-Type]
    Should Be Equal    ${DEFAULT_HEADERS}[Accept]    application/json

    # Create and modify dictionaries
    &{server}=    Create Dictionary    host=localhost    port=8080
    Set To Dictionary    ${server}    protocol=https
    Dictionary Should Contain Key    ${server}    protocol
    Should Be Equal    ${server}[protocol]    https

Variable Scoping - Local
    [Documentation]    Variables created in a test are local to that test
    [Tags]    regression
    ${local_var}=    Set Variable    I only exist here
    Should Be Equal    ${local_var}    I only exist here

Number Variables
    [Documentation]    Numeric variable types and operations
    [Tags]    regression
    ${int_val}=    Set Variable    ${42}
    ${float_val}=    Set Variable    ${3.14}

    Should Be Equal As Integers    ${int_val}    42
    Should Be Equal As Numbers    ${float_val}    3.14

    # Arithmetic in expressions
    ${sum}=    Evaluate    ${int_val} + 8
    Should Be Equal As Integers    ${sum}    50

Boolean Variables
    [Documentation]    Built-in boolean constants
    [Tags]    regression
    Should Be True    ${TRUE}
    Should Not Be True    ${FALSE}
    Should Be Equal    ${NONE}    ${NONE}

    # Boolean from expressions
    ${is_valid}=    Evaluate    10 > 5
    Should Be True    ${is_valid}

Environment Variables
    [Documentation]    Access system environment variables
    [Tags]    regression
    # HOME is available on macOS/Linux, USERPROFILE on Windows
    ${home}=    Get Environment Variable    HOME    default=/tmp
    Should Not Be Empty    ${home}
    Log    Home directory: ${home}

    # Handle missing env vars with defaults
    ${missing}=    Get Environment Variable    NONEXISTENT_VAR_12345    default=fallback_value
    Should Be Equal    ${missing}    fallback_value

Variable Assignment From Keywords
    [Documentation]    Capture keyword return values into variables
    [Tags]    regression
    ${timestamp}=    Get Time    epoch
    Should Be True    ${timestamp} > 0

    ${year}=    Get Time    year
    Should Not Be Empty    ${year}
    Log    Current year: ${year}

Inline Python Evaluation
    [Documentation]    Use ${{ }} syntax for inline Python expressions (RF 5+)
    [Tags]    regression
    ${result}=    Set Variable    ${{[x**2 for x in range(5)]}}
    Log    Squares: ${result}
    Length Should Be    ${result}    5
    Should Be Equal As Integers    ${result}[4]    16

    ${greeting}=    Set Variable    ${{ "hello".upper() }}
    Should Be Equal    ${greeting}    HELLO
