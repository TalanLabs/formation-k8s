export class Cat {
    constructor(
        public readonly id: string,
        public readonly name: string,
        public readonly age: string,
        public readonly type: string
    ) {
        this.id = id;
        this.age = age;
        this.name = name;
        this.type = type;
    }
}