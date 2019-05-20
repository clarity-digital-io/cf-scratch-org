({
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		if(name == 'Preview') {

			let navService = cmp.find("navService");
			
			let pageReference = {
				type: 'standard__component',
				attributes: {
					componentName: 'c__ClarityFormsPreview'
				},
				state : {
					recordId : cmp.get('v.recordId')
				}
			};

			navService.navigate(pageReference);

		}
	}
})