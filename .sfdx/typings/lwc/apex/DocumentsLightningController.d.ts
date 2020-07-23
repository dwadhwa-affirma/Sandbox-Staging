declare module "@salesforce/apex/DocumentsLightningController.GetAllData" {
  export default function GetAllData(param: {accid: any}): Promise<any>;
}
declare module "@salesforce/apex/DocumentsLightningController.GetAccountNumber" {
  export default function GetAccountNumber(param: {accid: any}): Promise<any>;
}
declare module "@salesforce/apex/DocumentsLightningController.GetPagingData" {
  export default function GetPagingData(param: {accid: any, PageNo: any, PageSize: any, SectionName: any, SortBy: any, SortDir: any, SearchText: any}): Promise<any>;
}
