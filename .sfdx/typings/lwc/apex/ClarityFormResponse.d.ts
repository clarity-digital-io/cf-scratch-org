declare module "@salesforce/apex/ClarityFormResponse.submit" {
  export default function submit(param: {formResponseId: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormResponse.create" {
  export default function create(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormResponse.preview" {
  export default function preview(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormResponse.saveAnswer" {
  export default function saveAnswer(param: {answer: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormResponse.publishFlow" {
  export default function publishFlow(param: {questionFlow: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormResponse.search" {
  export default function search(param: {searchTerm: any, lookupObject: any, selectedIds: any}): Promise<any>;
}
