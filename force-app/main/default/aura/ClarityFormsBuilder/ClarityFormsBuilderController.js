({
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		if(name == 'Preview') {

			var navService = cmp.find("navService");
			
			var pageReference = {
				type: 'standard__navItemPage',
				attributes: {
					apiName: 'Clarity_Form_Preview'
				}
			};

			navService.navigate(pageReference);

		}
	}
})