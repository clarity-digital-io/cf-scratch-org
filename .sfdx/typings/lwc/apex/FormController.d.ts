declare module "@salesforce/apex/clarityforms.FormController.getForm" {
  export default function getForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/clarityforms.FormController.getFormResponses" {
  export default function getFormResponses(param: {formId: any, name: any}): Promise<any>;
}
declare module "@salesforce/apex/clarityforms.FormController.deleteFormResponse" {
  export default function deleteFormResponse(param: {responseId: any}): Promise<any>;
}
declare module "@salesforce/apex/clarityforms.FormController.deleteForm" {
  export default function deleteForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/clarityforms.FormController.publishForm" {
  export default function publishForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/clarityforms.FormController.getAnswerColumns" {
  export default function getAnswerColumns(param: {recordId: any}): Promise<any>;
}
