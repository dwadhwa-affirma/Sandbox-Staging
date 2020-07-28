declare module "@salesforce/apex/Memeber360ViewLightningController.GetAllData" {
  export default function GetAllData(param: {accid: any}): Promise<any>;
}
declare module "@salesforce/apex/Memeber360ViewLightningController.GetPagingData" {
  export default function GetPagingData(param: {accid: any, PageNo: any, PageSize: any, SectionName: any, SortBy: any, SortDir: any, SearchText: any}): Promise<any>;
}
declare module "@salesforce/apex/Memeber360ViewLightningController.GetMasterCardAlertsData" {
  export default function GetMasterCardAlertsData(param: {PageNo: any, PageSize: any, SortBy: any, SortDir: any, Account: any, Card: any, SearchText: any}): Promise<any>;
}
