# ИграйУчи

Веб-приложение для управления цифровым обучением с элементами игрофикации.

## Почему и зачем?

### Проблема
В настоящее время наблюдение за тем, что темп жизни становится всё быстрее, изменения и открытия в различных областях жизнедеятельности происходят всё чаще, приводит всё большее число людей к идее того, что современному человеку необходимо учиться на протяжении всей его жизни, чтобы соответствовать профессиональным потребностям.
Если процесс обучения становится частью жизни человека, то нужно постараться сделать эту часть жизни более интересной и привлекательной.
### Средства
Один из современных способов повысить интерес и мотивировать человека заниматься определённой деятельностью является игрофикация.
### Цели
- Дать разработчикам курсов инструмент для создания игрофицированного процесса обучения
- Повысить мотивацию и интерес к процессу обучения у пользователя системы

## Установка

#### 1. Установить postgresql
Разработка велась с использованием postgres 10.x

#### 2. Клонировать
```
git clone https://github.com/rusdec/ilms
```

#### 3. Сконфигурировать config/database.yml
Пример:

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: ilms_development

test:
  <<: *default
  database: ilms_test

production:
  <<: *default
  database: ilms_production
```
#### 4. Создать БД вручную
Из-за [ошибки](https://github.com/pushtype/push_type/issues/47) в работе гема [closure_tree](https://github.com/ClosureTree/closure_tree) с [rails](https://github.com/rails/rails) версии 2.5.x, необходимо вручную создать базы данных, указанные вами в config/database.yml

Пример:

```
psql --command='create database ilms_development' postgres
psql --command='create database ilms_test' postgres
psql --command='create database ilms_production' postgres

```

#### 5. Установить приложение (гемы, миграции)
```
bin/setup

```

#### 6. Создать администратора
```
rails g ilms:administrator --email <эл.почта> --password <пароль>
```