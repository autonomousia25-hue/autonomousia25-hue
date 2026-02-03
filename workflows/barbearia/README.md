# 💈 Sistema Completo de Automação para Barbearia - n8n

## 📋 Visão Geral

Este workflow n8n foi projetado para automatizar completamente as operações de uma barbearia moderna, incluindo agendamento de clientes, notificações automáticas, lembretes, gestão de cancelamentos, coleta de feedback e relatórios gerenciais.

## 🎯 Funcionalidades Principais

### 1. **Agendamento Automático** 📅
- Recebe novos agendamentos via webhook
- Salva dados no MongoDB
- Envia confirmação por email e WhatsApp
- Armazena informações completas do cliente

### 2. **Sistema de Lembretes** 🔔
- Lembrete automático 24h antes do agendamento
- Envio via WhatsApp
- Verificação diária de agendamentos
- Possibilidade de cancelamento/remarcação

### 3. **Gestão de Cancelamentos** ❌
- Webhook para cancelamentos
- Atualização automática no banco de dados
- Notificação ao cliente via WhatsApp
- Registro do motivo do cancelamento

### 4. **Coleta de Feedback** ⭐
- Solicitação automática após o serviço
- Envio 1-2 horas após o horário agendado
- Controle para evitar múltiplos envios
- Melhoria contínua do serviço

### 5. **Relatórios Gerenciais** 📊
- Relatório diário automatizado
- Estatísticas de agendamentos
- Análise de receita
- Envio por email para gerência

## 🏗️ Arquitetura do Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE AGENDAMENTO                      │
└─────────────────────────────────────────────────────────────┘

Webhook             MongoDB              Notificações
(Novo Agendamento) → (Salvar) → ┬→ Email (Confirmação)
                                 └→ WhatsApp (Confirmação)

┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE LEMBRETES                        │
└─────────────────────────────────────────────────────────────┘

Cron (Diário) → MongoDB → WhatsApp
                (Buscar)  (Lembrete 24h)

┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE CANCELAMENTO                      │
└─────────────────────────────────────────────────────────────┘

Webhook           MongoDB              Notificação
(Cancelamento) → (Atualizar) → WhatsApp (Cancelamento)

┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE FEEDBACK                         │
└─────────────────────────────────────────────────────────────┘

Cron (Horário) → MongoDB → WhatsApp → MongoDB
                 (Buscar)  (Feedback)  (Marcar Enviado)

┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE RELATÓRIOS                        │
└─────────────────────────────────────────────────────────────┘

Webhook/Cron → MongoDB → Email
               (Agregar) (Relatório)
```

## 📦 Estrutura de Dados

### Coleção: `agendamentos`

```json
{
  "cliente_nome": "João Silva",
  "cliente_telefone": "+5511999999999",
  "cliente_email": "joao@email.com",
  "servico": "Corte + Barba",
  "barbeiro": "Carlos",
  "data_hora": "2026-02-05T14:00:00Z",
  "status": "confirmado",
  "valor": 50.00,
  "observacoes": "Cliente prefere degradê",
  "criado_em": "2026-02-03T12:00:00Z",
  "feedback_enviado": false,
  "cancelado_em": null,
  "motivo_cancelamento": null
}
```

## 🔧 Configuração e Instalação

### Pré-requisitos

1. **n8n instalado** (self-hosted ou cloud)
2. **MongoDB** (local ou cloud - MongoDB Atlas)
3. **WhatsApp Business API** (Twilio, 360Dialog ou similar)
4. **Servidor SMTP** para emails

### Passo a Passo

#### 1. Importar o Workflow

```bash
# No n8n, vá em:
Workflows → Import from File → Selecione workflow-barbearia.json
```

#### 2. Configurar Credenciais

**MongoDB:**
```
Nome: MongoDB Barbearia
Host: localhost:27017 (ou seu MongoDB Atlas)
Database: barbearia
```

**SMTP:**
```
Nome: SMTP Barbearia
Host: smtp.gmail.com
Port: 587
User: seu-email@gmail.com
Password: sua-senha-de-app
```

**WhatsApp API:**
```
Nome: WhatsApp Business API
Provider: Twilio/360Dialog
Account SID: seu-account-sid
Auth Token: seu-auth-token
Phone Number: +5511999999999
```

#### 3. Configurar Webhooks

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
