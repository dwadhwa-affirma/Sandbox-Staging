declare module "@salesforce/apex/WiresTransactionApprovalController.getWiresData" {
  export default function getWiresData(param: {WiresRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/WiresTransactionApprovalController.ApproveTransaction" {
  export default function ApproveTransaction(param: {WiresRecordId: any, Action: any, wiresdetails: any}): Promise<any>;
}
