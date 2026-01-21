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
- **Repository Pattern**: Abstração da camada de dados com interfaces
- **Service Locator Pattern**: Injeção de dependências usando GetIt
- **Strategy Pattern**: Implementação de serviços através de interfaces
- **Orientação a Objetos**: Implementação completa com classes e herança

### Estrutura do Projeto
```
lib/
├── config/                 # Configurações da aplicação
│   ├── app.config.dart    # Configuração principal do MaterialApp
│   ├── injection.dart     # Configuração de injeção de dependências (GetIt)
│   └── routes.config.dart # Definição de rotas
├── constants/             # Constantes da aplicação
│   ├── colors.constants.dart
│   └── urls.constants.dart
├── features/              # Funcionalidades por módulo
│   ├── details/           # Tela de detalhes
│   │   ├── view/
│   │   └── viewmodel/
│   ├── home/             # Tela inicial
│   │   ├── view/
│   │   └── viewmodel/
│   └── users/            # Tela de usuários persistidos
│       ├── view/
│       └── viewmodel/
├── shared/               # Componentes compartilhados
│   ├── exceptions/       # Exceções customizadas
│   ├── models/           # Modelos de dados
│   ├── repositories/     # Repositórios (abstração de dados)
│   ├── services/         # Serviços (API, Storage, Navigation)
│   └── widgets/          # Widgets reutilizáveis
└── main.dart            # Ponto de entrada
```

## 🛠️ Tecnologias Utilizadas

### Dependências Principais
- **Flutter SDK**: ^3.9.2
- **HTTP**: ^1.5.0 - Para requisições à API
- **SharedPreferences**: ^2.5.3 - Para persistência local
- **GetIt**: ^8.0.0 - Para injeção de dependências
- **Cupertino Icons**: ^1.0.8 - Ícones do iOS

### Dependências de Desenvolvimento
- **Flutter Lints**: ^6.0.0 - Para análise estática de código
- **Mocktail**: ^1.0.0 - Para criação de mocks nos testes

### Controle de Estado e Injeção de Dependências
- **ChangeNotifier**: Implementação nativa do Flutter para gerenciamento de estado
- **GetIt**: Sistema de injeção de dependências (Service Locator Pattern)
- **ListenableBuilder**: Para escutar mudanças nos ViewModels

## 📊 Modelos de Dados

### UserModel
Modelo principal que representa um usuário com todos os campos da API:
- Informações pessoais (nome, gênero, nacionalidade)
- Localização (endereço, coordenadas)
- Dados de contato (email, telefone)
- Informações de login e identificação
- Fotos e dados de registro

### Modelos Auxiliares
- **ApiResponseModel**: Modelo de resposta da API Random User
- **NameModel**: Nome completo do usuário
- **LocationModel**: Endereço e coordenadas
- **LoginModel**: Credenciais e UUID
- **PictureModel**: URLs das fotos
- **DobModel**: Data de nascimento
- **RegisteredModel**: Data de registro
- **IdModel**: Identificadores alternativos

### Estrutura de Persistência
- **Formato**: JSON serializado
- **Armazenamento**: SharedPreferences
- **Chave**: `saved_users_list`
- **Operações**: CRUD completo (Create, Read, Update, Delete)

## 🔧 Serviços e Repositórios

### Serviços
- **UserService**: Comunicação com a API Random User
- **StorageService**: Gerenciamento de persistência de usuários
- **PersistenceService**: Interface para persistência (SharedPreferences)
- **SelectedUserService**: Gerenciamento do usuário selecionado para navegação
- **NavigationService**: Centralização da navegação entre telas

### Repositórios
- **UserRepository**: Abstração para obtenção de usuários da API
- **UserStorageRepository**: Abstração para persistência local de usuários

### Sistema de Exceções
- **RepositoryException**: Exceção base para erros de repositório
- **UserRepositoryException**: Exceções específicas do repositório de API
- **UserStorageRepositoryException**: Exceções específicas do repositório de storage

## 🔄 Fluxo de Dados

1. **Inicialização**: GetIt configura todas as dependências no `main.dart`
2. **Requisição**: Ticker dispara requisição a cada 5 segundos na tela inicial
3. **Parsing**: JSON da API é convertido para UserModel através do UserService
4. **Exibição**: Dados são exibidos na interface através dos ViewModels
5. **Navegação**: SelectedUserService gerencia o usuário selecionado entre telas
6. **Persistência**: Usuários podem ser salvos/removidos localmente via StorageService
7. **Sincronização**: Mudanças são refletidas em tempo real através do ChangeNotifier

## 🏛️ Injeção de Dependências

O projeto utiliza **GetIt** para gerenciamento de dependências:

- **Singletons**: SharedPreferences, SelectedUserService
- **Lazy Singletons**: Serviços e Repositórios (criados sob demanda, mas únicos)
- **Factories**: ViewModels (nova instância a cada acesso)

Todas as dependências são configuradas no arquivo `lib/config/injection.dart` e inicializadas antes do `runApp()`.

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

# Executar testes com cobertura
flutter test --coverage

# Build para produção
flutter build apk --release
```

### Plataformas Suportadas
- **Android**

## 🧪 Testes

O projeto possui uma suíte completa de testes unitários cobrindo:

### Estrutura de Testes
```
test/
├── exceptions/          # Testes de exceções customizadas
├── helpers/            # Utilitários para testes (loggers, etc)
├── models/             # Testes dos modelos de dados
├── repositories/       # Testes dos repositórios
├── services/           # Testes dos serviços
└── viewmodels/         # Testes dos ViewModels
```

### Cobertura de Testes
- ✅ Modelos de dados (UserModel, ApiResponseModel, LoginModel)
- ✅ Repositórios (UserRepository, UserStorageRepository)
- ✅ Serviços (UserService, StorageService, SelectedUserService)
- ✅ ViewModels (HomeViewModel, DetailsViewModel, UsersViewModel)
- ✅ Exceções customizadas

### Executando Testes
```bash
# Executar todos os testes
flutter test

# Executar teste específico
flutter test test/viewmodels/home_viewmodel_test.dart

# Executar com cobertura
flutter test --coverage
```

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
