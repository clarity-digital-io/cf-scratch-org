({
    doInit: function(cmp) {

        let id = cmp.get('v.sObjectId');

        let type = cmp.get('v.sObjectType');

        console.log('type id', id, type); 

        if(id != null && type != null) {

            let parameters = cmp.get('v.parameters'); 

            if(parameters != "") {

                cmp.set('v.parameters', parameters + '&' + type + '=' + id);

            } else {

                cmp.set('v.parameters', type + '=' + id);

            }

        }

        let pageRef = cmp.get("v.pageReference");

        if(pageRef) {
            let formId = pageRef.state.c__formId;
            cmp.set('v.formId', formId);

            let formName = pageRef.state.c__formName;
            cmp.set('v.formName', formName);

            let preview = pageRef.state.c__preview;
            cmp.set('v.preview', preview);

            let workspaceAPI = cmp.find("workspace");

            workspaceAPI.getTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: "Preview",
                });
    
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "action:preview",
                    iconAlt: "Preview"
                });
            })
            .catch(function(error) {
                console.log(error);
            });
            
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