import { LightningElement, api } from 'lwc';

import publishFlow from '@salesforce/apex/ClarityFormPreview.publishFlow';

export default class ClarityFormMultipleChoice extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow

    handleChange(event) {

        const selectedOption = event.detail.value;

        if(this.flow.Active__c && !this.flow.Form_Submission) {
            createFlow(this.id, this.options, selectedOption); 
        }
            
    }

}

const createFlow = (questionId, options, selectedOption) => {
    
    let option = options.find(option => option.value == selectedOption);

    if(option.flow) {

        let flow = { Value__c : option.label, Clarity_Form_Question__c: questionId };

        publishFlow({ questionFlow: JSON.stringify(flow) })
            .then(result => {
                console.log(result);
            })
            .catch(error => {
                console.log(error);
            })

    } 

}

