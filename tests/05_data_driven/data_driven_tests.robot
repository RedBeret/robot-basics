*** Settings ***
Documentation    Data-driven testing with templates — run the same test logic
...              with multiple sets of input data.
Library          String
Library          Collections


*** Test Cases ***
Addition Should Work Correctly
    [Documentation]    Template test: verify addition with multiple inputs
    [Tags]    regression
    [Template]    Verify Addition
    1      1      2
    10     20     30
    -5     5      0
    0      0      0
    100    -100   0
    999    1      1000

String Concatenation
    [Documentation]    Template test: verify string joining
    [Tags]    regression
    [Template]    Verify String Join
    Hello      World      Hello World
    Robot      Framework  Robot Framework
    ${EMPTY}   Test       Test

Status Code Descriptions
    [Documentation]    Template test: map HTTP status codes to descriptions
    [Tags]    regression    api
    [Template]    Verify Status Description
    200    OK
    201    Created
    204    No Content
    400    Bad Request
    404    Not Found
    500    Internal Server Error

Email Validation
    [Documentation]    Template test: validate email format patterns
    [Tags]    regression
    [Template]    Email Should Be Valid
    user@example.com
    test.user@domain.org
    name+tag@company.co

Invalid Email Detection
    [Documentation]    Template test: reject invalid email formats
    [Tags]    regression    negative
    [Template]    Email Should Be Invalid
    plaintext
    @nodomain.com
    user@


*** Keywords ***
Verify Addition
    [Arguments]    ${a}    ${b}    ${expected}
    ${result}=    Evaluate    ${a} + ${b}
    Should Be Equal As Integers    ${result}    ${expected}

Verify String Join
    [Arguments]    ${first}    ${second}    ${expected}
    ${result}=    Catenate    SEPARATOR=${SPACE}    ${first}    ${second}
    # Strip leading/trailing spaces for the empty string case
    ${result}=    Strip String    ${result}
    Should Be Equal    ${result}    ${expected}

Verify Status Description
    [Arguments]    ${code}    ${description}
    &{status_map}=    Create Dictionary
    ...    200=OK
    ...    201=Created
    ...    204=No Content
    ...    400=Bad Request
    ...    404=Not Found
    ...    500=Internal Server Error
    Dictionary Should Contain Key    ${status_map}    ${code}
    Should Be Equal    ${status_map}[${code}]    ${description}

Email Should Be Valid
    [Arguments]    ${email}
    Should Match Regexp    ${email}    ^[\\w.+-]+@[\\w-]+\\.[\\w.-]+$

Email Should Be Invalid
    [Arguments]    ${email}
    ${status}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${email}    ^[\\w.+-]+@[\\w-]+\\.[\\w.-]+$
    Should Not Be True    ${status}    msg=${email} should not be a valid email
