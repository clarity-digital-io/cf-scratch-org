import { wire, api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import editResponse from '@salesforce/apex/ResponseController.editResponse';
import getResponse from '@salesforce/apex/ResponseController.getResponse';

export default class ResponseFormNew extends LightningElement {
	@api isCommunity = false; 
	@api formId;
	@api responseId;

	@api answers = {}
	loading = true; 

	constructor() {
		super();
		this.addEventListener('answerchange', this.handleAnswers.bind(this));
	}

	@wire(getResponse, { recordId: '$responseId' })
	wiredResponse({ error, data }) {
		window.console.log('wiredResponse', data); 
		if (data) {
			data.forms__Answers__r.forEach(answer => {
				this.answers[answer.forms__Question__c] = answer.forms__Answer__c;
			})
			window.console.log('wiredResponse', this.answers); 
			this.loading = false; 
		} else if (error) {
			this.error = error;
		}
	}

	@api
	handleSave() {
		editResponse({
				responseId: this.responseId, 
				sAnswers: JSON.stringify(this.answers), 
				status: 'In Progress'
			})
			.then(result => {
				this.showNotification('Success', `Response Saved: ${result}`, 'success');				
			})
			.catch(error => {
				this.showNotification('Error', `Response Save Error: ${error}`, 'error');				
			});
	}

	@api
	handleSubmit() {
		editResponse({
			responseId: this.responseId, 
			sAnswers: JSON.stringify(this.answers), 
			status: 'Submitted'
		})
			.then(result => {
				this.showNotification('Success', `Response Submitted: ${result}`, 'success');				
			})
			.catch(error => {
				this.showNotification('Error', `Response Submission Error: ${error}`, 'error');				
			});
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
		});
		this.dispatchEvent(evt);
	}

	handleAnswers(event) {
		window.console.log('response event', event.detail.questionId, event.detail.value); 
		this.answers[event.detail.questionId] = event.detail.value;
	}

}