# 📚 Exemplos de Uso - API Barbearia

## 🔗 Endpoints Disponíveis

### 1. Criar Agendamento
### 2. Cancelar Agendamento
### 3. Gerar Relatório
### 4. Consultar Agendamentos (via MongoDB)

---

## 1️⃣ Criar Novo Agendamento

### Request

```http
POST https://seu-n8n.com/webhook/agendamento
Content-Type: application/json
X-API-Key: sua-chave-secreta (opcional)

{
  "nome": "João Silva",
  "telefone": "+5511987654321",
  "email": "joao.silva@email.com",
  "servico": "Corte + Barba",
  "barbeiro": "Carlos Eduardo",
  "data_hora": "2026-02-10T14:00:00Z",
  "valor": 50.00,
  "observacoes": "Cliente prefere degradê alto"
}
```

### Response (Sucesso)

```json
{
  "success": true,
  "message": "Agendamento criado com sucesso",
  "data": {
    "_id": "65f1234567890abcdef12345",
    "cliente_nome": "João Silva",
    "cliente_telefone": "+5511987654321",
    "cliente_email": "joao.silva@email.com",
    "servico": "Corte + Barba",
    "barbeiro": "Carlos Eduardo",
    "data_hora": "2026-02-10T14:00:00.000Z",
    "status": "confirmado",
    "valor": 50.00,
    "observacoes": "Cliente prefere degradê alto",
    "criado_em": "2026-02-03T12:30:00.000Z",
    "feedback_enviado": false
  }
}
```

### Exemplo cURL

```bash
curl -X POST https://seu-n8n.com/webhook/agendamento \
  -H "Content-Type: application/json" \
  -H "X-API-Key: sua-chave-secreta" \
  -d '{
    "nome": "João Silva",
    "telefone": "+5511987654321",
    "email": "joao.silva@email.com",
    "servico": "Corte + Barba",
    "barbeiro": "Carlos Eduardo",
    "data_hora": "2026-02-10T14:00:00Z",
    "valor": 50.00,
    "observacoes": "Cliente prefere degradê alto"
  }'
```

### Exemplo JavaScript/TypeScript

```typescript
async function criarAgendamento() {
  const response = await fetch('https://seu-n8n.com/webhook/agendamento', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': 'sua-chave-secreta',
    },
    body: JSON.stringify({
      nome: 'João Silva',
      telefone: '+5511987654321',
      email: 'joao.silva@email.com',
      servico: 'Corte + Barba',
      barbeiro: 'Carlos Eduardo',
      data_hora: '2026-02-10T14:00:00Z',
      valor: 50.00,
      observacoes: 'Cliente prefere degradê alto'
    })
  });
  
  const data = await response.json();
  console.log('Agendamento criado:', data);
  return data;
}
```

### Exemplo Python

```python
import requests
import json
from datetime import datetime

def criar_agendamento():
    url = "https://seu-n8n.com/webhook/agendamento"
    headers = {
        "Content-Type": "application/json",
        "X-API-Key": "sua-chave-secreta"
    }
    
    data = {
        "nome": "João Silva",
        "telefone": "+5511987654321",
        "email": "joao.silva@email.com",
        "servico": "Corte + Barba",
        "barbeiro": "Carlos Eduardo",
        "data_hora": "2026-02-10T14:00:00Z",
        "valor": 50.00,
        "observacoes": "Cliente prefere degradê alto"
    }
    
    response = requests.post(url, headers=headers, json=data)
    
    if response.status_code == 200:
        print("Agendamento criado:", response.json())
        return response.json()
    else:
        print("Erro:", response.status_code)
        return None
```

---

## 2️⃣ Cancelar Agendamento

### Request

```http
POST https://seu-n8n.com/webhook/cancelamento
Content-Type: application/json
X-API-Key: sua-chave-secreta (opcional)

{
  "_id": "65f1234567890abcdef12345",
  "cliente_nome": "João Silva",
  "cliente_telefone": "+5511987654321",
  "data_hora": "2026-02-10T14:00:00Z",
  "servico": "Corte + Barba",
  "motivo": "Imprevisto pessoal - viagem inesperada"
}
```

