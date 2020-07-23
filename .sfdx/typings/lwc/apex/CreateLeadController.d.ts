declare module "@salesforce/apex/CreateLeadController.FetchLeedData" {
  export default function FetchLeedData(param: {AccountID: any}): Promise<any>;
}
declare module "@salesforce/apex/CreateLeadController.LeadInsertUpdate" {
  export default function LeadInsertUpdate(param: {leadObject: any, MemberAccountID: any}): Promise<any>;
}
declare module "@salesforce/apex/CreateLeadController.getDependentOptionsImpl" {
  export default function getDependentOptionsImpl(param: {objName: any, contrfieldName: any, depfieldName: any}): Promise<any>;
}
declare module "@salesforce/apex/CreateLeadController.getMemberAccounts" {
  export default function getMemberAccounts(param: {AccountId: any}): Promise<any>;
}
declare module "@salesforce/apex/CreateLeadController.getEpsysDetails" {
  export default function getEpsysDetails(): Promise<any>;
}
