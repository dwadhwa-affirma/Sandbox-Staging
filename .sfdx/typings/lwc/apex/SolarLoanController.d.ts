declare module "@salesforce/apex/SolarLoanController.waitingForResponse" {
  export default function waitingForResponse(param: {SolarLoanRecordId: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/SolarLoanController.getMemberData" {
  export default function getMemberData(param: {SolarLoanRecordId: any, CurrentStage: any}): Promise<any>;
}
declare module "@salesforce/apex/SolarLoanController.routingInfo" {
  export default function routingInfo(param: {RoutingNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/SolarLoanController.saveRoutingInfo" {
  export default function saveRoutingInfo(param: {SolarLoanRecordId: any, RoutingNumber: any, BankName: any}): Promise<any>;
}