### Response

```json
{
  "success": true,
  "message": "Agendamento cancelado",
  "data": {
    "_id": "65f1234567890abcdef12345",
    "status": "cancelado",
    "cancelado_em": "2026-02-04T10:15:00.000Z",
    "motivo_cancelamento": "Imprevisto pessoal - viagem inesperada"
  }
}
```

### Exemplo cURL

```bash
curl -X POST https://seu-n8n.com/webhook/cancelamento \
  -H "Content-Type: application/json" \
  -H "X-API-Key: sua-chave-secreta" \
  -d '{
    "_id": "65f1234567890abcdef12345",
    "cliente_nome": "João Silva",
    "cliente_telefone": "+5511987654321",
    "data_hora": "2026-02-10T14:00:00Z",
    "servico": "Corte + Barba",
    "motivo": "Imprevisto pessoal - viagem inesperada"
  }'
```

### Exemplo JavaScript

```typescript
async function cancelarAgendamento(agendamentoId: string, motivo: string) {
  // Primeiro, buscar dados do agendamento
  const agendamento = await buscarAgendamento(agendamentoId);
  
  const response = await fetch('https://seu-n8n.com/webhook/cancelamento', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': 'sua-chave-secreta',
    },
    body: JSON.stringify({
      _id: agendamento._id,
      cliente_nome: agendamento.cliente_nome,
      cliente_telefone: agendamento.cliente_telefone,
      data_hora: agendamento.data_hora,
      servico: agendamento.servico,
      motivo: motivo
    })
  });
  
  return await response.json();
}
```

---

## 3️⃣ Gerar Relatório Diário

### Request

```http
POST https://seu-n8n.com/webhook/relatorio-diario
Content-Type: application/json
X-API-Key: sua-chave-secreta (opcional)

{}
```

### Response

```json
{
  "success": true,
  "message": "Relatório gerado",
  "data": [
    {
      "_id": "confirmado",
      "total": 12,
      "valor_total": 600.00
    },
    {
      "_id": "cancelado",
      "total": 2,
      "valor_total": 100.00
    }
  ],
  "resumo": {
    "data": "2026-02-03",
    "total_agendamentos": 14,
    "confirmados": 12,
    "cancelados": 2,
    "receita_total": 600.00,
    "receita_cancelada": 100.00
  }
}
```

### Exemplo cURL

```bash
curl -X POST https://seu-n8n.com/webhook/relatorio-diario \
  -H "Content-Type: application/json" \
  -H "X-API-Key: sua-chave-secreta" \
  -d '{}'
```

---

## 4️⃣ Exemplos de Consultas MongoDB

### Buscar Agendamentos por Cliente

```javascript
db.agendamentos.find({
  "cliente_telefone": "+5511987654321"
}).sort({ "data_hora": -1 })
```

### Buscar Agendamentos do Dia

```javascript
const hoje = new Date();
hoje.setHours(0, 0, 0, 0);

const amanha = new Date(hoje);
amanha.setDate(amanha.getDate() + 1);

db.agendamentos.find({
  "data_hora": {
    "$gte": hoje,
    "$lt": amanha
  },
  "status": "confirmado"
}).sort({ "data_hora": 1 })
```

### Relatório de Performance por Barbeiro

```javascript
db.agendamentos.aggregate([
  {
    $match: {
      "data_hora": {
        $gte: new Date("2026-02-01"),
        $lt: new Date("2026-03-01")
      },
      "status": "confirmado"
    }
  },
  {
    $group: {
      _id: "$barbeiro",
      total_atendimentos: { $sum: 1 },
      receita_total: { $sum: "$valor" },
      ticket_medio: { $avg: "$valor" }
    }
  },
  {
    $sort: { receita_total: -1 }
  }
])
```

### Análise de Cancelamentos

