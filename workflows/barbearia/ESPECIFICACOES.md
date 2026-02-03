# 💈 Barbearia n8n Workflow - Especificações Técnicas

## 📊 Resumo Executivo

**Nome do Projeto:** Sistema de Automação para Barbearia  
**Plataforma:** n8n (Workflow Automation)  
**Versão:** 1.0.0  
**Data:** 03 de Fevereiro de 2026  
**Autor:** Autonomousia  

---

## 🎯 Objetivos do Sistema

### Objetivos Principais:
1. ✅ Automatizar processo de agendamento
2. ✅ Reduzir no-shows com lembretes automáticos
3. ✅ Melhorar comunicação com clientes
4. ✅ Coletar feedback sistematicamente
5. ✅ Fornecer insights de negócio via relatórios

### KPIs Esperados:
- 📈 Redução de 40% em no-shows
- ⚡ Tempo de resposta < 2 segundos
- 📊 Taxa de satisfação > 90%
- 💰 Aumento de 25% em reagendamentos

---

## 🏗️ Arquitetura Técnica

### Stack Tecnológico:

```yaml
Backend:
  - n8n: v1.0.0+
  - Node.js: v18+
  - MongoDB: v6.0+

Comunicação:
  - WhatsApp Business API
  - SMTP/SendGrid
  - Webhooks REST

Infraestrutura:
  - Docker: v20+
  - Nginx: v1.21+
  - SSL: Let's Encrypt

Desenvolvimento:
  - TypeScript/JavaScript
  - Python (exemplos)
  - JSON Schema
```

### Componentes do Sistema:

```
┌───────────────────────────────────────────────────────┐
│                    CAMADA DE ENTRADA                   │
├───────────────────────────────────────────────────────┤
│  • Webhook de Agendamento                             │
│  • Webhook de Cancelamento                            │
│  • Webhook de Relatório                               │
│  • Cron Jobs (3 schedules)                            │
└───────────────────────────────────────────────────────┘
                          ↓
┌───────────────────────────────────────────────────────┐
│                  CAMADA DE PROCESSAMENTO               │
├───────────────────────────────────────────────────────┤
│  • Validação de dados                                 │
│  • Transformação de dados                             │
│  • Lógica de negócio                                  │
│  • Controle de fluxo                                  │
└───────────────────────────────────────────────────────┘
                          ↓
┌───────────────────────────────────────────────────────┐
│                  CAMADA DE PERSISTÊNCIA                │
├───────────────────────────────────────────────────────┤
│  • MongoDB (Create, Read, Update)                     │
│  • Índices otimizados                                 │
│  • Queries agregadas                                  │
└───────────────────────────────────────────────────────┘
                          ↓
┌───────────────────────────────────────────────────────┐
│                  CAMADA DE NOTIFICAÇÃO                 │
├───────────────────────────────────────────────────────┤
│  • Email (SMTP)                                       │
│  • WhatsApp (Business API)                            │
│  • Logs e auditoria                                   │
└───────────────────────────────────────────────────────┘
```

---

## 📋 Especificação de Fluxos

### Fluxo 1: Agendamento

**Trigger:** Webhook POST  
**Endpoint:** `/webhook/agendamento`  
**Método:** POST  

**Input Schema:**
```json
{
  "nome": "string (required)",
  "telefone": "string (required, formato: +5511999999999)",
  "email": "string (required, email válido)",
  "servico": "string (required)",
  "barbeiro": "string (required)",
  "data_hora": "string (required, ISO 8601)",
  "valor": "number (required, positivo)",
  "observacoes": "string (optional)"
}
```

**Processo:**
1. Recebe dados via webhook
2. Valida formato e campos obrigatórios
3. Salva no MongoDB (collection: agendamentos)
4. **Paralelamente:**
   - Envia email de confirmação
   - Envia WhatsApp de confirmação
5. Retorna resposta de sucesso

**Output:**
```json
{
  "success": true,
  "message": "Agendamento criado",
  "data": {
    "_id": "ObjectId",
    "status": "confirmado",
    "criado_em": "timestamp"
  }
}
```

**SLA:** < 2 segundos  
**Taxa de erro esperada:** < 1%

---

### Fluxo 2: Lembretes

**Trigger:** Cron (Diário, 09:00 BRT)  
**Periodicidade:** 24 horas  

**Processo:**
1. Cron executa às 09:00
2. Query MongoDB: agendamentos entre D+1 00:00 e D+1 23:59
3. Filtra apenas status "confirmado"
4. Para cada agendamento:
   - Compõe mensagem personalizada
   - Envia via WhatsApp
   - Loga envio

**Query MongoDB:**
```javascript
{
  "data_hora": {
    "$gte": ISODate("amanha-00:00"),
    "$lte": ISODate("amanha-23:59")
  },
  "status": "confirmado"
}
```

**Mensagem Template:**
```
🔔 *Lembrete de Agendamento*

Olá *{{nome}}*!

Lembramos que você tem um horário marcado *amanhã*:

⏰ Horário: {{data_hora}}
✂️ Serviço: {{servico}}
💈 Barbeiro: {{barbeiro}}

Caso precise cancelar ou remarcar, entre em contato.

Até amanhã! 🙌
```

