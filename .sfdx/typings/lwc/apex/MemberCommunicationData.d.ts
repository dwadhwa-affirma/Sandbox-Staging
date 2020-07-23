declare module "@salesforce/apex/MemberCommunicationData.SNAILSetting" {
  export default function SNAILSetting(): Promise<any>;
}
declare module "@salesforce/apex/MemberCommunicationData.GetMemberCommData" {
  export default function GetMemberCommData(param: {source: any, fromdate: any, todate: any, recid: any, keyword: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommunicationData.GetBDICommData" {
  export default function GetBDICommData(param: {source: any, fromdate: any, todate: any, recid: any, keyword: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommunicationData.GetSalesforceData" {
  export default function GetSalesforceData(param: {source: any, fromdate: any, todate: any, recid: any, keyword: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommunicationData.GetOOWData" {
  export default function GetOOWData(param: {fromdate: any, todate: any, keyword: any, recid: any}): Promise<any>;
}
