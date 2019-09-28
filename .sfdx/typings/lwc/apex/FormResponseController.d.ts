declare module "@salesforce/apex/FormResponseController.getForm" {
  export default function getForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/FormResponseController.getFormResponses" {
  export default function getFormResponses(param: {name: any}): Promise<any>;
}
declare module "@salesforce/apex/FormResponseController.deleteFormResponse" {
  export default function deleteFormResponse(param: {responseId: any}): Promise<any>;
}
