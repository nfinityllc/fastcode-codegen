export enum listColumnType {
    String = "String",
    Number = "Number",
    Date = "Date",
    Boolean = "Boolean",
}
export interface IListColumn {
    column: string,
    label: string,
    sort: boolean,
    filter: boolean,
    type: listColumnType,
    options?: Array<any>
}

export class ListColumn implements IListColumn {
  constructor(
    public column: string,
    public label: string,
    public sort: boolean,
    public filter: boolean,
    public type: listColumnType,
    public options?: Array<any>,
  ) { }
}