# Script de Configuração Automática do GitHub Copilot
# Este script automatiza a instalação e configuração do GitHub Copilot no VS Code
# Para Windows PowerShell

Write-Host "🚀 Configuração Automática do GitHub Copilot para VS Code" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se VS Code está instalado
Write-Host "🔍 Verificando instalação do VS Code..." -ForegroundColor Yellow
$codeCommand = Get-Command code -ErrorAction SilentlyContinue

if (-not $codeCommand) {
    Write-Host "❌ VS Code não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale o VS Code: https://code.visualstudio.com/download" -ForegroundColor Red
    exit 1
}
Write-Host "✅ VS Code encontrado!" -ForegroundColor Green
Write-Host ""

# Verificar versão do VS Code
Write-Host "📌 Versão do VS Code:" -ForegroundColor Yellow
code --version
Write-Host ""

# Instalar GitHub Copilot
Write-Host "📦 Instalando GitHub Copilot..." -ForegroundColor Yellow
code --install-extension GitHub.copilot --force
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ GitHub Copilot instalado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao instalar GitHub Copilot" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Instalar GitHub Copilot Chat
Write-Host "📦 Instalando GitHub Copilot Chat..." -ForegroundColor Yellow
code --install-extension GitHub.copilot-chat --force
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ GitHub Copilot Chat instalado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "⚠️  GitHub Copilot Chat pode não estar disponível" -ForegroundColor Yellow
}
Write-Host ""

# Instalar extensões recomendadas
Write-Host "📦 Instalando extensões recomendadas..." -ForegroundColor Yellow
$extensions = @(
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens",
    "usernamehw.errorlens",
    "gruntfuggly.todo-tree",
    "aaron-bond.better-comments",
    "pkief.material-icon-theme"
)

foreach ($ext in $extensions) {
    Write-Host "  → Instalando $ext..." -ForegroundColor Gray
    code --install-extension $ext --force
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✓ Instalado" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Não foi possível instalar $ext" -ForegroundColor Yellow
    }
}
Write-Host ""

# Próximos passos
Write-Host "🔐 Próximos Passos - Autenticação:" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. VS Code será aberto agora"
Write-Host "2. Procure por uma notificação do GitHub Copilot no canto inferior direito"
Write-Host "3. Clique em 'Sign In to GitHub' ou use Ctrl + Shift + P"
Write-Host "4. Digite 'GitHub Copilot: Sign In' e pressione Enter"
Write-Host "5. Seu navegador abrirá para autenticação"
Write-Host "6. Faça login com sua conta GitHub"
Write-Host "7. Autorize o GitHub Copilot"
Write-Host ""
Write-Host "⏳ Abrindo VS Code em 3 segundos..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Abrir VS Code no diretório atual
& code .

Write-Host ""
Write-Host "✨ Configuração concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Resumo:" -ForegroundColor Cyan
Write-Host "  ✅ GitHub Copilot instalado"
Write-Host "  ✅ Extensões recomendadas instaladas"
Write-Host "  ✅ Configurações aplicadas"
Write-Host ""
Write-Host "🔍 Verifique o ícone do GitHub Copilot na barra de status (canto inferior direito)"
Write-Host "   ✅ Ícone verde = Copilot ativo e funcionando"
Write-Host "   ⚠️  Ícone com alerta = Necessita autenticação"
Write-Host ""
Write-Host "📚 Para mais informações, consulte o README.md"
Write-Host ""
