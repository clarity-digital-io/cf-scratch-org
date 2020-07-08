import { wire, track, api, LightningElement } from 'lwc';
import getQuestions from '@salesforce/apex/ResponseController.getQuestions';
import { calculateLogic, getCriteriaControllers, getCriteriaControlledQuestions } from 'c/responseHelpers';

export default class ResponseFormQuestions extends LightningElement {
	@api formId;
	@track questions;
	answers = new Map();

	@wire(getQuestions, { recordId: '$formId' })
	wiredQuestions({ error, data }) {
		if (data) {
			this.criteriaControllers = getCriteriaControllers(data); 
			this.criteriaControlledQuestions = getCriteriaControlledQuestions(data); 
			this.questions = this.getActiveQuestions(data);
			this.error = undefined;
		} else if (error) {
				this.error = error;
				this.questions = undefined;
		}
	}

	getActiveQuestions(data) {

		let bgStyle = true; 

		return data.map(question => {

			if(calculateLogic(question.Id, question.forms__Logic__c, this.answers, this.criteriaControlledQuestions)) {
				bgStyle = !bgStyle; 
				return { ...question, active: true };
			} 

			return { ...question, active: false }
	
		});
		
	}

	handleChange(event) {

		if(event.detail.questionId) {
			//this.response[event.detail.questionId] = event.detail.value;
			this.answers.set(event.detail.questionId, event.detail.value);
			if(this.criteriaControllers.has(event.detail.questionId)) {
				this.questions = this.questions.map((question, index) => {

					if(calculateLogic(question.Id, question.forms__Logic__c, this.answers, this.criteriaControlledQuestions)) {
						return { ...question, active: true }; 
					} 

					return { ...question, active: false }

				});
			}

		}
	} 

}