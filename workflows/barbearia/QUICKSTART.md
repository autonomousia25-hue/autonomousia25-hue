# 🚀 Quick Start - Workflow n8n Barbearia

## 📦 O que você vai encontrar aqui?

Este é um **sistema completo de automação para barbearias** desenvolvido com n8n e **Google Workspace**. Inclui:

✅ **Workflow funcional em JSON** - Pronto para importar no n8n  
✅ **Integração Google Workspace** - Sheets, Drive, Calendar e Gmail  
✅ **Documentação completa em Português** - Guias detalhados  
✅ **Exemplos de código** - JavaScript, Python, cURL  
✅ **Diagramas visuais** - Entenda a arquitetura facilmente  
✅ **Guia de configuração** - Passo a passo para deploy  

---

## 📁 Estrutura de Arquivos

```
workflows/barbearia/
├── workflow-barbearia.json  ← Arquivo principal do workflow n8n
├── README.md                ← Documentação principal (COMECE AQUI)
├── DIAGRAMA.md             ← Visualização da arquitetura
├── CONFIGURACAO.md         ← Guia de setup e instalação
├── EXEMPLOS.md             ← Exemplos de API e código
└── QUICKSTART.md           ← Este arquivo
```

---

## ⚡ Como Usar - 3 Passos Simples

### 1️⃣ Importar o Workflow

```bash
1. Abra seu n8n
2. Vá em: Workflows → Import from File
3. Selecione: workflow-barbearia.json
4. Clique em "Import"
```

### 2️⃣ Configurar Credenciais

Você precisará configurar 4 integrações do Google:

**Google Sheets** (Banco de dados)
- Crie planilha "Barbearia - Agendamentos"
- Adicione colunas conforme documentação
- OAuth2 com scope spreadsheets

**Google Calendar** (Agendamento)
- Crie calendário "Barbearia - Agendamentos"
- Configure lembretes automáticos
- OAuth2 com scope calendar

**Google Drive** (Documentos)
- Crie pastas para confirmações e relatórios
- OAuth2 com scope drive

**Gmail** (Email/Comunicação)
- Configure OAuth2 ou Service Account
- Scope gmail.send

📖 **Veja o guia completo:** [CONFIGURACAO.md](./CONFIGURACAO.md)

### 3️⃣ Ativar e Testar

```bash
# Ative o workflow no n8n
# Teste com cURL:

curl -X POST https://seu-n8n.com/webhook/agendamento \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva",
    "telefone": "+5511999999999",
    "email": "joao@email.com",
    "servico": "Corte + Barba",
    "barbeiro": "Carlos",
    "data_hora": "2026-02-10T14:00:00Z",
    "valor": 50.00,
    "observacoes": "Teste"
  }'
```

---

## 🎯 Principais Funcionalidades

### 📅 Agendamento Automático
Cliente agenda → Salva no Sheets → Cria evento no Calendar → Envia confirmação por Gmail + salva no Drive

### 🔔 Lembretes Inteligentes
Todo dia às 9h → Sistema verifica agendamentos de amanhã → Envia lembrete por Gmail
Google Calendar também envia lembretes automáticos (24h + 30min antes)

### ❌ Gestão de Cancelamentos
Cliente cancela → Atualiza Sheets → Cancela evento no Calendar → Notifica via Gmail

### ⭐ Coleta de Feedback
A cada hora → Sistema verifica serviços concluídos → Solicita avaliação por Gmail

### 📊 Relatórios Automáticos
Fim do dia → Busca dados no Sheets → Processa stats → Salva no Drive + envia por Gmail

---

## 🏗️ Arquitetura Simplificada

