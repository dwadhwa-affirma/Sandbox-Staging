declare module "@salesforce/apex/eSignatureContoller.saveSignature" {
  export default function saveSignature(param: {signatureBody: any, wiresId: any}): Promise<any>;
}
declare module "@salesforce/apex/eSignatureContoller.savePDF" {
  export default function savePDF(param: {wiresId: any}): Promise<any>;
}
declare module "@salesforce/apex/eSignatureContoller.getWireTransactionData" {
  export default function getWireTransactionData(param: {wiresId: any}): Promise<any>;
}
