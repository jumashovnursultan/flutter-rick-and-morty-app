# Rick and Morty Character Browser

Мобильное приложение на Flutter для просмотра персонажей из мультсериала "Рик и Морти" с использованием публичного API.

## 🎯 Функционал

- **Список персонажей** с пагинацией при скролле
- **Избранное** с возможностью добавления/удаления персонажей
- **Сортировка избранных** по имени, статусу или виду
- **Оффлайн режим** - кеширование данных в локальной БД
- **Темная тема** с переключателем
- **Анимации** при добавлении/удалении из избранного

## 🏗️ Архитектура

Проект реализован с использованием **Clean Architecture** и **Layer-First** подхода:
```
lib/
├── core/           # Константы, темы, утилиты
├── domain/         # Entities, UseCases, Repository интерфейсы
├── data/           # Models, DataSources, Repository реализации
└── presentation/   # Providers, Screens, Widgets
```

## 🛠️ Технологии

- **State Management:** Riverpod 3.0.3
- **Networking:** Dio 5.9.0
- **Database:** Drift 2.29.0 (SQLite)
- **Image Caching:** Cached Network Image 3.4.1
- **Code Generation:** build_runner

## 📋 Требования

- **Flutter SDK:** 3.22.0 или выше
- **Dart SDK:** 3.9.2 или выше

## 🚀 Установка и запуск

### 1. Клонируйте репозиторий
```bash
git clone <repository-url>
cd rick_and_morty_app
```

### 2. Установите зависимости
```bash
flutter pub get
```

### 3. Запустите кодогенерацию
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Запустите приложение
```bash
flutter run
```

## 📦 Основные зависимости
```yaml
dependencies:
  flutter_riverpod: ^3.0.3      # State management
  dio: ^5.9.0                    # HTTP клиент
  drift: ^2.29.0                 # SQLite ORM
  cached_network_image: ^3.4.1  # Кеширование изображений
  path_provider: ^2.1.5          # Доступ к файловой системе
  equatable: ^2.0.7              # Сравнение объектов

dev_dependencies:
  build_runner: ^2.4.0           # Кодогенерация
  drift_dev: ^2.29.0             # Генерация БД кода
  flutter_lints: ^5.0.0          # Линтер
```

## 🌐 API

Приложение использует [Rick and Morty API](https://rickandmortyapi.com/documentation)

- **Base URL:** `https://rickandmortyapi.com/api`
- **Endpoint:** `/character` с поддержкой пагинации

## 🗂️ Структура БД

**Таблица Characters (кеш):**
- Полные данные всех загруженных персонажей
- Используется для оффлайн режима

**Таблица Favorites:**
- ID избранных персонажей
- Дата добавления


## 📱 Скриншоты

![Главный экран](https://i.imgur.com/abcd123.png)
![Избранное](https://i.imgur.com/efgh456.png)
![Темная тема](https://i.imgur.com/ijkl789.png)