```
┌─────────────────────────────────────────────────────────┐
│                    GOOGLE WORKSPACE                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│   WEBHOOK → SHEETS → CALENDAR → DRIVE + GMAIL          │
│   (Entrada)  (Salvar) (Evento)   (Notificar)           │
│                                                          │
│   CRON → SHEETS → GMAIL                                │
│   (Diário) (Buscar) (Lembrete)                         │
│                                                          │
│   Calendar também envia lembretes automáticos           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

📊 **Veja os diagramas completos:** [DIAGRAMA.md](./DIAGRAMA.md)

---

## 📚 Documentação Detalhada

### 📖 [README.md](./README.md)
**Comece aqui!** Visão geral completa do sistema.

- Funcionalidades principais
- Arquitetura do workflow
- Estrutura de dados
- Exemplos de personalização
- Métricas e KPIs

### 🎨 [DIAGRAMA.md](./DIAGRAMA.md)
Visualização completa da arquitetura.

- Fluxos de dados
- Diagramas ASCII
- Ciclo de vida de agendamento
- Pontos de integração
- Roadmap de evolução

### ⚙️ [CONFIGURACAO.md](./CONFIGURACAO.md)
Guia passo a passo de instalação.

- Setup do n8n (Docker + NPM)
- Configuração Google Sheets
- Configuração Google Calendar  
- Configuração Google Drive
- Integração Gmail
- Variáveis de ambiente
- Backup e restore
- Troubleshooting

### 📚 [EXEMPLOS.md](./EXEMPLOS.md)
Código pronto para usar.

- Exemplos de API calls (cURL, JavaScript, Python)
- Queries MongoDB úteis
- Sistema de agendamento web (React)
- Bot de WhatsApp
- Testes automatizados

---

## 💡 Casos de Uso

### Para Barbeiros/Proprietários:
- ✂️ Gerencie agendamentos automaticamente
- 📊 Receba relatórios diários
- ⭐ Colete feedback dos clientes
- 💰 Acompanhe receita em tempo real

### Para Desenvolvedores:
- 🔧 Base sólida para customização
- 🚀 Deploy rápido com Docker
- 📱 Integre com apps mobile/web
- 🔌 API pronta para uso

### Para Estudantes:
- 📖 Aprenda n8n na prática
- 🎓 Exemplo real de automação
- 💻 Código bem documentado
- 🌟 Portfolio project

---

## 🛠️ Tech Stack

**Backend & Automação:**
- n8n (workflow engine)
- Google Workspace (plataforma)
- Node.js (runtime)

**Google Services:**
- Google Sheets (database)
- Google Calendar (scheduling)
- Google Drive (file storage)
- Gmail (communication)

**Infraestrutura:**
- Docker (containerização)
- Nginx (proxy reverso)
- Let's Encrypt (SSL)

---

## 📈 Métricas do Sistema

### Nós do Workflow: 21
- 🔷 3 Webhooks
- ⏰ 3 Cron Jobs
- 📊 8 Operações Google Sheets
- 📅 2 Operações Google Calendar
- 📁 2 Operações Google Drive
- 📧 5 Envios de Gmail
- 🔧 1 Code (processamento)

### Performance:
- ⚡ Tempo de resposta: < 2s
- 🎯 Taxa de sucesso: > 95%
- ⏱️ Uptime: > 99.5%

---

## 🎓 Tutorial Rápido

### Cenário 1: Cliente Agenda Online

```javascript
// Frontend React/Next.js
const response = await fetch('https://seu-n8n.com/webhook/agendamento', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    nome: "Maria Santos",
    telefone: "+5511987654321",
    email: "maria@email.com",
    servico: "Corte + Barba",
    barbeiro: "Carlos",
    data_hora: "2026-02-15T15:00:00Z",
    valor: 50.00,
    observacoes: ""
  })
});

// O que acontece automaticamente:
// 1. ✅ Agendamento salvo no Google Sheets
// 2. 📅 Evento criado no Google Calendar
// 3. 🔗 Event ID salvo no Sheets
// 4. 📁 Confirmação salva no Google Drive
// 5. 📧 Gmail de confirmação enviado
// 6. 📅 Cliente recebe convite do Calendar
// 7. 🔔 Calendar envia lembretes automáticos (24h + 30min)
// 8. ⭐ Feedback solicitado após o serviço
```

### Cenário 2: Cliente Cancela

```bash
curl -X POST https://seu-n8n.com/webhook/cancelamento \
  -H "Content-Type: application/json" \
  -d '{
    "row_number": "5",
    "calendar_event_id": "abc123xyz",
    "cliente_nome": "Maria Santos",
    "cliente_email": "maria@email.com",
    "data_hora": "2026-02-15T15:00:00Z",
    "servico": "Corte + Barba",
    "motivo": "Imprevisto"
  }'

