declare module "@salesforce/apex/ClarityFormPreview.preview" {
  export default function preview(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormPreview.saveAnswer" {
  export default function saveAnswer(param: {answer: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormPreview.publishFlow" {
  export default function publishFlow(param: {questionFlow: any}): Promise<any>;
}
declare module "@salesforce/apex/ClarityFormPreview.search" {
  export default function search(param: {searchTerm: any, lookupObject: any, selectedIds: any}): Promise<any>;
}
