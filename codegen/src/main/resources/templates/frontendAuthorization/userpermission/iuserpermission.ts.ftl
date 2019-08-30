export interface I[=authenticationTable]permission {  

      permissionId: number;
      userid: number;
      [=authenticationTable?uncap_first]Username?: string;
      permissionName?: string;
  }