**SLA:** Envio até 10:00 BRT  
**Cobertura:** 100% dos agendamentos D+1

---

### Fluxo 3: Cancelamento

**Trigger:** Webhook POST  
**Endpoint:** `/webhook/cancelamento`  

**Input Schema:**
```json
{
  "_id": "ObjectId (required)",
  "cliente_nome": "string (required)",
  "cliente_telefone": "string (required)",
  "data_hora": "string (required)",
  "servico": "string (required)",
  "motivo": "string (optional)"
}
```

**Processo:**
1. Recebe solicitação de cancelamento
2. Atualiza documento no MongoDB:
   - status: "cancelado"
   - cancelado_em: timestamp
   - motivo_cancelamento: motivo
3. Envia notificação WhatsApp ao cliente
4. Retorna confirmação

**SLA:** < 1 segundo  
**Garantia:** Idempotente (múltiplas chamadas = mesmo resultado)

---

### Fluxo 4: Feedback

**Trigger:** Cron (A cada hora)  
**Periodicidade:** 60 minutos  

**Processo:**
1. Executa a cada hora
2. Query: agendamentos concluídos nas últimas 1-2h
3. Filtra: feedback_enviado = false
4. Para cada agendamento:
   - Envia solicitação de feedback via WhatsApp
   - Marca feedback_enviado = true
   - Registra timestamp

**Query MongoDB:**
```javascript
{
  "data_hora": {
    "$gte": now - 2h,
    "$lte": now
  },
  "status": "confirmado",
  "feedback_enviado": { "$ne": true }
}
```

**Controle de Duplicação:** Campo `feedback_enviado`  
**Taxa esperada de resposta:** > 60%

---

### Fluxo 5: Relatórios

**Trigger:** Webhook POST (manual) ou Cron (20:00)  
**Endpoint:** `/webhook/relatorio-diario`  

**Processo:**
1. Executa agregação MongoDB
2. Agrupa por status
3. Calcula:
   - Total de agendamentos
   - Valor total por status
   - Ticket médio
4. Formata relatório
5. Envia email para gerência

**Agregação MongoDB:**
```javascript
[
  {
    $match: {
      data_hora: { $gte: hoje_00h, $lte: hoje_23h }
    }
  },
  {
    $group: {
      _id: "$status",
      total: { $sum: 1 },
      valor_total: { $sum: "$valor" }
    }
  }
]
```

**Output Email:**
```
Assunto: Relatório Diário - {{data}}

📊 Estatísticas do Dia:

✅ Confirmados: X agendamentos (R$ Y)
❌ Cancelados: X agendamentos (R$ Y)
💰 Receita Total: R$ Z

[Detalhamento por barbeiro]
[Serviços mais populares]
```

**SLA:** Envio até 20:30  
**Destinatários:** Gerência + Proprietários

---

## 💾 Modelo de Dados

### Collection: `agendamentos`

```javascript
{
  _id: ObjectId,                    // PK, auto-gerado
  cliente_nome: String,             // Nome completo
  cliente_telefone: String,         // +5511999999999 (E.164)
  cliente_email: String,            // email@dominio.com
  servico: String,                  // Nome do serviço
  barbeiro: String,                 // Nome do profissional
  data_hora: ISODate,              // Data/hora agendada
  status: String,                   // enum: confirmado|cancelado
  valor: Number,                    // Decimal (2 casas)
  observacoes: String,              // Texto livre
  criado_em: ISODate,              // Timestamp criação
  feedback_enviado: Boolean,        // Default: false
  feedback_enviado_em: ISODate,    // Timestamp envio
  cancelado_em: ISODate,           // Timestamp cancelamento
  motivo_cancelamento: String      // Motivo informado
}
```

### Índices:

```javascript
// Índice composto para queries de lembrete
db.agendamentos.createIndex({ 
  "data_hora": 1, 
  "status": 1 
})

// Índice para busca por cliente
db.agendamentos.createIndex({ 
  "cliente_telefone": 1 
})

// Índice para feedback
db.agendamentos.createIndex({ 
  "feedback_enviado": 1,
  "data_hora": 1
})

// Índice para relatórios
db.agendamentos.createIndex({ 
  "criado_em": -1,
  "status": 1
})
```

**Tamanho médio de documento:** ~500 bytes  
**Estimativa de crescimento:** 100-500 docs/dia  
**Retenção:** 365 dias (1 ano)

---

## 🔌 APIs e Integrações

### API Interna (Webhooks)

| Endpoint | Método | Autenticação | Rate Limit |
|----------|--------|--------------|------------|
| /webhook/agendamento | POST | API Key (opcional) | 100/min |
| /webhook/cancelamento | POST | API Key (opcional) | 50/min |
| /webhook/relatorio-diario | POST | API Key (recomendado) | 10/min |

### APIs Externas Utilizadas

**WhatsApp (Twilio):**
- Endpoint: `https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages`
- Método: POST
- Rate Limit: 80 msg/segundo (produção)
- Custo: ~$0.005/mensagem

