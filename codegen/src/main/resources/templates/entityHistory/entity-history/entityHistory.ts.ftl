export interface IEntityHistory {
    globalId?: any,
    commitMetadata?: any,
    changeType?: string,
    property?: string,
    left?: string,
    right?: any,


}

export class EntityHistory implements IEntityHistory {
    constructor(
        public globalId?: any,
        public commitMetadata?: any,
        public changeType?: string,
        public property?: string,
        public left?: string,
        public right?: string
    ) { }
}