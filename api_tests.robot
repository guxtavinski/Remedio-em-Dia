*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Criar sessao da API

*** Variables ***
${BASE_API}       %{BASE_API=http://localhost:8080}
${EMAIL_VALIDO}   joao@email.com
${SENHA_VALIDA}   senha123
${EMAIL_INVALIDO}             joaoemail.com
${EMAIL_NAO_CADASTRADO}       naoexiste@email.com
${SENHA_INVALIDA}             senhaerrada
${EMAIL_EM_BRANCO}            ${SPACE}${SPACE}${SPACE}

*** Test Cases ***
API CT01 - Login Com Email Em Formato Invalido
    ${body}=       Create Dictionary    email=${EMAIL_INVALIDO}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=400
    Entao a resposta da API deve conter erro    ${resposta}    E-mail inválido    EMAIL_INVALIDO

API CT02 - Login Com Email Nao Cadastrado
    ${body}=       Create Dictionary    email=${EMAIL_NAO_CADASTRADO}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=401
    Entao a resposta da API deve conter erro    ${resposta}    Credenciais inválidas    CREDENCIAIS_INVALIDAS

API CT03 - Login Com Sucesso
    ${body}=       Create Dictionary    email=${EMAIL_VALIDO}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=200
    Entao a resposta da API deve conter sucesso    ${resposta}

API CT04 - Login Com Senha Incorreta
    ${body}=       Create Dictionary    email=${EMAIL_VALIDO}    senha=${SENHA_INVALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=401
    Entao a resposta da API deve conter erro    ${resposta}    Credenciais inválidas    CREDENCIAIS_INVALIDAS

API CT05 - Login Com Email Vazio
    ${body}=       Create Dictionary    email=${EMPTY}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=400
    Entao a resposta da API deve conter erro    ${resposta}    E-mail inválido    EMAIL_INVALIDO

API CT06 - Login Com Senha Vazia
    ${body}=       Create Dictionary    email=${EMAIL_VALIDO}    senha=${EMPTY}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=401
    Entao a resposta da API deve conter erro    ${resposta}    Credenciais inválidas    CREDENCIAIS_INVALIDAS

API CT07 - Login Com Email E Senha Vazios
    ${body}=       Create Dictionary    email=${EMPTY}    senha=${EMPTY}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=400
    Entao a resposta da API deve conter erro    ${resposta}    E-mail inválido    EMAIL_INVALIDO

API CT08 - Login Com Email Em Branco
    ${body}=       Create Dictionary    email=${EMAIL_EM_BRANCO}    senha=${SENHA_VALIDA}
    ${resposta}=   POST On Session    api    /login    json=${body}    expected_status=400
    Entao a resposta da API deve conter erro    ${resposta}    E-mail inválido    EMAIL_INVALIDO

*** Keywords ***
Criar sessao da API
    Create Session    api    ${BASE_API}

Entao a resposta da API deve conter sucesso
    [Arguments]    ${resposta}
    ${json}=    Set Variable    ${resposta.json()}
    Dictionary Should Contain Item    ${json}    status      sucesso
    Dictionary Should Contain Item    ${json}    mensagem    Login realizado com sucesso
    Dictionary Should Contain Key     ${json}    dados

Entao a resposta da API deve conter erro
    [Arguments]    ${resposta}    ${mensagem_esperada}    ${codigo_esperado}
    ${json}=    Set Variable    ${resposta.json()}
    Dictionary Should Contain Item    ${json}    status        erro
    Dictionary Should Contain Item    ${json}    mensagem      ${mensagem_esperada}
    Dictionary Should Contain Item    ${json}    codigoErro    ${codigo_esperado}
