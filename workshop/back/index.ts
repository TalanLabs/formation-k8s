import express, { Express, Request, Response } from 'express';
import cors from 'cors'
import _ from "lodash"
import dotenv from "dotenv"
import {Name} from "./enums/name";
import {Adjective} from "./enums/adjective";
import {Type } from "./enums/type";
import { CatRepository, InMemoryCatRepository, PostgresCatRepository , FileCatRepository} from './repository';
import morgan from "morgan";

dotenv.config()

const app = express()
app.use(cors())

app.use(morgan((tokens, req, res) => {
    return [
      new Date().toISOString(), // Add timestamp
      tokens.method(req, res), // HTTP method
      tokens.url(req, res),    // URL
      tokens.status(req, res), // HTTP status code
      tokens.res(req, res, 'content-length'), // Content length
      '-',
      tokens['response-time'](req, res), // Response time
      'ms'
    ].join(' ');
  })
)
const port = 3000


let repository: CatRepository;



switch (process.env.APP_STORAGE) {
    case 'postgres':
        repository = new PostgresCatRepository();
        break;
    case 'fs':
        repository = new FileCatRepository();
        break;
    default:
        repository =  new InMemoryCatRepository();
        break;
}


app.get('/random', (req, res) => {
    const random = _.random(10)
    res.status(200).send({random})
})

app.get('/version', (req, res) => {
    const version = process.env.VERSION || '0.0.1'
    res.status(200).send({version})
})


app.get('/cats', async (req, res) => {
    try {
        const cats = await repository.listAllCats();
        res.status(200).send({cats: cats})
    } catch (err) {
        console.error('[http]: error while retreving  cats', err)
        res.status(500).send('Error while retreving cats, better check the logs...')
    }
    
})

app.post('/cats', async (req, res) => {
    try {
        await repository.addCat(_.sample(Object.values(Name)) + ' ' + _.sample(Object.values(Adjective)), _.sample(Object.values(Type))!.toString(), _.random(14),)
        res.status(200).send('Successfully added a cat')
    } catch (err) {
        console.error('[http]: error while addding  a cat', err)
        res.status(500).send('Error while adding a cat, better check the logs...')
    }
})


const startup = async () => {

    try {
        console.log(`[server]: starting application with backend = ${process.env.APP_STORAGE || 'memory'}`)
        await repository.setup();
        app.listen(port, '0.0.0.0', () => {
            console.log(`[server]: Server is running at http://localhost:${port}`);
        });

    } catch(error) {
        console.error('[server]: Error starting the server:', error);
    }
   
    
}

startup()
