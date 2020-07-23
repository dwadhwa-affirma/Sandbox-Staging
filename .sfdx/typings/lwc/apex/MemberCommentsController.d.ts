declare module "@salesforce/apex/MemberCommentsController.getBasicDetails" {
  export default function getBasicDetails(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getAttachmentDetails" {
  export default function getAttachmentDetails(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getPrimaryData" {
  export default function getPrimaryData(param: {brand: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getSecondaryData" {
  export default function getSecondaryData(param: {brand: any, primaryText: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getTertioryData" {
  export default function getTertioryData(param: {brand: any, primaryText: any, secondaryText: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getItembySearchText" {
  export default function getItembySearchText(param: {brand: any, searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getItembyCategories" {
  export default function getItembyCategories(param: {brand: any, selectedPrimary: any, selectedSecondary: any, selectedTertiary: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getSelectedDecription" {
  export default function getSelectedDecription(param: {CategoryId: any, Brand: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.saveComment" {
  export default function saveComment(param: {MemberDescription: any, CaseId: any, Draft: any, secureEmailAddress: any, Attachments: any, CURead: any, CRAttachments: any, selectedCannedResponse: any}): Promise<any>;
}
declare module "@salesforce/apex/MemberCommentsController.getSelectedAttachments" {
  export default function getSelectedAttachments(param: {CategoryId: any, Brand: any}): Promise<any>;
}
