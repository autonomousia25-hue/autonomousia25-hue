# 💈 Sistema Completo de Automação para Barbearia - n8n + Google Workspace

## 📋 Visão Geral

Este workflow n8n foi projetado para automatizar completamente as operações de uma barbearia moderna usando o **Google Workspace**: 
- **Google Sheets** como banco de dados
- **Google Drive** para armazenamento de documentos  
- **Google Calendar** para agendamento de horários
- **Gmail** para comunicação com clientes

Inclui agendamento de clientes, criação automática de eventos no calendário, notificações via Gmail, lembretes, gestão de cancelamentos, coleta de feedback e relatórios gerenciais.

## 🎯 Funcionalidades Principais

### 1. **Agendamento Automático** 📅
- Recebe novos agendamentos via webhook
- Salva dados no **Google Sheets**
- Cria evento no **Google Calendar** automaticamente
- Salva ID do evento no Sheets para referência
- Cria documento de confirmação no **Google Drive**
- Envia confirmação por **Gmail**
- Cliente recebe convite do Calendar por email

### 2. **Sistema de Lembretes** 🔔
- Lembrete automático 24h antes do agendamento
- Busca agendamentos no **Google Sheets**
- Envio via **Gmail**
- Google Calendar também envia lembretes configuráveis
- Verificação diária de agendamentos

### 3. **Gestão de Cancelamentos** ❌
- Webhook para cancelamentos
- Atualização automática no **Google Sheets**
- Remove/cancela evento no **Google Calendar**
- Notifica todos os participantes automaticamente
- Envia notificação adicional via **Gmail**
- Registro do motivo do cancelamento

### 4. **Coleta de Feedback** ⭐
- Solicitação automática após o serviço
- Busca serviços concluídos no **Google Sheets**
- Envio via **Gmail**
- Controle para evitar múltiplos envios
- Melhoria contínua do serviço

### 5. **Relatórios Gerenciais** 📊
- Relatório diário automatizado
- Estatísticas de agendamentos do **Google Sheets**
- Análise de receita
- Salva relatório no **Google Drive**
- Envio por **Gmail** para gerência

## 🏗️ Arquitetura do Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE AGENDAMENTO                      │
└─────────────────────────────────────────────────────────────┘

Webhook → Google Sheets → Google Calendar → Atualizar Sheet → ┬→ Google Drive
                           (Criar Evento)    (Event ID)        └→ Gmail

┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE LEMBRETES                        │
└─────────────────────────────────────────────────────────────┘

Cron (Diário) → Google Sheets → Filtro → Gmail
                (Buscar Linhas)          (Lembrete 24h)
                                        
                Google Calendar também envia lembretes automáticos

┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE CANCELAMENTO                      │
└─────────────────────────────────────────────────────────────┘

Webhook → Google Sheets → Google Calendar → Gmail
          (Atualizar)      (Cancelar Evento)  (Notificar)

┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE LEMBRETES                        │
└─────────────────────────────────────────────────────────────┘

Cron (Diário) → Google Sheets → Gmail
                (Buscar Linhas)  (Lembrete 24h)

┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE CANCELAMENTO                      │
└─────────────────────────────────────────────────────────────┘

Webhook           Google Sheets         Notificação
(Cancelamento) → (Atualizar Linha) → Gmail (Cancelamento)

┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE FEEDBACK                         │
└─────────────────────────────────────────────────────────────┘

Cron (Horário) → Google Sheets → Gmail → Google Sheets
                 (Buscar Linhas) (Feedback) (Marcar Enviado)

┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE RELATÓRIOS                        │
└─────────────────────────────────────────────────────────────┘

Webhook/Cron → Google Sheets → Code → ┬→ Google Drive (Salvar)
               (Buscar Dados)   (Stats) └→ Gmail (Enviar)