**Email (SMTP):**
- Protocol: SMTP/TLS
- Port: 587
- Rate Limit: Depende do provedor
- Custo: Gratuito (Gmail) ou ~$0.001/email (SendGrid)

**MongoDB:**
- Connection: MongoDB Driver
- Pool Size: 10 conexões
- Timeout: 30 segundos

---

## 🔐 Segurança

### Autenticação e Autorização:

```yaml
Webhooks:
  - Opcional: Header X-API-Key
  - Recomendado: HTTPS obrigatório
  - IP Whitelist: Configurável

Database:
  - Usuário/senha dedicados
  - Conexão criptografada (TLS)
  - Princípio do menor privilégio

APIs Externas:
  - Credenciais em variáveis de ambiente
  - Rotação periódica de tokens
  - Secrets do n8n (encrypted)
```

### Proteção de Dados (LGPD):

- ✅ Criptografia em trânsito (TLS 1.3)
- ✅ Criptografia em repouso (MongoDB Encryption)
- ✅ Logs anonimizados
- ✅ Direito ao esquecimento (API de deleção)
- ✅ Consentimento explícito (opt-in)
- ✅ Backup seguro com retenção limitada

---

## 📈 Monitoramento e Observabilidade

### Métricas Coletadas:

**Operacionais:**
- Taxa de sucesso de workflows
- Tempo de resposta (p50, p95, p99)
- Taxa de erro por endpoint
- Throughput (req/min)

**Negócio:**
- Total de agendamentos/dia
- Taxa de confirmação
- Taxa de cancelamento
- Taxa de no-show
- NPS (via feedback)

**Infraestrutura:**
- CPU/Memória (n8n container)
- Conexões MongoDB
- Latência de APIs externas
- Espaço em disco

### Logs:

```javascript
// Formato estruturado (JSON)
{
  "timestamp": "2026-02-03T12:00:00Z",
  "level": "info",
  "workflow": "agendamento",
  "node": "MongoDB - Salvar",
  "execution_id": "abc123",
  "message": "Agendamento criado",
  "metadata": {
    "cliente_id": "...",
    "servico": "Corte + Barba"
  }
}
```

---

## 🧪 Testes

### Cobertura de Testes:

| Tipo | Cobertura | Ferramenta |
|------|-----------|------------|
| Unitários | 80% | Jest |
| Integração | 60% | Postman/Newman |
| E2E | 40% | Cypress |
| Carga | N/A | k6 |

### Cenários de Teste:

1. ✅ Agendamento válido → Sucesso
2. ✅ Agendamento com dados faltando → Erro 400
3. ✅ Cancelamento de agendamento existente → Sucesso
4. ✅ Cancelamento de agendamento inexistente → Erro 404
5. ✅ Lembrete enviado 24h antes → Verificar WhatsApp
6. ✅ Feedback após 2h → Verificar envio
7. ✅ Relatório diário → Verificar email

---

## 📊 Capacidade e Escalabilidade

### Limites Atuais:

| Recurso | Limite | Observação |
|---------|--------|------------|
| Agendamentos/dia | 500 | Single instance |
| Requisições/min | 100 | Rate limit recomendado |
| Tamanho do DB | 50GB | MongoDB Atlas M0 (grátis) |
| Conexões simultâneas | 10 | Pool do MongoDB |

### Plano de Escalabilidade:

**Fase 1 (até 1.000 agend/dia):**
- n8n single instance
- MongoDB Atlas M2
- Recursos atuais

**Fase 2 (até 10.000 agend/dia):**
- n8n clustered (2-3 instances)
- MongoDB Atlas M10
- Load balancer
- Cache (Redis)

**Fase 3 (> 10.000 agend/dia):**
- n8n auto-scaling
- MongoDB sharded cluster
- CDN para assets
- Microservices architecture

---

## 💰 Estimativa de Custos

### Opção 1: Self-hosted (Recomendado para início)

```
VPS (DigitalOcean/Linode): $12/mês
MongoDB Atlas (M0 Free): $0/mês
WhatsApp (Twilio): ~$50/mês (1000 msg)
Email (Gmail): $0/mês
SSL (Let's Encrypt): $0/mês
-----------------------------------------
TOTAL: ~$62/mês
```

### Opção 2: Cloud-managed

```
n8n Cloud: $20/mês
MongoDB Atlas (M2): $9/mês
WhatsApp (Twilio): ~$50/mês
SendGrid: $15/mês
-----------------------------------------
TOTAL: ~$94/mês
```

### ROI Estimado:

- 📈 Redução de 40% em no-shows = +$500/mês
- ⏰ Economia de 10h/mês de trabalho manual = +$200/mês
- 📊 Melhoria em reagendamentos = +$300/mês
- **ROI:** ~15x no primeiro mês

---

**Última atualização:** 03/02/2026  
**Versão:** 1.0.0  
**Status:** ✅ Production Ready

**Desenvolvido por:** [Autonomousia](https://github.com/autonomousia25-hue)
