import { wire, track, api, LightningElement } from 'lwc';
import getQuestions from '@salesforce/apex/ResponseController.getQuestions';
import { calculateLogic, getCriteriaControllers, getCriteriaControlledQuestions } from 'c/responseHelpers';

export default class ResponseFormQuestions extends LightningElement {
	@api answers = {};
	@api formId;
	@track questions;
	
	//pass in answers when edit and add it to quesetion object in getActiveQuestions
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

			let answer = this.answers[question.Id] || '';

			if(calculateLogic(question.Id, question.forms__Logic__c, this.answers, this.criteriaControlledQuestions)) {
				bgStyle = !bgStyle; 
				return { ...question, active: true, answer: answer };
			} 

			return { ...question, active: false, answer: answer }
	
		});
		
	}

	handleChange(event) {

		if(event.detail.questionId) {
			this.answers[event.detail.questionId] = event.detail.value;
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