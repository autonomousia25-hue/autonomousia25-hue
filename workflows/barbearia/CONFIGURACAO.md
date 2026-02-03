# ⚙️ Guia de Configuração - Workflow Barbearia

## 📋 Checklist de Configuração

### ✅ Pré-requisitos

- [ ] n8n instalado (versão 1.0.0+)
- [ ] MongoDB instalado ou conta no MongoDB Atlas
- [ ] Conta WhatsApp Business API (Twilio, 360Dialog, etc.)
- [ ] Servidor SMTP configurado
- [ ] Domínio próprio (recomendado)

## 🔧 Configuração Passo a Passo

### 1. Instalação do n8n

#### Opção A: Docker (Recomendado)

```bash
# Criar diretório
mkdir n8n-barbearia
cd n8n-barbearia

# Criar docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n-barbearia
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=senha-segura-aqui
      - N8N_HOST=seu-dominio.com
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://seu-dominio.com/
      - GENERIC_TIMEZONE=America/Sao_Paulo
    volumes:
      - n8n_data:/home/node/.n8n
      - ./workflows:/home/node/workflows

  mongodb:
    image: mongo:6
    container_name: mongodb-barbearia
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=senha-mongodb
      - MONGO_INITDB_DATABASE=barbearia
    volumes:
      - mongodb_data:/data/db

volumes:
  n8n_data:
  mongodb_data:
EOF

# Iniciar containers
docker-compose up -d
```

#### Opção B: NPM

```bash
npm install n8n -g
n8n start
```

### 2. Configurar MongoDB

#### MongoDB Local:

```bash
# Conectar ao MongoDB
mongosh

# Criar database e usuário
use barbearia

db.createUser({
  user: "barbearia_user",
  pwd: "senha-segura",
  roles: [
    { role: "readWrite", db: "barbearia" }
  ]
})

# Criar índices para performance
db.agendamentos.createIndex({ "data_hora": 1 })
db.agendamentos.createIndex({ "cliente_telefone": 1 })
db.agendamentos.createIndex({ "status": 1 })
db.agendamentos.createIndex({ "feedback_enviado": 1 })
```

#### MongoDB Atlas (Cloud):

```bash
1. Acesse https://cloud.mongodb.com
2. Crie cluster grátis (M0)
3. Configure Network Access (0.0.0.0/0 para desenvolvimento)
4. Crie Database User
5. Obtenha connection string:
   mongodb+srv://usuario:senha@cluster.mongodb.net/barbearia
```

### 3. Configurar Credenciais no n8n

#### MongoDB:

```
Nome: MongoDB Barbearia
Tipo: MongoDB
Host: localhost (ou connection string do Atlas)
Port: 27017 (não necessário para Atlas)
Database: barbearia
User: barbearia_user
Password: sua-senha
```

#### SMTP (Gmail):

```bash
# 1. Ativar verificação em 2 etapas no Google
# 2. Gerar senha de app em: https://myaccount.google.com/apppasswords

Configuração no n8n:
Nome: SMTP Barbearia
Host: smtp.gmail.com
Port: 587
Security: STARTTLS
User: seu-email@gmail.com
Password: senha-de-app-gerada
```

#### WhatsApp (Twilio):

```bash
# 1. Criar conta em https://www.twilio.com
# 2. Ativar WhatsApp Sandbox
# 3. Obter credenciais

Configuração no n8n:
Nome: WhatsApp Business API
Account SID: ACxxxxxxxxxxxx
Auth Token: seu-token
From Number: +14155238886 (número sandbox)
```

#### WhatsApp (360Dialog):

```bash
# 1. Criar conta em https://www.360dialog.com
# 2. Configurar canal WhatsApp
# 3. Obter API key

Configuração no n8n:
Nome: WhatsApp Business API
API Key: sua-api-key
Phone Number ID: seu-phone-id
```

### 4. Importar e Ativar Workflow

