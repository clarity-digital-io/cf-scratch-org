import { wire, api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import saveResponse from '@salesforce/apex/ResponseController.saveResponse';
import getConnections from '@salesforce/apex/ResponseController.getConnections';

export default class ResponseForm extends LightningElement {
	@api isCommunity = false; 
	@api formId;
	@api readyFormId;
	@api recordId;

	@api hasConnection = false;
	@api hasConnectionReady = false;

	response = {};

	@api connections;

	constructor() {
		super();
		this.addEventListener('change', this.handleAnswers.bind(this));
	}

	handleConnectionsRequired(event) {
		this.hasConnection = false; 
		this.hasConnectionReady = true; 
		const e = new CustomEvent('connectionsready');		
		this.dispatchEvent(e);
	}

	@wire(getConnections, { recordId: '$formId' })
	wiredConnections({ error, data }) {
		window.console.log('wiredConnections', data); 
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
				sResponse: JSON.stringify(this.response), 
				status: 'In Progress',
				recordId: this.recordId
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
		saveResponse({
			formId: this.formId, 
			sResponse: JSON.stringify(this.response), 
			status: 'Submitted',
			recordId: this.recordId
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
		window.console.log('event.target.getSelection()', event); 
	}

}