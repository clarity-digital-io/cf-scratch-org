import { LightningElement, api } from 'lwc';

import publishFlow from '@salesforce/apex/ClarityFormPreview.publishFlow';

import combobox from './combobox.html';
import textarea from './textarea.html';
import multiplechoice from './multiplechoice.html';
import buttongroup from './buttongroup.html';
import slider from './slider.html';
import date from './date.html';
import email from './email.html';
import checkbox from './checkbox.html';
import lookup from './lookup.html';
import error from './error.html';

export default class ClarityFormQuestion extends LightningElement {

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

    render() {
        switch (this.type) {
            case 'MultipleChoice':
                return multiplechoice;
                break;
            case 'Comment':
                return textarea;
                break;
            case 'Dropdown':
                return combobox;
                break;
            case 'Ranking':
                return error;
                break;
            case 'NetPromoterScore':
                return buttongroup;
                break;
            case 'Slider':
                return slider;
                break;
            case 'Date':
                return date;
                break;
            case 'Email':
                return email;
                break;
            case 'Payment':
                return error;
                break;
            case 'Number':
                return number;
                break;
            case 'Lookup':
                return lookup;
                break;
            case 'RecordGroup':
                return error;
                break;
            case 'Image':
                return error;
                break;
            case 'Checkbox':
                return checkbox;
                break;
            default:
                return error;
                break;
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

