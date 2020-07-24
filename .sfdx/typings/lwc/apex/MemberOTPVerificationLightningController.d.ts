declare module "@salesforce/apex/MemberOTPVerificationLightningController.ListOfEmailsAndPhoneNumbers" {
  export default function ListOfEmailsAndPhoneNumbers(param: {accid: any, IsAuth: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.DeclineOTPAtFirstStep" {
  export default function DeclineOTPAtFirstStep(param: {accid: any, GUID: any, IVRGUIDFromUrl: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.GenerateRandomOTP" {
  export default function GenerateRandomOTP(param: {fieldName: any, BrandName: any, resend: any, accid: any, GUID: any, IVRGUIDFromUrl: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.verifyOTP" {
  export default function verifyOTP(param: {accid: any, EnteredOTP: any, fieldName: any, model: any, GUID: any, IVRGUIDFromUrl: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.CancelOTP" {
  export default function CancelOTP(param: {accid: any, GUID: any, fieldName: any, IVRGUIDFromUrl: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.OTPResend" {
  export default function OTPResend(param: {IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.GetMemberAuthenticationSessionTime" {
  export default function GetMemberAuthenticationSessionTime(): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.GetOTPLogForReload" {
  export default function GetOTPLogForReload(param: {memberid: any, IVRGUIDFromUrl: any, IsUserSessionLoaded: any, IsReLoadRequired: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.GetRecordTypeData" {
  export default function GetRecordTypeData(param: {sobjecttype: any, RecordTypeName: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberOTPVerificationLightningController.GetDataForMasterAuthenticationLog" {
  export default function GetDataForMasterAuthenticationLog(param: {IVRGuid: any, RecordTypeId: any}): Promise<any>;
}
