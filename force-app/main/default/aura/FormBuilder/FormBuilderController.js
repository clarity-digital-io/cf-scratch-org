({
	doInit: function(cmp) {
		console.log('recordId', cmp.get('v.recordId'));
		if(cmp.get('v.recordId') == '') {
            cmp.set('v.recordId', cmp.get("v.pageReference").state.c__recordId);
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
            console.log(error);
        });
		
	},
	
	handleMessage : function(cmp, event, helper) {
		let message = event.getParams();

		let name = message.payload.name; 

		let formId = message.payload.value; 

		let navService = cmp.find("navService");
		
		let pageReference = {
			type: 'standard__component',
			attributes: {
				componentName: 'c__FormResponse'
			},
			state: {
				c__formId  : formId, 
				c__preview : 'true'
			}
		};

		navService.navigate(pageReference);
	}
})