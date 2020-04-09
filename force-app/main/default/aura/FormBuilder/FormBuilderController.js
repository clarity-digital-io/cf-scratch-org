({
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		let formId = message.payload.value; 

		if(name == 'Back') {
			window.open ('/lightning/r/forms_Clarity_Form__c/' + formId + '/view','_self',false)
		}

		if(name == 'Help') {
			window.open ('https://claritydigital.io','_blank',false)
		}

	}
})