*** Settings ***
Documentation    Shared keywords and variables for the robot-basics project.
Library          DateTime
Library          String


*** Variables ***
${DEFAULT_TIMEOUT}    30s
${LOG_LEVEL}          INFO


*** Keywords ***
Get Current Timestamp
    [Documentation]    Return the current date/time as an ISO string
    ${now}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    RETURN    ${now}

Sanitize String
    [Documentation]    Remove HTML tags from a string (basic XSS prevention demo)
    [Arguments]    ${input}
    ${clean}=    Replace String Using Regexp    ${input}    <[^>]+>    ${EMPTY}
    RETURN    ${clean}

Should Be Valid Email
    [Documentation]    Basic email format validation
    [Arguments]    ${email}
    Should Match Regexp    ${email}    ^[\\w.+-]+@[\\w-]+\\.[\\w.-]+$

Log Step
    [Documentation]    Log a test step with formatting
    [Arguments]    ${step_number}    ${description}
    Log    Step ${step_number}: ${description}    level=${LOG_LEVEL}
