import { AssociationColumn } from './association-column.interface'
export interface IAssociationEntry {
  column: AssociationColumn[],
  table: string,
  isParent?: boolean,
  service?: any,
  data?: any,
  type?: string,
  descriptiveField?: string,
  referencedDescriptiveField?: string,
  associatedObj?: any,
}
