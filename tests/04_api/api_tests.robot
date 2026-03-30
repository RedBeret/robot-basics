*** Settings ***
Documentation    REST API testing fundamentals using RequestsLibrary
...              against the public JSONPlaceholder API.
Library          RequestsLibrary
Library          Collections
Resource         ../../resources/api_keywords.resource

Suite Setup      Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com
Suite Teardown   Delete All Sessions


*** Test Cases ***
GET All Posts
    [Documentation]    Fetch a list of posts and validate structure
    [Tags]    smoke    api    regression
    ${response}=    GET On Session    jsonplaceholder    /posts
    Status Should Be    200    ${response}
    ${posts}=    Set Variable    ${response.json()}
    Length Should Be    ${posts}    100
    # Validate first post structure
    Dictionary Should Contain Key    ${posts}[0]    userId
    Dictionary Should Contain Key    ${posts}[0]    id
    Dictionary Should Contain Key    ${posts}[0]    title
    Dictionary Should Contain Key    ${posts}[0]    body

GET Single Post By ID
    [Documentation]    Fetch a specific post and validate content
    [Tags]    smoke    api    regression
    ${response}=    GET On Session    jsonplaceholder    /posts/1
    Status Should Be    200    ${response}
    ${post}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${post}[id]    1
    Should Be Equal As Integers    ${post}[userId]    1
    Should Not Be Empty    ${post}[title]

GET Post That Does Not Exist
    [Documentation]    Verify 404 for a nonexistent resource
    [Tags]    negative    api    regression
    ${response}=    GET On Session    jsonplaceholder    /posts/99999    expected_status=404
    Status Should Be    404    ${response}

GET Posts With Query Parameters
    [Documentation]    Filter posts by userId using query params
    [Tags]    api    regression
    ${params}=    Create Dictionary    userId=1
    ${response}=    GET On Session    jsonplaceholder    /posts    params=${params}
    Status Should Be    200    ${response}
    ${posts}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${posts}
    FOR    ${post}    IN    @{posts}
        Should Be Equal As Integers    ${post}[userId]    1
    END

POST Create A New Post
    [Documentation]    Create a resource via POST and validate response
    [Tags]    api    regression
    ${body}=    Create Dictionary
    ...    title=Robot Framework Test Post
    ...    body=This post was created by an automated test.
    ...    userId=${1}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    jsonplaceholder    /posts
    ...    json=${body}    headers=${headers}
    Status Should Be    201    ${response}
    ${created}=    Set Variable    ${response.json()}
    Should Be Equal    ${created}[title]    Robot Framework Test Post
    Should Be Equal As Integers    ${created}[userId]    1
    # JSONPlaceholder returns id 101 for new posts
    Should Be Equal As Integers    ${created}[id]    101

PUT Update An Existing Post
    [Documentation]    Replace a resource via PUT
    [Tags]    api    regression
    ${body}=    Create Dictionary
    ...    id=${1}
    ...    title=Updated Title
    ...    body=Updated body content.
    ...    userId=${1}
    ${response}=    PUT On Session    jsonplaceholder    /posts/1    json=${body}
    Status Should Be    200    ${response}
    ${updated}=    Set Variable    ${response.json()}
    Should Be Equal    ${updated}[title]    Updated Title

PATCH Partial Update
    [Documentation]    Partially update a resource via PATCH
    [Tags]    api    regression
    ${body}=    Create Dictionary    title=Patched Title Only
    ${response}=    PATCH On Session    jsonplaceholder    /posts/1    json=${body}
    Status Should Be    200    ${response}
    ${patched}=    Set Variable    ${response.json()}
    Should Be Equal    ${patched}[title]    Patched Title Only

DELETE A Post
    [Documentation]    Delete a resource and verify response
    [Tags]    api    regression
    ${response}=    DELETE On Session    jsonplaceholder    /posts/1
    Status Should Be    200    ${response}

GET Comments For A Post
    [Documentation]    Test nested resource endpoint
    [Tags]    api    regression
    ${response}=    GET On Session    jsonplaceholder    /posts/1/comments
    Status Should Be    200    ${response}
    ${comments}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${comments}
    # All comments should reference post 1
    FOR    ${comment}    IN    @{comments}
        Should Be Equal As Integers    ${comment}[postId]    1
        Dictionary Should Contain Key    ${comment}    email
        Dictionary Should Contain Key    ${comment}    body
    END

GET Users List
    [Documentation]    Fetch users and validate structure using shared keyword
    [Tags]    api    regression
    ${response}=    GET On Session    jsonplaceholder    /users
    Status Should Be    200    ${response}
    ${users}=    Set Variable    ${response.json()}
    Length Should Be    ${users}    10
    Validate User Response Structure    ${users}[0]

Response Headers Are Present
    [Documentation]    Verify expected headers exist in API response
    [Tags]    api    regression
    ${response}=    GET On Session    jsonplaceholder    /posts/1
    Dictionary Should Contain Key    ${response.headers}    Content-Type
    Should Contain    ${response.headers}[Content-Type]    application/json