```bash
# 1. No n8n, vá em: Workflows → Import from File
# 2. Selecione: workflow-barbearia.json
# 3. Configure todas as credenciais
# 4. Teste cada webhook
# 5. Ative o workflow
```

## 🧪 Testes de Integração

### Testar Webhook de Agendamento

```bash
# Obter URL do webhook no n8n
# Formato: https://seu-n8n.com/webhook/agendamento

# Teste com curl
curl -X POST https://seu-n8n.com/webhook/agendamento \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Teste Silva",
    "telefone": "+5511999999999",
    "email": "teste@email.com",
    "servico": "Corte Masculino",
    "barbeiro": "João",
    "data_hora": "2026-02-10T14:00:00Z",
    "valor": 40.00,
    "observacoes": "Teste de integração"
  }'

# Verificar no MongoDB
mongosh
use barbearia
db.agendamentos.find().pretty()
```

### Testar Email

```bash
# No n8n, clique com botão direito no nó "Email - Confirmação"
# Selecione "Execute Node"
# Verifique se o email chegou
```

### Testar WhatsApp

```bash
# Configure seu número no WhatsApp Sandbox (Twilio)
# Envie "join <código>" para o número do sandbox
# Execute o nó WhatsApp no n8n
# Verifique se recebeu a mensagem
```

## 🔐 Variáveis de Ambiente

Crie arquivo `.env` na raiz do projeto:

```bash
# n8n
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=senha-segura
N8N_HOST=seu-dominio.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://seu-dominio.com/
GENERIC_TIMEZONE=America/Sao_Paulo
N8N_ENCRYPTION_KEY=chave-de-criptografia-segura

# MongoDB
MONGODB_HOST=localhost
MONGODB_PORT=27017
MONGODB_USER=barbearia_user
MONGODB_PASSWORD=senha-mongodb
MONGODB_DATABASE=barbearia
# OU para Atlas:
MONGODB_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/barbearia

# SMTP
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu-email@gmail.com
SMTP_PASSWORD=senha-de-app

# WhatsApp (Twilio)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=seu-token
TWILIO_WHATSAPP_NUMBER=+14155238886

# WhatsApp (360Dialog)
WHATSAPP_360_API_KEY=sua-api-key
WHATSAPP_360_PHONE_ID=seu-phone-id
```

## 📊 Monitoramento e Logs

### Configurar Logs do n8n

```bash
# Em docker-compose.yml, adicione:
environment:
  - N8N_LOG_LEVEL=debug
  - N8N_LOG_OUTPUT=console,file
  - N8N_LOG_FILE_LOCATION=/home/node/.n8n/logs/

# Visualizar logs
docker logs -f n8n-barbearia
```

### Monitorar Execuções

```javascript
// No n8n, acesse:
// Executions → Ver todas as execuções
// Filtrar por: Sucesso, Erro, Em execução

// Configurar alertas de erro:
// Settings → Error Workflow
// Criar workflow para notificar erros por email/slack
```

## 🎨 Personalização Avançada

### Adicionar Autenticação aos Webhooks

```javascript
// Em cada nó Webhook, adicione:
{
  "options": {
    "headerAuth": {
      "name": "X-API-Key",
      "value": "sua-chave-secreta-aqui"
    }
  }
}

// Chamada com autenticação:
curl -X POST https://seu-n8n.com/webhook/agendamento \
  -H "X-API-Key: sua-chave-secreta-aqui" \
  -H "Content-Type: application/json" \
  -d '{ ... }'
```

### Configurar SSL/HTTPS

```bash
# Usando Nginx como proxy reverso
sudo apt install nginx certbot python3-certbot-nginx

# Configurar Nginx
sudo nano /etc/nginx/sites-available/n8n

# Conteúdo:
server {
    server_name seu-dominio.com;
    
    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Ativar site
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Obter certificado SSL
sudo certbot --nginx -d seu-dominio.com
```

