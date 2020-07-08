import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import FORM_FACTOR from '@salesforce/client/formFactor';
import getResponses from '@salesforce/apex/ResponseController.getResponses';
import formSearch from '@salesforce/apex/ResponseController.formSearch';

export default class ResponseFormList extends NavigationMixin(LightningElement) {
		columns = [];

		constructor() {
			super();
			this.columns = [
				{ label: 'Form Name', fieldName: 'FormTitle', type: 'text', cellAttributes: { iconName: 'standard:record' } },
				{ label: 'Response Name', fieldName: 'Name', type: 'text' },
				{ label: 'Status', fieldName: 'Status', type: 'text' },
				{ type: 'action', typeAttributes: { rowActions: this.getRowActions } },
			]
		}

		showFormSelection = true;
		showConnectionSelection = false;
		showForm = false;
		showResponseControls = false; 
		formId;
		@api showModal = false;
		@api recordId;

		responses;
		@wire(getResponses, { recordId: '$recordId' })
		wiredResponses({error, data}) {
			if(data) {
				this.responses = data.map(record => {
					return {
						FormTitle: record.forms__Form__r.forms__Title__c,
						Name: record.Name,
						Status: record.forms__Status__c
					}
				}); 
			}
		}

		handleConnectionsReady() {
			this.showConnectionSelection = false; 
			this.showResponseControls = true;
		}

		handleNewResponse() {
			if(FORM_FACTOR == 'Large') {
				this.showFormSelection = true; 
				this.showConnectionSelection = false; 
				this.showForm = false; 
				this.showResponseControls = false; 
				this.formId = null; 
				this.showModal = true; 
			}

			if(FORM_FACTOR == 'Small') {
				window.location.href = 'clarityforms://response';
			}

		}

		modalCloseHandler() {
			this.showFormSelection = true; 
			this.showConnectionSelection = false; 
			this.showForm = false; 
			this.showResponseControls = false; 
			this.formId = null; 
			this.showModal = false;
		}

		handleFormSearch(event) {
			const target = event.target;
			formSearch(event.detail)
					.then(results => {
							target.setSearchResults(results);
					})
					.catch(error => {
						window.console.log('error', error);
					});
		}

		handleFormSelectionChange(event) {
			window.console.log('event.target.getSelection()', event.target.getSelection()); 
			this.formId = event.detail[0];
		}

		handleStartForm() {
			window.console.log(this.formId);
			if(this.formId != null) {

				this.showFormSelection = false;
				this.showConnectionSelection = true; 
				this.showForm = true;

			}
		}

		handleSave() {
			this.template.querySelector('c-response-form').handleSave()
		}

		handleSubmit() {
			this.template.querySelector('c-response-form').handleSubmit()
		}

		getRowActions(row, doneCallback) {
			window.console.log('getRowActions', row); 
			let actions = [];
			if(row.Status == 'In Progress') {
				actions.push({
					'label': 'Edit',
					'iconName': 'utility:adduser',
					'name': 'edit'
				});
				actions.push({
					'label': 'Delete',
					'iconName': 'utility:block_visitor',
					'name': 'delete'
				});
			}

			if(row.Status == 'Submitted') {
				actions.push({
					'label': 'View',
					'iconName': 'utility:adduser',
					'name': 'view'
				});
			}

			doneCallback(actions);

		}

		handleRowAction(event) {
			const action = event.detail.action.name;
			switch (action) {
				case 'delete':
					this.deleteResponse(row);
					break;
				case 'view':
					this.viewResponse(row);
					break;
				case 'edit':
					this.editResponse(row);
					break;
				default:
			}
		}

		deleteResponse(row) {
			window.console.log('row', row);
		}

		viewResponse(row) {
			window.console.log('row', row);
		}

		editResponse(row) {
			window.console.log('row', row);
		}
}