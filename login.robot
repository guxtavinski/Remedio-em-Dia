*** Settings ***
Library    SeleniumLibrary
Suite Setup       Dado que o usuário acessa a tela de login
Suite Teardown    E fecha o navegador

*** Variables ***
${URL}            http://localhost:8080/login.html
${BROWSER}        edge

${INPUT_EMAIL}    id=email
${INPUT_SENHA}    id=senha
${BOTAO_LOGIN}    id=btnLogin
${MENSAGEM}       id=mensagem

*** Test Cases ***
CT01 - Deve validar e-mail inválido
    Dado que o usuário informa o email    joaoemail.com
    E informa a senha                     senha123
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem  Email invalido

CT02 - Deve validar e-mail não cadastrado
    Dado que o usuário informa o email    naoexiste@email.com
    E informa a senha                     senha123
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Credenciais invalidas

CT03 - Deve realizar login com sucesso
    Dado que o usuário informa o email    joao@email.com
    E informa a senha                     senha123
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Login realizado com sucesso

CT04 - Deve validar senha incorreta
    Dado que o usuário informa o email    joao@email.com
    E informa a senha                     senhaerrada
    Quando solicitar o login
    Então o sistema deve apresentar a mensagem    Credenciais invalidas

*** Keywords ***
Dado que o usuário acessa a tela de login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Dado que o usuário informa o email
    [Arguments]    ${email}=${EMPTY}
    Input Text    ${INPUT_EMAIL}    ${email}

E informa a senha
    [Arguments]    ${senha}=${EMPTY}
    Input Password    ${INPUT_SENHA}    ${senha}

Quando solicitar o login
    Click Button    ${BOTAO_LOGIN}

Então o sistema deve apresentar a mensagem
    [Arguments]    ${mensagem_esperada}
    Sleep    2s
    ${texto}=    Get Text    ${MENSAGEM}
    Log To Console    TEXTO ENCONTRADO: ${texto}
    Should Be Equal As Strings    ${texto}    ${mensagem_esperada}

E fecha o navegador
    Close Browser