*** Settings ***
Library    SeleniumLibrary
Suite Setup       Abrir navegador
Test Setup        Dado que o usuario acessa a tela de login
Suite Teardown    E fecha o navegador

*** Variables ***
${URL}            %{LOGIN_URL=http://localhost:8080/login.html}
${BROWSER}        %{BROWSER=edge}
${EMAIL_VALIDO}   joao@email.com
${SENHA_VALIDA}   senha123
${EMAIL_INVALIDO}             joaoemail.com
${EMAIL_NAO_CADASTRADO}       naoexiste@email.com
${SENHA_INVALIDA}             senhaerrada
${EMAIL_EM_BRANCO}            ${SPACE}${SPACE}${SPACE}

${INPUT_EMAIL}    id=email
${INPUT_SENHA}    id=senha
${BOTAO_LOGIN}    id=btnLogin
${MENSAGEM}       id=mensagem

*** Test Cases ***
WEB CT01 - Deve Validar Email Em Formato Invalido
    Dado que o usuario informa o email    ${EMAIL_INVALIDO}
    E informa a senha                     ${SENHA_VALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Email invalido

WEB CT02 - Deve Validar Email Nao Cadastrado
    Dado que o usuario informa o email    ${EMAIL_NAO_CADASTRADO}
    E informa a senha                     ${SENHA_VALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Credenciais invalidas

WEB CT03 - Deve Realizar Login Com Sucesso
    Dado que o usuario informa o email    ${EMAIL_VALIDO}
    E informa a senha                     ${SENHA_VALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Login realizado com sucesso

WEB CT04 - Deve Validar Senha Incorreta
    Dado que o usuario informa o email    ${EMAIL_VALIDO}
    E informa a senha                     ${SENHA_INVALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Credenciais invalidas

WEB CT05 - Deve Validar Email Vazio
    Dado que o usuario informa o email    ${EMPTY}
    E informa a senha                     ${SENHA_VALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Email invalido

WEB CT06 - Deve Validar Senha Vazia
    Dado que o usuario informa o email    ${EMAIL_VALIDO}
    E informa a senha                     ${EMPTY}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Credenciais invalidas

WEB CT07 - Deve Validar Email E Senha Vazios
    Dado que o usuario informa o email    ${EMPTY}
    E informa a senha                     ${EMPTY}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Email invalido

WEB CT08 - Deve Validar Email Em Branco
    Dado que o usuario informa o email    ${EMAIL_EM_BRANCO}
    E informa a senha                     ${SENHA_VALIDA}
    Quando solicitar o login
    Entao o sistema deve apresentar a mensagem    Email invalido

*** Keywords ***
Abrir navegador
    Open Browser    about:blank    ${BROWSER}
    Maximize Browser Window

Dado que o usuario acessa a tela de login
    Go To    ${URL}
    Wait Until Page Contains Element    ${INPUT_EMAIL}
    Wait Until Page Contains Element    ${INPUT_SENHA}
    Wait Until Page Contains Element    ${BOTAO_LOGIN}

Dado que o usuario informa o email
    [Arguments]    ${email}=${EMPTY}
    Clear Element Text    ${INPUT_EMAIL}
    Input Text    ${INPUT_EMAIL}    ${email}

E informa a senha
    [Arguments]    ${senha}=${EMPTY}
    Clear Element Text    ${INPUT_SENHA}
    Input Password    ${INPUT_SENHA}    ${senha}

Quando solicitar o login
    Click Button    ${BOTAO_LOGIN}

Entao o sistema deve apresentar a mensagem
    [Arguments]    ${mensagem_esperada}
    Wait Until Element Contains    ${MENSAGEM}    ${mensagem_esperada}    timeout=5s
    ${texto}=    Get Text    ${MENSAGEM}
    Should Be Equal As Strings    ${texto}    ${mensagem_esperada}

E fecha o navegador
    Close Browser
