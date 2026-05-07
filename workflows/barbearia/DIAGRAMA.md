# 🎨 Diagrama Visual - Workflow Barbearia

## 📐 Arquitetura Completa

```
╔══════════════════════════════════════════════════════════════════════════╗
║                      SISTEMA DE AUTOMAÇÃO - BARBEARIA                     ║
╚══════════════════════════════════════════════════════════════════════════╝

┌──────────────────────────────────────────────────────────────────────────┐
│                        1. FLUXO DE AGENDAMENTO                            │
└──────────────────────────────────────────────────────────────────────────┘

    📱 Cliente                🌐 Webhook              💾 MongoDB
    Formulário          ──────►  Recebe           ──────►  Salva
    Web/App                      Dados                     Dados
                                                             │
                                                             │
                                    ┌────────────────────────┴─────────────────┐
                                    │                                          │
                                    ▼                                          ▼
                              📧 Email                              📲 WhatsApp
                            Confirmação                            Confirmação
                         "Agendamento OK!"                     "Horário Marcado!"


┌──────────────────────────────────────────────────────────────────────────┐
│                         2. FLUXO DE LEMBRETES                             │
└──────────────────────────────────────────────────────────────────────────┘

    ⏰ Cron Job              💾 MongoDB              📲 WhatsApp
    (24 em 24h)         ──────►  Busca           ──────►  Envia
    Verifica                 Agendamentos             Lembrete
    Diariamente              de Amanhã                24h antes


┌──────────────────────────────────────────────────────────────────────────┐
│                       3. FLUXO DE CANCELAMENTO                            │
└──────────────────────────────────────────────────────────────────────────┘

    📱 Cliente                🌐 Webhook              💾 MongoDB
    Solicita            ──────►  Recebe           ──────►  Atualiza
    Cancelamento                 Request                 Status
                                                             │
                                                             │
                                                             ▼
                                                        📲 WhatsApp
                                                        Notifica
                                                        Cancelamento


┌──────────────────────────────────────────────────────────────────────────┐
│                      4. FLUXO DE FEEDBACK                                 │
└──────────────────────────────────────────────────────────────────────────┘

    ⏰ Cron Job              💾 MongoDB              📲 WhatsApp
    (1 em 1h)           ──────►  Busca           ──────►  Solicita
    Verifica                 Concluídos              Avaliação
    Serviços                 Recentes                    │
                                                         │
                                                         ▼
                                                    💾 MongoDB
                                                    Marca como
                                                    Enviado


┌──────────────────────────────────────────────────────────────────────────┐
│                    5. FLUXO DE RELATÓRIOS                                 │
└──────────────────────────────────────────────────────────────────────────┘

    ⏰ Trigger               💾 MongoDB              📧 Email
    Manual/Cron         ──────►  Agrega          ──────►  Envia
    Solicita                     Dados                  Relatório
    Relatório                    do Dia                 Gerência
```

## 🗂️ Estrutura de Dados Detalhada

```
┌─────────────────────────────────────────────────────────────┐
│                    COLEÇÃO: agendamentos                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Campo                 │ Tipo      │ Descrição                │
├───────────────────────┼───────────┼─────────────────────────┤
│ _id                   │ ObjectId  │ ID único do agendamento  │
│ cliente_nome          │ String    │ Nome completo            │
│ cliente_telefone      │ String    │ +5511999999999          │
│ cliente_email         │ String    │ Email de contato         │
│ servico               │ String    │ Tipo de serviço          │
│ barbeiro              │ String    │ Nome do profissional     │
│ data_hora             │ DateTime  │ Data e hora agendada     │
│ status                │ String    │ confirmado/cancelado     │
│ valor                 │ Number    │ Valor do serviço         │
│ observacoes           │ String    │ Notas adicionais         │
│ criado_em             │ DateTime  │ Data de criação          │
│ feedback_enviado      │ Boolean   │ Controle de feedback     │
│ feedback_enviado_em   │ DateTime  │ Quando foi enviado       │
│ cancelado_em          │ DateTime  │ Data do cancelamento     │
│ motivo_cancelamento   │ String    │ Motivo informado         │
└───────────────────────┴───────────┴─────────────────────────┘
```

## 🔄 Ciclo de Vida de um Agendamento

```
    ┌─────────────┐
    │   CRIADO    │  ← Cliente faz agendamento
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │ CONFIRMADO  │  ← Sistema envia confirmações
    └──────┬──────┘
           │
           ├──────────────┐
           │              │
           ▼              ▼
    ┌─────────────┐  ┌─────────────┐
    │ LEMBRETE    │  │ CANCELADO   │
    │  ENVIADO    │  │             │
    └──────┬──────┘  └─────────────┘
           │
           ▼
    ┌─────────────┐
    │  REALIZADO  │  ← Serviço concluído
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │  FEEDBACK   │  ← Sistema coleta avaliação
    │  SOLICITADO │
    └─────────────┘
```

## 📊 Fluxo de Notificações

```
┌──────────────────────────────────────────────────────────────┐
│              NOTIFICAÇÕES AUTOMÁTICAS                         │
└──────────────────────────────────────────────────────────────┘

Momento                  │  Canal          │  Mensagem
─────────────────────────┼─────────────────┼───────────────────
Agendamento criado       │  Email          │  Confirmação
                         │  WhatsApp       │  Confirmação
─────────────────────────┼─────────────────┼───────────────────
24h antes                │  WhatsApp       │  Lembrete
─────────────────────────┼─────────────────┼───────────────────
Cancelamento             │  WhatsApp       │  Notificação
─────────────────────────┼─────────────────┼───────────────────
1-2h após serviço        │  WhatsApp       │  Feedback
─────────────────────────┼─────────────────┼───────────────────
Fim do dia               │  Email          │  Relatório
```

