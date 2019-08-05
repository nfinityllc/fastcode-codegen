export interface IExecutingJob {
    id?: number;
    jobName?: string;
    jobGroup?: string;
    triggerName?: string;
    triggerGroup?: string;
    jobClass?: string;
    fireTime?: Date;
    finishTime?: Date;
    jobStatus?: string;
    jobMapData?: Map<string,string>;
  }
  export class ExecutingJob implements IExecutingJob {
    constructor(public id?: number, public jobName?: string, public jobGroup?: string,
      public description?: string, public jobClass?: string, public duration?: string,
      public fireTime?: Date, public finishTime?: Date, public jobMapData?: Map<string,string>,
      public jobStatus?: string) { }
  }