import path from "path";
import fs from "fs";
import { Cat , toCats } from "./models";
import {Pool} from "pg";

export interface CatRepository {
    addCat(name: string, type: string, age: number): Promise<void>;
    listAllCats(): Promise<Cat[]>;
    setup(): Promise<void>;
  }


export class PostgresCatRepository implements CatRepository {
    

    pool: Pool;

    constructor() {
        this.pool = new Pool({
            user: process.env.DB_USER,
            host: process.env.DB_HOST,
            database: process.env.DB_NAME,
            password: process.env.DB_PASSWORD,
            port: process.env.DB_PORT as unknown as number,
        });
    }


    async addCat(name: string, type: string, age: number): Promise<void> {
        const client = await this.pool.connect();
        try {
            // Execute the SQL INSERT statement
            await client.query(`
        INSERT INTO public."Cat" (name, type, age) VALUES ($1, $2, $3);
        `, [name, type, age]);
        } finally {
            client.release();
        }
    }
    
    async listAllCats(): Promise<Cat[]> {
        const client = await this.pool.connect();
        try {
            const result = await client.query('SELECT * FROM public."Cat"');
            const cats = result.rows;
    
            // @ts-ignore
            cats.forEach((cat) => {
                console.log(`ID: ${cat.id}, Name: ${cat.name}, Type: ${cat.type}, Age: ${cat.age}`);
            });
    
            return cats.map(toCats);
        } finally {
            client.release();
        }

    }

    async setup(): Promise<void> {

        const client = await this.pool.connect();

    try {
        await client.query(`
            CREATE TABLE IF NOT EXISTS public."Cat" (
                id SERIAL PRIMARY KEY,
                name TEXT NOT NULL,
                type TEXT NOT NULL,
                age INTEGER NOT NULL
            );
        `);
    } finally {
        client.release();
    }
        
    }
    
}


export class InMemoryCatRepository implements CatRepository {

    cats: Cat[] = []
    
    addCat(name: string, type: string, age: number): Promise<void> {
        const id = Math.floor(Math.random() * 100000);
        const cat = new Cat(id, name, age, type);
        this.cats.push(cat); 
        return Promise.resolve();
    }
    listAllCats(): Promise<Cat[]> {
        return Promise.resolve(this.cats);
    }
    setup(): Promise<void> {
        return Promise.resolve();
    }
}


export class FileCatRepository implements CatRepository  {

    filePath: string

    constructor() {
        this.filePath = path.join(process.env.DB_DIRECTORY || "", "cats.json");
    }

    async addCat(name: string, type: string, age: number): Promise<void> {

        const id = Math.floor(Math.random() * 100000);
        const content = await fs.promises.readFile(this.filePath, 'utf8');
        const jsonArray: any[] = JSON.parse(content);

        jsonArray.push({id, name, type, age});
        await fs.promises.writeFile(this.filePath, JSON.stringify(jsonArray), 'utf8');
        return Promise.resolve();
        
    }
    async listAllCats(): Promise<Cat[]> {
       const content = await fs.promises.readFile(this.filePath, 'utf8');
       const jsonArray: any[] = JSON.parse(content);

       return jsonArray
                .map((entry) => new Cat(entry.id as number, entry.name as string, entry.age as number, entry.type as string));
    }
    async setup(): Promise<void> {
        
        const alreadyExist = await fs.promises.access(this.filePath).then(() => true).catch(() => false);
        if (!alreadyExist) {
            await fs.promises.writeFile(this.filePath, "[]");
        }
    }
    
}