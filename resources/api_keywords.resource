*** Settings ***
Documentation    Reusable keywords for API testing.
Library          RequestsLibrary
Library          Collections


*** Keywords ***
Validate User Response Structure
    [Documentation]    Verify a user object from JSONPlaceholder has all expected fields
    [Arguments]    ${user}
    Dictionary Should Contain Key    ${user}    id
    Dictionary Should Contain Key    ${user}    name
    Dictionary Should Contain Key    ${user}    username
    Dictionary Should Contain Key    ${user}    email
    Dictionary Should Contain Key    ${user}    phone
    Dictionary Should Contain Key    ${user}    website
    Dictionary Should Contain Key    ${user}    address
    Dictionary Should Contain Key    ${user}    company

Validate Post Response Structure
    [Documentation]    Verify a post object has all expected fields
    [Arguments]    ${post}
    Dictionary Should Contain Key    ${post}    userId
    Dictionary Should Contain Key    ${post}    id
    Dictionary Should Contain Key    ${post}    title
    Dictionary Should Contain Key    ${post}    body
    Should Not Be Empty    ${post}[title]
    Should Not Be Empty    ${post}[body]

Response Status Should Be OK
    [Documentation]    Shorthand: verify response is 200
    [Arguments]    ${response}
    Status Should Be    200    ${response}

Response Should Be JSON
    [Documentation]    Verify response content type is JSON
    [Arguments]    ${response}
    Should Contain    ${response.headers}[Content-Type]    application/json
