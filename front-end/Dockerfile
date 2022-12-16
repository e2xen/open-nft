FROM node:14-alpine as vue-build

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY ./ .

EXPOSE 8080
CMD ["npm", "run", "serve"]