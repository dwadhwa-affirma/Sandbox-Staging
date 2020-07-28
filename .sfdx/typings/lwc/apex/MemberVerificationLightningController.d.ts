declare module "@salesforce/apex/MemberVerificationLightningController.ListOfEmailsAndPhoneNumbers" {
  export default function ListOfEmailsAndPhoneNumbers(param: {accid: any, IsAuth: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberVerificationLightningController.DeclineOTPAtFirstStep" {
  export default function DeclineOTPAtFirstStep(param: {accid: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberVerificationLightningController.GenerateRandomOTP" {
  export default function GenerateRandomOTP(param: {fieldName: any, BrandName: any, resend: any, accid: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberVerificationLightningController.verifyOTP" {
  export default function verifyOTP(param: {accid: any, EnteredOTP: any, fieldName: any, model: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberVerificationLightningController.CancelOTP" {
  export default function CancelOTP(param: {accid: any, fieldName: any}): Promise<any>;
}
