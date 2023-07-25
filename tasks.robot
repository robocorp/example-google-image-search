*** Settings ***
Documentation     Executes Google image search and stores the first result image.
Library           RPA.Browser.Selenium

*** Variables ***
${GOOGLE_URL}     https://google.com/?hl=en
${SEARCH_TERM}    cute cat picture

*** Keywords ***
Reject Google Cookies
    Click Element If Visible    xpath://button/div[contains(text(), 'Reject all')]

Accept Google Consent
    Click Element If Visible    xpath://button/div[contains(text(), 'I agree')]

Close Google Sign in
    Click Element If Visible    No thanks

*** Keywords ***
Open Google search page
    IF    %{USE_CHROME=''}
        Open Available Browser    ${GOOGLE_URL}    browser_selection=Chrome
        ...    download=${True}
    ELSE
        Open Available Browser    ${GOOGLE_URL}
    END
    Run Keyword And Ignore Error    Close Google Sign in
    Run Keyword And Ignore Error    Reject Google Cookies
    Run Keyword And Ignore Error    Accept Google Consent

*** Keywords ***
Search for
    [Arguments]    ${text}
    Wait Until Page Contains Element    name:q
    Input Text    name:q    ${text}
    Press Keys    name:q    ENTER
    Wait Until Page Contains Element    search

*** Keywords ***
Capture Image Result
    Click Link    Images
    Wait Until Page Contains Element   css:div[data-ri="0"]  2
    Capture Element Screenshot    css:div[data-ri="0"]

*** Tasks ***
Execute Google image search and store the first result image
    TRY
        Open Google search page
        Search for    ${SEARCH_TERM}
        Capture Image Result
    EXCEPT
        Capture Page Screenshot     %{ROBOT_ARTIFACTS}${/}error.png
        Fail    Checkout the screenshot: error.png
    END
    [Teardown]    Close Browser
