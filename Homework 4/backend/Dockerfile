FROM node:10

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY ./backend .

COPY certificate.crt .
COPY private.key .
COPY dhparams.pem .

EXPOSE 5000

ENTRYPOINT ["npm", "start"]