declare module "@salesforce/apex/FormController.getForm" {
  export default function getForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/FormController.getFormResponses" {
  export default function getFormResponses(param: {formId: any, name: any}): Promise<any>;
}
declare module "@salesforce/apex/FormController.deleteFormResponse" {
  export default function deleteFormResponse(param: {responseId: any}): Promise<any>;
}
declare module "@salesforce/apex/FormController.deleteForm" {
  export default function deleteForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/FormController.publishForm" {
  export default function publishForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/FormController.getAnswerColumns" {
  export default function getAnswerColumns(param: {recordId: any}): Promise<any>;
}
