({
	create: function(cmp) {

		let action = cmp.get("c.create");

		cmp.set('v.loading', true); 

		action.setCallback(this, function (response) {

				let state = response.getState();
		
				if (state === "SUCCESS") {
				
						let formId = response.getReturnValue();

						cmp.set('v.recordId', formId); 

				} 
				
				if (state === "ERROR") {

					let errors = response.getError();

					cmp.find('notifLib').showToast({
							"variant": "error",
							"title"  : "Error!",
							"message": errors
					});

				}

				cmp.set('v.loading', false); 

		}); 

		$A.enqueueAction(action);
		
	}
})