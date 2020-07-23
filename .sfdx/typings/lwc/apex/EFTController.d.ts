declare module "@salesforce/apex/EFTController.getStageData" {
  export default function getStageData(param: {recordId: any, sObjectType: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getMembers" {
  export default function getMembers(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getEFT" {
  export default function getEFT(param: {EFTRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.saveStageData" {
  export default function saveStageData(param: {EFTRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.expireEFT" {
  export default function expireEFT(param: {EFTRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.createCase" {
  export default function createCase(param: {EFTRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.sendACHDocument" {
  export default function sendACHDocument(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.routingInfo" {
  export default function routingInfo(param: {RoutingNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getShareLoanAccounts" {
  export default function getShareLoanAccounts(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getEFTRecordsEpisys" {
  export default function getEFTRecordsEpisys(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getEpisysEmailAddresses" {
  export default function getEpisysEmailAddresses(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/EFTController.getDaysofMonth" {
  export default function getDaysofMonth(): Promise<any>;
}
