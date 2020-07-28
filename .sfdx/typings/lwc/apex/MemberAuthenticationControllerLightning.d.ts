declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetRecordTypeData" {
  export default function GetRecordTypeData(param: {sobjecttype: any, RecordTypeName: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetDataForMasterAuthenticationLog" {
  export default function GetDataForMasterAuthenticationLog(param: {IVRGuid: any, RecordTypeId: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.getMemberSearchData" {
  export default function getMemberSearchData(param: {PhoneNumber: any, MemberNumber: any, SSNNumber: any, IVRGUIDFromUrl: any, IsUserSessionLoaded: any, SSNMatch: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetAccountNumber" {
  export default function GetAccountNumber(param: {accdetailid: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.SaveOOWLogData" {
  export default function SaveOOWLogData(param: {status: any, MemberNumber: any, MemberId: any, reason: any, notes: any, GUID: any, name: any, Error: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.KYMSaveLogData" {
  export default function KYMSaveLogData(param: {MemberId: any, reason: any, otherReason: any, GUID: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.PublicWalletSaveLogData" {
  export default function PublicWalletSaveLogData(param: {MemberId: any, Status: any, GUID: any, DOBMatch: any, IdNumberMatch: any, MMNMatch: any, EmailMatch: any, AdditionalTokenOption3Match: any, IVRGUIDFromUrl: any, DOB: any, IdNumber: any, MMN: any, Email: any, AdditionalTokenOption3: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.CFCUWalletSaveLogData" {
  export default function CFCUWalletSaveLogData(param: {MemberId: any, Status: any, GUID: any, BeneficiaryDetailMatch: any, JointOwnerDetailMatch: any, CardNumberMatch: any, AdditionalTokenOption1Match: any, AdditionalTokenOption2Match: any, LoanDetailMatch: any, IVRGUIDFromUrl: any, BeneficiaryAccount: any, JointAccount: any, LoanAccount: any, Card: any, AdditionalTokenOption1: any, AdditionalTokenOption2: any, MemberNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.InsertLogData" {
  export default function InsertLogData(param: {MemberId: any, Decision: any, FDL: any, PhoneNumber: any, EnteredSSN: any, PageUrl: any, OverrideType: any, OverrideSupervisor: any, ManagerCallbackComments: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetCFCUWalletInfo" {
  export default function GetCFCUWalletInfo(param: {selectedID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.getPublicWalletInfo" {
  export default function getPublicWalletInfo(param: {MemberId: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetFailedDesiredLevelLog" {
  export default function GetFailedDesiredLevelLog(param: {MemberId: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck" {
  export default function MemberVerificationAttemptsCheck(param: {MemberId: any, GUID: any, DebitCardStatus: any, SSNFromURL: any, MemberNumberFromURL: any, PhoneFromURL: any, PageURL: any, IVRGUIDFromUrl: any, ReLoadRequired: any, ReasonCodeFromURL: any, HighFlagFromUrl: any, PointsObtained: any, IsOOWTabVisible: any, IsUserSessionLoaded: any, EnteredCardNumber: any, CardNumberMatch: any, PhoneNumberMatch: any, MemberNumberMatch: any, SSNnumberMatch: any, PINMatch: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel" {
  export default function GetTabsToAchieveNextLevel(param: {LevelModel: any, ScoringModel: any, MemberType: any, DebitPinStatus: any, IsPinChanged: any, IsOTPAvailable: any, IsPublicWalletAvailable: any, IsCFCUWalletAvailable: any, IsOOWAvailable: any, CurrentScore: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetMemberAuthenticationLevel" {
  export default function GetMemberAuthenticationLevel(): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetScoringModelData" {
  export default function GetScoringModelData(param: {MemberType: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetNextAuthenticationType" {
  export default function GetNextAuthenticationType(param: {MemberId: any, MemberType: any, MaximumPointsAvailable: any, PointsObtained: any, IsKYMAvailable: any, IsOTPAvailable: any, IsDebitPinAvailable: any, IsOOWAvailable: any, IsPublicWalletAvailable: any, IsCFCUWalletAvailable: any, IVRGUIDFromUrl: any, AccountNumberInput: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt" {
  export default function SaveOTPCancelledAttempt(param: {MemberId: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.SaveLastAchievableLevelLogs" {
  export default function SaveLastAchievableLevelLogs(param: {MemberId: any, GUID: any, LastLevel: any, IVRGUIDFromUrl: any, PhoneFromURL: any, MemberNumberFromURL: any, EnteredCardNumber: any, CardNumberMatch: any, PhoneNumberMatch: any, MemberNumberMatch: any, SSNnumberMatch: any, HighFlagFromUrl: any, ReasonCodeFromURL: any, PINMatch: any, SSNFromURL: any, DebitCardStatus: any, MaximumPointsAvailable: any, PointsObtained: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.SaveCaseWithLogData" {
  export default function SaveCaseWithLogData(param: {MemberId: any, AccountNumber: any, casecomment: any, AccountId: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetLogHistoryDetailData" {
  export default function GetLogHistoryDetailData(param: {MemberId: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetLogHistoryData" {
  export default function GetLogHistoryData(param: {MemberId: any, Days: any, GUID: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetSupervisor" {
  export default function GetSupervisor(param: {MemberId: any, Days: any, GUID: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.getLevel" {
  export default function getLevel(param: {accoutid: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.SaveFailedDesiredLevelLog" {
  export default function SaveFailedDesiredLevelLog(param: {MemberId: any, Decision: any, FDL: any, GUID: any, IVRGUIDFromUrl: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.getDataForReload" {
  export default function getDataForReload(param: {memberid: any, GUID: any, IVRGUIDFromUrl: any, DebitCardStatus: any, IsUserSessionLoaded: any, AccountNumberInput: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetMemberAuthenticationSessionTime" {
  export default function GetMemberAuthenticationSessionTime(): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetMAAPLogData" {
  export default function GetMAAPLogData(param: {MemberId: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberAuthenticationControllerLightning.GetMasterLogData" {
  export default function GetMasterLogData(param: {LogId: any}): Promise<any>;
}
