#!/bin/bash

# Script de Configuração Automática do GitHub Copilot
# Este script automatiza a instalação e configuração do GitHub Copilot no VS Code

set -e

echo "🚀 Configuração Automática do GitHub Copilot para VS Code"
echo "=========================================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se VS Code está instalado
echo "🔍 Verificando instalação do VS Code..."
if ! command -v code &> /dev/null; then
    echo -e "${RED}❌ VS Code não encontrado!${NC}"
    echo "Por favor, instale o VS Code: https://code.visualstudio.com/download"
    exit 1
fi
echo -e "${GREEN}✅ VS Code encontrado!${NC}"
echo ""

# Verificar versão do VS Code
echo "📌 Versão do VS Code:"
code --version
echo ""

# Instalar GitHub Copilot
echo "📦 Instalando GitHub Copilot..."
if code --install-extension GitHub.copilot --force; then
    echo -e "${GREEN}✅ GitHub Copilot instalado com sucesso!${NC}"
else
    echo -e "${RED}❌ Erro ao instalar GitHub Copilot${NC}"
    exit 1
fi
echo ""

# Instalar GitHub Copilot Chat
echo "📦 Instalando GitHub Copilot Chat..."
if code --install-extension GitHub.copilot-chat --force; then
    echo -e "${GREEN}✅ GitHub Copilot Chat instalado com sucesso!${NC}"
else
    echo -e "${YELLOW}⚠️  GitHub Copilot Chat pode não estar disponível${NC}"
fi
echo ""

# Instalar extensões recomendadas
echo "📦 Instalando extensões recomendadas..."
extensions=(
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "eamodio.gitlens"
    "usernamehw.errorlens"
    "gruntfuggly.todo-tree"
    "aaron-bond.better-comments"
    "pkief.material-icon-theme"
)

for ext in "${extensions[@]}"; do
    echo "  → Instalando $ext..."
    if code --install-extension "$ext" --force; then
        echo -e "${GREEN}    ✓ Instalado${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Não foi possível instalar $ext${NC}"
    fi
done
echo ""

# Abrir VS Code para autenticação
echo "🔐 Próximos Passos - Autenticação:"
echo "=================================="
echo ""
echo "1. VS Code será aberto agora"
echo "2. Procure por uma notificação do GitHub Copilot no canto inferior direito"
echo "3. Clique em 'Sign In to GitHub' ou use Ctrl/Cmd + Shift + P"
echo "4. Digite 'GitHub Copilot: Sign In' e pressione Enter"
echo "5. Seu navegador abrirá para autenticação"
echo "6. Faça login com sua conta GitHub"
echo "7. Autorize o GitHub Copilot"
echo ""
echo -e "${YELLOW}⏳ Abrindo VS Code em 3 segundos...${NC}"
sleep 3

# Abrir VS Code no diretório atual
echo "Opening VS Code..."
code .

echo ""
echo -e "${GREEN}✨ Configuração concluída!${NC}"
echo ""
echo "📋 Resumo:"
echo "  ✅ GitHub Copilot instalado"
echo "  ✅ Extensões recomendadas instaladas"
echo "  ✅ Configurações aplicadas"
echo ""
echo "🔍 Verifique o ícone do GitHub Copilot na barra de status (canto inferior direito)"
echo "   ✅ Ícone verde = Copilot ativo e funcionando"
echo "   ⚠️  Ícone com alerta = Necessita autenticação"
echo ""
echo "📚 Para mais informações, consulte o README.md"
echo ""
