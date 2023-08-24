*** Settings ***
Documentation     Executes Google image search and stores the first image result.

Library           OperatingSystem
Library           RPA.Browser.Selenium

Suite Teardown    Close All Browsers


*** Variables ***
${GOOGLE_URL}     https://google.com/?hl=en
${SEARCH_TERM}    cute monkey picture


*** Keywords ***
Reject Google Cookies
    Click Element If Visible    xpath://button/div[contains(text(), 'Reject all')]

Accept Google Consent
    Click Element If Visible    xpath://button/div[contains(text(), 'I agree')]

Close Google Sign in
    Click Element If Visible    No thanks

Open Google search page
    ${use_chrome} =    Get Environment Variable    USE_CHROME    ${EMPTY}
    IF    "${use_chrome}" != ""
        Open Available Browser    ${GOOGLE_URL}    browser_selection=Chrome
        ...    download=${True}  # forces Chrome and matching webdriver download
    ELSE
        Open Available Browser    ${GOOGLE_URL}  # just opens any available browser
    END
    Run Keyword And Ignore Error    Close Google Sign in
    Run Keyword And Ignore Error    Reject Google Cookies
    Run Keyword And Ignore Error    Accept Google Consent

Search for
    [Arguments]    ${text}
    Wait Until Page Contains Element    name:q
    Input Text    name:q    ${text}
    Press Keys    name:q    ENTER
    Wait Until Page Contains Element    search

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
        ${err_ss} =    Set Variable    ${OUTPUT_DIR}${/}error.png
        Capture Page Screenshot     ${err_ss}
        Fail    Checkout the screenshot: ${err_ss}
    END
