# Desafio Técnico Bus2 - Aplicativo Flutter

## 📱 Sobre o Projeto

Este é um aplicativo Flutter desenvolvido como parte do desafio técnico da Bus2. O aplicativo consome dados da API pública [Random User](https://randomuser.me/) e implementa um sistema completo de gerenciamento de usuários com persistência local.

## 🎯 Funcionalidades

### ✅ Tela Inicial
- **Requisições automáticas**: Utiliza `Ticker` para fazer requisições à API a cada 5 segundos
- **Lista de usuários**: Exibe informações básicas dos usuários obtidos
- **Navegação**: Cada item da lista é clicável e redireciona para detalhes
- **Botão de banco de dados**: Acesso direto à tela de usuários persistidos

### ✅ Tela de Detalhes
- **Informações completas**: Exibe todos os dados do usuário organizados por grupos
- **Persistência**: Botão para salvar/remover usuário dos persistidos
- **Interface organizada**: Detalhes agrupados conforme modelo da API

### ✅ Tela de Usuários Persistidos
- **Lista persistida**: Exibe todos os usuários salvos localmente
- **Gerenciamento**: Permite remover usuários da persistência
- **Navegação**: Acesso aos detalhes de cada usuário persistido
- **Sincronização**: Garante que remoções sejam refletidas na lista

## 🏗️ Arquitetura

### Padrões Implementados
- **MVVM (Model-View-ViewModel)**: Separação clara entre lógica de negócio e interface
- **Repository Strategy**: Abstração da camada de dados
- **Orientação a Objetos**: Implementação completa com classes e herança

### Estrutura do Projeto
```
lib/
├── config/                 # Configurações da aplicação
│   ├── app.config.dart    # Configuração principal
│   └── routes.config.dart # Definição de rotas
├── constants/             # Constantes da aplicação
│   ├── colors.constants.dart
│   └── urls.constants.dart
├── features/              # Funcionalidades por módulo
│   ├── details/           # Tela de detalhes
│   ├── home/             # Tela inicial
│   └── users/            # Tela de usuários persistidos
├── shared/               # Componentes compartilhados
│   ├── models/           # Modelos de dados
│   ├── services/         # Serviços (API e Storage)
│   └── widgets/          # Widgets reutilizáveis
└── main.dart            # Ponto de entrada
```

## 🛠️ Tecnologias Utilizadas

### Dependências Principais
- **Flutter SDK**: ^3.9.2
- **HTTP**: ^1.5.0 - Para requisições à API
- **SharedPreferences**: ^2.5.3 - Para persistência local
- **Cupertino Icons**: ^1.0.8 - Ícones do iOS

### Controle de Estado
- **ChangeNotifier**: Implementação nativa do Flutter para gerenciamento de estado
- **Provider Pattern**: Para injeção de dependências e notificação de mudanças

## 📊 Modelos de Dados

### UserModel
Modelo principal que representa um usuário com todos os campos da API:
- Informações pessoais (nome, gênero, nacionalidade)
- Localização (endereço, coordenadas)
- Dados de contato (email, telefone)
- Informações de login e identificação
- Fotos e dados de registro

### Estrutura de Persistência
- **Formato**: JSON serializado
- **Armazenamento**: SharedPreferences
- **Chave**: `saved_users_list`
- **Operações**: CRUD completo (Create, Read, Update, Delete)

## 🔄 Fluxo de Dados

1. **Requisição**: Ticker dispara requisição a cada 5 segundos
2. **Parsing**: JSON da API é convertido para UserModel
3. **Exibição**: Dados são exibidos na interface
4. **Persistência**: Usuários podem ser salvos/removidos localmente
5. **Sincronização**: Mudanças são refletidas em tempo real

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.9.2 ou superior
- Dart SDK compatível
- Android Studio / VS Code com extensão Flutter

### Instalação
```bash
# Clone o repositório
git clone [URL_DO_REPOSITORIO]

# Navegue para o diretório
cd desafio_tecnico_bus2

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

### Comandos Úteis
```bash
# Limpar cache
flutter clean

# Atualizar dependências
flutter pub upgrade

# Executar testes
flutter test

# Build para produção
flutter build apk --release
```

### Plataformas Suportadas
- **Android**
- **Web**

## 🚀 Deploy

### Build para Produção
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

---

**Desenvolvido para o desafio técnico da Bus2**
