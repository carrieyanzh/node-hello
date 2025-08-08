FROM node:20

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

USER node

EXPOSE 3000

ENV NEW_RELIC_LICENSE_KEY=${NEW_RELIC_LICENSE_KEY}

CMD ["npm", "start"]