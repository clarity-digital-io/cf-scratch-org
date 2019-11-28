({
    
    handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		if(name == 'Cancel' || name == 'Close') {

            cmp.find("overlayLib").notifyClose();

		} 

	}
    
})