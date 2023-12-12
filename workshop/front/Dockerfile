FROM node:latest as Build

WORKDIR /frontend

COPY . .

RUN npm version

RUN npm install

RUN npm run build

FROM node:latest as Run

WORKDIR /frontend

## quick hack tu run the server
RUN npm i vite

COPY --from=build /frontend/dist ./dist/
COPY --from=build /frontend/package.json .

EXPOSE 8080

CMD [ "npm", "run", "preview" ]