```

## 📦 Estrutura de Dados - Google Sheets

### Planilha: `Agendamentos`

**Colunas:**
- A: `criado_em` - Data/hora de criação (ISO 8601)
- B: `cliente_nome` - Nome completo do cliente
- C: `cliente_telefone` - Telefone (+5511999999999)
- D: `cliente_email` - Email do cliente
- E: `servico` - Nome do serviço
- F: `barbeiro` - Nome do profissional
- G: `data_hora` - Data/hora do agendamento
- H: `status` - Status (confirmado/cancelado)
- I: `valor` - Valor do serviço (número)
- J: `observacoes` - Observações adicionais
- K: `feedback_enviado` - Controle de feedback (true/false)
- L: `calendar_event_id` - ID do evento no Google Calendar

**Exemplo de linha:**

```
| 2026-02-03T12:00:00Z | João Silva | +5511999999999 | joao@email.com | Corte + Barba | Carlos | 2026-02-05T14:00:00Z | confirmado | 50.00 | Cliente prefere degradê | false | abc123xyz |
```

### Google Calendar

**Calendário: Barbearia Premium**
- Cada agendamento cria um evento no calendário
- Evento inclui: título, descrição, horário, localização
- Cliente é adicionado como convidado
- Lembretes automáticos configurados (24h por email, 30min por popup)
- Cor do evento: Azul (#9)
- Duração padrão: 1 hora

```
| 2026-02-03T12:00:00Z | João Silva | +5511999999999 | joao@email.com | Corte + Barba | Carlos | 2026-02-05T14:00:00Z | confirmado | 50.00 | Cliente prefere degradê | false |
```

### Estrutura do Google Drive

**Pasta: Confirmações**
- Armazena documentos de confirmação de agendamento
- Formato: `Confirmacao_[Nome]_[Data].txt`

**Pasta: Relatórios**
- Armazena relatórios diários
- Formato: `Relatorio_[Data].txt`

## 🔧 Configuração e Instalação

### Pré-requisitos

1. **n8n instalado** (self-hosted ou cloud)
2. **Conta Google Workspace** ou Gmail
3. **Google Sheets** com planilha criada
4. **Google Drive** com pastas criadas

### Passo a Passo

#### 1. Importar o Workflow

```bash
# No n8n, vá em:
Workflows → Import from File → Selecione workflow-barbearia.json
```

#### 2. Criar Google Sheets

1. Acesse [Google Sheets](https://sheets.google.com)
2. Crie uma nova planilha chamada "Barbearia - Agendamentos"
3. Renomeie a primeira aba para "Agendamentos"
4. Adicione o cabeçalho na primeira linha:

```
criado_em | cliente_nome | cliente_telefone | cliente_email | servico | barbeiro | data_hora | status | valor | observacoes | feedback_enviado | calendar_event_id
```

5. Copie o ID da planilha da URL (exemplo: `1ABC...XYZ`)

#### 3. Criar Google Calendar

1. Acesse [Google Calendar](https://calendar.google.com)
2. Crie um novo calendário chamado "Barbearia - Agendamentos"
3. Configure as permissões (adicione barbeiros se necessário)
4. Copie o ID do calendário:
   - Configurações → Configurações do calendário
   - Role até "Integrar calendário"
   - Copie o "ID do calendário" (exemplo: `abc123@group.calendar.google.com`)

#### 4. Criar Pastas no Google Drive

1. Acesse [Google Drive](https://drive.google.com)
2. Crie duas pastas:
   - `Barbearia - Confirmações`
   - `Barbearia - Relatórios`
3. Copie o ID de cada pasta da URL

#### 5. Configurar Credenciais no n8n

**Google Sheets OAuth2:**
```
Nome: Google Sheets - Barbearia
Tipo: OAuth2
Scopes: https://www.googleapis.com/auth/spreadsheets
```

**Google Drive OAuth2:**
```
Nome: Google Drive - Barbearia
Tipo: OAuth2  
Scopes: https://www.googleapis.com/auth/drive
```

**Google Calendar OAuth2:**
```
Nome: Google Calendar - Barbearia
Tipo: OAuth2
Scopes: https://www.googleapis.com/auth/calendar
```

**Google API (Gmail):**
```
Nome: Google API - Barbearia
Tipo: Service Account ou OAuth2
Scopes: https://www.googleapis.com/auth/gmail.send
```

#### 6. Atualizar IDs no Workflow

No workflow JSON, substitua:
- `SPREADSHEET_ID` pelo ID da sua planilha
- `CALENDAR_ID` pelo ID do seu calendário
- `CONFIRMACOES_FOLDER_ID` pelo ID da pasta de confirmações
- `RELATORIOS_FOLDER_ID` pelo ID da pasta de relatórios

#### 7. Configurar Webhooks

Os webhooks criados automaticamente terão URLs como:

```
Novo Agendamento:
POST https://seu-n8n.com/webhook/agendamento

Cancelamento:
POST https://seu-n8n.com/webhook/cancelamento

Relatório:
POST https://seu-n8n.com/webhook/relatorio-diario
```

#### 4. Configurar Crons

- **Lembretes:** Diário às 09:00
- **Feedback:** A cada hora
- **Relatórios:** Diário às 20:00 (opcional)

## 📱 Exemplos de Uso

### Criar Novo Agendamento

```bash
curl -X POST https://seu-n8n.com/webhook/agendamento \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva",
    "telefone": "+5511999999999",
    "email": "joao@email.com",
    "servico": "Corte + Barba",
    "barbeiro": "Carlos",
    "data_hora": "2026-02-05T14:00:00Z",
    "valor": 50.00,
    "observacoes": "Cliente prefere degradê"
  }'
