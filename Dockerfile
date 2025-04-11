FROM node:slim
WORKDIR /app
COPY . .
RUN npm ci
CMD ["npm", "start"]