import { LightningElement, track, api } from 'lwc';
import preview from '@salesforce/apex/ClarityFormPreview.preview';
import publishFlow from '@salesforce/apex/ClarityFormPreview.publishFlow';
import saveAnswer from '@salesforce/apex/ClarityFormPreview.saveAnswer';

export default class ClarityForm extends LightningElement {
    
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

    formsave({ detail }) {
        console.log('detail', detail);

        let clean = this.cleanAnswers({ Id: null, Answer__c: detail.Answer__c, Clarity_Form_Question__c: detail.Clarity_Form_Question__c, Clarity_Form_Response__c: this.formresponseid });
        console.log('clean', clean);
        detail.save ? this.save(clean) : null;

    }

    cleanAnswers(detail) {

        let match = this.answers.find(answer => answer.Clarity_Form_Question__c == detail.Clarity_Form_Question__c); 
        console.log('match', match, 'deta', detail);
        return match != null ? { ...match, Answer__c: detail.Answer__c } : detail; 

    }

    save(clean) {
        console.log('this.answers0', JSON.stringify(this.answers), clean);

        saveAnswer({ answer: JSON.stringify(clean) })
            .then(result => {
                console.log('where is result')
                console.log(result);
                console.log('this.answers2', JSON.stringify(this.answers));
                let match = this.answers.find(answer => answer.Clarity_Form_Question__c == clean.Clarity_Form_Question__c); 

                match != null ? 
                    this.answers.map(answer => {

                        if(answer.Clarity_Form_Question__c == result.Clarity_Form_Question__c) {
                            return result; 
                        } 
        
                        return answer; 

                    }) :
                    this.answers.concat([result]) 

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

