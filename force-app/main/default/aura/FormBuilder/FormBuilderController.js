({
	doInit: function(cmp) {
		
		if(cmp.get('v.recordId') == '') {
            cmp.set('v.recordId', cmp.get("v.pageReference").state.recordId);
		}
		
	},
	
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		let formId = message.payload.value; 

		if(name == 'Preview') {

			let navService = cmp.find("navService");
			
			let pageReference = {
				type: 'standard__component',
				attributes: {
					componentName: 'c__FormPreview'
				},
				state : {
					recordId : cmp.get('v.recordId') || formId
				}
			};

			navService.navigate(pageReference);

		}
	}
})