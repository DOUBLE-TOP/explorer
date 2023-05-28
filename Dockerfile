# Мультистейдж для сборки и запуска React веб-сайта
# Стадия 1: Сборка фронтенда
FROM node:18-alpine AS builder

WORKDIR /app

# Копирование зависимостей
COPY package.json yarn.lock /app/

# Установка зависимостей
RUN yarn

# Копирование остальных файлов проекта
COPY . /app/

# Сборка и оптимизация фронтенда
RUN yarn build-only

# Стадия 2: Запуск веб-сайта с использованием Nginx
FROM nginx:alpine

# Копирование собранного фронтенда из предыдущей стадии
COPY --from=builder /app/dist /usr/share/nginx/html

# Копирование файла конфигурации Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открытие порта для доступа к веб-сайту
EXPOSE 80

# Запуск Nginx
CMD ["nginx", "-g", "daemon off;"]
