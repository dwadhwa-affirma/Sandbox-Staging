declare module "@salesforce/apex/ManualMemberMergeProcess.GetMemberList" {
  export default function GetMemberList(param: {membertype: any}): Promise<any>;
}
declare module "@salesforce/apex/ManualMemberMergeProcess.GetMemberAccountDetail" {
  export default function GetMemberAccountDetail(param: {id: any}): Promise<any>;
}
declare module "@salesforce/apex/ManualMemberMergeProcess.MergeMemberAccount" {
  export default function MergeMemberAccount(param: {mid: any, pmid: any}): Promise<any>;
}