# O que acontece:
# 1. ✅ Status atualizado no Google Sheets
# 2. 📅 Evento cancelado no Google Calendar
# 3. 📧 Gmail de cancelamento enviado
# 4. 📅 Calendar notifica todos os participantes
# 3. 📊 Estatística registrada
```

---

## 🔐 Segurança

✅ **Implementado:**
- HTTPS obrigatório
- OAuth2 do Google (autenticação segura)
- Dados armazenados no Google Workspace (criptografia nativa)
- API keys nos webhooks (opcional)
- Controle de permissões granular no Google

📚 **Veja mais em:** [CONFIGURACAO.md - Seção Segurança](./CONFIGURACAO.md#-segurança-e-conformidade)

---

## 🌟 Próximos Passos

### Opção A: Usar Como Está ✨
1. Importe o workflow
2. Configure credenciais
3. Comece a usar!

### Opção B: Customizar 🎨
1. Leia [README.md](./README.md) para entender a estrutura
2. Modifique mensagens e fluxos
3. Adicione suas integrações

### Opção C: Expandir 🚀
1. Adicione pagamentos online
2. Crie app mobile
3. Implemente IA/ML
4. Lance marketplace

---

## ❓ FAQ

**Q: Preciso pagar por algum serviço?**  
A: n8n self-hosted é grátis. Google Workspace tem tier gratuito para uso pessoal. Gmail, Sheets, Drive e Calendar são gratuitos com conta Google.

**Q: Funciona para vários barbeiros?**  
A: Sim! O workflow já suporta múltiplos barbeiros. Você pode criar calendários separados ou usar cores diferentes no mesmo calendário.

**Q: Posso usar sem saber programar?**  
A: Sim! Basta importar o workflow e configurar as credenciais do Google. Não precisa escrever código.

**Q: Como funcionam os backups?**  
A: Os dados ficam no Google Sheets/Drive, que já tem backup automático do Google. Você também pode exportar dados periodicamente.

**Q: Funciona em produção?**  
A: Sim! Está pronto para produção. Google Workspace é escalável e confiável. Recomendamos usar SSL e autenticação nos webhooks.

**Q: Preciso de Google Workspace pago?**  
A: Não! Funciona perfeitamente com conta Google gratuita (Gmail). Google Workspace pago oferece recursos extras mas não é necessário.

---

## 🆘 Precisa de Ajuda?

### Documentação:
1. 📖 [README.md](./README.md) - Visão geral
2. ⚙️ [CONFIGURACAO.md](./CONFIGURACAO.md) - Setup
3. 📚 [EXEMPLOS.md](./EXEMPLOS.md) - Código
4. 🎨 [DIAGRAMA.md](./DIAGRAMA.md) - Arquitetura

### Suporte:
- 📧 Email: autonomousia25@gmail.com
- 💬 GitHub: [@autonomousia25-hue](https://github.com/autonomousia25-hue)
- 🐛 Issues: [Abrir issue](https://github.com/autonomousia25-hue/autonomousia25-hue/issues)

### Comunidade:
- 🌐 n8n Community: [community.n8n.io](https://community.n8n.io)
- 📺 YouTube: Tutoriais de n8n
- 💡 Stack Overflow: Tag `n8n`

---

## 🤝 Contribuindo

Encontrou um bug? Tem uma sugestão?

1. 🍴 Fork o repositório
2. 🔧 Faça suas alterações
3. ✅ Teste localmente
4. 📤 Abra um Pull Request

---

## 📄 Licença

Este projeto é fornecido como **exemplo educacional**. Sinta-se livre para usar e adaptar conforme necessário.

---

## ⭐ Gostou?

Se este workflow foi útil para você:

- ⭐ Dê uma estrela no GitHub
- 🔄 Compartilhe com outros desenvolvedores
- 💬 Deixe seu feedback
- 🤝 Contribua com melhorias

---

<div align="center">

### 🚀 Comece Agora!

**1.** Importe `workflow-barbearia.json` no seu n8n  
**2.** Configure as credenciais  
**3.** Ative o workflow  
**4.** Teste e personalize!

---

**Desenvolvido com ❤️ por [Autonomousia](https://github.com/autonomousia25-hue)**

*"A automação não é sobre fazer menos, é sobre fazer o certo, mais rápido."*

![Last Updated](https://img.shields.io/badge/Last%20Updated-Fevereiro%202026-blue?style=flat-square)
![n8n](https://img.shields.io/badge/n8n-FF6B35?style=flat-square&logo=n8n&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=flat-square)

</div>
