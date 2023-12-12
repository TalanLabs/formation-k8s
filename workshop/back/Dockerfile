FROM node:latest as Build

WORKDIR /backend

COPY . .
RUN npm i
RUN npm run build


FROM node:latest as Run

WORKDIR /backend

COPY --from=build ./backend .

EXPOSE 3000

CMD ["npm", "run", "start"]