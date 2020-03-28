({
	doInit: function(cmp, event, helper) {

		if(cmp.get('v.recordId') == '') {
			
			if( cmp.get("v.pageReference") != null && cmp.get("v.pageReference").state.c__recordId != null ) {
				cmp.set('v.recordId', cmp.get("v.pageReference").state.c__recordId);
			} else {
				helper.create(cmp); 
			}

		}

		let workspaceAPI = cmp.find("workspace");

        workspaceAPI.getTabInfo().then(function(response) {
			let focusedTabId = response.tabId;
			
			workspaceAPI.addToBrowserTitleQueue({
				title: "Clarity Form Builder"
			})

            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Builder",
            });

            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "action:canvas",
                iconAlt: "Builder"
            });
        })
        .catch(function(error) {

		});
		
	},
	
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		let formId = message.payload.value; 

		if(name == 'Preview') {

			$A.createComponents([
				["c:FormResponse", { "formId": formId, preview: true }]
			],
			function(components, status) {
				if (status === "SUCCESS") {
	
					let formResponse = components[0];
					cmp.find('overlayLib').showCustomModal({
						header: 'Form Preview',
						cssClass: "clarityModal",
						body: formResponse, 
						showCloseButton: true
					})
	
				}
			});

		} 

		var navLink = cmp.find("navService");

		if(name == 'Back') {
			var pageRef = {
					type: 'standard__recordPage',
					attributes: {
							actionName: 'view',
							objectApiName: 'ns__Clarity_Form__c',
							recordId : formId // change record id. 
					},
			};
			navLink.navigate(pageRef, true);
		}

		if(name == 'Help') {
			var pageRef =	{    
					"type": "standard__webPage",
					"attributes": {
							"url": "https://claritydigital.io"
					}
			}
			navLink.navigate(pageRef, true);
		}

	}
})