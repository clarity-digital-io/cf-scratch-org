import { LightningElement, track, api, wire } from 'lwc';
import preview from '@salesforce/apex/ClarityFormPreview.preview';

export default class ClarityForm extends LightningElement {
    
    @api recordId;
    @track form;
    @track formresponseid; 
    @track questions;
    @track error;

    constructor() {
        super(); 
    }

    connectedCallback() {

        preview({ recordId: this.recordId })
            .then(result => {
                this.formresponseid = result['FormResponse'][0].Id;
                this.form = result['Form'][0];
                this.questions = sortQuestions(result['Questions']);
            })
            .catch(error => {
                this.error = error; 
            })

    }


}

const sortQuestions = (result) => {

    let questions = result.sort((a, b) => {
        if(a.Order__c < b.Order__c) {
            return -1; 
        }
        if(a.Order__c > b.Order__c) {
            return 1; 
        }
    })

    return questions.map(question => {

        let options = question.Clarity_Form_Question_Options__r;

        let nQuestion = { 
            ...question, 
            Clarity_Form_Question_Flow_Designs__r: question.Clarity_Form_Question_Flow_Designs__r[0], 
            Clarity_Form_Question_Options__r: options != null && options.length ? transformOptions(options) : [] 
        };
        console.log(nQuestion);
        return nQuestion;

    });

}

const transformOptions = (options) => {

    return options.map(option => {

        return {
            value : option.Id, 
            label : option.Label__c, 
            flow  : option.Active_Flow__c
        }

    });

}