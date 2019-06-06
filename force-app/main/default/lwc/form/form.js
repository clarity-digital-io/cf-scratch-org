import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import create from '@salesforce/apex/ClarityFormResponse.create';
import publishFlow from '@salesforce/apex/ClarityFormResponse.publishFlow';
import saveAnswer from '@salesforce/apex/ClarityFormResponse.saveAnswer';
import submit from '@salesforce/apex/ClarityFormResponse.submit';

export default class Form extends LightningElement {
    
    @api recordId;

    @track form;
    @track formresponseid; 
    @track questions;
    @track error;
    @track answers = [];

    constructor() {
        super(); 
    }

    connectedCallback() {

        create({ recordId: this.recordId })
            .then(result => {
                this.formresponseid = result['FormResponse'][0].Id;
                this.form = result['Form'][0];
                this.questions = sortQuestions(result['Questions']);
            })
            .catch(error => {
                this.error = error; 
            })

    }

    formsave({ detail }) {

        let clean = this.cleanAnswers({ Id: null, Answer__c: detail.Answer__c, Clarity_Form_Question__c: detail.Clarity_Form_Question__c, Clarity_Form_Response__c: this.formresponseid });

        detail.save ? this.save(clean) : null;

    }

    cleanAnswers(detail) {

        let match = this.answers.find(answer => answer.Clarity_Form_Question__c == detail.Clarity_Form_Question__c); 

        return match != null ? { ...match, Answer__c: detail.Answer__c } : detail; 

    }

    save(clean) {

        let match = this.answers.find(answer => answer.Clarity_Form_Question__c == clean.Clarity_Form_Question__c); 

        if(match != undefined && match.Answer__c == clean.Answer__c) return; 

        saveAnswer({ answer: JSON.stringify(clean) })
            .then(result => {
                console.log(result);
                match ? 
                    this.answers = this.answers.map(answer => {

                        if(answer.Clarity_Form_Question__c == result.Clarity_Form_Question__c) {
                            return result; 
                        } 
        
                        return answer; 

                    }) :
                    this.answers = this.answers.concat([result])

            })
            .catch(error => {
                console.log(error);
            })

    }

    cancelHandler() {

    }

    submitHandler() {

        submit({ formResponseId: this.formresponseid })
            .then(result => {
                
                console.log(result);        

                this.notifyUser('Form Response Submitted', 'Your form response has been submitted. Thank you!', 'success');

            })
            .catch(error => {
                console.log(error);
            })

    }

    flowHandler(event) {

        const selectedOption = event.detail.value;

        if(this.flow.Active__c && !this.flow.Form_Submission) {
            createFlow(this.id, this.options, selectedOption); 
        }
            
    }

    notifyUser(title, message, variant){
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
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

