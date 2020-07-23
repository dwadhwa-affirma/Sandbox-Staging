declare module "@salesforce/apex/ManageTravelPlansController.getCurrentTravelPlans" {
  export default function getCurrentTravelPlans(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.getCardDetails" {
  export default function getCardDetails(param: {accid: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.getCountryData" {
  export default function getCountryData(): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.saveTravelNotification" {
  export default function saveTravelNotification(param: {id: any, selectedCards: any, traveldetailsobj: any, result: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.getTimeZone" {
  export default function getTimeZone(): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.getStateData" {
  export default function getStateData(): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.updateCurrentTravelPlans" {
  export default function updateCurrentTravelPlans(param: {mcObjString: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.updateSFCurrentTravelPlans" {
  export default function updateSFCurrentTravelPlans(param: {mcObjString: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.deleteCurrentTravelPlans" {
  export default function deleteCurrentTravelPlans(param: {mcObjString: any}): Promise<any>;
}
declare module "@salesforce/apex/ManageTravelPlansController.MCAPICallout" {
  export default function MCAPICallout(param: {id: any, selectedCards: any, traveldetailsobj: any}): Promise<any>;
}
