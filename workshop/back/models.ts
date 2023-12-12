export class Cat {
    constructor(
        public readonly id: number,
        public readonly name: string,
        public readonly age: number,
        public readonly type: string
    ) {
        this.id = id;
        this.age = age;
        this.name = name;
        this.type = type;
    }
}

export const toCats = (cat: any): Cat => {
    return new Cat(
        cat.id,
        cat.name,
        cat.age,
        cat.type
    )
}