```

### Cancelar Agendamento

```bash
curl -X POST https://seu-n8n.com/webhook/cancelamento \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "65f1234567890abcdef12345",
    "cliente_nome": "João Silva",
    "cliente_telefone": "+5511999999999",
    "data_hora": "2026-02-05T14:00:00Z",
    "servico": "Corte + Barba",
    "motivo": "Imprevisto pessoal"
  }'
```

### Gerar Relatório Manual

```bash
curl -X POST https://seu-n8n.com/webhook/relatorio-diario
```

## 🎨 Personalização

### Modificar Mensagens do WhatsApp

Edite os nós de WhatsApp para personalizar as mensagens:

```javascript
// Exemplo de mensagem personalizada
🔔 *Agendamento Confirmado!*

Olá *{{ $json.cliente_nome }}*!

📅 Data: {{ $json.data_hora }}
✂️ Serviço: {{ $json.servico }}
💈 Barbeiro: {{ $json.barbeiro }}
💰 Valor: R$ {{ $json.valor }}

// Adicione aqui seu texto personalizado
🎁 Primeira vez? Ganhe 10% de desconto!

Nos vemos em breve! 👋

_Sua Barbearia_
```

### Adicionar Novos Serviços

Crie campos adicionais no MongoDB:

```json
{
  "servicos_extras": ["Sobrancelha", "Platinado"],
  "produtos_vendidos": ["Pomada", "Shampoo"],
  "forma_pagamento": "cartao",
  "cupom_desconto": "PRIMEIRA10"
}
```

### Integrar com Outros Sistemas

**Google Calendar:**
- Adicione nó Google Calendar após salvar agendamento
- Sincronize com agenda do barbeiro

**Sistemas de Pagamento:**
- Integre Stripe/PayPal para pagamentos online
- Adicione webhook de confirmação de pagamento

**CRM:**
- Sincronize com HubSpot/Salesforce
- Mantenha histórico completo do cliente

## 📊 Métricas e KPIs

O workflow coleta automaticamente:

- ✅ Total de agendamentos
- ❌ Taxa de cancelamento
- ⭐ Feedback dos clientes
- 💰 Receita diária/mensal
- 👤 Clientes recorrentes
- ⏰ Horários mais procurados

## 🚀 Melhorias Futuras

### Sugestões de Expansão:

1. **Sistema de Fidelidade**
   - Pontos por visita
   - Descontos progressivos
   - Programa VIP

2. **Lista de Espera**
   - Notificação de vagas disponíveis
   - Priorização de clientes

3. **Multi-loja**
   - Gestão de várias unidades
   - Transferência entre lojas

4. **Análise de IA**
   - Previsão de demanda
   - Otimização de agenda
   - Recomendações personalizadas

5. **App Mobile**
   - Interface para clientes
   - Auto-agendamento
   - Histórico de serviços

## 🔒 Segurança e Privacidade

### Boas Práticas Implementadas:

- ✅ Armazenamento seguro de dados
- ✅ Criptografia de comunicação
- ✅ Conformidade com LGPD
- ✅ Backup automático
- ✅ Logs de auditoria

### Dados Sensíveis:

```javascript
// NUNCA exponha em webhooks públicos:
- Credenciais de API
- Senhas de banco de dados
- Tokens de autenticação

// USE sempre:
- Variáveis de ambiente
- Secrets do n8n
- Autenticação nos webhooks
```

## 🆘 Troubleshooting

### Problemas Comuns:

**1. Webhook não responde:**
```bash
# Verifique se o workflow está ativo
# Teste com curl/Postman
# Verifique logs do n8n
```

**2. MongoDB não conecta:**
```bash
# Verifique credenciais
# Confirme IP na whitelist (Atlas)
# Teste conexão manual
```

**3. WhatsApp não envia:**
```bash
# Verifique saldo da API
# Confirme número está verificado
# Teste com número de teste
```

**4. Emails na spam:**
```bash
# Configure SPF/DKIM
# Use domínio próprio
# Evite palavras-spam
```

## 📞 Suporte

Para dúvidas ou suporte:

- 📧 Email: autonomousia25@gmail.com
- 💬 GitHub: [@autonomousia25-hue](https://github.com/autonomousia25-hue)
- 📝 Issues: [Abrir issue](https://github.com/autonomousia25-hue/autonomousia25-hue/issues)

## 📄 Licença

Este workflow é fornecido como exemplo educacional. Sinta-se livre para adaptar às suas necessidades.

---

## 🌟 Contribuições

Contribuições são bem-vindas! Se você melhorou este workflow:

1. Fork o repositório
2. Crie sua feature branch
3. Commit suas mudanças
4. Push para o branch
5. Abra um Pull Request

---

**Desenvolvido com ❤️ por [Autonomousia](https://github.com/autonomousia25-hue)**

*"A automação não é sobre fazer menos, é sobre fazer o certo, mais rápido."*
