#  Letterboxd Clone

Aplicativo mobile desenvolvido em **Flutter** inspirado na experiência do **Letterboxd**, permitindo que usuários descubram, acompanhem e avaliem filmes e séries. O projeto foi desenvolvido como atividade prática da disciplina de Desenvolvimento Mobile, com foco em **interface gráfica**, **componentização**, **navegação entre telas** e **gerenciamento de estado**.

---

##  Objetivo

Criar um aplicativo para cinéfilos contendo três telas principais:

* **Feed** – avaliações recentes da comunidade.
* **Descobrir** – busca e exploração de filmes e séries.
* **Perfil** – informações do usuário e filmes avaliados.

O aplicativo utiliza uma barra de navegação inferior para alternar livremente entre as telas e organiza seus dados por meio de listas locais, sem necessidade de API externa.

---

##  Funcionalidades

###  Feed

* Barra superior com logotipo/nome do aplicativo.
* Ícone de ações rápidas.
* Seção de destaques da semana com rolagem horizontal.
* Lista de avaliações recentes da comunidade.
* Exibição de:

  * Foto e nome do usuário.
  * Pôster do filme.
  * Nota em estrelas.
  * Comentário.
  * Botões de interação.
* Sistema de curtidas com atualização em tempo real.

###  Descobrir

* Campo de busca para filmes e séries.
* Grade responsiva de pôsteres.
* Filtragem de resultados a partir dos dados locais.

###  Perfil

* Foto de perfil.
* Nome de usuário.
* Biografia.
* Estatísticas:

  * Filmes assistidos.
  * Seguidores.
  * Seguindo.
* Botão de edição de perfil.
* Grade com filmes avaliados.

---

##  Telas do Aplicativo

| Tela      | Descrição                                         |
| --------- | ------------------------------------------------- |
| Feed      | Exibe avaliações recentes e destaques da semana.  |
| Descobrir | Permite pesquisar e explorar filmes e séries.     |
| Perfil    | Mostra informações do usuário e filmes avaliados. |

---

## 🛠️ Tecnologias Utilizadas

* Flutter
* Dart
* Material Design 3
* Stateful Widgets
* Navigator / BottomNavigationBar

---

##  Componentes Reutilizáveis

Para facilitar a manutenção e organização do código, a interface foi dividida em componentes reutilizáveis:

* **ReviewCard** – cartão de avaliação.
* **HighlightMovieCard** – item dos destaques da semana.
* **MovieGridItem** – item da grade de filmes.
* **ProfileHeader** – cabeçalho do perfil.
* **BottomNavBar** – barra de navegação inferior.

---

##  Estrutura do Projeto

```text
lib/
│
├── main.dart
│
├── screens/
│   ├── feed_screen.dart
│   ├── discover_screen.dart
│   └── profile_screen.dart
│
├── widgets/
│   ├── review_card.dart
│   ├── highlight_movie_card.dart
│   ├── movie_grid_item.dart
│   ├── profile_header.dart
│   └── bottom_nav_bar.dart
│
├── models/
│   ├── movie.dart
│   ├── review.dart
│   └── user_profile.dart
│
└── data/
    ├── movies_data.dart
    ├── reviews_data.dart
    └── profile_data.dart
```

---

##  Como Executar

### Pré-requisitos

* Flutter SDK instalado
* Android Studio ou VS Code
* Emulador Android/iOS ou dispositivo físico

### Instalação

```bash
git clone <repositorio>
cd letterboxd_clone
flutter pub get
```

### Executando o projeto

```bash
flutter run
```

### Gerando APK

```bash
flutter build apk --release
```

---

##  Conceitos Aplicados

* Navegação entre múltiplas telas.
* Componentização e reutilização de widgets.
* Manipulação de listas e coleções.
* Gerenciamento de estado local.
* Layouts responsivos.
* Organização de código em camadas.

---

##  Dados Utilizados

Os dados exibidos no aplicativo são armazenados localmente em listas dentro do projeto:

* Filmes
* Avaliações
* Destaques
* Perfil do usuário

As imagens dos pôsteres podem ser carregadas por URLs públicas ou arquivos locais adicionados à pasta `assets`.

---

##  Autor

Projeto desenvolvido como atividade prática da disciplina de Flutter, inspirado na plataforma Letterboxd.

**Ana Aleixo e**
**Manuela Catarina**
