({
	doInit: function(cmp, event, helper) {

		if(cmp.get('v.recordId') == '') {
			
			if( cmp.get("v.pageReference").state.c__recordId != null ) {
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
						header: cmp.get("v.formName"),
						cssClass: "clarityModal",
						body: formResponse, 
						showCloseButton: true
					})
	
				}
			});

		} 

	}
})