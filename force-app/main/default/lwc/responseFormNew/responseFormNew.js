import { wire, api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import saveResponse from '@salesforce/apex/ResponseController.saveResponse';
import getConnections from '@salesforce/apex/ResponseController.getConnections';

export default class ResponseFormNew extends LightningElement {
	@api isCommunity = false; 
	@api formId;
	@api readyFormId;
	@api recordId; //sObject like account or case or any other Salesforce object
	@api hasConnection = false;
	@api hasConnectionReady = false;
	@api connections;

	answers = {};
	responseConnections = {};
	constructor() {
		super();
		this.addEventListener('answerchange', this.handleAnswers.bind(this));
	}

	@wire(getConnections, { formId: '$formId' })
	wiredConnections({ error, data }) {
		if (data) {
			this.connections = data;
			if(data.length == 0) {
				this.hasConnectionReady = true;
			} else {
				this.hasConnection = true; 
			}
		} else if (error) {
				this.error = error;
				this.connections = undefined;
		}
	}


	@api
	handleSave() {
		saveResponse({
				formId: this.formId, 
				sAnswers: JSON.stringify(this.answers), 
				status: 'In Progress',
				sRecordIds: JSON.stringify(this.responseConnections)
			})
			.then(result => {
				this.showNotification('Success', `Response Saved: ${result}`, 'success');				
			})
			.catch(error => {
				this.showNotification('Error', `Response Save Error: ${error.body.message}`, 'error');				
			});
	}

	@api
	handleSubmit() {
		saveResponse({
			formId: this.formId, 
			sAnswers: JSON.stringify(this.answers), 
			status: 'Submitted',
			sRecordIds: JSON.stringify(this.responseConnections)
		})
			.then(result => {
				this.showNotification('Success', `Response Submitted: ${result}`, 'success');				
			})
			.catch(error => {
				this.showNotification('Error', `Response Submission Error: ${error.body.message}`, 'error');				
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
		this.answers[event.detail.questionId] = event.detail.value;
	}

	handleConnectionsRequired(event) {
		window.console.log('handleConnectionsRequired' , event.detail)
		this.responseConnections = event.detail;
		this.hasConnection = false; 
		this.hasConnectionReady = true; 
		const e = new CustomEvent('connectionsready', { bubbles: true, composed: true });		
		this.dispatchEvent(e);
	}

}