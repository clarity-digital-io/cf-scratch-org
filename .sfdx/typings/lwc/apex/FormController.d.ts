declare module "@salesforce/apex/forms.FormController.create" {
  export default function create(): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.updateResponse" {
  export default function updateResponse(param: {responseId: any, totalTime: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.getForm" {
  export default function getForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.getFormResponses" {
  export default function getFormResponses(param: {formId: any, name: any, recordId: any, sObjectName: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.deleteFormResponse" {
  export default function deleteFormResponse(param: {responseId: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.deleteForm" {
  export default function deleteForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.publishForm" {
  export default function publishForm(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forms.FormController.getAnswerColumns" {
  export default function getAnswerColumns(param: {recordId: any}): Promise<any>;
}
