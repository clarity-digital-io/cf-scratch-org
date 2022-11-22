import { LightningElement, track, api } from 'lwc';

export default class ResponseReviewAnswer extends LightningElement {
	@api answer;

	get isText() {
		return this.answer.forms__Question__r.forms__Type__c != 'Attachments';
	}

	get isAttachment() {
		return this.answer.forms__Question__r.forms__Type__c == 'Attachments'
	}

	get attachmentUrl() {
		return '/sfc/servlet.shepherd/version/download/' +  this.answer.forms__ContentVersion__c;
	}
}