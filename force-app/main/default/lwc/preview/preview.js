import { LightningElement, track, api } from 'lwc';
import preview from '@salesforce/apex/ClarityFormResponse.preview';
import publishFlow from '@salesforce/apex/ClarityFormResponse.publishFlow';
import saveAnswer from '@salesforce/apex/ClarityFormResponse.saveAnswer';

export default class Preview extends LightningElement {
    
    @api recordId;

    @track form;
    @track formresponseid; 
    @track questions;
    @track criteria; 
    @track error;
    @track answers = [];
    @track rendered = false;

    connectedCallback() {

        preview({ recordId: this.recordId })
            .then(result => {

                this.formresponseid = result['FormResponse'][0].Id;
                this.form = result['Form'][0];
                this.styling = this.form.Clarity_Form_Style__r;
                this.questions = sortQuestions(result['Questions']); 
                this.criteriaController = getCriteriaController(this.questions); //criteria by controlling question
                this.criteriaControlled = getCriteriaControlled(this.questions); //criteria by controlled question

            })
            .catch(error => {
                this.error = error; 
            })

    }

    renderedCallback() {
        /*
            Custom Styling for Card Background, Card Title, and Border
        */
        if(this.form != null) {
            this.template.querySelector("article.slds-card").style.backgroundColor = this.styling.Background_Color__c ? this.styling.Background_Color__c : '#fff';
            this.template.querySelector("article.slds-card").style.border = 'none';
            this.template.querySelector("div.slds-media__body").style.color = this.styling.Color__c ? this.styling.Color__c : '#000';
            this.rendered = true; 
        }

    }

    formsave({ detail }) {

        this.conditionCheck(detail);

        let clean = this.cleanAnswers({ Id: null, Answer__c: detail.Answer__c, Clarity_Form_Question__c: detail.Clarity_Form_Question__c, Clarity_Form_Response__c: this.formresponseid });

        detail.save ? this.save(clean) : null;

    }

    conditionCheck(detail) {

        let criteria = this.criteriaController.get(detail.Clarity_Form_Question__c);

        if(criteria != null && criteria.length > 0) {

            this.questions = this.questions.map(question => { 

                if(this.criteriaControlled.get(question.Id) != null) {

                    let conditions = this.criteriaControlled.get(question.Id);
                    console.log(conditions[0].Value, detail.Answer__c, question);
                    return { 
                        ...question, 
                        Show: conditions[0].Value == detail.Answer__c ? true : false
                    }

                } else {
                    return question; 
                }

            });
            
        }

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

    flowHandler(event) {

        const selectedOption = event.detail.value;

        if(this.flow.Active__c && !this.flow.Form_Submission) {
            createFlow(this.id, this.options, selectedOption); 
        }
            
    }

}

const getCriteriaControlled = (questions) => {

    return questions.reduce((accum, question) => {

        if(question.Clarity_Form_Question_Criteria__r != null && question.Clarity_Form_Question_Criteria__r.length > 0) {

            accum.set(question.Id, question.Clarity_Form_Question_Criteria__r.map(c => {
                return { QuestionId: c.Clarity_Form_Question__c, Operator: c.Operator__c, Type: c.Type__c, Value: c.Value__c }
            }));

        }

        return accum; 

    }, new Map());

}

const getCriteriaController = (questions) => {

    return questions.reduce((accum, question) => {

        if(question.Clarity_Form_Question_Criteria__r != null && question.Clarity_Form_Question_Criteria__r.length > 0) {

            question.Clarity_Form_Question_Criteria__r.forEach((criteria, i) => {

                if(accum.get(criteria.Field__c) != null) {
                    let conditions = accum.get(criteria.Field__c); 
                    conditions.push({ QuestionId: criteria.Clarity_Form_Question__c, Operator: criteria.Operator__c, Type: criteria.Type__c, Value: criteria.Value__c })
                    accum.set(criteria.Field__c, conditions);
                } else {
                    accum.set(criteria.Field__c, [{ QuestionId: criteria.Clarity_Form_Question__c, Operator: criteria.Operator__c, Type: criteria.Type__c, Value: criteria.Value__c }])
                }

            })

        }

        return accum;

    }, new Map());
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
            Clarity_Form_Question_Options__r: options != null && options.length ? transformOptions(options) : [], 
            Show: question.Clarity_Form_Question_Criteria__r != null && question.Clarity_Form_Question_Criteria__r.length > 0 ? false : true
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

