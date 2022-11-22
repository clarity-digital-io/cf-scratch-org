import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RecordGroup extends LightningElement {
	@api recordGroupFields; 
	@api question; 
	showRecordGroupForm = false;
	data = [];
	recordId;

	get salesforceObjectName() {
		return this.question.forms__Salesforce_Object__c;
	}

	get columns() {
		
		let idColumn = [{
			label: 'Id',
			fieldName: 'Id',
			type: 'text'
		}];

		let columns = this.recordGroupFields.map(field => {
			return {
				label: field.forms__Salesforce_Field__c,
				fieldName: field.forms__Salesforce_Field__c,
				type: 'text'
			}
		})
		
		return idColumn.concat(columns); 

	}

	back() {
		this.showRecordGroupForm = false;
	}

	newRecord() {
		this.showRecordGroupForm = true; 
	}

	handleSuccess(event) {

		let recordId = event.detail.id;

		let fields = this.recordGroupFields.map(field => {
			return field.forms__Salesforce_Field__c;
		});

		let values = fields.reduce((accum, field) => {

			let fieldValue = {};
			accum[field] = event.detail.fields.hasOwnProperty(field) ? event.detail.fields[field].displayValue : null; 
			console.log(fieldValue,  event.detail.fields.hasOwnProperty(field), field);
			return accum;

		}, { Id: recordId });

		console.log('values', values); 

		// let fieldValues = Object.keys(event.detail.fields).map((field) => {
		// 	console.log(field);

		// 	let key = Object.keys(field) 
		// 	console.log(key);
		// 	let fieldValue = {};
		// 	fieldValue[key] = field.displayValue
		// 	return fieldValue;
		// });

		this.showNotification('Created', 'New Record Group', 'success');
	
		this.data = [values];

		this.back();

	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
		});
		this.dispatchEvent(evt);
	}

}


