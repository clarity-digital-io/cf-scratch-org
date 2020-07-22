import { api, wire, LightningElement } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';

export default class ResponseFormConnections extends LightningElement {
	@api formId;
	@api connections; 
	@api responseConnections = new Map(); 
	@api recordId; 
	@api defaultSObject; 
	defaultFields; 
	defaultRecordId; 

	loading = true;

	constructor() {
		super();
		console.log('recordId', this.recordId); 
	}

	@wire(CurrentPageReference)
	setCurrentPageReference(currentPageReference) {
			console.log('currentPageReference', currentPageReference); 

			if(currentPageReference.attributes) {
				this.defaultSObject = currentPageReference.attributes.objectApiName;
				this.defaultFields = this.connections.filter(connection => {
					if(connection.forms__Salesforce_Object__c == this.defaultSObject) {
						return connection;
					}
				}).map(connection => {
					return connection.forms__Form_Connection_Fields__r.map(connectionField => {
						return this.defaultSObject + '.' + connectionField.forms__Salesforce_Field__c;
					});
				})
				this.defaultRecordId = currentPageReference.attributes.recordId;
			} 
			this.loading = false;
	}

	@wire(getRecord, { recordId: '$recordId', fields: ['Account.Name'] })
	wiredRecord({error, data }) {
		console.log('error', error, data, this.recordId); 
		if(data) {
			console.log('data', data); 
			this.defaultRecord = data;
		} else {
			console.log('error', error); 
		}
	}

	handleResponseConnectionChange(event) {
		console.log('this.defaultRecord', this.defaultRecord);

		const detail = JSON.parse(event.detail);
		this.responseConnections.set(detail.connectionId, detail.recordId); 
		if(this.responseConnections.size == this.connections.length) {
			let connections = {};
			this.responseConnections.forEach((value, key) => {
				connections[key] = value; 
			})
			const e = new CustomEvent('connectionsrequired', { detail: connections });		
			this.dispatchEvent(e);
		}
	}

}