## 🔄 Backup e Restore

### Backup Automático

```bash
# Criar script de backup
cat > backup-barbearia.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/home/backups/barbearia"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup MongoDB
docker exec mongodb-barbearia mongodump \
  --username admin \
  --password senha-mongodb \
  --db barbearia \
  --out /tmp/backup_$DATE

docker cp mongodb-barbearia:/tmp/backup_$DATE $BACKUP_DIR/

# Backup workflows n8n
docker cp n8n-barbearia:/home/node/.n8n $BACKUP_DIR/n8n_$DATE

# Compactar
tar -czf $BACKUP_DIR/backup_completo_$DATE.tar.gz \
  $BACKUP_DIR/backup_$DATE \
  $BACKUP_DIR/n8n_$DATE

# Limpar arquivos temporários
rm -rf $BACKUP_DIR/backup_$DATE $BACKUP_DIR/n8n_$DATE

# Manter apenas últimos 30 dias
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Backup concluído: backup_completo_$DATE.tar.gz"
EOF

chmod +x backup-barbearia.sh

# Agendar no crontab (diário às 2h da manhã)
crontab -e
# Adicionar linha:
0 2 * * * /path/to/backup-barbearia.sh
```

### Restore de Backup

```bash
# Extrair backup
tar -xzf backup_completo_20260203_020000.tar.gz

# Restore MongoDB
docker exec -i mongodb-barbearia mongorestore \
  --username admin \
  --password senha-mongodb \
  --db barbearia \
  /tmp/backup_20260203_020000/barbearia

# Restore n8n workflows
docker cp n8n_20260203_020000/.n8n n8n-barbearia:/home/node/
docker restart n8n-barbearia
```

## 📱 Integração com Frontend

### Exemplo React/Next.js

```typescript
// api/agendamento.ts
export async function criarAgendamento(dados: AgendamentoDTO) {
  const response = await fetch('https://seu-n8n.com/webhook/agendamento', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': process.env.NEXT_PUBLIC_N8N_API_KEY,
    },
    body: JSON.stringify(dados),
  });
  
  if (!response.ok) {
    throw new Error('Erro ao criar agendamento');
  }
  
  return response.json();
}

// Uso no componente
const handleSubmit = async (e: FormEvent) => {
  e.preventDefault();
  
  try {
    await criarAgendamento({
      nome: formData.nome,
      telefone: formData.telefone,
      email: formData.email,
      servico: formData.servico,
      barbeiro: formData.barbeiro,
      data_hora: formData.dataHora,
      valor: 40.00,
      observacoes: formData.observacoes,
    });
    
    alert('Agendamento confirmado!');
  } catch (error) {
    alert('Erro ao agendar. Tente novamente.');
  }
};
```

## 🐛 Troubleshooting

### Problema: Webhook retorna 404

```bash
Solução:
1. Verificar se workflow está ativo
2. Confirmar URL do webhook
3. Verificar logs: docker logs n8n-barbearia
4. Testar com Postman/Insomnia
```

### Problema: MongoDB não conecta

```bash
Solução:
1. Verificar se container está rodando: docker ps
2. Testar conexão: mongosh --host localhost --port 27017
3. Verificar credenciais
4. Para Atlas: confirmar IP na whitelist
```

### Problema: WhatsApp não envia

```bash
Solução:
1. Verificar saldo da conta Twilio
2. Confirmar número está em sandbox (desenvolvimento)
3. Verificar formato do número: +5511999999999
4. Checar logs da API do provedor
```

### Problema: Emails vão para spam

```bash
Solução:
1. Configurar SPF record no DNS
2. Configurar DKIM
3. Usar domínio próprio
4. Evitar palavras suspeitas no assunto
5. Considerar usar SendGrid/Mailgun
```

---

**Última atualização:** 03 de Fevereiro de 2026  
**Desenvolvido por:** [Autonomousia](https://github.com/autonomousia25-hue)
