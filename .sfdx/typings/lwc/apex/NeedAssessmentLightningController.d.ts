declare module "@salesforce/apex/NeedAssessmentLightningController.FetchNeedAssessmentData" {
  export default function FetchNeedAssessmentData(param: {accountid: any}): Promise<any>;
}
declare module "@salesforce/apex/NeedAssessmentLightningController.SaveNeedAssessmentData" {
  export default function SaveNeedAssessmentData(param: {objNeedsAssesment: any, SectionName: any, accountid: any, SubItems: any, deletedItems: any}): Promise<any>;
}
declare module "@salesforce/apex/NeedAssessmentLightningController.changeoptout" {
  export default function changeoptout(param: {optout: any, Accountid: any}): Promise<any>;
}
