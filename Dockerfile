FROM node:18 AS build

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build
RUN npm install --omit=dev --legacy-peer-deps && npm cache clean --force

FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./dist/node_modules


EXPOSE 3000

CMD ["npm", "run", "start:prod"]