```javascript
db.agendamentos.aggregate([
  {
    $match: {
      "status": "cancelado",
      "cancelado_em": {
        $gte: new Date("2026-02-01")
      }
    }
  },
  {
    $group: {
      _id: "$motivo_cancelamento",
      total: { $sum: 1 }
    }
  },
  {
    $sort: { total: -1 }
  }
])
```

---

## 📊 Casos de Uso Completos

### Caso 1: Sistema de Agendamento Online

```typescript
// Frontend React Component
import { useState } from 'react';

export function AgendamentoForm() {
  const [formData, setFormData] = useState({
    nome: '',
    telefone: '',
    email: '',
    servico: 'Corte Masculino',
    barbeiro: '',
    data: '',
    horario: '',
    observacoes: ''
  });

  const servicos = [
    { nome: 'Corte Masculino', valor: 40.00 },
    { nome: 'Corte + Barba', valor: 50.00 },
    { nome: 'Apenas Barba', valor: 30.00 },
    { nome: 'Corte Infantil', valor: 30.00 },
    { nome: 'Platinado', valor: 150.00 }
  ];

  const barbeiros = [
    'Carlos Eduardo',
    'João Pedro',
    'Ricardo Santos',
    'Fernando Lima'
  ];

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    const servicoSelecionado = servicos.find(s => s.nome === formData.servico);
    const dataHora = new Date(`${formData.data}T${formData.horario}:00`);
    
    try {
      const response = await fetch('https://seu-n8n.com/webhook/agendamento', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': process.env.REACT_APP_N8N_API_KEY
        },
        body: JSON.stringify({
          nome: formData.nome,
          telefone: formData.telefone,
          email: formData.email,
          servico: formData.servico,
          barbeiro: formData.barbeiro,
          data_hora: dataHora.toISOString(),
          valor: servicoSelecionado.valor,
          observacoes: formData.observacoes
        })
      });
      
      if (response.ok) {
        alert('Agendamento confirmado! Você receberá uma confirmação no WhatsApp.');
        // Reset form
        setFormData({
          nome: '', telefone: '', email: '', servico: 'Corte Masculino',
          barbeiro: '', data: '', horario: '', observacoes: ''
        });
      } else {
        alert('Erro ao agendar. Por favor, tente novamente.');
      }
    } catch (error) {
      console.error('Erro:', error);
      alert('Erro de conexão. Verifique sua internet.');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="agendamento-form">
      {/* Form fields aqui */}
      <button type="submit">Confirmar Agendamento</button>
    </form>
  );
}
```

### Caso 2: Painel Administrativo

```typescript
// Dashboard de Gerência
export function Dashboard() {
  const [stats, setStats] = useState(null);
  
  useEffect(() => {
    async function carregarDados() {
      // Buscar estatísticas via API do MongoDB ou endpoint customizado
      const response = await fetch('https://seu-n8n.com/webhook/relatorio-diario');
      const data = await response.json();
      setStats(data);
    }
    
    carregarDados();
    
    // Atualizar a cada 5 minutos
    const interval = setInterval(carregarDados, 5 * 60 * 1000);
    return () => clearInterval(interval);
  }, []);
  
  return (
    <div className="dashboard">
      <h1>Dashboard - Barbearia Premium</h1>
      
      {stats && (
        <div className="stats-grid">
          <div className="stat-card">
            <h3>Agendamentos Hoje</h3>
            <p className="stat-value">{stats.resumo.total_agendamentos}</p>
          </div>
          
          <div className="stat-card">
            <h3>Confirmados</h3>
            <p className="stat-value">{stats.resumo.confirmados}</p>
          </div>
          
          <div className="stat-card">
            <h3>Cancelados</h3>
            <p className="stat-value">{stats.resumo.cancelados}</p>
          </div>
          
          <div className="stat-card">
            <h3>Receita do Dia</h3>
            <p className="stat-value">R$ {stats.resumo.receita_total.toFixed(2)}</p>
          </div>
        </div>
      )}
    </div>
  );
}
```

### Caso 3: Bot de WhatsApp para Agendamento

