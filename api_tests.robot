*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Criar sessao da API

*** Variables ***
${BASE_API}       %{BASE_API=http://localhost:8080}
${EMAIL_VALIDO}   joao@email.com
${SENHA_VALIDA}   senha123

*** Test Cases ***
API CT05 - Login Com Email Vazio
    ${body}=       Create Dictionary    email=${EMPTY}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=400
    Entao a resposta da API deve conter erro    ${resposta}    E-mail inválido    EMAIL_INVALIDO

API CT06 - Login Com Senha Vazia
    ${body}=       Create Dictionary    email=${EMAIL_VALIDO}    senha=${EMPTY}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=401
    Entao a resposta da API deve conter erro    ${resposta}    Credenciais inválidas    CREDENCIAIS_INVALIDAS

*** Keywords ***
Criar sessao da API
    Create Session    api    ${BASE_API}

Entao a resposta da API deve conter erro
    [Arguments]    ${resposta}    ${mensagem_esperada}    ${codigo_esperado}
    ${json}=    Set Variable    ${resposta.json()}
    Dictionary Should Contain Item    ${json}    status        erro
    Dictionary Should Contain Item    ${json}    mensagem      ${mensagem_esperada}
    Dictionary Should Contain Item    ${json}    codigoErro    ${codigo_esperado}
