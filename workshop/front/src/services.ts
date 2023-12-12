import axios from "axios";
import {Cat} from "./models.ts";

const url: string = import.meta.env.VITE_API_URL || 'http://localhost:3000'

export const getRandomNumber = async (): Promise<number> => {
    return axios.get<{random: number}>(url)
        .then(resp => resp.data.random)
}

export const addCat = async (): Promise<Cat> => {
    return axios.post<Cat>(url + '/cats')
        .then(resp => new Cat(resp.data.id, resp.data.name, resp.data.age, resp.data.type))
}

export const getCats = async (): Promise<Cat[]> => {
    return axios.get<{cats: Cat[]}>(url + '/cats')
        .then(resp => resp.data.cats.map(cat => new Cat(cat.id, cat.name, cat.age, cat.type)))
}