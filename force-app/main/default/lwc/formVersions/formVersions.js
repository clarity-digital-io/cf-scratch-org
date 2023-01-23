import { LightningElement, api, track, wire } from 'lwc';
import getFormVersionsByFormId from '@salesforce/apex/FormSummaryController.getFormVersionsByFormId';

export default class FormVersions extends LightningElement {
  @api recordId;
  @track formVersions; 

  @wire(getFormVersionsByFormId, { formId: '$recordId' })
  wiredFormVersions({ error, data }) {
    if(data) {
      console.log({ data })
    } else if(error) {

    }
  } 
}