({
	handleCancel : function(cmp, event, helper) {
			cmp.find("overlayLib").notifyClose();
	},
	handleInsert : function(cmp, event, helper) {

			let action = cmp.get("c.sign");

			action.setParams({
				signature: cmp.get("v.signature"),
				body: cmp.get("v.body")
			});

			cmp.set('v.loading', true); 

			action.setCallback(this, function (response) {

				let state = response.getState();

				if (state === "SUCCESS") {
				
						let response = response.getReturnValue();

						console.log('response', response); 
				}

				cmp.set('v.loading', false); 

			}); 

			$A.enqueueAction(action);
			
	},
	handleSignatureEvent: function(cmp, event, helper) {

		var agreed = event.getParam("agreed");
		cmp.set("v.notagreed", !agreed);

		var signature = event.getParam("signature");

		if(signature) {
			cmp.set('v.signature', signature);
		}

		var body = event.getParam("body");

		if(body) {
			cmp.set('v.body', body);
		}

	}
})