## ⚙️ Nós do Workflow

```
┌──────────────────────────────────────────────────────────────┐
│                    NODOS n8n UTILIZADOS                       │
└──────────────────────────────────────────────────────────────┘

🔷 Webhook (3 instâncias)
   ├─ webhook-agendamento      → Recebe novos agendamentos
   ├─ webhook-cancelamento     → Recebe cancelamentos
   └─ webhook-relatorio         → Trigger manual para relatórios

⏰ Cron (3 instâncias)
   ├─ cron-lembretes           → Diário (09:00)
   ├─ cron-feedback            → A cada hora
   └─ cron-relatorio (opcional) → Diário (20:00)

💾 MongoDB (6 instâncias)
   ├─ mongodb-salvar           → Create (agendamento)
   ├─ mongodb-buscar-amanha    → Read (lembretes)
   ├─ mongodb-cancelar         → Update (cancelamento)
   ├─ mongodb-buscar-concluidos→ Read (feedback)
   ├─ mongodb-marcar-feedback  → Update (feedback)
   └─ mongodb-relatorio        → Aggregate (estatísticas)

📧 Email (2 instâncias)
   ├─ email-confirmacao        → Confirmação de agendamento
   └─ email-relatorio          → Relatório gerencial

📲 WhatsApp (4 instâncias)
   ├─ whatsapp-confirmacao     → Confirmação
   ├─ whatsapp-lembrete        → Lembrete 24h
   ├─ whatsapp-cancelamento    → Notificação cancelamento
   └─ whatsapp-feedback        → Solicitação de avaliação

TOTAL: 18 nós
```

## 🎯 Pontos de Integração

```
┌──────────────────────────────────────────────────────────────┐
│              INTEGRAÇÕES EXTERNAS POSSÍVEIS                   │
└──────────────────────────────────────────────────────────────┘

Frontend/App
    ├─ React/Next.js      → Interface de agendamento
    ├─ Flutter/React Native → App mobile
    └─ Landing Page       → Formulário web

Banco de Dados
    ├─ MongoDB Atlas      → Banco principal
    ├─ PostgreSQL         → Alternativa relacional
    └─ Redis              → Cache de sessões

Comunicação
    ├─ Twilio             → WhatsApp/SMS
    ├─ 360Dialog          → WhatsApp Business
    ├─ SendGrid           → Email transacional
    └─ Mailgun            → Alternativa email

Pagamento
    ├─ Stripe             → Pagamentos online
    ├─ PayPal             → Alternativa
    └─ Mercado Pago       → Mercado brasileiro

Analytics
    ├─ Google Analytics   → Métricas web
    ├─ Mixpanel           → Análise de produto
    └─ Metabase           → Dashboard customizado

Calendar
    ├─ Google Calendar    → Sincronização agenda
    └─ Outlook Calendar   → Alternativa MS

CRM
    ├─ HubSpot            → Gestão de clientes
    └─ Salesforce         → Enterprise CRM
```

## 📈 Métricas de Performance

```
┌──────────────────────────────────────────────────────────────┐
│                   KPIs MONITORADOS                            │
└──────────────────────────────────────────────────────────────┘

Operacionais:
  ✓ Tempo médio de resposta: < 2 segundos
  ✓ Taxa de sucesso de notificações: > 95%
  ✓ Uptime do workflow: > 99.5%

Negócio:
  ✓ Taxa de confirmação: 85-95%
  ✓ Taxa de cancelamento: < 15%
  ✓ Taxa de no-show: < 10%
  ✓ NPS (Net Promoter Score): > 8

Engajamento:
  ✓ Taxa de abertura WhatsApp: > 90%
  ✓ Taxa de resposta feedback: > 60%
  ✓ Taxa de reagendamento: 40-50%
```

## 🔐 Segurança e Conformidade

```
┌──────────────────────────────────────────────────────────────┐
│                CAMADAS DE SEGURANÇA                           │
└──────────────────────────────────────────────────────────────┘

Camada 1: Rede
  ├─ HTTPS obrigatório
  ├─ Rate limiting nos webhooks
  └─ IP whitelist (opcional)

Camada 2: Autenticação
  ├─ API keys nos webhooks
  ├─ OAuth 2.0 para APIs
  └─ Tokens JWT (se app mobile)

Camada 3: Dados
  ├─ Criptografia em trânsito (TLS)
  ├─ Criptografia em repouso
  └─ Backup diário automático

Camada 4: Compliance
  ├─ LGPD - Lei Geral de Proteção de Dados
  ├─ Anonimização de dados sensíveis
  └─ Direito ao esquecimento
```

## 🚀 Roadmap de Evolução

```
FASE 1 - MVP (Atual)
  ✅ Agendamento básico
  ✅ Notificações automáticas
  ✅ Lembretes
  ✅ Feedback

FASE 2 - Expansão (Q1 2026)
  🔄 Sistema de fidelidade
  🔄 Multi-barbeiro/Multi-loja
  🔄 Pagamentos online
  🔄 App mobile nativo

FASE 3 - Inteligência (Q2 2026)
  🔮 IA para previsão de demanda
  🔮 Recomendações personalizadas
  🔮 Otimização automática de agenda
  🔮 Chatbot para atendimento

FASE 4 - Escala (Q3 2026)
  🌟 Franchise/White label
  🌟 API pública
  🌟 Marketplace de serviços
  🌟 Integração com parceiros
```

---

**Última atualização:** 03 de Fevereiro de 2026  
**Versão do Workflow:** 1.0.0  
**Desenvolvido por:** [Autonomousia](https://github.com/autonomousia25-hue)
