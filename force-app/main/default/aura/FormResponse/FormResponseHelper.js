({
    update: function(cmp, recordId) {

			let endTime = new Date().getTime();

			let startTime = cmp.get('v.startTime'); 

			let actualTime = endTime - startTime;

			let action = cmp.get("c.updateResponse");

			action.setParams({
					responseId : cmp.get("v.recordId") || recordId,
					totalTime : actualTime
			})

			action.setCallback(this, function (response) {

				let state = response.getState();

				if (state === "ERROR") {

					let errors = response.getError();

									cmp.find('notifLib').showToast({
											"variant": "error",
											"title"  : "Error!",
											"message": response.getError()
									});

				}

			});

			$A.enqueueAction(action);

    }
    
})