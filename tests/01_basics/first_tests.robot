*** Settings ***
Documentation    Your first Robot Framework tests — assertions, setup, teardown, and tags.
Library          String
Library          Collections

Suite Setup      Log    Starting the basics test suite
Suite Teardown   Log    Basics suite complete


*** Test Cases ***
String Equality Check
    [Documentation]    Verify two strings are equal
    [Tags]    smoke    regression
    ${greeting}=    Set Variable    Hello, Robot Framework!
    Should Be Equal    ${greeting}    Hello, Robot Framework!

Integer Arithmetic
    [Documentation]    Basic math operations with type conversion
    [Tags]    smoke    regression
    ${result}=    Evaluate    5 + 3
    Should Be Equal As Integers    ${result}    8

    ${product}=    Evaluate    7 * 6
    Should Be Equal As Integers    ${product}    42

Boolean Assertions
    [Documentation]    True/false checks
    [Tags]    regression
    ${flag}=    Set Variable    ${TRUE}
    Should Be True    ${flag}

    ${zero}=    Set Variable    ${0}
    Should Not Be True    ${zero}

String Contains Check
    [Documentation]    Verify substrings exist in a string
    [Tags]    smoke    regression
    ${message}=    Set Variable    Robot Framework is powerful and flexible
    Should Contain    ${message}    powerful
    Should Not Contain    ${message}    fragile

List Operations
    [Documentation]    Create and validate list contents
    [Tags]    regression
    @{fruits}=    Create List    apple    banana    cherry
    Length Should Be    ${fruits}    3
    Should Contain    ${fruits}    banana
    List Should Not Contain Value    ${fruits}    grape

Dictionary Operations
    [Documentation]    Create and validate dictionary contents
    [Tags]    regression
    &{user}=    Create Dictionary    name=Steve    role=engineer    active=true
    Dictionary Should Contain Key    ${user}    name
    Should Be Equal    ${user}[name]    Steve
    Dictionary Should Not Contain Key    ${user}    password

Test With Setup And Teardown
    [Documentation]    Demonstrate per-test setup and teardown
    [Tags]    regression
    [Setup]    Log    Setting up this specific test
    Log    Running the actual test logic
    Should Be True    ${TRUE}
    [Teardown]    Log    Cleaning up after this test

Negative Test - Expected Failure
    [Documentation]    Verify that invalid operations are caught
    [Tags]    negative    regression
    ${status}=    Run Keyword And Return Status
    ...    Should Be Equal    apples    oranges
    Should Not Be True    ${status}

String Manipulation
    [Documentation]    Built-in string operations
    [Tags]    regression
    ${upper}=    Convert To Upper Case    hello world
    Should Be Equal    ${upper}    HELLO WORLD

    ${replaced}=    Replace String    Hello World    World    Robot
    Should Be Equal    ${replaced}    Hello Robot

Type Conversion
    [Documentation]    Converting between types
    [Tags]    regression
    ${str_num}=    Set Variable    42
    ${int_num}=    Convert To Integer    ${str_num}
    Should Be Equal As Integers    ${int_num}    42

    ${float_num}=    Convert To Number    3.14
    Should Be True    ${float_num} > 3.0
    Should Be True    ${float_num} < 4.0