```python
# Bot simples usando Twilio
from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse
import requests
import re

app = Flask(__name__)

@app.route("/whatsapp", methods=['POST'])
def whatsapp_bot():
    incoming_msg = request.values.get('Body', '').lower()
    resp = MessagingResponse()
    msg = resp.message()
    
    # Comando: agendar
    if 'agendar' in incoming_msg:
        msg.body("""
        📅 *Fazer Agendamento*
        
        Por favor, envie no formato:
        AGENDAR [Nome] | [Serviço] | [Data DD/MM] | [Hora HH:MM]
        
        Exemplo:
        AGENDAR João Silva | Corte + Barba | 10/02 | 14:00
        
        Serviços disponíveis:
        • Corte Masculino - R$ 40
        • Corte + Barba - R$ 50
        • Apenas Barba - R$ 30
        • Corte Infantil - R$ 30
        """)
    
    # Processar agendamento
    elif incoming_msg.startswith('agendar '):
        try:
            # Parse da mensagem
            parts = incoming_msg.replace('agendar ', '').split('|')
            nome = parts[0].strip()
            servico = parts[1].strip()
            data = parts[2].strip()
            hora = parts[3].strip()
            
            telefone = request.values.get('From', '')
            
            # Criar agendamento via n8n
            response = requests.post(
                'https://seu-n8n.com/webhook/agendamento',
                json={
                    'nome': nome,
                    'telefone': telefone,
                    'email': f'{telefone}@whatsapp.com',
                    'servico': servico,
                    'barbeiro': 'A definir',
                    'data_hora': f'2026-{data} {hora}:00',
                    'valor': 50.00,
                    'observacoes': 'Agendado via WhatsApp Bot'
                }
            )
            
            if response.status_code == 200:
                msg.body(f"✅ Agendamento confirmado para {nome}!\n\n📅 {data} às {hora}\n✂️ {servico}\n\nNos vemos em breve!")
            else:
                msg.body("❌ Erro ao agendar. Tente novamente ou ligue para (11) 99999-9999")
                
        except Exception as e:
            msg.body("❌ Formato inválido. Use:\nAGENDAR [Nome] | [Serviço] | [Data] | [Hora]")
    
    # Comando: cancelar
    elif 'cancelar' in incoming_msg:
        msg.body("Para cancelar, ligue para (11) 99999-9999 ou envie email para contato@barbearia.com")
    
    # Menu padrão
    else:
        msg.body("""
        👋 Olá! Bem-vindo à *Barbearia Premium*
        
        Comandos disponíveis:
        • Digite *AGENDAR* para fazer um agendamento
        • Digite *CANCELAR* para cancelar
        • Digite *HORARIOS* para ver disponibilidade
        
        Ou ligue: (11) 99999-9999
        """)
    
    return str(resp)

if __name__ == "__main__":
    app.run(debug=True)
```

---

## 🧪 Testes Automatizados

### Teste com Jest (JavaScript)

```javascript
// agendamento.test.js
const { criarAgendamento } = require('./api/agendamento');

describe('API de Agendamento', () => {
  test('Deve criar agendamento com sucesso', async () => {
    const dados = {
      nome: 'Teste Silva',
      telefone: '+5511999999999',
      email: 'teste@test.com',
      servico: 'Corte Masculino',
      barbeiro: 'João',
      data_hora: '2026-02-10T14:00:00Z',
      valor: 40.00,
      observacoes: 'Teste'
    };
    
    const resultado = await criarAgendamento(dados);
    
    expect(resultado.success).toBe(true);
    expect(resultado.data.cliente_nome).toBe('Teste Silva');
    expect(resultado.data.status).toBe('confirmado');
  });
  
  test('Deve rejeitar agendamento sem dados obrigatórios', async () => {
    const dados = {
      nome: 'Teste Silva'
      // Faltam campos obrigatórios
    };
    
    await expect(criarAgendamento(dados)).rejects.toThrow();
  });
});
```

---

**Última atualização:** 03 de Fevereiro de 2026  
**Desenvolvido por:** [Autonomousia](https://github.com/autonomousia25-hue)
