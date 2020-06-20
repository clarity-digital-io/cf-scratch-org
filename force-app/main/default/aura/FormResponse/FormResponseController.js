({
    doInit: function(cmp) {

				let startTime = new Date().getTime();

				cmp.set('v.startTime', startTime);

        let id = cmp.get('v.sObjectId');

        let type = cmp.get('v.sObjectType');

        if(id != null && type != null) {

            let parameters = cmp.get('v.parameters'); 

            if(parameters != "") {

                cmp.set('v.parameters', parameters + '&' + type + '=' + id);

            } else {

                cmp.set('v.parameters', type + '=' + id);

            }

					}

    }, 
		handleMessage : function(cmp, event, helper) {
			let message = event.getParams();

			let name = message.payload.name; 

			if(name == 'Cancel' || name == 'Close') {

				cmp.find("overlayLib").notifyClose();

				var formEvent = $A.get("e.c:formResponseEvent");

				formEvent.setParams({
						formId: cmp.get('v.formId')
				})

				formEvent.fire();

			} 

		}
    
})