import { api, LightningElement } from 'lwc';

export default class ResponseForm extends LightningElement {
	@api isEdit; 
	@api isNew; 
	@api formId;
	@api responseId;
	@api recordId;
	@api isCommunity = false; 

	@api
	handleSave() {
		if(this.isEdit) {
			this.template.querySelector('c-response-form-edit').handleSave()
		} else {
			window.console.log('what the save');
			this.template.querySelector('c-response-form-new').handleSave()
		}
	}

	@api
	handleSubmit() {
		if(this.isEdit) {
			this.template.querySelector('c-response-form-edit').handleSubmit()
		} else {
			this.template.querySelector('c-response-form-new').handleSubmit()
		}
	}

}