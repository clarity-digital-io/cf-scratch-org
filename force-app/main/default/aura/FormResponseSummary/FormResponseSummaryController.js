({
	doInit: function(cmp, event, helper) {

			let action = cmp.get("c.getForm");

			action.setParams({
					recordId: cmp.get("v.recordId")
			});

			action.setCallback(this, function (response) {

					let state = response.getState();
			
					if (state === "SUCCESS") {
					
							var form = response.getReturnValue();
							if(!cmp.get("v.recordId")) {
								cmp.set("v.recordId", form.Id);
							}
							cmp.set('v.form', form); 

							var workspaceAPI = cmp.find("workspace");
							workspaceAPI.getEnclosingTabId().then(function(response){
								cmp.set("v.tabId", response);
							});

					}
			}); 

			$A.enqueueAction(action);

	},
	edit: function(cmp, event, helper) {
			
			window.open ('/cforms/FormBuilderApp.app?recordId=' + cmp.get('v.recordId'),'_self',false)

	},
	delete: function(cmp, event, helper) {

			let action = cmp.get("c.deleteForm");

			action.setParams({
					formId: cmp.get("v.recordId")
			});

			action.setCallback(this, function (response) {

					let state = response.getState();
			
					if (state === "SUCCESS") {

						if(cmp.get('v.tabId') != null) {
							var workspaceAPI = cmp.find("workspace");

							workspaceAPI.getFocusedTabInfo().then(function(response) {
								var focusedTabId = response.tabId;
								workspaceAPI.closeTab({tabId: focusedTabId});
							})
							.catch(function(error) {
									console.log(error);
							});
						}
					
						var navService = cmp.find("navService");

						var pageReference = {
								type: 'standard__objectPage',
								attributes: {
										objectApiName: 'forms__Form__c',
										actionName: 'list'
								},
								state: {
									filterName: "Recent"
								}
						};

						navService.navigate(pageReference);

					} else {

							cmp.find('notifLib').showNotice({
									"variant": "error",
									"header": "Error",
									"title": "Failed to delete",
									"message": response.getError()[0].message
							});
					}
					
			}); 

			$A.enqueueAction(action);

	},
	handlePublishForm: function(cmp, event, helper) {

			let action = cmp.get("c.publishForm");

			action.setParams({
					formId: cmp.get("v.recordId")
			});

			cmp.set('v.loading', true); 

			action.setCallback(this, function (response) {

					let state = response.getState();
			
					cmp.set('v.loading', false); 

					if (state === "SUCCESS") {
					
							var form = response.getReturnValue();

							cmp.set('v.form', form); 

					}
			}); 

			$A.enqueueAction(action);

	},
	handleSetDraft: function(cmp, event) {
		let action = cmp.get("c.setToDraft");

		action.setParams({
				recordId: cmp.get("v.recordId")
		});

		cmp.set('v.loading', true); 

		action.setCallback(this, function (response) {

				let state = response.getState();
		
				cmp.set('v.loading', false); 

				if (state === "SUCCESS") {
				
						var form = response.getReturnValue();

						cmp.set('v.form', form); 

				}
		}); 

		$A.enqueueAction(action);
	}

})