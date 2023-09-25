FROM node:alpine3.14 AS build

WORKDIR /app

RUN npm cache clean --force

COPY . .
RUN npm install --force
RUN npm run build --prod



### STAGE 2:RUN ###
FROM nginx:latest AS ngi
 
COPY --from=build /app/dist/ecommerce-store /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf

EXPOSE 80